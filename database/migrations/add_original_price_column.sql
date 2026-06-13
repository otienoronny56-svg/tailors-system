-- Add original_price column to marketplace_listings table
ALTER TABLE public.marketplace_listings 
ADD COLUMN IF NOT EXISTS original_price numeric DEFAULT null;
