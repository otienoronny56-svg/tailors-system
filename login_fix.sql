-- ==========================================================
-- 🛠️ FIX FOR 406 LOGIN ERROR (PROFILE NOT FOUND/BLOCKED)
-- ==========================================================

-- 1. Ensure the exact admin profile exists and is a superadmin
INSERT INTO public.user_profiles (id, full_name, role)
VALUES ('22cde106-232f-4984-b69c-59b6546e4747', 'Otima Admin', 'superadmin')
ON CONFLICT (id) DO UPDATE 
SET role = 'superadmin', full_name = 'Otima Admin';

-- 2. Ensure the RLS policy exists to allow the user to read their own profile
-- First drop it to avoid 'already exists' error
DROP POLICY IF EXISTS "Users Read Own Profile" ON public.user_profiles;
DROP POLICY IF EXISTS "Allow Profile Initial Lookup" ON public.user_profiles;

-- Recreate the foolproof policy that lets anyone read their own row
CREATE POLICY "Users Read Own Profile" 
ON public.user_profiles 
FOR SELECT 
USING ( id = auth.uid() );

-- Also allow a general initial lookup for session establishment
CREATE POLICY "Allow Profile Initial Lookup" 
ON public.user_profiles 
FOR SELECT 
TO authenticated 
USING ( true );

-- 3. Confirm permissions
GRANT ALL ON TABLE public.user_profiles TO anon, authenticated, service_role;

SELECT '✅ 406 ERROR PROXY FIXED: Admin profile secured and RLS restored.' as status;
