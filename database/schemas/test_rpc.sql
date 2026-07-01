-- Test the spatial function directly to see if it finds the shops we just force-updated to Nairobi
-- User's approximate location based on screenshot (Limuru/Kikuyu area):
-- Latitude: -1.144
-- Longitude: 36.643

SELECT * FROM get_shops_near_me(-1.144, 36.643, 50000);
