-- ==========================================================
-- 🚀 NEW MULTI-TENANT BACKEND SCRIPT (SaaS SETUP)
-- ==========================================================

-- 1. CLEANUP (Wipe everything to ensure a fresh canvas)
-- ==========================================================
-- We use DO blocks to avoid "relation does not exist" errors when dropping triggers on non-existent tables
DO $$ 
BEGIN
  IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'payments') THEN
    DROP TRIGGER IF EXISTS on_payment_added ON public.payments CASCADE;
  END IF;
END $$;

DROP FUNCTION IF EXISTS update_order_paid_amount() CASCADE;
DROP FUNCTION IF EXISTS get_user_org_id() CASCADE;
DROP FUNCTION IF EXISTS get_user_role() CASCADE;

DROP TABLE IF EXISTS public.expenses CASCADE;
DROP TABLE IF EXISTS public.payments CASCADE;
DROP TABLE IF EXISTS public.orders CASCADE;
DROP TABLE IF EXISTS public.workers CASCADE;
DROP TABLE IF EXISTS public.clients CASCADE;
DROP TABLE IF EXISTS public.user_profiles CASCADE;
DROP TABLE IF EXISTS public.shops CASCADE;
DROP TABLE IF EXISTS public.organizations CASCADE;


-- 2. CREATE DATABASE STRUCTURE (The SaaS Skeleton)
-- ==========================================================

