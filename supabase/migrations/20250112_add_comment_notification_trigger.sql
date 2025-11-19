-- 댓글 알림 생성 함수
CREATE OR REPLACE FUNCTION public.create_comment_notification()
RETURNS TRIGGER AS $$
DECLARE
    post_author_id UUID;
    post_title TEXT;
    comment_author_username TEXT;
BEGIN
    -- 게시글 작성자 정보 가져오기
    SELECT p.author_id, p.title 
    INTO post_author_id, post_title
    FROM public.posts p 
    WHERE p.id = NEW.post_id;
    
    -- 댓글 작성자 username 가져오기
    SELECT username INTO comment_author_username
    FROM public.profiles 
    WHERE id = NEW.author_id;
    
    -- 자신의 게시물에 자신이 댓글을 단 경우는 알림 생성 안 함
    IF NEW.author_id != post_author_id THEN
        -- 게시글 작성자에게 댓글 알림 생성
        INSERT INTO public.notifications (
            user_id,
            type,
            title,
            message,
            target_type,
            target_id
        ) VALUES (
            post_author_id,
            'comment',
            '새로운 댓글이 달렸습니다',
            comment_author_username || '님이 "' || post_title || '"에 댓글을 남겼습니다.',
            'post',
            NEW.post_id
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 댓글 알림 트리거 생성
DROP TRIGGER IF EXISTS comment_notification_trigger ON public.comments;
CREATE TRIGGER comment_notification_trigger
    AFTER INSERT ON public.comments
    FOR EACH ROW 
    WHEN (NEW.parent_comment_id IS NULL) -- 최상위 댓글만 알림 생성
    EXECUTE FUNCTION public.create_comment_notification();






























