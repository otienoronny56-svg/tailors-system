-- Allow Superadmins to update any user profile (needed for Suspend/Activate)
CREATE POLICY "Superadmins can update any profile" 
ON public.user_profiles 
FOR UPDATE 
TO authenticated 
USING (
  (SELECT role FROM public.user_profiles WHERE id = auth.uid()) = 'superadmin'
)
WITH CHECK (
  (SELECT role FROM public.user_profiles WHERE id = auth.uid()) = 'superadmin'
);
