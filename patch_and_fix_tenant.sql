-- ==========================================================
-- 🛠️ 1. SCHEMA RESCUE: ADD MISSING TENANT COLUMNS
-- ==========================================================
-- This guarantees every table has the multi-tenant column
-- so the RLS policies don't crash.

ALTER TABLE public.shops ADD COLUMN IF NOT EXISTS organization_id uuid REFERENCES public.organizations(id) ON DELETE CASCADE;
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS organization_id uuid REFERENCES public.organizations(id) ON DELETE CASCADE;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS organization_id uuid REFERENCES public.organizations(id) ON DELETE CASCADE;
ALTER TABLE public.payments ADD COLUMN IF NOT EXISTS organization_id uuid REFERENCES public.organizations(id) ON DELETE CASCADE;
ALTER TABLE public.expenses ADD COLUMN IF NOT EXISTS organization_id uuid REFERENCES public.organizations(id) ON DELETE CASCADE;
ALTER TABLE public.clients ADD COLUMN IF NOT EXISTS organization_id uuid REFERENCES public.organizations(id) ON DELETE CASCADE;

-- ==========================================================
-- 🛡️ 2. BULLETPROOF TENANT EXPLICIT RLS FIX
-- ==========================================================

-- Ensure the org helper function handles auth securely
CREATE OR REPLACE FUNCTION get_user_org_id() 
RETURNS uuid AS $$
  SELECT organization_id FROM public.user_profiles WHERE id = auth.uid() LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER SET search_path = public;

-- SHOPS
DROP POLICY IF EXISTS "Users Read/Write Same Org Shops" ON public.shops;
DROP POLICY IF EXISTS "Tenant Select Shops" ON public.shops;
DROP POLICY IF EXISTS "Tenant Insert Shops" ON public.shops;
DROP POLICY IF EXISTS "Tenant Update Shops" ON public.shops;
DROP POLICY IF EXISTS "Tenant Delete Shops" ON public.shops;
CREATE POLICY "Tenant Select Shops" ON public.shops FOR SELECT USING (organization_id = get_user_org_id());
CREATE POLICY "Tenant Insert Shops" ON public.shops FOR INSERT WITH CHECK (organization_id = get_user_org_id());
CREATE POLICY "Tenant Update Shops" ON public.shops FOR UPDATE USING (organization_id = get_user_org_id()) WITH CHECK (organization_id = get_user_org_id());
CREATE POLICY "Tenant Delete Shops" ON public.shops FOR DELETE USING (organization_id = get_user_org_id());

-- WORKERS
DROP POLICY IF EXISTS "Users Read/Write Same Org Workers" ON public.workers;
DROP POLICY IF EXISTS "Tenant Select Workers" ON public.workers;
DROP POLICY IF EXISTS "Tenant Insert Workers" ON public.workers;
DROP POLICY IF EXISTS "Tenant Update Workers" ON public.workers;
DROP POLICY IF EXISTS "Tenant Delete Workers" ON public.workers;
CREATE POLICY "Tenant Select Workers" ON public.workers FOR SELECT USING (organization_id = get_user_org_id());
CREATE POLICY "Tenant Insert Workers" ON public.workers FOR INSERT WITH CHECK (organization_id = get_user_org_id());
CREATE POLICY "Tenant Update Workers" ON public.workers FOR UPDATE USING (organization_id = get_user_org_id()) WITH CHECK (organization_id = get_user_org_id());
CREATE POLICY "Tenant Delete Workers" ON public.workers FOR DELETE USING (organization_id = get_user_org_id());

