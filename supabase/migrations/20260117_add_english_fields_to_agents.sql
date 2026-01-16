-- Add English fields to preset_agents table
ALTER TABLE preset_agents
ADD COLUMN IF NOT EXISTS instructions_en TEXT[] DEFAULT '{}',
ADD COLUMN IF NOT EXISTS example_conversation_en JSONB DEFAULT '[]'::jsonb,
ADD COLUMN IF NOT EXISTS description_en TEXT;
