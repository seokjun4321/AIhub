-- Check Step 11 content
SELECT 
  id,
  step_order,
  title,
  LENGTH(content) as content_length,
  SUBSTRING(content, 1, 500) as content_preview
FROM guide_steps
WHERE guide_id = 14 AND step_order = 11;
