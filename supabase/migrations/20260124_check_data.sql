-- 1. Check if ai_models has data
select count(*) as ai_models_count from ai_models;

-- 2. Check if the new view has data
select count(*) as view_total_count from aihub_content_catalog_v2;

-- 3. Check count specifically for 'tool' type in the view
select count(*) as tools_in_view_count from aihub_content_catalog_v2 where item_type = 'tool';

-- 4. Try to select direct data to see if it works without errors
select item_id, title from aihub_content_catalog_v2 where item_type = 'tool' limit 5;
