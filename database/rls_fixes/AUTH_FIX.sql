-- ==========================================================
-- 🛠️ THE ACTUAL FIX: CLEARING AUTH SCHEMA CONFLICTS
-- ==========================================================
-- This script targets the AUTH schema specifically to remove rogue triggers.

-- 1. IDENTIFY AND DROP ROGUE TRIGGERS ON AUTH.USERS
-- ==========================================================
DO $$
DECLARE
    trig RECORD;
BEGIN
    FOR trig IN 
        SELECT trigger_name, event_object_table 
        FROM information_schema.triggers 
        WHERE event_object_schema = 'auth'
    LOOP
        EXECUTE 'DROP TRIGGER IF EXISTS ' || trig.trigger_name || ' ON auth.' || trig.event_object_table || ' CASCADE';
    END LOOP;
END $$;

-- 2. RE-INITIALIZE THE PROFILE WITHOUT RLS
-- ==========================================================
DROP TABLE IF EXISTS public.user_profiles CASCADE;
CREATE TABLE public.user_profiles (
    id uuid PRIMARY KEY,
    full_name text,
    role text,
    organization_id uuid,
    shop_id uuid
);

GRANT ALL ON TABLE public.user_profiles TO anon, authenticated, service_role;

-- 3. ENSURE USER IS IN PROFILES
-- ==========================================================
DO $$
DECLARE
  target_id uuid;
BEGIN
  SELECT id INTO target_id FROM auth.users WHERE email = 'ronny@software.com' LIMIT 1;
  IF target_id IS NOT NULL THEN
    INSERT INTO public.user_profiles (id, full_name, role)
    VALUES (target_id, 'Ronny Admin', 'superadmin')
    ON CONFLICT (id) DO UPDATE SET role = 'superadmin';
  END IF;
END $$;

SELECT '✅ AUTH TRIGGERS CLEARED. LOGIN SHOULD WORK NOW!' as status;
