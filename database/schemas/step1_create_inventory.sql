-- =============================================
-- STEP 1: Create Inventory Items Table
-- =============================================
-- Run this in Supabase SQL Editor
-- This creates the product catalog for each shop

CREATE TABLE IF NOT EXISTS inventory_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id UUID NOT NULL,
  shop_id UUID NOT NULL,
  name TEXT NOT NULL,
  category TEXT NOT NULL DEFAULT 'Accessory',
  sku TEXT,
  price NUMERIC NOT NULL DEFAULT 0,
  stock_quantity INTEGER NOT NULL DEFAULT 0,
  low_stock_threshold INTEGER DEFAULT 5,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- =============================================
-- STEP 2: Enhance order_accessories table
-- =============================================
-- Link sold extras back to the inventory catalog

ALTER TABLE order_accessories
  ADD COLUMN IF NOT EXISTS inventory_item_id UUID REFERENCES inventory_items(id),
  ADD COLUMN IF NOT EXISTS organization_id UUID,
  ADD COLUMN IF NOT EXISTS shop_id UUID;

-- =============================================
-- STEP 3: RLS Policies for Tenant Isolation
-- =============================================

ALTER TABLE inventory_items ENABLE ROW LEVEL SECURITY;

-- Users can only see their own organization's inventory
CREATE POLICY "Users see own org inventory"
  ON inventory_items FOR SELECT TO authenticated
  USING (organization_id = (
    SELECT organization_id FROM user_profiles WHERE id = auth.uid()
  ));

-- Managers/Owners can manage (insert/update/delete) their own inventory
CREATE POLICY "Managers manage own org inventory"
  ON inventory_items FOR INSERT TO authenticated
  WITH CHECK (organization_id = (
    SELECT organization_id FROM user_profiles WHERE id = auth.uid()
  ));

CREATE POLICY "Managers update own org inventory"
  ON inventory_items FOR UPDATE TO authenticated
  USING (organization_id = (
    SELECT organization_id FROM user_profiles WHERE id = auth.uid()
  ));

CREATE POLICY "Managers delete own org inventory"
  ON inventory_items FOR DELETE TO authenticated
  USING (organization_id = (
    SELECT organization_id FROM user_profiles WHERE id = auth.uid()
  ));

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_inventory_org_shop ON inventory_items(organization_id, shop_id);
CREATE INDEX IF NOT EXISTS idx_inventory_category ON inventory_items(category);
CREATE INDEX IF NOT EXISTS idx_inventory_active ON inventory_items(is_active);
