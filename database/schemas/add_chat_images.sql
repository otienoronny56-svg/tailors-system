-- 1. Add image_url column to messages table
ALTER TABLE public.messages ADD COLUMN IF NOT EXISTS image_url text;

-- 2. Create the chat_images bucket if it doesn't exist
INSERT INTO storage.buckets (id, name, public)
VALUES ('chat_images', 'chat_images', true)
ON CONFLICT (id) DO NOTHING;

-- 3. Set up Storage Policies for chat_images
-- Allow public viewing of chat images
CREATE POLICY "chat_images_public_access"
ON storage.objects FOR SELECT
USING (bucket_id = 'chat_images');

-- Allow authenticated users to upload images
CREATE POLICY "chat_images_authenticated_upload"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'chat_images' 
);

-- Allow authenticated users to delete their own uploads
CREATE POLICY "chat_images_delete_own"
ON storage.objects FOR DELETE
TO authenticated
USING (
    bucket_id = 'chat_images' 
    AND owner = auth.uid()
);
