-- ==========================================================
-- 🚀 FINAL MULTI-TENANT BACKEND SETUP (SaaS)
-- ==========================================================
-- This script performs a COMPLETE CLEANUP and RE-INITIALIZATION.
-- It is designed to fix "Database error querying schema" (500 Error).

-- 1. GLOBAL CLEANUP
-- ==========================================================
DO $$ 
BEGIN
  -- Drop Triggers
  IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'payments') THEN
    DROP TRIGGER IF EXISTS on_payment_added ON public.payments CASCADE;
  END IF;
END $$;

DROP FUNCTION IF EXISTS update_order_paid_amount() CASCADE;
DROP FUNCTION IF EXISTS get_user_org_id() CASCADE;
DROP FUNCTION IF EXISTS get_user_role() CASCADE;

-- Drop All Tables
DROP TABLE IF EXISTS public.expenses CASCADE;
DROP TABLE IF EXISTS public.payments CASCADE;
DROP TABLE IF EXISTS public.orders CASCADE;
DROP TABLE IF EXISTS public.workers CASCADE;
DROP TABLE IF EXISTS public.clients CASCADE;
DROP TABLE IF EXISTS public.user_profiles CASCADE;
DROP TABLE IF EXISTS public.shops CASCADE;
DROP TABLE IF EXISTS public.organizations CASCADE;

