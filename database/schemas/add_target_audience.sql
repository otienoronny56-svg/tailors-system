-- 1. Add target_audience column if it doesn't exist
ALTER TABLE public.marketplace_listings 
ADD COLUMN IF NOT EXISTS target_audience text DEFAULT 'Unisex';

-- 2. Auto-categorize existing listings based on title and category
UPDATE public.marketplace_listings
SET target_audience = 
  CASE 
    WHEN lower(title) LIKE '%men%' OR lower(title) LIKE '%suit%' OR lower(category) = 'senator wear' OR lower(category) = 'suits' THEN 'Men'
    WHEN lower(title) LIKE '%women%' OR lower(title) LIKE '%ladies%' OR lower(title) LIKE '%dress%' OR lower(category) = 'dresses' THEN 'Ladies'
    WHEN lower(title) LIKE '%kid%' OR lower(title) LIKE '%child%' OR lower(title) LIKE '%boy%' OR lower(title) LIKE '%girl%' THEN 'Children'
    ELSE 'Unisex'
  END
WHERE target_audience IS NULL OR target_audience = 'Unisex';
