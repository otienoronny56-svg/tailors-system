-- Add the business_type column to the shops table with a default value of 'tailor'.
-- This ensures all existing shops maintain their current identity and no data is disrupted.

ALTER TABLE public.shops 
ADD COLUMN IF NOT EXISTS business_type TEXT DEFAULT 'tailor';