-- 2. CREATE BASE STRUCTURE
-- ==========================================================
CREATE TABLE public.organizations (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE TABLE public.shops (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    organization_id uuid REFERENCES public.organizations(id) ON DELETE CASCADE NOT NULL,
    name text NOT NULL,
    location text,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE TABLE public.user_profiles (
    id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    organization_id uuid REFERENCES public.organizations(id) ON DELETE CASCADE,
    full_name text,
    role text DEFAULT 'worker',
    shop_id uuid REFERENCES public.shops(id) ON DELETE SET NULL, 
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE TABLE public.workers (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    organization_id uuid REFERENCES public.organizations(id) ON DELETE CASCADE NOT NULL,
    shop_id uuid REFERENCES public.shops(id) ON DELETE CASCADE,
    name text NOT NULL,
    role text DEFAULT 'tailor',
    phone_number text,
    status text DEFAULT 'active',
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE TABLE public.orders (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    organization_id uuid REFERENCES public.organizations(id) ON DELETE CASCADE NOT NULL,
    shop_id uuid REFERENCES public.shops(id) ON DELETE CASCADE,
    manager_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
    customer_name text NOT NULL,
    customer_phone text,
    garment_type text NOT NULL,
    measurements_details jsonb DEFAULT '{}'::jsonb, 
    customer_preferences text, 
    worker_id uuid REFERENCES public.workers(id) ON DELETE SET NULL, 
    additional_workers jsonb DEFAULT '[]'::jsonb, 
    price numeric DEFAULT 0,
    amount_paid numeric DEFAULT 0, 
    status integer DEFAULT 1,
    due_date date,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);

CREATE TABLE public.payments (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    organization_id uuid REFERENCES public.organizations(id) ON DELETE CASCADE NOT NULL,
    order_id uuid REFERENCES public.orders(id) ON DELETE CASCADE,
    manager_id uuid REFERENCES auth.users(id) ON DELETE SET NULL, 
    amount numeric NOT NULL,
    payment_method text DEFAULT 'cash',
    notes text,
    recorded_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    edited_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
    edited_at timestamp with time zone,
    deleted_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
    deleted_at timestamp with time zone
);

CREATE TABLE public.expenses (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    organization_id uuid REFERENCES public.organizations(id) ON DELETE CASCADE NOT NULL,
    shop_id uuid REFERENCES public.shops(id) ON DELETE CASCADE,
    manager_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
    item_name text NOT NULL,
    amount numeric NOT NULL,
    category text DEFAULT 'General',
    notes text,
    incurred_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);

CREATE TABLE public.clients (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    organization_id uuid REFERENCES public.organizations(id) ON DELETE CASCADE NOT NULL,
    name text NOT NULL,
    phone text NOT NULL,
    measurements_history jsonb DEFAULT '[]'::jsonb,
    last_garment_type text,
    notes text,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    UNIQUE(organization_id, phone)
);

-- 3. ENABLE SECURITY
-- ==========================================================
ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.shops ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;

-- 🛡️ POLICIES: AUTH COMPATIBLE (NO RECURSION)
CREATE POLICY "Public Read Profiles" ON public.user_profiles FOR SELECT TO authenticated, anon USING (true);
CREATE POLICY "Users Update Own" ON public.user_profiles FOR UPDATE USING (auth.uid() = id);

-- For other tables, we can use the helper functions as long as they don't call themselves
CREATE OR REPLACE FUNCTION get_user_org_id() RETURNS uuid AS $$
  SELECT organization_id FROM public.user_profiles WHERE id = auth.uid() LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION get_user_role() RETURNS text AS $$
  SELECT role FROM public.user_profiles WHERE id = auth.uid() LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER;

CREATE POLICY "Superadmin All" ON public.organizations FOR ALL USING ((SELECT role FROM public.user_profiles WHERE id = auth.uid()) = 'superadmin');
CREATE POLICY "Org Read" ON public.organizations FOR SELECT USING (id = (SELECT organization_id FROM public.user_profiles WHERE id = auth.uid()));

-- Apply similar logic to all other tables
CREATE POLICY "Superadmin Full Shops" ON public.shops FOR ALL USING ((SELECT role FROM public.user_profiles WHERE id = auth.uid()) = 'superadmin');
CREATE POLICY "Org Access Shops" ON public.shops FOR ALL USING (organization_id = (SELECT organization_id FROM public.user_profiles WHERE id = auth.uid()));

CREATE POLICY "Superadmin Full Workers" ON public.workers FOR ALL USING ((SELECT role FROM public.user_profiles WHERE id = auth.uid()) = 'superadmin');
CREATE POLICY "Org Access Workers" ON public.workers FOR ALL USING (organization_id = (SELECT organization_id FROM public.user_profiles WHERE id = auth.uid()));

CREATE POLICY "Superadmin Full Orders" ON public.orders FOR ALL USING ((SELECT role FROM public.user_profiles WHERE id = auth.uid()) = 'superadmin');
CREATE POLICY "Org Access Orders" ON public.orders FOR ALL USING (organization_id = (SELECT organization_id FROM public.user_profiles WHERE id = auth.uid()));

CREATE POLICY "Superadmin Full Payments" ON public.payments FOR ALL USING ((SELECT role FROM public.user_profiles WHERE id = auth.uid()) = 'superadmin');
CREATE POLICY "Org Access Payments" ON public.payments FOR ALL USING (organization_id = (SELECT organization_id FROM public.user_profiles WHERE id = auth.uid()));

CREATE POLICY "Superadmin Full Expenses" ON public.expenses FOR ALL USING ((SELECT role FROM public.user_profiles WHERE id = auth.uid()) = 'superadmin');
CREATE POLICY "Org Access Expenses" ON public.expenses FOR ALL USING (organization_id = (SELECT organization_id FROM public.user_profiles WHERE id = auth.uid()));

CREATE POLICY "Superadmin Full Clients" ON public.clients FOR ALL USING ((SELECT role FROM public.user_profiles WHERE id = auth.uid()) = 'superadmin');
CREATE POLICY "Org Access Clients" ON public.clients FOR ALL USING (organization_id = (SELECT organization_id FROM public.user_profiles WHERE id = auth.uid()));

-- 4. PERMISSIONS
-- ==========================================================
GRANT USAGE ON SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO anon, authenticated, service_role;

-- 5. CREATE SUPER ADMIN
-- ==========================================================
DO $$
DECLARE
  super_id uuid;
  super_email text := 'ronny@software.com';
  super_pass text := 'adminpassword';
BEGIN
  -- We don't touch auth.users here anymore to avoid schema conflicts.
  -- You must use an existing user or create one via the Supabase UI first.
  -- IF YOU KNOW THE EMAIL EXISTS, PROCEED:
  SELECT id INTO super_id FROM auth.users WHERE email = super_email;
  
  IF super_id IS NOT NULL THEN
    INSERT INTO public.user_profiles (id, full_name, role, organization_id, shop_id)
    VALUES (super_id, 'Ronny Admin', 'superadmin', NULL, NULL)
    ON CONFLICT (id) DO UPDATE SET role = 'superadmin';
  END IF;
END $$;
