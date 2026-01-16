-- Add user_id column to preset_prompt_templates
ALTER TABLE preset_prompt_templates ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id);

-- Add user_id column to preset_agents
ALTER TABLE preset_agents ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id);

-- Add user_id column to preset_workflows
ALTER TABLE preset_workflows ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id);

-- Add user_id column to preset_templates
ALTER TABLE preset_templates ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id);

-- Add user_id column to preset_designs
ALTER TABLE preset_designs ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id);
