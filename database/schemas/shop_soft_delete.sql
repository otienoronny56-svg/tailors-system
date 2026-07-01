-- Migration: Shop Soft Deletion with 488-hour window
-- Enable pg_cron (Note: on Supabase cloud, this might require dashboard activation, but we can try)
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Add deleted_at column
ALTER TABLE public.shops ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMP WITH TIME ZONE;

-- Create an RPC to safely restore a shop
CREATE OR REPLACE FUNCTION public.restore_shop(shop_uuid UUID)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    UPDATE public.shops
    SET status = 'Active', deleted_at = NULL
    WHERE id = shop_uuid;
END;
$$;

-- Create a function to permanently delete expired shops (48 hours)
CREATE OR REPLACE FUNCTION public.cleanup_expired_shops()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Delete shops that have been pending deletion for more than 48 hours
    DELETE FROM public.shops
    WHERE status = 'Pending Deletion' 
      AND deleted_at IS NOT NULL
      AND deleted_at < NOW() - INTERVAL '48 hours';
END;
$$;

-- Schedule the cleanup to run every hour using pg_cron
-- Remove any existing cron job first to avoid duplicates
DO $$
BEGIN
    PERFORM cron.unschedule('cleanup-expired-shops-job');
EXCEPTION WHEN OTHERS THEN
    -- Ignore if job doesn't exist or pg_cron is not properly configured
END
$$;

-- Schedule it to run hourly
SELECT cron.schedule(
    'cleanup-expired-shops-job',
    '0 * * * *', -- Run at minute 0 past every hour
    $$SELECT public.cleanup_expired_shops()$$
);
