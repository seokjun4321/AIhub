-- Query to see all guides with readable information
SELECT 
    g.id,
    g.title,
    g.description,
    g.estimated_time,
    g.difficulty,
    c.name as category_name,
    am.name as ai_model_name,
    g.tags,
    g.created_at,
    (SELECT COUNT(*) FROM guide_steps WHERE guide_id = g.id) as step_count,
    (SELECT COUNT(*) FROM guide_sections WHERE guide_id = g.id AND section_type = 'prompt_pack') as prompt_count
FROM guides g
LEFT JOIN categories c ON g.category_id = c.id
LEFT JOIN ai_models am ON g.ai_model_id = am.id
ORDER BY g.created_at DESC;
