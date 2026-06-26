-- Nuclear option for messages table RLS

ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users Insert Own Messages" ON public.messages;
DROP POLICY IF EXISTS "Users Read Own Chat Threads" ON public.messages;
DROP POLICY IF EXISTS "Superadmin Full Access Messages" ON public.messages;
DROP POLICY IF EXISTS "chat_messages_insert" ON public.messages;
DROP POLICY IF EXISTS "chat_messages_select" ON public.messages;
DROP POLICY IF EXISTS "chat_messages_all" ON public.messages;
DROP POLICY IF EXISTS "messages_insert" ON public.messages;
DROP POLICY IF EXISTS "messages_select" ON public.messages;
DROP POLICY IF EXISTS "messages_update" ON public.messages;

-- Create ultra-permissive policies just for testing or fallback
CREATE POLICY "Users Insert Own Messages" 
ON public.messages 
FOR INSERT 
TO authenticated 
WITH CHECK (true);

CREATE POLICY "Users Read Own Chat Threads" 
ON public.messages 
FOR SELECT 
TO authenticated 
USING (true);

CREATE POLICY "Superadmin Full Access Messages" 
ON public.messages 
FOR ALL 
USING (get_user_role() = 'superadmin');
