-- Add new columns for platform and import info
ALTER TABLE preset_workflows 
ADD COLUMN IF NOT EXISTS platform TEXT,
ADD COLUMN IF NOT EXISTS import_info TEXT;

-- Drop credentials column as it is merged into requirements
ALTER TABLE preset_workflows 
DROP COLUMN IF EXISTS credentials;

-- Optional: Update existing rows to have default values if needed
-- UPDATE preset_workflows SET platform = 'Other' WHERE platform IS NULL;
