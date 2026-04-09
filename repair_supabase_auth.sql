-- ==========================================================
-- 🛠️ SUPABASE AUTH REPAIR SCRIPT
-- ==========================================================
-- This script fixes the "Database error querying schema" (500 Error)
-- by resetting permissions and clearing recursive RLS policies.

-- 1. RESET ALL SCHEMA PERMISSIONS
-- ==========================================================
GRANT USAGE ON SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO postgres, anon, authenticated, service_role;

GRANT USAGE ON SCHEMA auth TO postgres, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA auth TO postgres, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA auth TO postgres, service_role;

-- 2. DISABLE RLS TEMPORARILY ON PROBLEM TABLES
-- ==========================================================
-- This breaks any circular loops causing the 500 error
ALTER TABLE public.user_profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.organizations DISABLE ROW LEVEL SECURITY;

-- 3. DROP RECURSIVE POLICIES
-- ==========================================================
DROP POLICY IF EXISTS "Superadmin Full Access Profiles" ON public.user_profiles;
DROP POLICY IF EXISTS "Users Read Same Org Profiles" ON public.user_profiles;
DROP POLICY IF EXISTS "Owners Manage Same Org Profiles" ON public.user_profiles;
DROP POLICY IF EXISTS "Allow Profile Initial Lookup" ON public.user_profiles;
DROP POLICY IF EXISTS "Users Read Own Profile" ON public.user_profiles;

-- 4. RE-ENABLE RLS WITH MINIMAL RULES
-- ==========================================================
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;

-- Minimal rules that don't call functions (to avoid recursion)
CREATE POLICY "Public Read Profiles" ON public.user_profiles FOR SELECT USING (true);
CREATE POLICY "Users Update Own Profile" ON public.user_profiles FOR UPDATE USING (auth.uid() = id);

-- 5. RE-GRANT TO GO-TRUE (AUTH ENGINE)
-- ==========================================================
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres, anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres, anon, authenticated, service_role;

SELECT '✅ Repair Complete. Try logging in now!' as status;
