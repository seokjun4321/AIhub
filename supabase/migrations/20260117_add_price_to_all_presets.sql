-- Add price column to preset_prompt_templates
ALTER TABLE preset_prompt_templates ADD COLUMN IF NOT EXISTS price INTEGER DEFAULT 0;

-- Add price column to preset_agents
ALTER TABLE preset_agents ADD COLUMN IF NOT EXISTS price INTEGER DEFAULT 0;

-- Add price column to preset_workflows
ALTER TABLE preset_workflows ADD COLUMN IF NOT EXISTS price INTEGER DEFAULT 0;

-- Add price column to preset_designs
ALTER TABLE preset_designs ADD COLUMN IF NOT EXISTS price INTEGER DEFAULT 0;

-- Add price column to preset_templates
ALTER TABLE preset_templates ADD COLUMN IF NOT EXISTS price INTEGER DEFAULT 0;