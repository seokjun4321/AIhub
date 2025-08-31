-- 조회수 증가를 위한 트리거 추가
-- post_views 테이블에 데이터가 삽입될 때 posts 테이블의 view_count를 자동으로 증가시키는 트리거

-- 게시글 조회수 업데이트 함수
CREATE OR REPLACE FUNCTION public.update_post_view_count()
RETURNS TRIGGER AS $$
BEGIN
    -- post_views 테이블에 새 레코드가 삽입될 때마다 해당 게시글의 조회수 증가
    UPDATE public.posts 
    SET view_count = view_count + 1
    WHERE id = NEW.post_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 게시글 조회수 트리거
DROP TRIGGER IF EXISTS post_view_count_trigger ON public.post_views;
CREATE TRIGGER post_view_count_trigger
    AFTER INSERT ON public.post_views
    FOR EACH ROW EXECUTE FUNCTION public.update_post_view_count();
