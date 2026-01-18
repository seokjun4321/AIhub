-- Add related_ai_model_ids column to all preset tables
ALTER TABLE preset_prompt_templates ADD COLUMN IF NOT EXISTS related_ai_model_ids INTEGER[] DEFAULT '{}';
ALTER TABLE preset_agents ADD COLUMN IF NOT EXISTS related_ai_model_ids INTEGER[] DEFAULT '{}';
ALTER TABLE preset_workflows ADD COLUMN IF NOT EXISTS related_ai_model_ids INTEGER[] DEFAULT '{}';
ALTER TABLE preset_designs ADD COLUMN IF NOT EXISTS related_ai_model_ids INTEGER[] DEFAULT '{}';
ALTER TABLE preset_templates ADD COLUMN IF NOT EXISTS related_ai_model_ids INTEGER[] DEFAULT '{}';

-- Create a temporary function to help populate IDs
DO $$
DECLARE
    chatgpt_id INT;
    claude_id INT;
    gemini_id INT;
    midjourney_id INT;
    notion_id INT;
    sheets_id INT;
    mj_id INT;
    sd_id INT;
    dalle_id INT;
    perplexity_id INT;
BEGIN
    -- Get IDs for common tools (using ILIKE for robustness)
    SELECT id INTO chatgpt_id FROM ai_models WHERE name ILIKE '%ChatGPT%' LIMIT 1;
    SELECT id INTO claude_id FROM ai_models WHERE name ILIKE '%Claude%' LIMIT 1;
    SELECT id INTO gemini_id FROM ai_models WHERE name ILIKE '%Gemini%' LIMIT 1;
    SELECT id INTO midjourney_id FROM ai_models WHERE name ILIKE '%Midjourney%' LIMIT 1;
    SELECT id INTO notion_id FROM ai_models WHERE name ILIKE '%Notion%' LIMIT 1;
    SELECT id INTO perplexity_id FROM ai_models WHERE name ILIKE '%Perplexity%' LIMIT 1;
    SELECT id INTO dalle_id FROM ai_models WHERE name ILIKE '%DALL-E%' LIMIT 1;
    SELECT id INTO sd_id FROM ai_models WHERE name ILIKE '%Stable Diffusion%' LIMIT 1;

    -- 1. Populate preset_prompt_templates (compatible_tools array)
    IF chatgpt_id IS NOT NULL THEN
        UPDATE preset_prompt_templates SET related_ai_model_ids = array_append(related_ai_model_ids, chatgpt_id) 
        WHERE 'ChatGPT' = ANY(compatible_tools) AND NOT (related_ai_model_ids @> ARRAY[chatgpt_id]);
    END IF;
    IF claude_id IS NOT NULL THEN
        UPDATE preset_prompt_templates SET related_ai_model_ids = array_append(related_ai_model_ids, claude_id) 
        WHERE 'Claude' = ANY(compatible_tools) AND NOT (related_ai_model_ids @> ARRAY[claude_id]);
    END IF;
    IF gemini_id IS NOT NULL THEN
        UPDATE preset_prompt_templates SET related_ai_model_ids = array_append(related_ai_model_ids, gemini_id) 
        WHERE 'Gemini' = ANY(compatible_tools) AND NOT (related_ai_model_ids @> ARRAY[gemini_id]);
    END IF;

    -- 2. Populate preset_agents (platform column)
    IF chatgpt_id IS NOT NULL THEN
        UPDATE preset_agents SET related_ai_model_ids = array_append(related_ai_model_ids, chatgpt_id) 
        WHERE platform = 'GPT' AND NOT (related_ai_model_ids @> ARRAY[chatgpt_id]);
    END IF;
    IF claude_id IS NOT NULL THEN
        UPDATE preset_agents SET related_ai_model_ids = array_append(related_ai_model_ids, claude_id) 
        WHERE platform = 'Claude' AND NOT (related_ai_model_ids @> ARRAY[claude_id]);
    END IF;
     IF gemini_id IS NOT NULL THEN
        UPDATE preset_agents SET related_ai_model_ids = array_append(related_ai_model_ids, gemini_id) 
        WHERE platform = 'Gemini' AND NOT (related_ai_model_ids @> ARRAY[gemini_id]);
    END IF;
     IF perplexity_id IS NOT NULL THEN
        UPDATE preset_agents SET related_ai_model_ids = array_append(related_ai_model_ids, perplexity_id) 
        WHERE platform = 'Perplexity' AND NOT (related_ai_model_ids @> ARRAY[perplexity_id]);
    END IF;

    -- 3. Populate preset_templates (category column)
    IF notion_id IS NOT NULL THEN
        UPDATE preset_templates SET related_ai_model_ids = array_append(related_ai_model_ids, notion_id) 
        WHERE category = 'Notion' AND NOT (related_ai_model_ids @> ARRAY[notion_id]);
    END IF;

    -- 4. Populate preset_designs (params JSONB - looking for Model key)
    -- This is simplified; assumes specific strings in params
    IF midjourney_id IS NOT NULL THEN
        UPDATE preset_designs SET related_ai_model_ids = array_append(related_ai_model_ids, midjourney_id) 
        WHERE params::text ILIKE '%Midjourney%' AND NOT (related_ai_model_ids @> ARRAY[midjourney_id]);
    END IF;
    IF dalle_id IS NOT NULL THEN
         UPDATE preset_designs SET related_ai_model_ids = array_append(related_ai_model_ids, dalle_id) 
        WHERE params::text ILIKE '%DALL-E%' AND NOT (related_ai_model_ids @> ARRAY[dalle_id]);
    END IF;
    IF sd_id IS NOT NULL THEN
         UPDATE preset_designs SET related_ai_model_ids = array_append(related_ai_model_ids, sd_id) 
        WHERE (params::text ILIKE '%Stable Diffusion%' OR params::text ILIKE '%SDXL%') AND NOT (related_ai_model_ids @> ARRAY[sd_id]);
    END IF;

    -- 5. Populate preset_workflows (apps JSONB array)
    IF notion_id IS NOT NULL THEN
        UPDATE preset_workflows SET related_ai_model_ids = array_append(related_ai_model_ids, notion_id) 
        WHERE apps::text ILIKE '%Notion%' AND NOT (related_ai_model_ids @> ARRAY[notion_id]);
    END IF;
    IF chatgpt_id IS NOT NULL THEN
        UPDATE preset_workflows SET related_ai_model_ids = array_append(related_ai_model_ids, chatgpt_id) 
        WHERE apps::text ILIKE '%ChatGPT%' AND NOT (related_ai_model_ids @> ARRAY[chatgpt_id]);
    END IF;
    
END $$;
