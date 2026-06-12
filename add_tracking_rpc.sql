-- ====================================================
-- ORDER TRACKING: Create RPC for unauthenticated tracking
-- ====================================================

-- Function to safely fetch an order by ID for the public tracking page
-- Returns only safe fields (no internal organization_id, etc.)
CREATE OR REPLACE FUNCTION get_tracking_order(tracking_id UUID)
RETURNS TABLE (
    id UUID,
    shop_id UUID,
    customer_name TEXT,
    garment_type TEXT,
    status INTEGER,
    price NUMERIC,
    amount_paid NUMERIC,
    due_date DATE,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ
)
LANGUAGE plpgsql
SECURITY DEFINER -- runs with elevated privileges to bypass RLS
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        o.id,
        o.shop_id,
        o.customer_name,
        o.garment_type,
        o.status,
        o.price,
        o.amount_paid,
        o.due_date,
        o.created_at,
        o.updated_at
    FROM orders o
    WHERE o.id = tracking_id;
END;
$$;

-- Grant execution to anon (guests) and authenticated users
GRANT EXECUTE ON FUNCTION get_tracking_order(UUID) TO anon;
GRANT EXECUTE ON FUNCTION get_tracking_order(UUID) TO authenticated;
