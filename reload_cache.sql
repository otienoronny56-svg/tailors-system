-- ==========================================================
-- 🔄 SUPABASE SCHEMA CACHE RELOAD FIX
-- ==========================================================

-- 1. Ensure the column is properly named 'phone_number' as the app expects
DO $$ 
BEGIN
  BEGIN
    ALTER TABLE public.workers RENAME COLUMN phone TO phone_number;
  EXCEPTION
    WHEN undefined_column THEN
      -- Column is already named phone_number, we can safely ignore
      NULL;
  END;
END $$;

-- 2. Force the PostgREST API to instantly reload its schema cache
NOTIFY pgrst, 'reload schema';

SELECT '✅ Schema fully synced and API cache reloaded!' as status;
