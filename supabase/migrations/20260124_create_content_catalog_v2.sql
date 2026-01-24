-- Create a new view that combines existing content (guidebooks/presets) with AI tools
create or replace view aihub_content_catalog_v2 with (security_invoker = true) as

-- 1) guidebook + preset (Reuse v1 logic or query directly)
-- Since we cannot query v1 accurately if we don't know if it exists in code, let's assume it exists in DB.
-- However, for robustness, if v1 is missing, this query might fail if we depend on it.
-- But the user said "aihub_content_catalog_v1라는 이름을 가진 view 테이블을 만들고... 내용을 넣었단 말이지"
-- So we trust v1 exists.

select 
    item_type,
    source_table,
    item_id,
    title,
    one_liner,
    description,
    content_text,
    tags,
    platform,
    price,
    url,
    created_at
from aihub_content_catalog_v1

union all

-- 2) tools (Integrated from ai_models)
select 
    'tool'::text as item_type,
    'ai_models'::text as source_table,
    id::text as item_id,
    name as title,
    coalesce(pricing_model, provider) as one_liner,
    description,
    -- Construct rich search text
    concat_ws(
        ' ', 
        coalesce(description,''), 
        coalesce(key_features::text, ''), -- Handle jsonb array 
        coalesce(array_to_string(pros,' '),''),
        coalesce(array_to_string(cons,' '),'')
    ) as content_text,
    coalesce(search_tags, '{}'::text[]) as tags,
    provider as platform,
    null::integer as price,
    website_url as url,
    created_at
from ai_models;

-- Helper function to cast jsonb array to text (if needed, or just cast to text directly)
-- But above concat_ws logic for key_features (which is jsonb) might need adjustment.
-- key_features is jsonb DEFAULT '[]'::jsonb per 20260117_update_ai_models_schema.sql
-- Let's cast it simply: (key_features)::text

comment on view aihub_content_catalog_v2 is 'Unified catalog of Guidebooks, Presets, and AI Tools for Chatbot RAG';