-- 🏢 ORGANIZATIONS (The Clients / Tenants)
CREATE TABLE public.organizations (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 🏪 SHOPS
CREATE TABLE public.shops (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    organization_id uuid REFERENCES public.organizations(id) ON DELETE CASCADE NOT NULL,
    name text NOT NULL,
    location text,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 👤 USER PROFILES
CREATE TABLE public.user_profiles (
    id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    organization_id uuid REFERENCES public.organizations(id) ON DELETE CASCADE,
    full_name text,
    role text DEFAULT 'worker', -- Options: 'superadmin', 'owner', 'manager', 'tailor'
    shop_id uuid REFERENCES public.shops(id) ON DELETE SET NULL, 
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 🧵 WORKERS (The Tailors/Staff members)
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

-- 📦 ORDERS 
CREATE TABLE public.orders (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    organization_id uuid REFERENCES public.organizations(id) ON DELETE CASCADE NOT NULL,
    shop_id uuid REFERENCES public.shops(id) ON DELETE CASCADE,
    manager_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
    
    -- Client Details
    customer_name text NOT NULL,
    customer_phone text,
    
    -- Item Details
    garment_type text NOT NULL,
    measurements_details jsonb DEFAULT '{}'::jsonb, 
    customer_preferences text, 
    
    -- Staff Assignment
    worker_id uuid REFERENCES public.workers(id) ON DELETE SET NULL, 
    additional_workers jsonb DEFAULT '[]'::jsonb, 
    
    -- Financials & Status
    price numeric DEFAULT 0,
    amount_paid numeric DEFAULT 0, 
    status integer DEFAULT 1, -- 1: Assigned, 2: In Progress ... 6: Closed
    
    -- Dates
    due_date date,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);

-- 💰 PAYMENTS (Transaction History)
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

-- 💸 EXPENSES (Shop Costs)
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

-- 👥 CLIENTS (Shared per Organization)
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


-- 3. ENABLE SECURITY AND MULTI-TENANCY RLS
-- ==========================================================
ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.shops ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;

-- Helper Function: Get Current User's Organization ID
CREATE OR REPLACE FUNCTION get_user_org_id() 
RETURNS uuid AS $$
  SELECT organization_id FROM public.user_profiles WHERE id = auth.uid() LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER;

-- Helper Function: Get Current User's Role
CREATE OR REPLACE FUNCTION get_user_role() 
RETURNS text AS $$
  SELECT role FROM public.user_profiles WHERE id = auth.uid() LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER;


-- 🛡️ POLICIES: ORGANIZATIONS
CREATE POLICY "Superadmin Full Access Org" ON public.organizations FOR ALL USING (get_user_role() = 'superadmin');
CREATE POLICY "Users Read Own Org" ON public.organizations FOR SELECT USING (id = get_user_org_id());

-- 🛡️ POLICIES: USER PROFILES
CREATE POLICY "Users Read Own Profile" ON public.user_profiles FOR SELECT USING (id = auth.uid());
CREATE POLICY "Superadmin Full Access Profiles" ON public.user_profiles FOR ALL USING (
  (SELECT role FROM public.user_profiles WHERE id = auth.uid()) = 'superadmin'
);
CREATE POLICY "Users Read Same Org Profiles" ON public.user_profiles FOR SELECT USING (
  organization_id = (SELECT organization_id FROM public.user_profiles WHERE id = auth.uid())
);
CREATE POLICY "Owners Manage Same Org Profiles" ON public.user_profiles FOR INSERT WITH CHECK (
  (SELECT role FROM public.user_profiles WHERE id = auth.uid()) = 'owner' AND 
  organization_id = (SELECT organization_id FROM public.user_profiles WHERE id = auth.uid())
);
CREATE POLICY "Allow Profile Initial Lookup" ON public.user_profiles FOR SELECT TO authenticated USING (true);

-- 🛡️ POLICIES: SHOPS
CREATE POLICY "Superadmin Full Access Shops" ON public.shops FOR ALL USING (get_user_role() = 'superadmin');
CREATE POLICY "Users Read/Write Same Org Shops" ON public.shops FOR ALL USING (organization_id = get_user_org_id());

-- 🛡️ POLICIES: WORKERS
CREATE POLICY "Superadmin Full Access Workers" ON public.workers FOR ALL USING (get_user_role() = 'superadmin');
CREATE POLICY "Users Read/Write Same Org Workers" ON public.workers FOR ALL USING (organization_id = get_user_org_id());

-- 🛡️ POLICIES: ORDERS
CREATE POLICY "Superadmin Full Access Orders" ON public.orders FOR ALL USING (get_user_role() = 'superadmin');
CREATE POLICY "Users Read/Write Same Org Orders" ON public.orders FOR ALL USING (organization_id = get_user_org_id());

-- 🛡️ POLICIES: PAYMENTS
CREATE POLICY "Superadmin Full Access Payments" ON public.payments FOR ALL USING (get_user_role() = 'superadmin');
CREATE POLICY "Users Read/Write Same Org Payments" ON public.payments FOR ALL USING (organization_id = get_user_org_id());

-- 🛡️ POLICIES: EXPENSES
CREATE POLICY "Superadmin Full Access Expenses" ON public.expenses FOR ALL USING (get_user_role() = 'superadmin');
CREATE POLICY "Users Read/Write Same Org Expenses" ON public.expenses FOR ALL USING (organization_id = get_user_org_id());

-- 🛡️ POLICIES: CLIENTS
CREATE POLICY "Superadmin Full Access Clients" ON public.clients FOR ALL USING (get_user_role() = 'superadmin');
CREATE POLICY "Users Read/Write Same Org Clients" ON public.clients FOR ALL USING (organization_id = get_user_org_id());


-- 4. AUTOMATION (The Calculators)
-- ==========================================================
CREATE OR REPLACE FUNCTION update_order_paid_amount()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE public.orders
  SET amount_paid = (
    SELECT COALESCE(SUM(amount), 0)
    FROM public.payments
    WHERE order_id = NEW.order_id AND deleted_at IS NULL
  )
  WHERE id = NEW.order_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_payment_added
AFTER INSERT OR UPDATE OR DELETE ON public.payments
FOR EACH ROW EXECUTE PROCEDURE update_order_paid_amount();


-- 5. GRANT API PERMISSIONS 
-- ==========================================================
GRANT USAGE ON SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO anon, authenticated, service_role;


-- 6. CREATE THE SUPER ADMIN (YOU)
-- ==========================================================
-- 👇👇👇 EDIT THESE CREDENTIALS FOR YOUR OWN ACCOUNT 👇👇👇
DO $$
DECLARE
  super_email text := 'ronny@software.com';  -- CHANGE THIS to your developer email
  super_pass text := 'adminpassword';        -- CHANGE THIS
  super_name text := 'Ronny Admin';          -- CHANGE THIS
  super_id uuid := gen_random_uuid();
BEGIN
  -- 1. Create Login (only if email doesn't exist)
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = super_email) THEN
    INSERT INTO auth.users (
      instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, raw_user_meta_data, created_at, updated_at
    )
    VALUES (
      '00000000-0000-0000-0000-000000000000',
      super_id,
      'authenticated',
      'authenticated',
      super_email,
      crypt(super_pass, gen_salt('bf')),
      now(),
      jsonb_build_object('full_name', super_name),
      now(),
      now()
    );
  ELSE
    SELECT id INTO super_id FROM auth.users WHERE email = super_email;
  END IF;

  -- 2. Create or Update Profile (Role: superadmin)
  INSERT INTO public.user_profiles (id, full_name, role, organization_id, shop_id)
  VALUES (super_id, super_name, 'superadmin', NULL, NULL)
  ON CONFLICT (id) DO UPDATE 
  SET role = 'superadmin', full_name = super_name;
  
END $$;

SELECT '✅ Installation Complete. Check for your Super Admin Account!' as status;
