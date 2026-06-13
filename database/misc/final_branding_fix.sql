-- ==========================================
-- 🛡️ FINAL BRANDING & PERMISSIONS FIX
-- ==========================================
-- This script fixes the "Catch-22" where you can't see the Org name 
-- because you aren't linked to it yet.

DO $$
DECLARE
  primary_org_id uuid;
  admin_user_id uuid;
BEGIN
  -- 1. Find the primary organization (Luxe Tailors)
  SELECT id INTO primary_org_id FROM public.organizations ORDER BY created_at ASC LIMIT 1;
  
  -- 2. Find the owner user (admin@sirs.com)
  -- We fetch by email to be sure
  SELECT id INTO admin_user_id FROM auth.users WHERE email = 'admin@sirs.com';

  IF primary_org_id IS NULL THEN
    RAISE NOTICE '❌ No organization found. Please check Superadmin.';
  ELSIF admin_user_id IS NULL THEN
     RAISE NOTICE '❌ Admin user record not found.';
  ELSE
    -- 3. Link the Owner Profile to the organization
    UPDATE public.user_profiles 
    SET organization_id = primary_org_id 
    WHERE id = admin_user_id OR role = 'owner';
    
    -- 4. Link all shops to this organization
    UPDATE public.shops SET organization_id = primary_org_id WHERE organization_id IS NULL;
    
    RAISE NOTICE '✅ Successfully linked Admin and Shops to Org: %', primary_org_id;
  END IF;
END $$;

-- 5. RELAX ORGANIZATION RLS
-- Allow anyone authenticated to AT LEAST see the organization they belong to
-- OR if they are an owner, let them see their own org easily.
DROP POLICY IF EXISTS "Users Read Own Org" ON public.organizations;
DROP POLICY IF EXISTS "Org Read" ON public.organizations;
DROP POLICY IF EXISTS "Tenant Select Organizations" ON public.organizations;

CREATE POLICY "Allow Select Own Organization" 
ON public.organizations 
FOR SELECT 
TO authenticated 
USING (
  id IN (SELECT organization_id FROM public.user_profiles WHERE id = auth.uid())
  OR 
  (SELECT role FROM public.user_profiles WHERE id = auth.uid()) = 'owner'
);

-- 6. ENSURE SHOPS RLS IS ALSO ROBUST
DROP POLICY IF EXISTS "Tenant Select Shops" ON public.shops;
CREATE POLICY "Tenant Select Shops" 
ON public.shops 
FOR SELECT 
TO authenticated 
USING (
  organization_id IN (SELECT organization_id FROM public.user_profiles WHERE id = auth.uid())
  OR 
  (SELECT role FROM public.user_profiles WHERE id = auth.uid()) = 'owner'
);

-- Refresh the postgrest cache
NOTIFY pgrst, 'reload schema';
