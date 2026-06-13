-- ==========================================
-- 📦 INVENTORY SCHEMA
-- Run this script in your Supabase SQL Editor
-- ==========================================

CREATE TABLE IF NOT EXISTS public.inventory (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    shop_id uuid REFERENCES public.shops(id) ON DELETE CASCADE,
    item_name text NOT NULL,
    category text DEFAULT 'Other',
    price numeric DEFAULT 0,
    stock_quantity integer DEFAULT 0,
    low_stock_threshold integer DEFAULT 5,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);

-- Enable RLS
ALTER TABLE public.inventory ENABLE ROW LEVEL SECURITY;

-- Allow all authenticated users to read/write inventory
-- (Since your simple policy allows auth users to manage)
CREATE POLICY "Allow All for Auth Users" ON public.inventory FOR ALL USING (auth.role() = 'authenticated');

-- Grant permissions to anon and authenticated
GRANT ALL ON TABLE public.inventory TO anon, authenticated, service_role;
