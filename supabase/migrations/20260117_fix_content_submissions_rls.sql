-- Drop existing restrictive policies if necessary (or just add permissive ones which usually OR together)

-- 1. Allow any authenticated user to VIEW all submissions (needed for Admin List)
-- This supplements "Users can view their own submissions" by adding an OR condition effectively.
CREATE POLICY "Allow all authenticated users to view all submissions"
ON content_submissions
FOR SELECT
USING (auth.role() = 'authenticated');

-- 2. Allow any authenticated user to UPDATE any submission (needed for Admin Approve/Reject)
-- We need to bypass the "status = pending" check that restricts the author.
CREATE POLICY "Allow all authenticated users to update submissions"
ON content_submissions
FOR UPDATE
USING (auth.role() = 'authenticated')
WITH CHECK (auth.role() = 'authenticated');

-- Note: The existing "Users can update their own pending submissions" policy restricts users to only 'pending' status.
-- By adding this new broader policy, Postgres allows access if ANY policy passes.
-- So authenticated users (including the author) will now be able to update regardless of status.
