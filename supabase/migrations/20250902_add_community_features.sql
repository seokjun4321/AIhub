-- 커뮤니티 기능 개선을 위한 마이그레이션
-- 1. 커뮤니티 섹션 테이블 생성
-- 2. posts 테이블에 community_section_id 추가
-- 3. 게시글 추천/비추천 테이블 생성

-- 커뮤니티 섹션 테이블 생성
CREATE TABLE IF NOT EXISTS public.community_sections (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    icon VARCHAR(50),
    color VARCHAR(20) DEFAULT '#3B82F6',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 기본 커뮤니티 섹션 데이터 삽입
INSERT INTO public.community_sections (name, description, icon, color) VALUES
    ('대학생', '대학생들을 위한 AI 활용 팁과 정보', 'graduation-cap', '#10B981'),
    ('직장인', '직장에서 AI를 활용하는 방법과 팁', 'briefcase', '#3B82F6'),
    ('일반인', '일상생활에서 AI를 활용하는 방법', 'users', '#8B5CF6'),
    ('개발자', '개발자를 위한 AI 도구와 팁', 'code', '#F59E0B'),
    ('디자이너', '디자인 작업에 AI를 활용하는 방법', 'palette', '#EF4444'),
    ('학생', '학습에 AI를 활용하는 방법', 'book-open', '#06B6D4'),
    ('창작자', '콘텐츠 제작에 AI를 활용하는 방법', 'pen-tool', '#EC4899'),
    ('기타', '기타 주제에 대한 토론', 'message-circle', '#6B7280')
ON CONFLICT (name) DO NOTHING;

-- posts 테이블에 community_section_id 컬럼 추가
ALTER TABLE public.posts 
ADD COLUMN IF NOT EXISTS community_section_id INTEGER REFERENCES public.community_sections(id) ON DELETE SET NULL;

-- 기존 posts에 기본 섹션 할당 (기타)
UPDATE public.posts 
SET community_section_id = (SELECT id FROM public.community_sections WHERE name = '기타')
WHERE community_section_id IS NULL;

-- 게시글 추천/비추천 테이블 생성
CREATE TABLE IF NOT EXISTS public.post_votes (
    id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL REFERENCES public.posts(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    vote_type SMALLINT NOT NULL CHECK (vote_type IN (1, -1)), -- 1: 추천, -1: 비추천
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(post_id, user_id)
);

-- posts 테이블에 추천/비추천 카운트 컬럼 추가
ALTER TABLE public.posts 
ADD COLUMN IF NOT EXISTS upvotes_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS downvotes_count INTEGER DEFAULT 0;

-- 추천/비추천 카운트를 자동으로 업데이트하는 함수 생성
CREATE OR REPLACE FUNCTION public.update_post_vote_counts()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        IF NEW.vote_type = 1 THEN
            UPDATE public.posts SET upvotes_count = upvotes_count + 1 WHERE id = NEW.post_id;
        ELSE
            UPDATE public.posts SET downvotes_count = downvotes_count + 1 WHERE id = NEW.post_id;
        END IF;
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        -- 이전 투표 취소
        IF OLD.vote_type = 1 THEN
            UPDATE public.posts SET upvotes_count = upvotes_count - 1 WHERE id = OLD.post_id;
        ELSE
            UPDATE public.posts SET downvotes_count = downvotes_count - 1 WHERE id = OLD.post_id;
        END IF;
        -- 새로운 투표 추가
        IF NEW.vote_type = 1 THEN
            UPDATE public.posts SET upvotes_count = upvotes_count + 1 WHERE id = NEW.post_id;
        ELSE
            UPDATE public.posts SET downvotes_count = downvotes_count + 1 WHERE id = NEW.post_id;
        END IF;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        IF OLD.vote_type = 1 THEN
            UPDATE public.posts SET upvotes_count = upvotes_count - 1 WHERE id = OLD.post_id;
        ELSE
            UPDATE public.posts SET downvotes_count = downvotes_count - 1 WHERE id = OLD.post_id;
        END IF;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- 트리거 생성
DROP TRIGGER IF EXISTS post_votes_trigger ON public.post_votes;
CREATE TRIGGER post_votes_trigger
    AFTER INSERT OR UPDATE OR DELETE ON public.post_votes
    FOR EACH ROW EXECUTE FUNCTION public.update_post_vote_counts();

-- 기존 데이터에 대한 카운트 초기화
UPDATE public.posts 
SET 
    upvotes_count = (
        SELECT COUNT(*) 
        FROM public.post_votes 
        WHERE post_id = posts.id AND vote_type = 1
    ),
    downvotes_count = (
        SELECT COUNT(*) 
        FROM public.post_votes 
        WHERE post_id = posts.id AND vote_type = -1
    );

-- RLS (Row Level Security) 정책 설정
ALTER TABLE public.community_sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.post_votes ENABLE ROW LEVEL SECURITY;

-- 커뮤니티 섹션은 모든 사용자가 읽기 가능
CREATE POLICY "Community sections are viewable by everyone" ON public.community_sections
    FOR SELECT USING (true);

-- 게시글 투표는 인증된 사용자만 가능
CREATE POLICY "Users can vote on posts" ON public.post_votes
    FOR ALL USING (auth.uid() = user_id);

-- 인덱스 생성으로 성능 향상
CREATE INDEX IF NOT EXISTS idx_posts_community_section ON public.posts(community_section_id);
CREATE INDEX IF NOT EXISTS idx_post_votes_post_user ON public.post_votes(post_id, user_id);
CREATE INDEX IF NOT EXISTS idx_post_votes_vote_type ON public.post_votes(vote_type);
