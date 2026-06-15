-- Run this in your Supabase SQL Editor to add the new message columns:

ALTER TABLE messages 
ADD COLUMN is_unsent BOOLEAN DEFAULT FALSE,
ADD COLUMN deleted_for_sender BOOLEAN DEFAULT FALSE,
ADD COLUMN deleted_for_recipient BOOLEAN DEFAULT FALSE;
