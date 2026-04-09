-- Add subscription tracking to organizations
ALTER TABLE public.organizations 
ADD COLUMN IF NOT EXISTS subscription_tier TEXT DEFAULT 'Basic',
ADD COLUMN IF NOT EXISTS subscription_status TEXT DEFAULT 'Active',
ADD COLUMN IF NOT EXISTS monthly_price DECIMAL(12,2) DEFAULT 0,
ADD COLUMN IF NOT EXISTS billing_cycle TEXT DEFAULT 'Monthly';

-- Seed existing organizations with Basic tier
UPDATE public.organizations 
SET subscription_tier = 'Basic', 
    subscription_status = 'Active',
    monthly_price = 50.00,
    billing_cycle = 'Monthly'
WHERE subscription_tier IS NULL;
