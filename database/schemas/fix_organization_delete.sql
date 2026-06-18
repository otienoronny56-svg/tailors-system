ALTER TABLE public.shops
  DROP CONSTRAINT IF EXISTS shops_organization_id_fkey;

ALTER TABLE public.shops
  ADD CONSTRAINT shops_organization_id_fkey 
  FOREIGN KEY (organization_id) 
  REFERENCES public.organizations(id) 
  ON DELETE CASCADE;

-- Also fix user_profiles just in case
ALTER TABLE public.user_profiles
  DROP CONSTRAINT IF EXISTS user_profiles_organization_id_fkey;

ALTER TABLE public.user_profiles
  ADD CONSTRAINT user_profiles_organization_id_fkey 
  FOREIGN KEY (organization_id) 
  REFERENCES public.organizations(id) 
  ON DELETE CASCADE;

-- Also fix workers just in case
ALTER TABLE public.workers
  DROP CONSTRAINT IF EXISTS workers_organization_id_fkey;

ALTER TABLE public.workers
  ADD CONSTRAINT workers_organization_id_fkey 
  FOREIGN KEY (organization_id) 
  REFERENCES public.organizations(id) 
  ON DELETE CASCADE;
