-- 1. Enable the pgvector extension if it's not already enabled
CREATE EXTENSION IF NOT EXISTS vector;

-- 2. Add an embedding column to the marketplace_listings table
ALTER TABLE public.marketplace_listings 
ADD COLUMN IF NOT EXISTS embedding vector(768);

-- 3. Create a helper function for similarity search
CREATE OR REPLACE FUNCTION match_listings (
  query_embedding vector(768),
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
