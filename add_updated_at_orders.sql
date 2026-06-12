-- ====================================================
-- FIX: Add updated_at column to orders table
-- Run this in Supabase SQL Editor
-- ====================================================

-- 1. Add the column (defaults to now for existing rows)
ALTER TABLE orders
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT NOW();

-- 2. Backfill existing rows with created_at as a sensible default
UPDATE orders SET updated_at = created_at WHERE updated_at IS NULL;

-- 3. Auto-update trigger — keeps updated_at current on every UPDATE
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS orders_set_updated_at ON orders;
CREATE TRIGGER orders_set_updated_at
  BEFORE UPDATE ON orders
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- Verify
SELECT id, status, created_at, updated_at FROM orders LIMIT 3;
