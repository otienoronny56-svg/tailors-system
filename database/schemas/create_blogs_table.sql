-- Create blogs table
CREATE TABLE IF NOT EXISTS public.blogs (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    content TEXT NOT NULL,
    image_url TEXT,
    author_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    shop_id UUID REFERENCES public.organizations(id) ON DELETE CASCADE,
    status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'pending', 'published', 'rejected')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.blogs ENABLE ROW LEVEL SECURITY;

-- Policy: Public can read published blogs
DROP POLICY IF EXISTS "Public can read published blogs" ON public.blogs;
CREATE POLICY "Public can read published blogs" 
ON public.blogs FOR SELECT 
USING (status = 'published');

-- Policy: Super Admins can read all blogs
DROP POLICY IF EXISTS "Super Admins can read all blogs" ON public.blogs;
CREATE POLICY "Super Admins can read all blogs" 
ON public.blogs FOR SELECT 
USING (get_user_role() = 'superadmin');

-- Policy: Super Admins can update all blogs (to approve/reject)
DROP POLICY IF EXISTS "Super Admins can update all blogs" ON public.blogs;
CREATE POLICY "Super Admins can update all blogs" 
ON public.blogs FOR UPDATE 
USING (get_user_role() = 'superadmin');

-- Policy: Employees Manage Own Shop Blogs
DROP POLICY IF EXISTS "Employees Manage Own Blogs" ON public.blogs;
CREATE POLICY "Employees Manage Own Blogs" 
ON public.blogs FOR ALL 
TO authenticated 
USING (shop_id = get_user_org_id()) 
WITH CHECK (shop_id = get_user_org_id());

-- Trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_blog_updated_at()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS update_blogs_updated_at ON public.blogs;
CREATE TRIGGER update_blogs_updated_at
BEFORE UPDATE ON public.blogs
FOR EACH ROW
EXECUTE FUNCTION update_blog_updated_at();
