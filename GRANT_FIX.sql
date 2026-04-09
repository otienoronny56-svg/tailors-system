-- ==========================================================
-- 🛠️ FIXING 403 FORBIDDEN ERROR: RESTORING GRANTS
-- ==========================================================
-- When tables are dropped and recreated, the default Supabase web API 
-- permissions (anon, authenticated) are sometimes lost. 
-- This script restores full access to the API so RLS can do its job.

GRANT USAGE ON SCHEMA public TO anon, authenticated, service_role;

-- Grant access to all existing tables in the public schema
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO anon, authenticated, service_role;

-- Grant access to all sequences (for auto-incrementing IDs if any)
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated, service_role;

-- Ensure future tables get these identical permissions automatically
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO anon, authenticated, service_role;

SELECT '✅ GRANTS RESTORED. API 403 ERRORS SHOULD BE FIXED.' as status;
