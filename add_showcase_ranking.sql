-- ====================================================
-- SHOWCASE RANKING: Add is_featured + views columns
-- Run this in Supabase SQL Editor
-- ====================================================

-- 1. Add is_featured flag (admin can manually pin a listing to the showcase)
ALTER TABLE marketplace_listings
  ADD COLUMN IF NOT EXISTS is_featured BOOLEAN DEFAULT FALSE;

-- 2. Add views counter (incremented each time a listing card is clicked)
ALTER TABLE marketplace_listings
  ADD COLUMN IF NOT EXISTS views INTEGER DEFAULT 0;

-- 3. Index for fast showcase query ordering
CREATE INDEX IF NOT EXISTS idx_listings_showcase
  ON marketplace_listings (is_featured DESC, views DESC, created_at DESC)
  WHERE status = 'active';

-- 4. Allow anon users to increment views (RLS-safe via a function)
CREATE OR REPLACE FUNCTION increment_listing_views(listing_id UUID)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE marketplace_listings
  SET views = COALESCE(views, 0) + 1
  WHERE id = listing_id AND status = 'active';
END;
$$;

-- Grant execute to anon (so homepage visitors can trigger it)
GRANT EXECUTE ON FUNCTION increment_listing_views(UUID) TO anon;
GRANT EXECUTE ON FUNCTION increment_listing_views(UUID) TO authenticated;
