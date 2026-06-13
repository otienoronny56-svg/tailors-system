-- ============================================================
-- 📊 LISTING VIEWS DEDUPLICATION + LIKES COUNT TRACKING
-- Run this in your Supabase SQL editor
-- ============================================================

-- 1. Create listing_views table to track per-user/per-day views
-- ============================================================
CREATE TABLE IF NOT EXISTS public.listing_views (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    listing_id uuid REFERENCES public.marketplace_listings(id) ON DELETE CASCADE NOT NULL,
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,  -- NULL for anonymous guests
    viewed_date date DEFAULT CURRENT_DATE NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    -- One logged-in user can only count 1 view per listing per day
    UNIQUE NULLS NOT DISTINCT (listing_id, user_id, viewed_date)
);

-- Enable RLS on listing_views
ALTER TABLE public.listing_views ENABLE ROW LEVEL SECURITY;

-- Policy: anyone can insert a view (including anon via RPC)
DROP POLICY IF EXISTS "Anyone Can Log Views" ON public.listing_views;
CREATE POLICY "Anyone Can Log Views"
ON public.listing_views FOR INSERT
WITH CHECK (true);

-- Policy: authenticated can read their own views
DROP POLICY IF EXISTS "Users Can Read Own Views" ON public.listing_views;
CREATE POLICY "Users Can Read Own Views"
ON public.listing_views FOR SELECT
TO authenticated
USING (auth.uid() = user_id);

-- ============================================================
-- 2. Add `views` column to marketplace_listings if not present
-- ============================================================
ALTER TABLE public.marketplace_listings
ADD COLUMN IF NOT EXISTS views integer DEFAULT 0;

-- ============================================================
-- 3. Replace increment_listing_views RPC with deduplication
--    - Checks if this user has already viewed this listing today
--    - Only increments the counter if it's a new view
-- ============================================================
CREATE OR REPLACE FUNCTION increment_listing_views(listing_id uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_user_id uuid;
    v_today date;
    v_already_viewed boolean;
BEGIN
    v_user_id := auth.uid();  -- NULL for anonymous
    v_today := CURRENT_DATE;

    -- For authenticated users: check if they've viewed today
    IF v_user_id IS NOT NULL THEN
        SELECT EXISTS (
            SELECT 1 FROM public.listing_views lv
            WHERE lv.listing_id = $1
              AND lv.user_id = v_user_id
              AND lv.viewed_date = v_today
        ) INTO v_already_viewed;

        IF v_already_viewed THEN
            RETURN; -- Don't count duplicate view
        END IF;

        -- Record this view
        INSERT INTO public.listing_views (listing_id, user_id, viewed_date)
        VALUES ($1, v_user_id, v_today)
        ON CONFLICT DO NOTHING;
    END IF;

    -- Increment counter (for anonymous users this always runs once per RPC call;
    -- duplicate prevention for them is handled by localStorage in the browser)
    UPDATE public.marketplace_listings
    SET views = COALESCE(views, 0) + 1
    WHERE id = $1;
END;
$$;

-- Grant access
GRANT EXECUTE ON FUNCTION increment_listing_views(uuid) TO anon;
GRANT EXECUTE ON FUNCTION increment_listing_views(uuid) TO authenticated;

-- ============================================================
-- 4. Ensure marketplace_likes table exists (idempotent)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.marketplace_likes (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid REFERENCES public.user_profiles(id) ON DELETE CASCADE NOT NULL,
    listing_id uuid REFERENCES public.marketplace_listings(id) ON DELETE CASCADE NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    UNIQUE (user_id, listing_id)
);

ALTER TABLE public.marketplace_likes ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public Read Likes" ON public.marketplace_likes;
CREATE POLICY "Public Read Likes"
ON public.marketplace_likes FOR SELECT
USING (true);

DROP POLICY IF EXISTS "Users Manage Own Likes" ON public.marketplace_likes;
CREATE POLICY "Users Manage Own Likes"
ON public.marketplace_likes FOR ALL
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- ============================================================
-- 5. Add like_count column to marketplace_listings (optional caching)
-- ============================================================
ALTER TABLE public.marketplace_listings
ADD COLUMN IF NOT EXISTS like_count integer DEFAULT 0;

-- Function to sync like count (can be called after bulk updates)
CREATE OR REPLACE FUNCTION sync_listing_like_counts()
RETURNS void
LANGUAGE sql
SECURITY DEFINER
AS $$
    UPDATE public.marketplace_listings ml
    SET like_count = (
        SELECT COUNT(*) FROM public.marketplace_likes lk
        WHERE lk.listing_id = ml.id
    );
$$;

GRANT EXECUTE ON FUNCTION sync_listing_like_counts() TO authenticated;
