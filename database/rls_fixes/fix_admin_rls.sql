-- ==========================================================
-- 🛡️ BULLETPROOF SUPERADMIN EXPLICIT RLS FIX
-- ==========================================================

-- 1. Ensure helper function handles auth correctly
CREATE OR REPLACE FUNCTION get_user_role() 
RETURNS text AS $$
  SELECT role FROM public.user_profiles WHERE id = auth.uid() LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER SET search_path = public;

-- 2. Clean up old organizations policies
DROP POLICY IF EXISTS "Superadmin Full Access Org" ON public.organizations;
DROP POLICY IF EXISTS "Superadmin Select Org" ON public.organizations;
DROP POLICY IF EXISTS "Superadmin Insert Org" ON public.organizations;
DROP POLICY IF EXISTS "Superadmin Update Org" ON public.organizations;
DROP POLICY IF EXISTS "Superadmin Delete Org" ON public.organizations;

-- 3. Explicit Policies for Organizations
CREATE POLICY "Superadmin Select Org" ON public.organizations FOR SELECT TO authenticated USING (get_user_role() = 'superadmin');
CREATE POLICY "Superadmin Insert Org" ON public.organizations FOR INSERT TO authenticated WITH CHECK (get_user_role() = 'superadmin');
CREATE POLICY "Superadmin Update Org" ON public.organizations FOR UPDATE TO authenticated USING (get_user_role() = 'superadmin') WITH CHECK (get_user_role() = 'superadmin');
CREATE POLICY "Superadmin Delete Org" ON public.organizations FOR DELETE TO authenticated USING (get_user_role() = 'superadmin');

-- 4. Clean up old user_profile policies
DROP POLICY IF EXISTS "Superadmin Full Access Profiles" ON public.user_profiles;
DROP POLICY IF EXISTS "Superadmin Select Profiles" ON public.user_profiles;
DROP POLICY IF EXISTS "Superadmin Insert Profiles" ON public.user_profiles;
DROP POLICY IF EXISTS "Superadmin Update Profiles" ON public.user_profiles;
DROP POLICY IF EXISTS "Superadmin Delete Profiles" ON public.user_profiles;

-- 5. Explicit Policies for User Profiles
CREATE POLICY "Superadmin Select Profiles" ON public.user_profiles FOR SELECT TO authenticated USING (get_user_role() = 'superadmin');
CREATE POLICY "Superadmin Insert Profiles" ON public.user_profiles FOR INSERT TO authenticated WITH CHECK (get_user_role() = 'superadmin');
CREATE POLICY "Superadmin Update Profiles" ON public.user_profiles FOR UPDATE TO authenticated USING (get_user_role() = 'superadmin') WITH CHECK (get_user_role() = 'superadmin');
CREATE POLICY "Superadmin Delete Profiles" ON public.user_profiles FOR DELETE TO authenticated USING (get_user_role() = 'superadmin');

-- 6. Clean up old shops policies
DROP POLICY IF EXISTS "Superadmin Full Access Shops" ON public.shops;

-- 7. Explicit Policies for Shops
CREATE POLICY "Superadmin Select Shops" ON public.shops FOR SELECT TO authenticated USING (get_user_role() = 'superadmin');
CREATE POLICY "Superadmin Insert Shops" ON public.shops FOR INSERT TO authenticated WITH CHECK (get_user_role() = 'superadmin');
CREATE POLICY "Superadmin Update Shops" ON public.shops FOR UPDATE TO authenticated USING (get_user_role() = 'superadmin') WITH CHECK (get_user_role() = 'superadmin');
CREATE POLICY "Superadmin Delete Shops" ON public.shops FOR DELETE TO authenticated USING (get_user_role() = 'superadmin');

SELECT '✅ Explicit RLS policies created to allow INSERTs' as status;
