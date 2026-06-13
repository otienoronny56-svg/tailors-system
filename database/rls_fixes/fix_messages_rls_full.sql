-- ================================================================
-- 🛠️ FULL FIX: IN-APP MESSAGING RLS & SCHEMA
-- ================================================================
-- Run this entire script in Supabase → SQL Editor
-- ================================================================

-- STEP 1: Fix messages table RLS
-- Allow users to see messages where they are sender OR recipient
-- ALSO allow shop owners to see ALL messages linked to their shop's inquiries

DROP POLICY IF EXISTS "Users Insert Own Messages" ON public.messages;
DROP POLICY IF EXISTS "Users Read Own Chat Threads" ON public.messages;
DROP POLICY IF EXISTS "Superadmin Full Access Messages" ON public.messages;
DROP POLICY IF EXISTS "Shop Owners Read Inquiry Messages" ON public.messages;

-- Insert: sender must be current user
CREATE POLICY "Users Insert Own Messages"
ON public.messages
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = sender_id);

-- Read: sender, recipient, OR shop owner of the linked inquiry
CREATE POLICY "Users Read Own Chat Threads"
ON public.messages
FOR SELECT
TO authenticated
USING (
    auth.uid() = sender_id
    OR auth.uid() = recipient_id
    OR EXISTS (
        SELECT 1
        FROM public.marketplace_inquiries mi
        JOIN public.shops s ON s.id = mi.shop_id
        JOIN public.user_profiles up ON up.organization_id = s.organization_id
        WHERE mi.id = messages.inquiry_id
          AND up.id = auth.uid()
          AND up.role IN ('owner', 'manager', 'superadmin')
    )
);

-- Superadmin: full access
CREATE POLICY "Superadmin Full Access Messages"
ON public.messages
FOR ALL
USING (
    EXISTS (
        SELECT 1 FROM public.user_profiles
        WHERE id = auth.uid() AND role = 'superadmin'
    )
);

-- STEP 2: Ensure shops table is readable by authenticated users
DROP POLICY IF EXISTS "Public Read Shops" ON public.shops;
CREATE POLICY "Public Read Shops"
ON public.shops
FOR SELECT
TO authenticated
USING (true);

-- Also allow anon for marketplace browsing
DROP POLICY IF EXISTS "Anon Read Shops" ON public.shops;
CREATE POLICY "Anon Read Shops"
ON public.shops
FOR SELECT
TO anon
USING (true);

-- STEP 3: Ensure user_profiles is readable by authenticated users (for resolving recipient IDs)
DROP POLICY IF EXISTS "Public Read Profiles" ON public.user_profiles;
CREATE POLICY "Public Read Profiles"
ON public.user_profiles
FOR SELECT
TO authenticated
USING (true);

-- STEP 4: Ensure marketplace_inquiries can be read by shop owners
DROP POLICY IF EXISTS "Shop Owners Read Inquiries" ON public.marketplace_inquiries;
CREATE POLICY "Shop Owners Read Inquiries"
ON public.marketplace_inquiries
FOR SELECT
TO authenticated
USING (
    -- client sees their own inquiries
    client_email = (SELECT email FROM auth.users WHERE id = auth.uid())
    OR
    -- shop owner sees inquiries to their shops
    EXISTS (
        SELECT 1 FROM public.shops s
        JOIN public.user_profiles up ON up.organization_id = s.organization_id
        WHERE s.id = shop_id
          AND up.id = auth.uid()
          AND up.role IN ('owner', 'manager', 'superadmin')
    )
);

-- STEP 5: Allow anon to INSERT inquiries (for non-logged-in users browsing the marketplace)
DROP POLICY IF EXISTS "Anon Insert Inquiries" ON public.marketplace_inquiries;
CREATE POLICY "Anon Insert Inquiries"
ON public.marketplace_inquiries
FOR INSERT
TO anon
WITH CHECK (true);

DROP POLICY IF EXISTS "Auth Insert Inquiries" ON public.marketplace_inquiries;
CREATE POLICY "Auth Insert Inquiries"
ON public.marketplace_inquiries
FOR INSERT
TO authenticated
WITH CHECK (true);

SELECT '✅ Messages RLS fully fixed! Tailors can now see all messages from their shop inquiries.' as status;
