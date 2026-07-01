-- Update the shop 'Wigs and Styles' to be an 'art' business type
UPDATE public.shops
SET business_type = 'art'
WHERE name = 'Wigs and Styles';
