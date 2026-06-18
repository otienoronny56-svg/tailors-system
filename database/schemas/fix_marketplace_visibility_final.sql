-- Final Fix for Marketplace Visibility
-- We need to grant public read access to the organization's subscription status 
-- so that the shops policy can correctly verify it!

-- 1. Allow everyone to read active organizations
DROP POLICY IF EXISTS "Public Read Organizations" ON public.organizations;
CREATE POLICY "Public Read Organizations" 
ON public.organizations 
FOR SELECT 
USING (
  subscription_status = 'Active' OR subscription_status IS NULL
);

-- 2. Ensure shops policy checks the organization status properly
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

-- 3. Ensure marketplace listings check the shop properly
DROP POLICY IF EXISTS "Public Read Active Listings" ON public.marketplace_listings;
CREATE POLICY "Public Read Active Listings" 
ON public.marketplace_listings 
FOR SELECT 
USING (
  status = 'active' AND 
  EXISTS (
    SELECT 1 FROM public.shops
    WHERE id = marketplace_listings.shop_id
  )
);
