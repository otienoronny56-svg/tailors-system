-- ==========================================================
-- 💬 IN-APP MESSAGING SCHEMA SETUP
-- ==========================================================

-- 1. CREATE MESSAGES TABLE
-- ==========================================================
CREATE TABLE IF NOT EXISTS public.messages (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    inquiry_id uuid REFERENCES public.marketplace_inquiries(id) ON DELETE SET NULL,
    sender_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    recipient_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    message_text text NOT NULL,
    is_read boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);

-- 2. ENABLE ROW LEVEL SECURITY
-- ==========================================================
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

-- 3. DEFINE ROW LEVEL SECURITY POLICIES
-- ==========================================================
DROP POLICY IF EXISTS "Users Insert Own Messages" ON public.messages;
DROP POLICY IF EXISTS "Users Read Own Chat Threads" ON public.messages;
DROP POLICY IF EXISTS "Superadmin Full Access Messages" ON public.messages;

-- Authenticated users can insert messages where they are the sender
CREATE POLICY "Users Insert Own Messages" 
ON public.messages 
FOR INSERT 
TO authenticated 
WITH CHECK (auth.uid() = sender_id);

-- Authenticated users can read messages where they are either sender or recipient
CREATE POLICY "Users Read Own Chat Threads" 
ON public.messages 
FOR SELECT 
TO authenticated 
USING (auth.uid() = sender_id OR auth.uid() = recipient_id);

-- Superadmin full access
CREATE POLICY "Superadmin Full Access Messages" 
ON public.messages 
FOR ALL 
USING (get_user_role() = 'superadmin');

-- 4. ENABLE REALTIME REPLICATION FOR INSTANT CHAT STREAMING
-- ==========================================================
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_publication WHERE pubname = 'supabase_realtime') THEN
    -- Only add the table if it is not already part of the publication to avoid duplicate relation errors
    IF NOT EXISTS (
      SELECT 1 FROM pg_publication_rel pr
      JOIN pg_class c ON c.oid = pr.prrelid
      JOIN pg_publication p ON p.oid = pr.prpubid
      WHERE p.pubname = 'supabase_realtime'
      AND c.relname = 'messages'
      AND c.relnamespace = 'public'::regnamespace
    ) THEN
      ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;
    END IF;
  END IF;
END $$;
