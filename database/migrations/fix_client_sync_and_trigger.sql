-- ==========================================================
-- 🛠️ DATABASE MIGRATION: CLIENT SYNC & TRIGGERS ENHANCEMENT
-- ==========================================================
-- Run this script in your Supabase SQL Editor.
-- This script automates registering customers to the clients database
-- when they send inquiries, and ensures their names and measurements sync.

-- 1. RE-CREATE THE CLIENT PROFILE SYNC FUNCTION (With name-update capability)
-- ==========================================================
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
    -- Retrieve client and shop/org details from the inquiry
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

    -- Look for an existing client profile in this organization by phone
    SELECT id, measurements_history 
    INTO existing_client_id, history
    FROM public.clients
    WHERE organization_id = org_uuid AND phone = client_phone
    LIMIT 1;

    -- Initialize measurements_history if null
    IF history IS NULL THEN
        history := '[]'::jsonb;
    END IF;

    -- Formulate the new history entry (if garment type and measurements are provided)
    IF p_garment_type IS NOT NULL AND p_garment_type <> '' AND p_measurements IS NOT NULL AND p_measurements <> '{}'::jsonb THEN
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
    END IF;

    -- Update or Insert client profile
    IF existing_client_id IS NOT NULL THEN
        -- Update existing client (Ensure name is updated to the latest name submitted)
        UPDATE public.clients
        SET 
            name = COALESCE(client_name, name),
            measurements_history = history,
            last_garment_type = COALESCE(p_garment_type, last_garment_type),
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

GRANT EXECUTE ON FUNCTION public.sync_client_measurements(uuid, text, jsonb) TO anon, authenticated, service_role;


-- 2. RE-CREATE THE MEASUREMENT SUBMISSION TRIGGER FUNCTION
-- ==========================================================
CREATE OR REPLACE FUNCTION public.sync_measurement_submission_trigger()
RETURNS TRIGGER AS $$
DECLARE
    garment_type text;
    json_payload text;
    payload_json jsonb;
    client_phone text;
    client_name text;
    shop_uuid uuid;
    org_uuid uuid;
    existing_client_id uuid;
    history jsonb;
    existing_idx integer;
    entry jsonb;
    i integer;
BEGIN
    -- Check if the message is a measurement submission
    IF NEW.message_text LIKE '[MEASUREMENT_SUBMISSION:%' THEN
        -- Extract garment type and JSON payload
        garment_type := split_part(substring(NEW.message_text from 25), ':', 1);
        json_payload := substring(NEW.message_text from 25 + length(garment_type) + 2);
        
        -- Strip trailing ']' if present
        IF right(json_payload, 1) = ']' THEN
            json_payload := left(json_payload, -1);
        END IF;

        BEGIN
            payload_json := json_payload::jsonb;
        EXCEPTION WHEN OTHERS THEN
            RETURN NEW;
        END;

        -- Retrieve the inquiry details to get the client details, shop_id, and organization_id
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
        WHERE i.id = NEW.inquiry_id;

        IF client_phone IS NULL OR org_uuid IS NULL THEN
            RETURN NEW;
        END IF;

        -- Look for existing client in this organization by phone
        SELECT id, measurements_history 
        INTO existing_client_id, history
        FROM public.clients
        WHERE organization_id = org_uuid AND phone = client_phone
        LIMIT 1;

        -- Initialize measurements_history if null
        IF history IS NULL THEN
            history := '[]'::jsonb;
        END IF;

        -- Formulate the new history entry
        entry := jsonb_build_object(
            'garment', garment_type,
            'updated_at', NEW.created_at,
            'measurements', payload_json
        );

        -- Find if garment already exists in history
        existing_idx := -1;
        IF jsonb_array_length(history) > 0 THEN
            FOR i IN 0 .. jsonb_array_length(history) - 1 LOOP
                IF (history->i->>'garment') = garment_type THEN
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

        IF existing_client_id IS NOT NULL THEN
            -- Update existing client
            UPDATE public.clients
            SET 
                name = COALESCE(client_name, name), -- Sync name too
                measurements_history = history,
                last_garment_type = garment_type,
                last_visit = NEW.created_at
            WHERE id = existing_client_id;
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
                garment_type,
                NEW.created_at,
                history
            );
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_sync_measurement_submission ON public.messages;
CREATE TRIGGER trg_sync_measurement_submission
AFTER INSERT ON public.messages
FOR EACH ROW
EXECUTE FUNCTION public.sync_measurement_submission_trigger();


-- 3. CREATE TRIGGER TO AUTOMATICALLY ADD CLIENT ON NEW INQUIRY SUBMISSION
-- ==========================================================
CREATE OR REPLACE FUNCTION public.sync_new_inquiry_trigger()
RETURNS TRIGGER AS $$
DECLARE
    org_uuid uuid;
    existing_client_id uuid;
