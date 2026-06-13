-- ==========================================================
-- 🛡️ BULLETPROOF OWNER PROFILE RLS FIX
-- ==========================================================

-- Clean up old potentially flawed policies for Owner profile management
DROP POLICY IF EXISTS "Owners Manage Same Org Profiles" ON public.user_profiles;
DROP POLICY IF EXISTS "Owner Select Profiles" ON public.user_profiles;
DROP POLICY IF EXISTS "Owner Insert Profiles" ON public.user_profiles;
DROP POLICY IF EXISTS "Owner Update Profiles" ON public.user_profiles;
DROP POLICY IF EXISTS "Owner Delete Profiles" ON public.user_profiles;

-- Create explicit deterministic policies using the secure helper functions
CREATE POLICY "Owner Select Profiles" ON public.user_profiles FOR SELECT TO authenticated USING (get_user_role() = 'owner' AND organization_id = get_user_org_id());
CREATE POLICY "Owner Insert Profiles" ON public.user_profiles FOR INSERT TO authenticated WITH CHECK (get_user_role() = 'owner' AND organization_id = get_user_org_id());
CREATE POLICY "Owner Update Profiles" ON public.user_profiles FOR UPDATE TO authenticated USING (get_user_role() = 'owner' AND organization_id = get_user_org_id()) WITH CHECK (get_user_role() = 'owner' AND organization_id = get_user_org_id());
CREATE POLICY "Owner Delete Profiles" ON public.user_profiles FOR DELETE TO authenticated USING (get_user_role() = 'owner' AND organization_id = get_user_org_id());

SELECT '✅ Owner explicit RLS policies for user_profiles applied!' as status;
