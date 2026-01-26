-- Add new columns to guide_submissions table for better management
ALTER TABLE guide_submissions 
ADD COLUMN title text,
ADD COLUMN category text,
ADD COLUMN submission_type text DEFAULT 'new',
ADD COLUMN original_guide_id uuid;

-- Optional: Add comment
COMMENT ON COLUMN guide_submissions.submission_type IS 'Type of submission: "new" or "update"';
COMMENT ON COLUMN guide_submissions.original_guide_id IS 'If update, ID of the original guide being modified';
