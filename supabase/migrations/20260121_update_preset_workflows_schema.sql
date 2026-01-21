-- Add missing columns to preset_workflows table if they don't exist
ALTER TABLE preset_workflows 
ADD COLUMN IF NOT EXISTS credentials TEXT[] DEFAULT '{}',
ADD COLUMN IF NOT EXISTS requirements TEXT[] DEFAULT '{}',
ADD COLUMN IF NOT EXISTS warnings TEXT[] DEFAULT '{}',
ADD COLUMN IF NOT EXISTS steps JSONB DEFAULT '[]'::jsonb,
ADD COLUMN IF NOT EXISTS apps JSONB DEFAULT '[]'::jsonb,
ADD COLUMN IF NOT EXISTS duration TEXT,
ADD COLUMN IF NOT EXISTS diagram_url TEXT,
ADD COLUMN IF NOT EXISTS download_url TEXT;
