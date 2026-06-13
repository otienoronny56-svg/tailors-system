-- ==========================================================
-- ⚙️ DATABASE FUNCTION: SECURITY DEFINER CLIENT MEASUREMENTS SYNC
-- ==========================================================
-- Run this query in your Supabase SQL Editor.
-- This function allows client-side code (which runs under client/anonymous role constraints)
-- to automatically create or update client records and measurements history.
-- By specifying "SECURITY DEFINER", it runs with database-owner permissions.

DROP FUNCTION IF EXISTS public.sync_client_measurements(integer, text, jsonb);

CREATE OR REPLACE FUNCTION public.sync_client_measurements(
    p_inquiry_id uuid,
    p_garment_type text,
    p_measurements jsonb
) RETURNS uuid SECURITY DEFINER AS $$
DECLARE
    client_phone text;
    client_name text;
    shop_uuid uuid;
    org_uuid uuid;
    existing_client_id uuid;
    history jsonb;
    existing_idx integer;
    entry jsonb;
    i integer;
    new_client_id uuid;
BEGIN
    -- 1. Retrieve client and shop/org details from the inquiry
    SELECT 
        i.client_phone, 
        i.client_name, 
        i.shop_id,
        s.organization_id
    INTO 
        client_phone, 
        client_name, 
        shop_uuid,
        org_uuid
    FROM public.marketplace_inquiries i
    LEFT JOIN public.shops s ON s.id = i.shop_id
    WHERE i.id = p_inquiry_id;

    IF client_phone IS NULL OR org_uuid IS NULL THEN
        RAISE EXCEPTION 'Could not find inquiry details or organization_id for inquiry_id: %', p_inquiry_id;
    END IF;

    -- 2. Look for an existing client profile in this organization by phone
    SELECT id, measurements_history 
    INTO existing_client_id, history
    FROM public.clients
    WHERE organization_id = org_uuid AND phone = client_phone
    LIMIT 1;

    -- Initialize measurements_history if null
    IF history IS NULL THEN
        history := '[]'::jsonb;
    END IF;

    -- 3. Formulate the new history entry
    entry := jsonb_build_object(
        'garment', p_garment_type,
        'updated_at', now(),
        'measurements', p_measurements
    );

    -- Find if garment already exists in history
    existing_idx := -1;
    IF jsonb_array_length(history) > 0 THEN
        FOR i IN 0 .. jsonb_array_length(history) - 1 LOOP
            IF (history->i->>'garment') = p_garment_type THEN
                existing_idx := i;
                EXIT;
            END IF;
        END LOOP;
    END IF;

    IF existing_idx <> -1 THEN
        -- Replace existing entry
        history := jsonb_set(history, array[existing_idx::text], entry);
    ELSE
        -- Append new entry
        history := history || jsonb_build_array(entry);
    END IF;

    -- 4. Update or Insert client profile
    IF existing_client_id IS NOT NULL THEN
        -- Update existing client
        UPDATE public.clients
        SET 
            measurements_history = history,
            last_garment_type = p_garment_type,
            last_visit = now()
        WHERE id = existing_client_id;
        
        new_client_id := existing_client_id;
    ELSE
        -- Insert new client
        INSERT INTO public.clients (
            organization_id,
            shop_id,
            name,
            phone,
            last_garment_type,
            last_visit,
            measurements_history
        ) VALUES (
            org_uuid,
            shop_uuid,
            client_name,
            client_phone,
            p_garment_type,
            now(),
            history
        ) RETURNING id INTO new_client_id;
    END IF;

    RETURN new_client_id;
END;
$$ LANGUAGE plpgsql;

-- Grant execution privileges to all roles (anon, authenticated, service_role)
GRANT EXECUTE ON FUNCTION public.sync_client_measurements(uuid, text, jsonb) TO anon, authenticated, service_role;
