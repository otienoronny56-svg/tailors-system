-- Fix the clients unique constraint to be multi-tenant safe
ALTER TABLE public.clients DROP CONSTRAINT IF EXISTS clients_phone_key;
ALTER TABLE public.clients DROP CONSTRAINT IF EXISTS clients_phone_key1;
ALTER TABLE public.clients DROP CONSTRAINT IF EXISTS clients_organization_id_phone_key;

ALTER TABLE public.clients ADD CONSTRAINT clients_organization_id_phone_key UNIQUE (organization_id, phone);
