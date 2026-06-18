-- 1. Add status column to shops table
ALTER TABLE public.shops ADD COLUMN IF NOT EXISTS status VARCHAR(50) DEFAULT 'Active';

-- 2. Update Public Select Public Shops to also check shop status
DROP POLICY IF EXISTS "Public Select Public Shops" ON public.shops;

CREATE POLICY "Public Select Public Shops" 
ON public.shops 
FOR SELECT 
USING (
  is_public = true AND 
  (status = 'Active' OR status IS NULL) AND
  EXISTS (
    SELECT 1 FROM public.organizations 
    WHERE id = shops.organization_id 
    AND (subscription_status = 'Active' OR subscription_status IS NULL)
  )
);

-- 3. Update Marketplace Listings Policy to also check shop status
DROP POLICY IF EXISTS "Public Read Active Listings" ON public.marketplace_listings;

CREATE POLICY "Public Read Active Listings" 
ON public.marketplace_listings 
FOR SELECT 
USING (
  status = 'active' AND 
  EXISTS (
    SELECT 1 FROM public.shops
    JOIN public.organizations ON public.shops.organization_id = public.organizations.id
    WHERE public.shops.id = marketplace_listings.shop_id
    AND (public.shops.status = 'Active' OR public.shops.status IS NULL)
    AND (public.organizations.subscription_status = 'Active' OR public.organizations.subscription_status IS NULL)
  )
);

-- 4. Ensure Superadmins can update shops (similar to organizations)
DROP POLICY IF EXISTS "Superadmins can update shops" ON public.shops;

CREATE POLICY "Superadmins can update shops"
ON public.shops
FOR UPDATE
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.user_profiles
        WHERE user_profiles.id = auth.uid() AND user_profiles.role = 'superadmin'
    )
);
