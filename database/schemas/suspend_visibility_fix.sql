-- 1. Ensure suspended organizations' shops are hidden from the public
DROP POLICY IF EXISTS "Public Select Public Shops" ON public.shops;

CREATE POLICY "Public Select Public Shops" 
ON public.shops 
FOR SELECT 
USING (
  is_public = true AND 
  EXISTS (
    SELECT 1 FROM public.organizations 
    WHERE id = shops.organization_id 
    AND (subscription_status = 'Active' OR subscription_status IS NULL)
  )
);

-- 2. Ensure suspended organizations' marketplace listings are hidden from the public
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
    AND (public.organizations.subscription_status = 'Active' OR public.organizations.subscription_status IS NULL)
  )
);
