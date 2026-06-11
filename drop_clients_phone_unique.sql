-- ==========================================================
-- 🛠️ DATABASE MIGRATION: FIX CLIENTS UNIQUE CONSTRAINT FOR MULTI-TENANCY
-- ==========================================================

-- 1. Drop the global unique constraint on phone
ALTER TABLE public.clients DROP CONSTRAINT IF EXISTS clients_phone_key;

-- 2. Add a composite unique constraint (organization_id, phone)
-- This allows different tailoring organizations to have clients with the same phone number (e.g. for testing or shared customers)
-- while preventing duplicate client profiles within the same organization.
ALTER TABLE public.clients ADD CONSTRAINT clients_org_phone_key UNIQUE (organization_id, phone);

-- 3. Update RLS policies to ensure select/insert boundaries are clean
ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;
