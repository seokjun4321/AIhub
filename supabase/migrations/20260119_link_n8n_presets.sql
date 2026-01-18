-- Link n8n presets to the n8n AI tool
DO $$
DECLARE
    n8n_id INT;
BEGIN
    -- Get n8n ID
    SELECT id INTO n8n_id FROM ai_models WHERE name = 'n8n' LIMIT 1;

    IF n8n_id IS NOT NULL THEN
        -- 1. Populate preset_workflows (apps JSONB array or description)
        -- Looking for 'n8n' in the "apps" column (which lists used tools)
        UPDATE preset_workflows 
        SET related_ai_model_ids = array_append(related_ai_model_ids, n8n_id) 
        WHERE (apps::text ILIKE '%n8n%' OR title ILIKE '%n8n%' OR description ILIKE '%n8n%')
        AND NOT (related_ai_model_ids @> ARRAY[n8n_id]);

        -- 2. Populate preset_agents (if any n8n or automation agents exist)
        UPDATE preset_agents
        SET related_ai_model_ids = array_append(related_ai_model_ids, n8n_id) 
        WHERE (platform ILIKE '%n8n%' OR title ILIKE '%n8n%' OR description ILIKE '%n8n%')
        AND NOT (related_ai_model_ids @> ARRAY[n8n_id]);

        -- 3. Populate preset_templates (category)
        UPDATE preset_templates
        SET related_ai_model_ids = array_append(related_ai_model_ids, n8n_id) 
        WHERE (category ILIKE '%n8n%' OR title ILIKE '%n8n%')
        AND NOT (related_ai_model_ids @> ARRAY[n8n_id]);
    END IF;
END $$;
