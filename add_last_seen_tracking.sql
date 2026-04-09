-- Add last_seen_at to user_profiles for real-time activity tracking
ALTER TABLE public.user_profiles 
ADD COLUMN IF NOT EXISTS last_seen_at TIMESTAMPTZ DEFAULT NOW();

-- Create an index for performance on the superadmin dashboard
CREATE INDEX IF NOT EXISTS idx_user_profiles_last_seen ON public.user_profiles(last_seen_at);
