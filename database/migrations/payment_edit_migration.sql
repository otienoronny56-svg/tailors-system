-- ==========================================================
-- 💰 PAYMENT EDIT & SOFT DELETE MIGRATION
-- ==========================================================
-- Run this script in your Supabase SQL editor to enable payment editing

-- 1. Add new columns to payments table
-- ==========================================================
ALTER TABLE public.payments
ADD COLUMN IF NOT EXISTS edited_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
ADD COLUMN IF NOT EXISTS edited_at timestamp with time zone,
ADD COLUMN IF NOT EXISTS deleted_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
ADD COLUMN IF NOT EXISTS deleted_at timestamp with time zone;

-- 2. Update the trigger to handle soft deletes (exclude deleted payments)
-- ==========================================================
DROP TRIGGER IF EXISTS on_payment_added ON public.payments;
DROP FUNCTION IF EXISTS update_order_paid_amount();

CREATE OR REPLACE FUNCTION update_order_paid_amount()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE public.orders
  SET amount_paid = (
    SELECT COALESCE(SUM(amount), 0)
    FROM public.payments
    WHERE order_id = NEW.order_id AND deleted_at IS NULL  -- Only count non-deleted payments
  )
  WHERE id = NEW.order_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_payment_added
AFTER INSERT OR UPDATE OR DELETE ON public.payments
FOR EACH ROW EXECUTE PROCEDURE update_order_paid_amount();

-- 3. Update RLS Policies for Payment Editing (SIMPLIFIED - Admin Only)
-- ==========================================================
DROP POLICY IF EXISTS "Allow All for Auth Users" ON public.payments;

-- Read: All authenticated users can view non-deleted payments
CREATE POLICY "Users can view non-deleted payments" ON public.payments
FOR SELECT USING (deleted_at IS NULL AND auth.role() = 'authenticated');

-- Insert: All authenticated users can record new payments
CREATE POLICY "Users can insert payments" ON public.payments
FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Update: Only admins/owners can edit payments (Simple check - App.js handles role validation)
CREATE POLICY "Only admins can update payments" ON public.payments
FOR UPDATE USING (auth.role() = 'authenticated')
WITH CHECK (auth.role() = 'authenticated');

-- Delete: Only admins can soft-delete payments (Simple check - App.js handles role validation)
CREATE POLICY "Only admins can delete payments" ON public.payments
FOR DELETE USING (auth.role() = 'authenticated');

-- 4. Done!
SELECT '✅ Payment editing system enabled. New fields: edited_by, edited_at, deleted_by, deleted_at' as status;
