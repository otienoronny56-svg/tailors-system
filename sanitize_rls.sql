-- ==========================================================
-- 🛡️ ULTIMATE MULTI-TENANT RLS SANITIZATION (V2 - NO RECURSION)
-- ==========================================

-- 1. DROP ALL POTENTIALLY BROKEN POLICIES
DO $$ 
DECLARE 
    tbl text;
BEGIN
    FOR tbl IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public' 
                AND tablename IN ('shops', 'workers', 'orders', 'payments', 'expenses', 'clients', 'user_profiles')) 
    LOOP
        EXECUTE format('DROP POLICY IF EXISTS "Enable read access for all users" ON public.%I', tbl);
        EXECUTE format('DROP POLICY IF EXISTS "Public Select" ON public.%I', tbl);
        EXECUTE format('DROP POLICY IF EXISTS "Allow all" ON public.%I', tbl);
        EXECUTE format('DROP POLICY IF EXISTS "Authenticated users can read all" ON public.%I', tbl);
        EXECUTE format('DROP POLICY IF EXISTS "Tenant Select Shops" ON public.%I', tbl);
        EXECUTE format('DROP POLICY IF EXISTS "Tenant Select Orders" ON public.%I', tbl);
        EXECUTE format('DROP POLICY IF EXISTS "Tenant Select Payments" ON public.%I', tbl);
        EXECUTE format('DROP POLICY IF EXISTS "Tenant Select Expenses" ON public.%I', tbl);
        EXECUTE format('DROP POLICY IF EXISTS "Tenant Select Clients" ON public.%I', tbl);
        EXECUTE format('DROP POLICY IF EXISTS "Tenant Select Workers" ON public.%I', tbl);
        EXECUTE format('DROP POLICY IF EXISTS "Tenant Select Profiles" ON public.%I', tbl);
    END LOOP;
END $$;

-- 2. CREATE HELPER FUNCTION (SECURITY DEFINER to avoid recursion)
CREATE OR REPLACE FUNCTION get_my_org_id() 
RETURNS uuid AS $$
  -- This bypasses RLS because it is security definer
  SELECT organization_id FROM public.user_profiles WHERE id = auth.uid() LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER;

-- 3. ENABLE RLS ON ALL TABLES
ALTER TABLE public.shops ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

-- 4. APPLY CLEAN TENANT POLICIES

-- USER PROFILES
CREATE POLICY "Tenant Select Profiles" ON public.user_profiles FOR SELECT USING (organization_id = get_my_org_id());

-- SHOPS
CREATE POLICY "Tenant Select Shops" ON public.shops FOR SELECT USING (organization_id = get_my_org_id());
CREATE POLICY "Tenant Insert Shops" ON public.shops FOR INSERT WITH CHECK (organization_id = get_my_org_id());

-- ORDERS
CREATE POLICY "Tenant Select Orders" ON public.orders FOR SELECT USING (organization_id = get_my_org_id());
CREATE POLICY "Tenant Insert Orders" ON public.orders FOR INSERT WITH CHECK (organization_id = get_my_org_id());

-- PAYMENTS
CREATE POLICY "Tenant Select Payments" ON public.payments FOR SELECT USING (organization_id = get_my_org_id());

-- EXPENSES
CREATE POLICY "Tenant Select Expenses" ON public.expenses FOR SELECT USING (organization_id = get_my_org_id());

-- CLIENTS
CREATE POLICY "Tenant Select Clients" ON public.clients FOR SELECT USING (organization_id = get_my_org_id());

-- WORKERS
CREATE POLICY "Tenant Select Workers" ON public.workers FOR SELECT USING (organization_id = get_my_org_id());

COMMIT;
