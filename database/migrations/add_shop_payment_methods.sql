ALTER TABLE public.shops ADD COLUMN IF NOT EXISTS payment_method_type TEXT DEFAULT 'paybill';
ALTER TABLE public.shops ADD COLUMN IF NOT EXISTS till_number TEXT;
ALTER TABLE public.shops ADD COLUMN IF NOT EXISTS pochi_number TEXT;
