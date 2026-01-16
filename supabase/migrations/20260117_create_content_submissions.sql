-- Create content_submissions table
CREATE TABLE IF NOT EXISTS content_submissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  type TEXT NOT NULL CHECK (type IN ('prompt', 'agent', 'workflow', 'template', 'design')),
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  title TEXT NOT NULL,
  content JSONB NOT NULL DEFAULT '{}'::jsonb, -- Stores category-specific fields
  images TEXT[] DEFAULT '{}', -- Array of image URLs
  admin_notes TEXT,
  submitted_at TIMESTAMPTZ DEFAULT now(),
  reviewed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS
ALTER TABLE content_submissions ENABLE ROW LEVEL SECURITY;

-- Policies

-- Users can view their own submissions
CREATE POLICY "Users can view their own submissions"
  ON content_submissions
  FOR SELECT
  USING (auth.uid() = user_id);

-- Admins can view all submissions (assuming admins meet specific criteria, or we can leave it open to service_role for now. 
-- Often admin panels use service_role, but for frontend RLS, we might need an admin check. 
-- For now, let's allow users to see their own. Admins usually have full access via dashboard logic or a specific admin table check.)
-- We will add an Admin policy if there is a known admin function.
-- Based on the project, assuming we might use a function like `is_admin()` if it exists, roughly checking public.profiles.
-- Let's stick to user-focused RLS first. Admin access via the Admin Hub might key off `auth.uid()` if we add an explicit policy for admins.

-- Users can create their own submissions
CREATE POLICY "Users can create their own submissions"
  ON content_submissions
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own submissions if they are pending (e.g. fixing typos before review)
CREATE POLICY "Users can update their own pending submissions"
  ON content_submissions
  FOR UPDATE
  USING (auth.uid() = user_id AND status = 'pending');

-- Setup storage bucket for submissions if it doesn't exist (This usually needs to be done in UI or via specific client calls, but RLS for storage objects can be set here if the bucket is 'submission-assets')
-- We will assume the bucket 'submission-assets' will be created.

-- Add a policy for admins if we can identify them. 
-- For now, we will assume the query logic in AdminHub might rely on a specific check, but standard RLS prevents non-admins from seeing other submissions.
