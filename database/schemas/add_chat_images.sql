-- 1. Add image_url column to messages table
ALTER TABLE public.messages ADD COLUMN IF NOT EXISTS image_url text;

-- 2. Create the chat_images bucket if it doesn't exist
INSERT INTO storage.buckets (id, name, public)
VALUES ('chat_images', 'chat_images', true)
ON CONFLICT (id) DO NOTHING;

-- 3. Set up Storage Policies for chat_images
-- Allow public viewing of chat images
CREATE POLICY "Public Access"
ON storage.objects FOR SELECT
USING (bucket_id = 'chat_images');

-- Allow authenticated users to upload images
CREATE POLICY "Authenticated users can upload"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'chat_images' 
);

-- Allow authenticated users to delete their own uploads
CREATE POLICY "Users can delete own uploads"
ON storage.objects FOR DELETE
TO authenticated
USING (
    bucket_id = 'chat_images' 
    AND owner = auth.uid()
);
