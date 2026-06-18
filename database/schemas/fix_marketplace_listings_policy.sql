-- Fix Marketplace Listings Policy
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
