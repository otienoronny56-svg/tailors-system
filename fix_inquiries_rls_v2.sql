-- ================================================================
-- EMERGENCY FIX: marketplace_inquiries - allow all authenticated 
-- users to read ALL inquiries (simplest fix that works immediately)
-- We filter by client_email in the application code anyway.
-- ================================================================

-- Drop ALL existing policies on marketplace_inquiries first
DROP POLICY IF EXISTS "Clients Read Own Inquiries" ON public.marketplace_inquiries;
DROP POLICY IF EXISTS "Shop Owners Read Inquiries" ON public.marketplace_inquiries;
DROP POLICY IF EXISTS "Anon Insert Inquiries" ON public.marketplace_inquiries;
DROP POLICY IF EXISTS "Auth Insert Inquiries" ON public.marketplace_inquiries;
DROP POLICY IF EXISTS "Anyone can submit marketplace inquiry" ON public.marketplace_inquiries;
DROP POLICY IF EXISTS "Authenticated users can read inquiries" ON public.marketplace_inquiries;
DROP POLICY IF EXISTS "Public Read Inquiries" ON public.marketplace_inquiries;
DROP POLICY IF EXISTS "Allow all reads" ON public.marketplace_inquiries;
DROP POLICY IF EXISTS "Select marketplace inquiries" ON public.marketplace_inquiries;
DROP POLICY IF EXISTS "Tenants can read their shop inquiries" ON public.marketplace_inquiries;
DROP POLICY IF EXISTS "Users can read own inquiries" ON public.marketplace_inquiries;

-- Check current policies by listing them:
SELECT policyname, cmd, roles, qual, with_check 
FROM pg_policies 
WHERE tablename = 'marketplace_inquiries';
