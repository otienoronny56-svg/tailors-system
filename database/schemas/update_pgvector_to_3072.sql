-- 1. Drop the old function first since it depends on vector(768)
DROP FUNCTION IF EXISTS match_listings(vector(768), float, int);

-- 2. Alter the column type to vector(3072)
ALTER TABLE public.marketplace_listings 
ALTER COLUMN embedding TYPE vector(3072);

-- 3. Recreate function with vector(3072)
CREATE OR REPLACE FUNCTION match_listings (
  query_embedding vector(3072),
  match_threshold float,
  match_count int
)
RETURNS TABLE (
  id uuid,
  title text,
  description text,
  price numeric,
  image_urls text,
  category text,
  target_audience text,
  shop_id uuid,
  similarity float
)
LANGUAGE sql STABLE
AS $$
  SELECT
    marketplace_listings.id,
    marketplace_listings.title,
    marketplace_listings.description,
    marketplace_listings.price,
    marketplace_listings.image_urls,
    marketplace_listings.category,
    marketplace_listings.target_audience,
    marketplace_listings.shop_id,
    1 - (marketplace_listings.embedding <=> query_embedding) AS similarity
  FROM marketplace_listings
  WHERE marketplace_listings.status = 'active'
    AND 1 - (marketplace_listings.embedding <=> query_embedding) > match_threshold
  ORDER BY marketplace_listings.embedding <=> query_embedding
  LIMIT match_count;
$$;
