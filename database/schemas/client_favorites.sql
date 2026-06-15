-- ==========================================================
-- ❤️ CLIENT FAVORITES SCHEMA
-- ==========================================================

CREATE TABLE IF NOT EXISTS public.client_favorite_shops (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    client_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    shop_id uuid REFERENCES public.shops(id) ON DELETE CASCADE NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    UNIQUE(client_id, shop_id)
);

-- Enable RLS
ALTER TABLE public.client_favorite_shops ENABLE ROW LEVEL SECURITY;

-- 1. Clients can see their own favorites
DROP POLICY IF EXISTS "Clients can read own favorites" ON public.client_favorite_shops;
CREATE POLICY "Clients can read own favorites" 
ON public.client_favorite_shops 
FOR SELECT 
TO authenticated 
USING (client_id = auth.uid());

-- 2. Clients can add to their favorites
DROP POLICY IF EXISTS "Clients can insert own favorites" ON public.client_favorite_shops;
CREATE POLICY "Clients can insert own favorites" 
ON public.client_favorite_shops 
FOR INSERT 
TO authenticated 
WITH CHECK (client_id = auth.uid());

-- 3. Clients can remove their favorites
DROP POLICY IF EXISTS "Clients can delete own favorites" ON public.client_favorite_shops;
CREATE POLICY "Clients can delete own favorites" 
ON public.client_favorite_shops 
FOR DELETE 
TO authenticated 
USING (client_id = auth.uid());

-- Allow shops/tailors to see who favorited them (Optional: for analytics)
DROP POLICY IF EXISTS "Shops can see their favorites" ON public.client_favorite_shops;
CREATE POLICY "Shops can see their favorites" 
ON public.client_favorite_shops 
FOR SELECT 
TO authenticated 
USING (
    shop_id IN (
        SELECT id FROM public.shops 
        WHERE organization_id = get_user_org_id()
    )
);
