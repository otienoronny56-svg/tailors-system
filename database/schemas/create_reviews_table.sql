-- ==========================================================
-- 🌟 MARKETPLACE REVIEWS SCHEMA & PRIVACY SETUP
-- ==========================================================

-- 1. Create the marketplace_reviews table
CREATE TABLE IF NOT EXISTS public.marketplace_reviews (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    reviewer_id uuid REFERENCES public.user_profiles(id) ON DELETE SET NULL,
    reviewer_name text NOT NULL,
    shop_id uuid REFERENCES public.shops(id) ON DELETE CASCADE,
    listing_id uuid REFERENCES public.marketplace_listings(id) ON DELETE CASCADE,
    rating integer NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment text,
    is_anonymous boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    -- Ensure a review targets either a shop, a specific listing, or both
    CONSTRAINT review_target_check CHECK (shop_id IS NOT NULL OR listing_id IS NOT NULL)
);

-- 2. Enable RLS on the table
ALTER TABLE public.marketplace_reviews ENABLE ROW LEVEL SECURITY;

-- 3. Define security policies for direct table access
DROP POLICY IF EXISTS "Anyone can select reviews" ON public.marketplace_reviews;
DROP POLICY IF EXISTS "Authenticated users can insert own reviews" ON public.marketplace_reviews;
DROP POLICY IF EXISTS "Review authors can update own reviews" ON public.marketplace_reviews;
DROP POLICY IF EXISTS "Review authors can delete own reviews" ON public.marketplace_reviews;

-- Anyone (public/anon) can view reviews directly, but we will steer public queries to the privacy view.
CREATE POLICY "Anyone can select reviews" 
ON public.marketplace_reviews 
FOR SELECT 
USING (true);

-- Authenticated users can insert reviews for themselves
CREATE POLICY "Authenticated users can insert own reviews" 
ON public.marketplace_reviews 
FOR INSERT 
TO authenticated 
WITH CHECK (auth.uid() = reviewer_id);

-- Authors can update or delete their own reviews
CREATE POLICY "Review authors can update own reviews" 
ON public.marketplace_reviews 
FOR UPDATE 
TO authenticated 
USING (auth.uid() = reviewer_id)
WITH CHECK (auth.uid() = reviewer_id);

CREATE POLICY "Review authors can delete own reviews" 
ON public.marketplace_reviews 
FOR DELETE 
TO authenticated 
USING (auth.uid() = reviewer_id);

-- 4. Create the secure privacy VIEW
-- This view filters out reviewer identities if is_anonymous is true.
-- Since the view is owned by the postgres superuser, it bypasses RLS and applies the CASE mapping.
CREATE OR REPLACE VIEW public.vw_marketplace_reviews AS
SELECT 
    id,
    shop_id,
    listing_id,
    rating,
    comment,
    is_anonymous,
    created_at,
    CASE 
        WHEN is_anonymous = true THEN 'Verified Customer'
        ELSE reviewer_name
    END AS reviewer_name,
    CASE 
        WHEN is_anonymous = true THEN NULL
        ELSE reviewer_id
    END AS reviewer_id
FROM public.marketplace_reviews;

-- 5. Grant access permissions on the VIEW
GRANT SELECT ON public.vw_marketplace_reviews TO anon;
GRANT SELECT ON public.vw_marketplace_reviews TO authenticated;
