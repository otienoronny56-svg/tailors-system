
-- Fix missing UPDATE policy for organizations
-- This allows admins (or any authorized user) to rename their own organization.

CREATE POLICY "Admins Update Own Org" ON public.organizations
FOR UPDATE 
USING (id = get_user_org_id())
WITH CHECK (id = get_user_org_id());
