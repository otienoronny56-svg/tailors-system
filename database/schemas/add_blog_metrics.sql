-- 1. Add views column to blogs table
ALTER TABLE public.blogs 
ADD COLUMN IF NOT EXISTS views INTEGER DEFAULT 0;

-- 2. Create blog_likes table to track individual user likes
CREATE TABLE IF NOT EXISTS public.blog_likes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    blog_id UUID REFERENCES public.blogs(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, blog_id) -- Prevent double liking
);

-- 3. Enable RLS on blog_likes
ALTER TABLE public.blog_likes ENABLE ROW LEVEL SECURITY;

-- 4. Policies for blog_likes
-- Anyone can see how many likes a blog has
DROP POLICY IF EXISTS "Anyone can view likes" ON public.blog_likes;
CREATE POLICY "Anyone can view likes" 
ON public.blog_likes FOR SELECT 
USING (true);

-- Authenticated users can insert their own likes
DROP POLICY IF EXISTS "Users can like a blog" ON public.blog_likes;
CREATE POLICY "Users can like a blog" 
ON public.blog_likes FOR INSERT 
WITH CHECK (auth.uid() = user_id);

-- Authenticated users can remove their own likes
DROP POLICY IF EXISTS "Users can unlike a blog" ON public.blog_likes;
CREATE POLICY "Users can unlike a blog" 
ON public.blog_likes FOR DELETE 
USING (auth.uid() = user_id);

-- 5. Create a function to increment views safely
CREATE OR REPLACE FUNCTION increment_blog_views(blog_slug TEXT)
RETURNS void AS $$
BEGIN
  UPDATE public.blogs
  SET views = views + 1
  WHERE slug = blog_slug;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
