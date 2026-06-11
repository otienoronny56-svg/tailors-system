-- Run this SQL in your Supabase SQL Editor to add the email column to user_profiles and backfill existing accounts:

-- 1. Add email column to public.user_profiles
ALTER TABLE public.user_profiles ADD COLUMN IF NOT EXISTS email text;

-- 2. Backfill existing emails from auth.users table
UPDATE public.user_profiles p
SET email = u.email
FROM auth.users u
WHERE p.id = u.id;

-- 3. Confirm update (optional verification)
SELECT id, full_name, role, email FROM public.user_profiles LIMIT 10;
