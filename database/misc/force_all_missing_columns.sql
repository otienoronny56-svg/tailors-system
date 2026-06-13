-- ==========================================================
-- 🛠️ DEFINITIVE SCHEMA RESCUE
-- ==========================================================
-- This script ensures absolutely every expected column 
-- used by the application exists in the database.

-- 1. ORDERS TABLE
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS manager_id uuid REFERENCES auth.users(id);
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS customer_name text;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS customer_phone text;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS garment_type text;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS measurements_details jsonb DEFAULT '{}'::jsonb;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS customer_preferences text;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS worker_id uuid REFERENCES public.workers(id);
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS additional_workers jsonb DEFAULT '[]'::jsonb;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS price numeric DEFAULT 0;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS amount_paid numeric DEFAULT 0;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS status integer DEFAULT 1;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS due_date date;

-- 2. PAYMENTS TABLE
ALTER TABLE public.payments ADD COLUMN IF NOT EXISTS manager_id uuid REFERENCES auth.users(id);
ALTER TABLE public.payments ADD COLUMN IF NOT EXISTS amount numeric;
ALTER TABLE public.payments ADD COLUMN IF NOT EXISTS payment_method text DEFAULT 'cash';
ALTER TABLE public.payments ADD COLUMN IF NOT EXISTS notes text;

-- 3. EXPENSES TABLE
ALTER TABLE public.expenses ADD COLUMN IF NOT EXISTS manager_id uuid REFERENCES auth.users(id);
ALTER TABLE public.expenses ADD COLUMN IF NOT EXISTS item_name text;
ALTER TABLE public.expenses ADD COLUMN IF NOT EXISTS amount numeric;
ALTER TABLE public.expenses ADD COLUMN IF NOT EXISTS category text DEFAULT 'General';
ALTER TABLE public.expenses ADD COLUMN IF NOT EXISTS notes text;

-- 4. RELOAD CACHE
NOTIFY pgrst, 'reload schema';

SELECT '✅ All missing schema columns have been forcefully injected and API cache reloaded!' as status;
