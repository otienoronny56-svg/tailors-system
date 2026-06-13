-- 1. ADD NEW COLUMNS TO SHOPS TABLE
ALTER TABLE public.shops ADD COLUMN IF NOT EXISTS logo_url TEXT;
ALTER TABLE public.shops ADD COLUMN IF NOT EXISTS paybill_number TEXT;
ALTER TABLE public.shops ADD COLUMN IF NOT EXISTS paybill_account TEXT;
ALTER TABLE public.shops ADD COLUMN IF NOT EXISTS receipt_header_text TEXT;
ALTER TABLE public.shops ADD COLUMN IF NOT EXISTS bank_details TEXT;
ALTER TABLE public.shops ADD COLUMN IF NOT EXISTS phone_number TEXT;

-- 2. CREATE SUPABASE STORAGE BUCKET FOR LOGOS
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'shop_logos',
  'shop_logos',
  true,
  5242880, -- 5MB limit
  ARRAY['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'image/svg+xml']
)
ON CONFLICT (id) DO UPDATE 
SET 
    public = EXCLUDED.public,
    allowed_mime_types = EXCLUDED.allowed_mime_types;

-- 3. SETUP BUCKET POLICIES
-- Drop existing to ensure clean slate
DROP POLICY IF EXISTS "Logos are publicly accessible" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can upload logos" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can update logos" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can delete logos" ON storage.objects;

-- Create Policies
CREATE POLICY "Logos are publicly accessible"
ON storage.objects FOR SELECT
USING (bucket_id = 'shop_logos');

CREATE POLICY "Authenticated users can upload logos"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'shop_logos');

CREATE POLICY "Authenticated users can update logos"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'shop_logos');

CREATE POLICY "Authenticated users can delete logos"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'shop_logos');

-- 4. FIX SHOPS UPDATE RLS POLICY
-- Ensure shop owners can update their own shop details
DROP POLICY IF EXISTS "Org Update Shops" ON public.shops;
DROP POLICY IF EXISTS "Users can update their own shop" ON public.shops;

CREATE POLICY "Users can update their own shop"
ON public.shops FOR UPDATE
USING (
    organization_id IN (SELECT organization_id FROM public.user_profiles WHERE id = auth.uid())
    AND (
        id IN (SELECT shop_id FROM public.user_profiles WHERE id = auth.uid()) 
        OR 
        'owner' = (SELECT role FROM public.user_profiles WHERE id = auth.uid())
        OR 
        'manager' = (SELECT role FROM public.user_profiles WHERE id = auth.uid())
    )
);
