-- ==========================================================
-- 🛠️ SECURITY PATCH: FIX USER PROFILES SELECT RLS POLICY
-- ==========================================================
-- This script drops old recursive select policies on public.user_profiles
-- and sets up a clean, non-recursive select policy allowing profile lookups.

-- 1. DROP CONFLICTING / RECURSIVE POLICIES
-- ==========================================================
DROP POLICY IF EXISTS "Public Read Profiles" ON public.user_profiles;
DROP POLICY IF EXISTS "Tenant Select Profiles" ON public.user_profiles;
DROP POLICY IF EXISTS "Users Read Same Org Profiles" ON public.user_profiles;
DROP POLICY IF EXISTS "Allow Profile Initial Lookup" ON public.user_profiles;

-- 2. CREATE CLEAN NON-RECURSIVE SELECT POLICY
-- ==========================================================
-- Allows any authenticated user to lookup profiles (e.g. tailors looking up clients, and vice versa)
CREATE POLICY "Public Read Profiles" 
ON public.user_profiles 
FOR SELECT 
TO authenticated 
USING (true);

-- Ensure RLS is enabled
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

SELECT '✅ user_profiles SELECT policy fixed successfully!' as status;
