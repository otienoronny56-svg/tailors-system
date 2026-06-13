-- Run this SQL in your Supabase SQL Editor to add the new configuration columns to the shops table.
-- Supabase Dashboard Link: https://supabase.com/dashboard/project/ouuhirckiavcvgqlpriw/sql

ALTER TABLE public.shops ADD COLUMN IF NOT EXISTS availability_hours TEXT;
ALTER TABLE public.shops ADD COLUMN IF NOT EXISTS specialization TEXT;
ALTER TABLE public.shops ADD COLUMN IF NOT EXISTS website_url TEXT;

COMMENT ON COLUMN public.shops.availability_hours IS 'Weekly working hours/days available (e.g. Mon - Sat: 8:00 AM - 6:00 PM)';
COMMENT ON COLUMN public.shops.specialization IS 'Main specialization or services provided (e.g. Bespoke Custom Tailoring)';
COMMENT ON COLUMN public.shops.website_url IS 'Website Link / external portfolio url';
