-- ==========================================
-- 🛠️ ORGANIZATION REPAIR SCRIPT
-- ==========================================
-- This script ensures all data is correctly linked to your organization
-- so that branding (Luxe Tailors) shows up correctly.

DO $$
DECLARE
  primary_org_id uuid;
  primary_org_name text;
BEGIN
  -- 1. Find your main organization
  SELECT id, name INTO primary_org_id, primary_org_name FROM public.organizations ORDER BY created_at ASC LIMIT 1;
  
  IF primary_org_id IS NULL THEN
    RAISE NOTICE '❌ No organization found. Please create one in the Superadmin first.';
  ELSE
    RAISE NOTICE '✅ Found Organization: % (%)', primary_org_name, primary_org_id;

    -- 2. Link the Owner Profile
    UPDATE public.user_profiles 
    SET organization_id = primary_org_id 
    WHERE organization_id IS NULL;
    RAISE NOTICE '   - Linked profiles to Organization';

    -- 3. Link existing Shops
    UPDATE public.shops 
    SET organization_id = primary_org_id 
    WHERE organization_id IS NULL;
    RAISE NOTICE '   - Linked shops to Organization';

    -- 4. Link existing Orders
    UPDATE public.orders 
    SET organization_id = primary_org_id 
    WHERE organization_id IS NULL;
    RAISE NOTICE '   - Linked orders to Organization';
    
    -- 5. Link existing Expenses
    UPDATE public.expenses 
    SET organization_id = primary_org_id 
    WHERE organization_id IS NULL;
    RAISE NOTICE '   - Linked expenses to Organization';

    -- 6. Clean up RLS Cache
    NOTIFY pgrst, 'reload schema';
  END IF;
END $$;