-- ORDERS
DROP POLICY IF EXISTS "Users Read/Write Same Org Orders" ON public.orders;
DROP POLICY IF EXISTS "Tenant Select Orders" ON public.orders;
DROP POLICY IF EXISTS "Tenant Insert Orders" ON public.orders;
DROP POLICY IF EXISTS "Tenant Update Orders" ON public.orders;
DROP POLICY IF EXISTS "Tenant Delete Orders" ON public.orders;
CREATE POLICY "Tenant Select Orders" ON public.orders FOR SELECT USING (organization_id = get_user_org_id());
CREATE POLICY "Tenant Insert Orders" ON public.orders FOR INSERT WITH CHECK (organization_id = get_user_org_id());
CREATE POLICY "Tenant Update Orders" ON public.orders FOR UPDATE USING (organization_id = get_user_org_id()) WITH CHECK (organization_id = get_user_org_id());
CREATE POLICY "Tenant Delete Orders" ON public.orders FOR DELETE USING (organization_id = get_user_org_id());

-- PAYMENTS
DROP POLICY IF EXISTS "Users Read/Write Same Org Payments" ON public.payments;
DROP POLICY IF EXISTS "Tenant Select Payments" ON public.payments;
DROP POLICY IF EXISTS "Tenant Insert Payments" ON public.payments;
DROP POLICY IF EXISTS "Tenant Update Payments" ON public.payments;
DROP POLICY IF EXISTS "Tenant Delete Payments" ON public.payments;
CREATE POLICY "Tenant Select Payments" ON public.payments FOR SELECT USING (organization_id = get_user_org_id());
CREATE POLICY "Tenant Insert Payments" ON public.payments FOR INSERT WITH CHECK (organization_id = get_user_org_id());
CREATE POLICY "Tenant Update Payments" ON public.payments FOR UPDATE USING (organization_id = get_user_org_id()) WITH CHECK (organization_id = get_user_org_id());
CREATE POLICY "Tenant Delete Payments" ON public.payments FOR DELETE USING (organization_id = get_user_org_id());

-- EXPENSES
DROP POLICY IF EXISTS "Users Read/Write Same Org Expenses" ON public.expenses;
DROP POLICY IF EXISTS "Tenant Select Expenses" ON public.expenses;
DROP POLICY IF EXISTS "Tenant Insert Expenses" ON public.expenses;
DROP POLICY IF EXISTS "Tenant Update Expenses" ON public.expenses;
DROP POLICY IF EXISTS "Tenant Delete Expenses" ON public.expenses;
CREATE POLICY "Tenant Select Expenses" ON public.expenses FOR SELECT USING (organization_id = get_user_org_id());
CREATE POLICY "Tenant Insert Expenses" ON public.expenses FOR INSERT WITH CHECK (organization_id = get_user_org_id());
CREATE POLICY "Tenant Update Expenses" ON public.expenses FOR UPDATE USING (organization_id = get_user_org_id()) WITH CHECK (organization_id = get_user_org_id());
CREATE POLICY "Tenant Delete Expenses" ON public.expenses FOR DELETE USING (organization_id = get_user_org_id());

-- CLIENTS
DROP POLICY IF EXISTS "Users Read/Write Same Org Clients" ON public.clients;
DROP POLICY IF EXISTS "Tenant Select Clients" ON public.clients;
DROP POLICY IF EXISTS "Tenant Insert Clients" ON public.clients;
DROP POLICY IF EXISTS "Tenant Update Clients" ON public.clients;
DROP POLICY IF EXISTS "Tenant Delete Clients" ON public.clients;
CREATE POLICY "Tenant Select Clients" ON public.clients FOR SELECT USING (organization_id = get_user_org_id());
CREATE POLICY "Tenant Insert Clients" ON public.clients FOR INSERT WITH CHECK (organization_id = get_user_org_id());
CREATE POLICY "Tenant Update Clients" ON public.clients FOR UPDATE USING (organization_id = get_user_org_id()) WITH CHECK (organization_id = get_user_org_id());
CREATE POLICY "Tenant Delete Clients" ON public.clients FOR DELETE USING (organization_id = get_user_org_id());

SELECT '✅ Schema Patched & Tenant RLS fully secured!' as status;
