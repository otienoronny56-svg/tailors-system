-- Create marketplace_likes table
CREATE TABLE IF NOT EXISTS public.marketplace_likes (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid REFERENCES public.user_profiles(id) ON DELETE CASCADE NOT NULL,
    listing_id uuid REFERENCES public.marketplace_listings(id) ON DELETE CASCADE NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    UNIQUE (user_id, listing_id)
);

-- Enable RLS
ALTER TABLE public.marketplace_likes ENABLE ROW LEVEL SECURITY;

-- Policies
DROP POLICY IF EXISTS "Public Read Likes" ON public.marketplace_likes;
CREATE POLICY "Public Read Likes" 
ON public.marketplace_likes 
FOR SELECT 
USING (true);

DROP POLICY IF EXISTS "Users Manage Own Likes" ON public.marketplace_likes;
CREATE POLICY "Users Manage Own Likes" 
ON public.marketplace_likes 
FOR ALL 
TO authenticated 
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);
