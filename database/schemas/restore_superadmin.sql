-- Restore Superadmin Profile
INSERT INTO public.user_profiles (id, full_name, role)
SELECT id, 'Ronny Admin', 'superadmin' 
FROM auth.users 
WHERE email = 'ronnywinstonee@gmail.com'
ON CONFLICT (id) DO UPDATE SET role = 'superadmin';