BEGIN
    -- Get organization_id of the shop
    SELECT organization_id INTO org_uuid
    FROM public.shops
    WHERE id = NEW.shop_id;

    IF org_uuid IS NULL THEN
        RETURN NEW;
    END IF;

    -- Look for existing client in this organization by phone
    SELECT id INTO existing_client_id
    FROM public.clients
    WHERE organization_id = org_uuid AND phone = NEW.client_phone
    LIMIT 1;

    IF existing_client_id IS NOT NULL THEN
        -- Update name to the latest client name and last visit
        UPDATE public.clients
        SET 
            name = NEW.client_name,
            last_visit = NEW.created_at
        WHERE id = existing_client_id;
    ELSE
        -- Insert new client record
        INSERT INTO public.clients (
            organization_id,
            shop_id,
            name,
            phone,
            last_visit,
            measurements_history
        ) VALUES (
            org_uuid,
            NEW.shop_id,
            NEW.client_name,
            NEW.client_phone,
            NEW.created_at,
            '[]'::jsonb
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_sync_new_inquiry ON public.marketplace_inquiries;
CREATE TRIGGER trg_sync_new_inquiry
AFTER INSERT ON public.marketplace_inquiries
FOR EACH ROW
EXECUTE FUNCTION public.sync_new_inquiry_trigger();


-- 4. BATCH SYNC EXISTING DATA (Ensure all past client inquiries/messages sync)
-- ==========================================================
DO $$
DECLARE
    r RECORD;
    org_uuid uuid;
    existing_client_id uuid;
BEGIN
    FOR r IN SELECT * FROM public.marketplace_inquiries LOOP
        SELECT organization_id INTO org_uuid FROM public.shops WHERE id = r.shop_id;
        
        IF org_uuid IS NOT NULL THEN
            SELECT id INTO existing_client_id FROM public.clients WHERE organization_id = org_uuid AND phone = r.client_phone LIMIT 1;
            
            IF existing_client_id IS NOT NULL THEN
                UPDATE public.clients SET name = r.client_name, last_visit = r.created_at WHERE id = existing_client_id;
            ELSE
                INSERT INTO public.clients (
                    organization_id,
                    shop_id,
                    name,
                    phone,
                    last_visit,
                    measurements_history
                ) VALUES (
                    org_uuid,
                    r.shop_id,
                    r.client_name,
                    r.client_phone,
                    r.created_at,
                    '[]'::jsonb
                );
            END IF;
        END IF;
    END LOOP;
END $$;


-- 5. BATCH SYNC EXISTING MEASUREMENTS FROM MESSAGE LOGS
-- ==========================================================
DO $$
DECLARE
    r RECORD;
    garment_type text;
    json_payload text;
    payload_json jsonb;
    client_phone text;
    client_name text;
    shop_uuid uuid;
    org_uuid uuid;
    existing_client_id uuid;
    history jsonb;
    existing_idx integer;
    entry jsonb;
    i integer;
BEGIN
    FOR r IN SELECT * FROM public.messages WHERE message_text LIKE '[MEASUREMENT_SUBMISSION:%' ORDER BY created_at ASC LOOP
        garment_type := split_part(substring(r.message_text from 25), ':', 1);
        json_payload := substring(r.message_text from 25 + length(garment_type) + 2);
        IF right(json_payload, 1) = ']' THEN
            json_payload := left(json_payload, -1);
        END IF;
        
        BEGIN
            payload_json := json_payload::jsonb;
        EXCEPTION WHEN OTHERS THEN
            CONTINUE;
        END;

        SELECT i.client_phone, i.client_name, i.shop_id, s.organization_id
        INTO client_phone, client_name, shop_uuid, org_uuid
        FROM public.marketplace_inquiries i
        LEFT JOIN public.shops s ON s.id = i.shop_id
        WHERE i.id = r.inquiry_id;

        IF client_phone IS NOT NULL AND org_uuid IS NOT NULL THEN
            SELECT id, measurements_history INTO existing_client_id, history
            FROM public.clients
            WHERE organization_id = org_uuid AND phone = client_phone
            LIMIT 1;

            IF existing_client_id IS NOT NULL THEN
                IF history IS NULL THEN
                    history := '[]'::jsonb;
                END IF;

                entry := jsonb_build_object(
                    'garment', garment_type,
                    'updated_at', r.created_at,
                    'measurements', payload_json
                );

                existing_idx := -1;
                IF jsonb_array_length(history) > 0 THEN
                    FOR i IN 0 .. jsonb_array_length(history) - 1 LOOP
                        IF (history->i->>'garment') = garment_type THEN
                            existing_idx := i;
                            EXIT;
                        END IF;
                    END LOOP;
                END IF;

                IF existing_idx <> -1 THEN
                    history := jsonb_set(history, array[existing_idx::text], entry);
                ELSE
                    history := history || jsonb_build_array(entry);
                END IF;

                UPDATE public.clients
                SET 
                    name = client_name,
                    measurements_history = history,
                    last_garment_type = garment_type,
                    last_visit = r.created_at
                WHERE id = existing_client_id;
            END IF;
        END IF;
    END LOOP;
END $$;

SELECT '✅ All database client sync triggers & batch migrations executed successfully!' as status;
