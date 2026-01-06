-- Add RLS policy for guide_sections table to allow public read access

-- Enable RLS on guide_sections if not already enabled
ALTER TABLE guide_sections ENABLE ROW LEVEL SECURITY;

-- Create policy to allow anyone to read guide_sections
CREATE POLICY "Allow public read access to guide_sections"
ON guide_sections
FOR SELECT
TO anon, authenticated
USING (true);
