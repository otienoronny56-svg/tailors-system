-- Add status tracking to user_profiles
ALTER TABLE public.user_profiles 
ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'Active';

-- Ensure existing nulls are Active
UPDATE public.user_profiles SET status = 'Active' WHERE status IS NULL;

-- Create index for performance
CREATE INDEX IF NOT EXISTS idx_user_profiles_status ON public.user_profiles(status);
