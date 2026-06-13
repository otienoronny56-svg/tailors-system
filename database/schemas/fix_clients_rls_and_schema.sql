CREATE TABLE IF NOT EXISTS public.clients (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
    shop_id UUID REFERENCES public.shops(id) ON DELETE SET NULL,
    name TEXT NOT NULL,
    phone TEXT UNIQUE,
    last_garment_type TEXT,
    last_visit TIMESTAMP WITH TIME ZONE,
    measurements_history JSONB DEFAULT '[]'::jsonb,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Ensure all expected columns exist if the table was created previously without them
DO $$
BEGIN
    BEGIN
        ALTER TABLE public.clients ADD COLUMN organization_id UUID REFERENCES public.organizations(id) ON DELETE CASCADE;
    EXCEPTION WHEN duplicate_column THEN END;
    
    BEGIN
        ALTER TABLE public.clients ADD COLUMN shop_id UUID REFERENCES public.shops(id) ON DELETE SET NULL;
    EXCEPTION WHEN duplicate_column THEN END;
    
    BEGIN
        ALTER TABLE public.clients ADD COLUMN last_garment_type TEXT;
    EXCEPTION WHEN duplicate_column THEN END;
    
    BEGIN
        ALTER TABLE public.clients ADD COLUMN last_visit TIMESTAMP WITH TIME ZONE;
    EXCEPTION WHEN duplicate_column THEN END;
    
    BEGIN
        ALTER TABLE public.clients ADD COLUMN measurements_history JSONB DEFAULT '[]'::jsonb;
    EXCEPTION WHEN duplicate_column THEN END;
    
    BEGIN
        ALTER TABLE public.clients ADD COLUMN notes TEXT;
    EXCEPTION WHEN duplicate_column THEN END;
    
    BEGIN
        ALTER TABLE public.clients ADD CONSTRAINT clients_phone_key UNIQUE (phone);
    EXCEPTION WHEN duplicate_table THEN END;
END $$;

-- Enable Row Level Security
ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;

-- Drop old policies if they exist
DROP POLICY IF EXISTS "Users can view clients in their shop" ON public.clients;
DROP POLICY IF EXISTS "Users can insert clients in their shop" ON public.clients;
DROP POLICY IF EXISTS "Users can update clients in their shop" ON public.clients;
DROP POLICY IF EXISTS "Users can view clients in their organization" ON public.clients;
DROP POLICY IF EXISTS "Users can insert clients in their organization" ON public.clients;
DROP POLICY IF EXISTS "Users can update clients in their organization" ON public.clients;

-- Recreate Comprehensive Standardized RLS Policies
CREATE POLICY "Users can view clients in their organization"
ON public.clients FOR SELECT
USING (
    organization_id IN (
        SELECT organization_id FROM public.user_profiles WHERE id = auth.uid()
    )
    AND (
        shop_id IS NULL OR -- Important: If client has no specific shop, any admin in the org can see them
        shop_id = (SELECT shop_id FROM public.user_profiles WHERE id = auth.uid()) OR
        'owner' = (SELECT role FROM public.user_profiles WHERE id = auth.uid()) OR
        'manager' = (SELECT role FROM public.user_profiles WHERE id = auth.uid())
    )
);

CREATE POLICY "Users can insert clients in their organization"
ON public.clients FOR INSERT
WITH CHECK (
    organization_id IN (
        SELECT organization_id FROM public.user_profiles WHERE id = auth.uid()
    )
);

CREATE POLICY "Users can update clients in their organization"
ON public.clients FOR UPDATE
USING (
    organization_id IN (
        SELECT organization_id FROM public.user_profiles WHERE id = auth.uid()
    )
);

CREATE POLICY "Users can delete clients in their organization"
ON public.clients FOR DELETE
USING (
    organization_id IN (
        SELECT organization_id FROM public.user_profiles WHERE id = auth.uid()
    )
    AND (
        'owner' = (SELECT role FROM public.user_profiles WHERE id = auth.uid()) OR
        'manager' = (SELECT role FROM public.user_profiles WHERE id = auth.uid())
    )
);

-- Backfill organization_id and shop_id for completely orphaned objects
UPDATE public.clients c
SET organization_id = (SELECT organization_id FROM public.user_profiles LIMIT 1)
WHERE organization_id IS NULL;

-- Automatically migrate all unique existing customers from the orders table over to the clients table
INSERT INTO public.clients (organization_id, shop_id, name, phone, last_garment_type, last_visit)
SELECT DISTINCT ON (customer_phone, customer_name) 
    o.organization_id, 
    o.shop_id, 
    o.customer_name as name, 
    o.customer_phone as phone, 
    o.garment_type as last_garment_type, 
    o.created_at as last_visit
FROM public.orders o
WHERE o.customer_name IS NOT NULL AND o.organization_id IS NOT NULL
ON CONFLICT (phone) DO UPDATE 
SET 
    last_visit = EXCLUDED.last_visit,
    last_garment_type = EXCLUDED.last_garment_type,
    shop_id = COALESCE(public.clients.shop_id, EXCLUDED.shop_id);
