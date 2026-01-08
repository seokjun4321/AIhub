-- RPC 함수: 다중 카테고리 지원을 위한 가이드 조회 함수
-- 이 함수는 guide_categories 중간 테이블을 활용하여 카테고리별 가이드를 가져옵니다

CREATE OR REPLACE FUNCTION get_guides_by_category(
    p_category_name TEXT,
    p_limit INTEGER DEFAULT 4
)
RETURNS TABLE (
    id INTEGER,
    title TEXT,
    description TEXT,
    image_url TEXT,
    difficulty_level TEXT,
    estimated_time TEXT,
    created_at TIMESTAMP WITH TIME ZONE,
    category_name TEXT,
    ai_model_name TEXT,
    ai_model_logo_url TEXT,
    author_username TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT ON (g.id)
        g.id,
        g.title,
        g.description,
        g.image_url,
        g.difficulty_level,
        g.estimated_time,
        g.created_at,
        c.name AS category_name,
        am.name AS ai_model_name,
        am.logo_url AS ai_model_logo_url,
        p.username AS author_username
    FROM public.guides g
    INNER JOIN public.guide_categories gc ON g.id = gc.guide_id
    INNER JOIN public.categories c ON gc.category_id = c.id
    LEFT JOIN public.ai_models am ON g.ai_model_id = am.id
    LEFT JOIN public.profiles p ON g.author_id = p.id
    WHERE c.name = p_category_name
    ORDER BY g.id, g.created_at DESC
    LIMIT p_limit;
END;
$$ LANGUAGE plpgsql STABLE;

-- 사용 예시:
-- SELECT * FROM get_guides_by_category('AI 기초 입문', 4);
