-- 0. Ensure the like_count column actually exists on the table
ALTER TABLE public.marketplace_listings ADD COLUMN IF NOT EXISTS like_count integer DEFAULT 0;

-- 1. Create a function to auto-update like counts on the listings table
CREATE OR REPLACE FUNCTION update_listing_like_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Safely increment like_count, treating NULL as 0
        UPDATE public.marketplace_listings 
        SET like_count = COALESCE(like_count, 0) + 1 
        WHERE id = NEW.listing_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        -- Safely decrement like_count, preventing it from dropping below 0
        UPDATE public.marketplace_listings 
        SET like_count = GREATEST(COALESCE(like_count, 0) - 1, 0) 
        WHERE id = OLD.listing_id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. Bind the trigger to the marketplace_likes table
DROP TRIGGER IF EXISTS trigger_update_listing_like_count ON public.marketplace_likes;
CREATE TRIGGER trigger_update_listing_like_count
AFTER INSERT OR DELETE ON public.marketplace_likes
FOR EACH ROW EXECUTE FUNCTION update_listing_like_count();

-- 3. Retroactively backfill all existing likes that were missed!
UPDATE public.marketplace_listings ml
SET like_count = (
    SELECT COUNT(*) FROM public.marketplace_likes lk
    WHERE lk.listing_id = ml.id
);
