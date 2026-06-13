-- Fix for 'column payments.deleted_at does not exist' Error
-- Please run this exact script in your Supabase SQL Editor for the project: nbksbimxyssfbgfxzcnc

ALTER TABLE public.payments 
ADD COLUMN IF NOT EXISTS edited_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
ADD COLUMN IF NOT EXISTS edited_at timestamp with time zone,
ADD COLUMN IF NOT EXISTS deleted_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
ADD COLUMN IF NOT EXISTS deleted_at timestamp with time zone;

CREATE OR REPLACE FUNCTION update_order_paid_amount()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE public.orders
  SET amount_paid = (
    SELECT COALESCE(SUM(amount), 0)
    FROM public.payments
    WHERE order_id = NEW.order_id AND deleted_at IS NULL
  )
  WHERE id = NEW.order_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

NOTIFY pgrst, 'reload schema';

SELECT '✅ Columns successfully added to payments table!' as status;
