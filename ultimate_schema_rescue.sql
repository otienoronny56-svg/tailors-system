-- ==========================================================
-- 🛠️ ULTIMATE SCHEMA RESCUE (SHOPS & DATES)
-- ==========================================================
-- This script ensures no table is missing the shop_id 
-- or timestamp columns used heavily by the UI.

ALTER TABLE public.expenses ADD COLUMN IF NOT EXISTS shop_id uuid REFERENCES public.shops(id) ON DELETE CASCADE;
ALTER TABLE public.expenses ADD COLUMN IF NOT EXISTS incurred_at timestamp with time zone DEFAULT timezone('utc'::text, now());

ALTER TABLE public.payments ADD COLUMN IF NOT EXISTS shop_id uuid REFERENCES public.shops(id) ON DELETE CASCADE;
ALTER TABLE public.payments ADD COLUMN IF NOT EXISTS order_id uuid REFERENCES public.orders(id) ON DELETE CASCADE;
ALTER TABLE public.payments ADD COLUMN IF NOT EXISTS edited_by uuid REFERENCES auth.users(id) ON DELETE SET NULL;
ALTER TABLE public.payments ADD COLUMN IF NOT EXISTS edited_at timestamp with time zone;
ALTER TABLE public.payments ADD COLUMN IF NOT EXISTS deleted_by uuid REFERENCES auth.users(id) ON DELETE SET NULL;
ALTER TABLE public.payments ADD COLUMN IF NOT EXISTS deleted_at timestamp with time zone;

ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS shop_id uuid REFERENCES public.shops(id) ON DELETE CASCADE;
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS shop_id uuid REFERENCES public.shops(id) ON DELETE CASCADE;

NOTIFY pgrst, 'reload schema';

SELECT '✅ Ultimate schema rescue applied! All shop relationships guaranteed.' as status;
