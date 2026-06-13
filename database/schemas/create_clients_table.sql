-- Create Clients Table
CREATE TABLE IF NOT EXISTS public.clients (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    name text NOT NULL,
    phone text UNIQUE NOT NULL,
    measurements_history jsonb DEFAULT '[]'::jsonb,
    last_garment_type text,
    notes text,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now())
);

-- Enable RLS
ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;

-- Policy: Authenticated users can do everything
CREATE POLICY "Allow All for Auth Users" ON public.clients FOR ALL USING (auth.role() = 'authenticated');

-- Initial Migration from Orders
INSERT INTO public.clients (name, phone, measurements_history, last_garment_type, notes, created_at)
SELECT DISTINCT ON (customer_phone) 
    customer_name, 
    customer_phone, 
    jsonb_build_array(jsonb_build_object(
        'date', created_at,
        'garment', garment_type,
        'measurements', measurements_details
    )),
    garment_type,
    customer_preferences,
    created_at
FROM public.orders
WHERE customer_phone IS NOT NULL AND customer_phone != ''
ON CONFLICT (phone) DO NOTHING;

-- Grant permissions
GRANT ALL ON public.clients TO authenticated, service_role;
