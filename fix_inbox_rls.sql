-- ==========================================================
-- 🛠️ SECURITY PATCH: FIX SHOP & USER PROFILE SELECT FOR IN-APP MESSAGING
-- ==========================================================

-- 1. Allow everyone to SELECT shops so clients can resolve shop owners for messaging
DROP POLICY IF EXISTS "Public Read Shops" ON public.shops;
CREATE POLICY "Public Read Shops" 
ON public.shops 
FOR SELECT 
USING (true);

-- 2. Allow all authenticated users to read user profiles so they can resolve recipient IDs for messages
DROP POLICY IF EXISTS "Public Read Profiles" ON public.user_profiles;
CREATE POLICY "Public Read Profiles" 
ON public.user_profiles 
FOR SELECT 
TO authenticated 
USING (true);

-- 3. Ensure RLS is enabled
ALTER TABLE public.shops ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
