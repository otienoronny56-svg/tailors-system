-- 1. Create a secure function to check if a shop's organization is active
CREATE OR REPLACE FUNCTION is_org_active(check_org_id uuid) 
RETURNS boolean AS $$
DECLARE
    org_status text;
BEGIN
    SELECT subscription_status INTO org_status 
    FROM public.organizations 
    WHERE id = check_org_id;
    
    RETURN (org_status = 'Active' OR org_status IS NULL);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. Create a secure function to check if a listing's shop is public and organization is active
CREATE OR REPLACE FUNCTION is_listing_active_and_public(check_shop_id uuid) 
RETURNS boolean AS $$
DECLARE
    shop_is_public boolean;
    org_status text;
BEGIN
    SELECT s.is_public, o.subscription_status 
    INTO shop_is_public, org_status
    FROM public.shops s
    JOIN public.organizations o ON s.organization_id = o.id
    WHERE s.id = check_shop_id;

    RETURN shop_is_public AND (org_status = 'Active' OR org_status IS NULL);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Update the shops policy to use the secure function
DROP POLICY IF EXISTS "Public Select Public Shops" ON public.shops;
CREATE POLICY "Public Select Public Shops" 
ON public.shops 
FOR SELECT 
USING (
  is_public = true AND 
  is_org_active(organization_id)
);

-- 4. Update the marketplace_listings policy to use the secure function
DROP POLICY IF EXISTS "Public Read Active Listings" ON public.marketplace_listings;
CREATE POLICY "Public Read Active Listings" 
ON public.marketplace_listings 
FOR SELECT 
USING (
  status = 'active' AND 
  is_listing_active_and_public(shop_id)
);

-- Reload PostgREST schema cache
NOTIFY pgrst, 'reload schema';
