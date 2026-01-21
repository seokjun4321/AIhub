-- Revert the check constraint to original strict values
ALTER TABLE preset_agents
DROP CONSTRAINT IF EXISTS preset_agents_platform_check;

-- Add original constraint (Strict: GPT, Claude, Gemini, Perplexity)
ALTER TABLE preset_agents
ADD CONSTRAINT preset_agents_platform_check 
CHECK (platform IN ('GPT', 'Claude', 'Gemini', 'Perplexity'));
