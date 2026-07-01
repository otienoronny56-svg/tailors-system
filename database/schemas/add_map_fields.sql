-- Add the necessary location columns to the shops table
ALTER TABLE public.shops ADD COLUMN IF NOT EXISTS location_name text;
ALTER TABLE public.shops ADD COLUMN IF NOT EXISTS latitude double precision;
ALTER TABLE public.shops ADD COLUMN IF NOT EXISTS longitude double precision;

-- Create the database function to calculate distance and find nearby shops
DROP FUNCTION IF EXISTS get_shops_near_me(double precision, double precision, double precision);
CREATE OR REPLACE FUNCTION get_shops_near_me(user_lat double precision, user_lon double precision, radius_in_meters double precision)
RETURNS TABLE (
    id uuid,
    shop_name text,
    location_name text,
    latitude double precision,
    longitude double precision,
    distance_meters double precision
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        s.id,
        s.name AS shop_name,
        s.location_name,
        s.latitude::double precision,
        s.longitude::double precision,
        -- Calculate distance using the Haversine formula
        (6371000 * acos(
            cos(radians(user_lat)) * cos(radians(s.latitude)) * 
            cos(radians(s.longitude) - radians(user_lon)) + 
            sin(radians(user_lat)) * sin(radians(s.latitude))
        )) AS distance_meters
    FROM public.shops s
    WHERE s.latitude IS NOT NULL AND s.longitude IS NOT NULL
    AND (
        6371000 * acos(
            cos(radians(user_lat)) * cos(radians(s.latitude)) * 
            cos(radians(s.longitude) - radians(user_lon)) + 
            sin(radians(user_lat)) * sin(radians(s.latitude))
        )
    ) <= radius_in_meters
    ORDER BY distance_meters ASC;
END;
$$;
