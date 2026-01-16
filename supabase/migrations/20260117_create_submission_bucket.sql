-- Create the storage bucket for submissions if it doesn't exist
INSERT INTO storage.buckets (id, name, public)
VALUES ('submission-assets', 'submission-assets', true)
ON CONFLICT (id) DO NOTHING;

-- Policy: Give authenticated users access to upload to their own folder (or just generally for now)
-- We'll allow public read access (already set by public=true above, but policy is needed for RLS enabled buckets usually)

-- Allow public read access to all files in the bucket (using a unique name)
CREATE POLICY "Public Access Submission Assets"
ON storage.objects FOR SELECT
USING ( bucket_id = 'submission-assets' );

-- Allow authenticated users to upload files (using a unique name)
CREATE POLICY "Authenticated Upload Submission Assets"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'submission-assets'
  AND auth.role() = 'authenticated'
);

-- Allow users to update/delete their own files (using a unique name)
CREATE POLICY "Users Update Own Submission Assets"
ON storage.objects FOR UPDATE
USING (
  bucket_id = 'submission-assets' 
  AND auth.uid() = owner
);
