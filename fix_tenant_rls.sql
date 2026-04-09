-- ==========================================================
-- 🛡️ BULLETPROOF TENANT EXPLICIT RLS FIX
-- ==========================================================

-- 1. Ensure the org helper function handles auth correctly
CREATE OR REPLACE FUNCTION get_user_org_id() 
RETURNS uuid AS $$
  SELECT organization_id FROM public.user_profiles WHERE id = auth.uid() LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER SET search_path = public;

-- 2. SHOPS
DROP POLICY IF EXISTS "Users Read/Write Same Org Shops" ON public.shops;
CREATE POLICY "Tenant Select Shops" ON public.shops FOR SELECT USING (organization_id = get_user_org_id());
CREATE POLICY "Tenant Insert Shops" ON public.shops FOR INSERT WITH CHECK (organization_id = get_user_org_id());
CREATE POLICY "Tenant Update Shops" ON public.shops FOR UPDATE USING (organization_id = get_user_org_id()) WITH CHECK (organization_id = get_user_org_id());
CREATE POLICY "Tenant Delete Shops" ON public.shops FOR DELETE USING (organization_id = get_user_org_id());

-- 3. WORKERS
DROP POLICY IF EXISTS "Users Read/Write Same Org Workers" ON public.workers;
CREATE POLICY "Tenant Select Workers" ON public.workers FOR SELECT USING (organization_id = get_user_org_id());
CREATE POLICY "Tenant Insert Workers" ON public.workers FOR INSERT WITH CHECK (organization_id = get_user_org_id());
CREATE POLICY "Tenant Update Workers" ON public.workers FOR UPDATE USING (organization_id = get_user_org_id()) WITH CHECK (organization_id = get_user_org_id());
CREATE POLICY "Tenant Delete Workers" ON public.workers FOR DELETE USING (organization_id = get_user_org_id());

-- 4. ORDERS
DROP POLICY IF EXISTS "Users Read/Write Same Org Orders" ON public.orders;
CREATE POLICY "Tenant Select Orders" ON public.orders FOR SELECT USING (organization_id = get_user_org_id());
CREATE POLICY "Tenant Insert Orders" ON public.orders FOR INSERT WITH CHECK (organization_id = get_user_org_id());
CREATE POLICY "Tenant Update Orders" ON public.orders FOR UPDATE USING (organization_id = get_user_org_id()) WITH CHECK (organization_id = get_user_org_id());
CREATE POLICY "Tenant Delete Orders" ON public.orders FOR DELETE USING (organization_id = get_user_org_id());

-- 5. PAYMENTS
DROP POLICY IF EXISTS "Users Read/Write Same Org Payments" ON public.payments;
CREATE POLICY "Tenant Select Payments" ON public.payments FOR SELECT USING (organization_id = get_user_org_id());
CREATE POLICY "Tenant Insert Payments" ON public.payments FOR INSERT WITH CHECK (organization_id = get_user_org_id());
CREATE POLICY "Tenant Update Payments" ON public.payments FOR UPDATE USING (organization_id = get_user_org_id()) WITH CHECK (organization_id = get_user_org_id());
CREATE POLICY "Tenant Delete Payments" ON public.payments FOR DELETE USING (organization_id = get_user_org_id());

-- 6. EXPENSES
DROP POLICY IF EXISTS "Users Read/Write Same Org Expenses" ON public.expenses;
CREATE POLICY "Tenant Select Expenses" ON public.expenses FOR SELECT USING (organization_id = get_user_org_id());
CREATE POLICY "Tenant Insert Expenses" ON public.expenses FOR INSERT WITH CHECK (organization_id = get_user_org_id());
CREATE POLICY "Tenant Update Expenses" ON public.expenses FOR UPDATE USING (organization_id = get_user_org_id()) WITH CHECK (organization_id = get_user_org_id());
CREATE POLICY "Tenant Delete Expenses" ON public.expenses FOR DELETE USING (organization_id = get_user_org_id());

-- 7. CLIENTS
DROP POLICY IF EXISTS "Users Read/Write Same Org Clients" ON public.clients;
CREATE POLICY "Tenant Select Clients" ON public.clients FOR SELECT USING (organization_id = get_user_org_id());
CREATE POLICY "Tenant Insert Clients" ON public.clients FOR INSERT WITH CHECK (organization_id = get_user_org_id());
CREATE POLICY "Tenant Update Clients" ON public.clients FOR UPDATE USING (organization_id = get_user_org_id()) WITH CHECK (organization_id = get_user_org_id());
CREATE POLICY "Tenant Delete Clients" ON public.clients FOR DELETE USING (organization_id = get_user_org_id());

SELECT '✅ Explicit RLS policies applied to all Tenant Tables!' as status;
