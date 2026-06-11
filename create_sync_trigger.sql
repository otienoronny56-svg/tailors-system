-- ==========================================================
-- ⚙️ DATABASE TRIGGER: AUTOMATIC CLIENT MEASUREMENTS SYNC
-- ==========================================================
-- This trigger listens for new messages. If the message starts with '[MEASUREMENT_SUBMISSION:',
-- it parses the payload and updates/inserts the client profile in the public.clients table.
-- Because it runs as SECURITY DEFINER, it bypasses client-side RLS write restrictions.

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
        -- Format is [MEASUREMENT_SUBMISSION:GarmentType:JSON_PAYLOAD]
        garment_type := split_part(substring(NEW.message_text from 25), ':', 1);
        json_payload := substring(NEW.message_text from 25 + length(garment_type) + 2);
        
        -- Strip trailing ']' if present
        IF right(json_payload, 1) = ']' THEN
            json_payload := left(json_payload, -1);
        END IF;

        BEGIN
            payload_json := json_payload::jsonb;
        EXCEPTION WHEN OTHERS THEN
            RAISE WARNING 'Failed to parse JSON payload in sync_measurement_submission_trigger: %', json_payload;
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
            RAISE WARNING 'Could not find inquiry details or organization_id for inquiry_id: %', NEW.inquiry_id;
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

-- Bind Trigger
DROP TRIGGER IF EXISTS trg_sync_measurement_submission ON public.messages;
CREATE TRIGGER trg_sync_measurement_submission
AFTER INSERT ON public.messages
FOR EACH ROW
EXECUTE FUNCTION public.sync_measurement_submission_trigger();
