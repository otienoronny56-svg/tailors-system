-- ==========================================================
-- ☢️ NUCLEAR RESET: SUPABASE SAAS FIX
-- ==========================================================
-- WARNING: This will WIPE ALL DATA and DISABLE ALL SECURITY temporarily.
-- Use this ONLY to resolve the "500 Internal Server Error" on login.

-- 1. COMPLETELY WIPE THE PUBLIC SCHEMA
-- ==========================================================
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

-- 2. RE-GRANT BASE PERMISSIONS (The "Unstuck" Move)
-- ==========================================================
GRANT USAGE ON SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO postgres, anon, authenticated, service_role;

-- 3. RECREATE MINIMAL TABLES (NO RLS FOR NOW)
-- ==========================================================
CREATE TABLE public.organizations (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);

CREATE TABLE public.shops (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    organization_id uuid REFERENCES public.organizations(id),
    name text NOT NULL
);

CREATE TABLE public.user_profiles (
    id uuid PRIMARY KEY, -- No FK to auth.users yet to keep it simple
    organization_id uuid REFERENCES public.organizations(id),
    full_name text,
    role text,
    shop_id uuid REFERENCES public.shops(id)
);

-- Note: We add only the absolute necessary tables to test login
CREATE TABLE public.workers (id uuid DEFAULT gen_random_uuid() PRIMARY KEY, shop_id uuid, name text);
CREATE TABLE public.orders (id uuid DEFAULT gen_random_uuid() PRIMARY KEY, organization_id uuid, shop_id uuid, customer_name text, garment_type text, status int DEFAULT 1, price numeric, amount_paid numeric, due_date date);
CREATE TABLE public.payments (id uuid DEFAULT gen_random_uuid() PRIMARY KEY, organization_id uuid, order_id uuid, amount numeric);
CREATE TABLE public.expenses (id uuid DEFAULT gen_random_uuid() PRIMARY KEY, organization_id uuid, amount numeric, item_name text);
CREATE TABLE public.clients (id uuid DEFAULT gen_random_uuid() PRIMARY KEY, organization_id uuid, phone text, name text, UNIQUE(organization_id, phone));

-- 4. INSERT SUPER ADMIN PROFILE
-- ==========================================================
-- We manually link your existing email to this profile.
DO $$
DECLARE
  target_id uuid;
BEGIN
  -- Get the ID of the user you already tried to create
  SELECT id INTO target_id FROM auth.users WHERE email = 'ronny@software.com' LIMIT 1;
  
  IF target_id IS NOT NULL THEN
    INSERT INTO public.user_profiles (id, full_name, role)
    VALUES (target_id, 'Ronny Admin', 'superadmin');
  END IF;
END $$;

-- 5. NO RLS! (Total Nuclear Option)
-- ==========================================================
-- We keep RLS DIS-ABLED on all tables for now.
-- Once you can log in, we will re-enable security one by one.

SELECT '☢️ NUCLEAR RESET COMPLETE. LOGIN NOW!' as log;
