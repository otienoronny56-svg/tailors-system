-- ==========================================================
-- 🛠️ FORCE WORKER PHONE COLUMN
-- ==========================================================

-- If the column was somehow deleted or never existed, this forces it into existence.
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS phone_number text;

-- Force the API to load the new column into memory
NOTIFY pgrst, 'reload schema';

SELECT '✅ phone_number column forcefully guaranteed!' as status;
