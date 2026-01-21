-- Add capabilities column to preset_agents
ALTER TABLE preset_agents
ADD COLUMN IF NOT EXISTS capabilities TEXT[] DEFAULT '{}';

-- Update the insert statement for mock data (optional, or just leave as default empty)
