DROP POLICY IF EXISTS "Super Admins Manage All Blogs" ON public.blogs;
CREATE POLICY "Super Admins Manage All Blogs" 
ON public.blogs FOR ALL 
USING (get_user_role() = 'superadmin')
WITH CHECK (get_user_role() = 'superadmin');
