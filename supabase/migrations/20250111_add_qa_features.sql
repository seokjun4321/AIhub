-- Q&A 답변 채택 기능을 위한 마이그레이션

-- 1. comments 테이블에 채택 여부 컬럼 추가
ALTER TABLE public.comments 
ADD COLUMN IF NOT EXISTS is_accepted BOOLEAN DEFAULT FALSE;

-- 2. posts 테이블에 채택된 답변 ID 컬럼 추가 (빠른 조회용)
ALTER TABLE public.posts 
ADD COLUMN IF NOT EXISTS accepted_answer_id INTEGER REFERENCES public.comments(id) ON DELETE SET NULL;

-- 3. 인덱스 생성 (성능 최적화)
CREATE INDEX IF NOT EXISTS idx_comments_is_accepted ON public.comments(is_accepted) WHERE is_accepted = TRUE;
CREATE INDEX IF NOT EXISTS idx_posts_accepted_answer ON public.posts(accepted_answer_id) WHERE accepted_answer_id IS NOT NULL;

-- 4. 답변 채택 제약 조건 함수 (한 게시글당 하나의 채택 답변만)
CREATE OR REPLACE FUNCTION public.enforce_single_accepted_answer()
RETURNS TRIGGER AS $$
BEGIN
    -- 답변을 채택으로 설정하는 경우
    IF NEW.is_accepted = TRUE AND (OLD.is_accepted IS NULL OR OLD.is_accepted = FALSE) THEN
        -- 같은 게시글의 다른 채택 답변들을 모두 해제
        UPDATE public.comments 
        SET is_accepted = FALSE 
        WHERE post_id = NEW.post_id 
        AND id != NEW.id 
        AND is_accepted = TRUE;
        
        -- posts 테이블의 accepted_answer_id 업데이트
        UPDATE public.posts 
        SET accepted_answer_id = NEW.id 
        WHERE id = NEW.post_id;
        
    -- 답변 채택을 해제하는 경우
    ELSIF NEW.is_accepted = FALSE AND OLD.is_accepted = TRUE THEN
        -- posts 테이블의 accepted_answer_id 제거
        UPDATE public.posts 
        SET accepted_answer_id = NULL 
        WHERE id = NEW.post_id AND accepted_answer_id = NEW.id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 5. 답변 채택 트리거 생성
DROP TRIGGER IF EXISTS single_accepted_answer_trigger ON public.comments;
CREATE TRIGGER single_accepted_answer_trigger
    AFTER UPDATE ON public.comments
    FOR EACH ROW 
    WHEN (OLD.is_accepted IS DISTINCT FROM NEW.is_accepted)
    EXECUTE FUNCTION public.enforce_single_accepted_answer();

-- 6. 답변 채택 알림 생성 함수
CREATE OR REPLACE FUNCTION public.create_accepted_answer_notification()
RETURNS TRIGGER AS $$
DECLARE
    answer_author_id UUID;
    question_author_id UUID;
    question_title TEXT;
    answer_author_username TEXT;
BEGIN
    -- 답변이 채택된 경우에만 알림 생성
    IF NEW.is_accepted = TRUE AND (OLD.is_accepted IS NULL OR OLD.is_accepted = FALSE) THEN
        
        -- 답변 작성자와 질문 작성자 정보 가져오기
        SELECT NEW.author_id INTO answer_author_id;
        
        SELECT p.author_id, p.title 
        INTO question_author_id, question_title
        FROM public.posts p 
        WHERE p.id = NEW.post_id;
        
        -- 답변 작성자 username 가져오기
        SELECT username INTO answer_author_username
        FROM public.profiles 
        WHERE id = answer_author_id;
        
        -- 자신의 질문에 자신이 답변한 경우는 알림 생성 안 함
        IF answer_author_id != question_author_id THEN
            -- 답변 작성자에게 채택 알림 생성
            INSERT INTO public.notifications (
                user_id,
                type,
                title,
                message,
                target_type,
                target_id
            ) VALUES (
                answer_author_id,
                'accepted_answer',
                '답변이 채택되었습니다!',
                '질문 "' || question_title || '"에서 회원님의 답변이 채택되었습니다.',
                'post',
                NEW.post_id
            );
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 7. 답변 채택 알림 트리거 생성
DROP TRIGGER IF EXISTS accepted_answer_notification_trigger ON public.comments;
CREATE TRIGGER accepted_answer_notification_trigger
    AFTER UPDATE ON public.comments
    FOR EACH ROW 
    WHEN (OLD.is_accepted IS DISTINCT FROM NEW.is_accepted)
    EXECUTE FUNCTION public.create_accepted_answer_notification();

-- 8. RLS 정책 업데이트 (comments 테이블)
-- 기존 정책은 유지하고, 답변 채택 관련 정책만 추가

-- 질문 작성자만 답변을 채택할 수 있음
CREATE OR REPLACE FUNCTION public.can_accept_answer(comment_row public.comments)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 
        FROM public.posts p 
        WHERE p.id = comment_row.post_id 
        AND p.author_id = auth.uid()
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- is_accepted 컬럼 업데이트 정책
DROP POLICY IF EXISTS "Users can accept answers on their questions" ON public.comments;
CREATE POLICY "Users can accept answers on their questions" ON public.comments
FOR UPDATE TO authenticated 
USING (can_accept_answer(comments.*))
WITH CHECK (can_accept_answer(comments.*));
