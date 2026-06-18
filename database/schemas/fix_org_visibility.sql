-- Give public access to read basic organization status so shops can be verified
DROP POLICY IF EXISTS "Public Read Organizations" ON public.organizations;

CREATE POLICY "Public Read Organizations" 
ON public.organizations 
FOR SELECT 
USING (
  subscription_status = 'Active' OR subscription_status IS NULL
);
