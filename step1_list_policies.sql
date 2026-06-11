-- ================================================================
-- STEP 1: See all current policies on marketplace_inquiries
-- (Run this first, check output, then run STEP 2)
-- ================================================================
SELECT policyname, cmd, roles::text, qual 
FROM pg_policies 
WHERE schemaname = 'public' 
AND tablename = 'marketplace_inquiries'
ORDER BY cmd;
