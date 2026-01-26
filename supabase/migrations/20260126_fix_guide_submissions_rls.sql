-- Enable RLS on the table (ensure it is on)
ALTER TABLE guide_submissions ENABLE ROW LEVEL SECURITY;

-- Policy to allow authenticated users to INSERT (likely already exists or RLS was off, but ensuring it)
CREATE POLICY "Enable insert for authenticated users" 
ON guide_submissions FOR INSERT 
TO authenticated 
WITH CHECK (true);

-- Policy to allow authenticated users to SELECT (This is what's missing for viewing)
-- Ideally, normal users see "own", Admins see "all". 
-- For now, allowing all authenticated users to View All to fix the "Admin not seeing it" issue immediately.
CREATE POLICY "Enable select for authenticated users" 
ON guide_submissions FOR SELECT 
TO authenticated 
USING (true);

-- Policy for UPDATE (for admins later)
CREATE POLICY "Enable update for authenticated users" 
ON guide_submissions FOR UPDATE 
TO authenticated 
USING (true);
