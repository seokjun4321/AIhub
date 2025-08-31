-- 커뮤니티 기능 대폭 개선을 위한 마이그레이션
-- 레딧, 디시인사이드 등의 성공적인 커뮤니티 사이트를 참조한 기능들

-- 0. 게시글 투표 테이블 (가장 먼저 생성)
CREATE TABLE IF NOT EXISTS public.post_votes (
    id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL REFERENCES public.posts(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    vote_type SMALLINT NOT NULL CHECK (vote_type IN (1, -1)),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(post_id, user_id)
);

-- 게시글 투표 카운트 업데이트 함수
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

-- 게시글 투표 트리거
DROP TRIGGER IF EXISTS post_votes_trigger ON public.post_votes;
CREATE TRIGGER post_votes_trigger
    AFTER INSERT OR UPDATE OR DELETE ON public.post_votes
    FOR EACH ROW EXECUTE FUNCTION public.update_post_vote_counts();

-- 1. 게시글 카테고리 테이블 (질문, 정보공유, 토론, 유머 등)
CREATE TABLE IF NOT EXISTS public.post_categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    icon VARCHAR(50),
    color VARCHAR(20) DEFAULT '#3B82F6',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 기본 카테고리 데이터 삽입
INSERT INTO public.post_categories (name, description, icon, color) VALUES
    ('질문', 'AI 관련 질문과 답변', 'help-circle', '#10B981'),
    ('정보공유', '유용한 AI 정보와 팁', 'info', '#3B82F6'),
    ('토론', 'AI에 대한 다양한 의견 교환', 'message-square', '#8B5CF6'),
    ('유머', 'AI 관련 재미있는 이야기', 'smile', '#F59E0B'),
    ('리뷰', 'AI 도구 사용 후기', 'star', '#EF4444'),
    ('뉴스', 'AI 관련 최신 소식', 'newspaper', '#06B6D4'),
    ('프로젝트', 'AI 프로젝트 공유', 'folder', '#EC4899'),
    ('기타', '기타 주제', 'more-horizontal', '#6B7280')
ON CONFLICT (name) DO NOTHING;

-- 2. 게시글 태그 테이블
CREATE TABLE IF NOT EXISTS public.tags (
    id SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL UNIQUE,
    description TEXT,
    color VARCHAR(20) DEFAULT '#6B7280',
    usage_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. 게시글-태그 연결 테이블
CREATE TABLE IF NOT EXISTS public.post_tags (
    id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL REFERENCES public.posts(id) ON DELETE CASCADE,
    tag_id INTEGER NOT NULL REFERENCES public.tags(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(post_id, tag_id)
);

-- 4. 사용자 활동 내역 테이블
CREATE TABLE IF NOT EXISTS public.user_activities (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    activity_type VARCHAR(50) NOT NULL, -- 'post_created', 'comment_added', 'vote_given', 'post_viewed'
    target_type VARCHAR(50) NOT NULL, -- 'post', 'comment', 'user'
    target_id INTEGER NOT NULL,
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. 알림 테이블
CREATE TABLE IF NOT EXISTS public.notifications (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL, -- 'comment_reply', 'vote_received', 'mention', 'system'
    title VARCHAR(200) NOT NULL,
    message TEXT,
    target_type VARCHAR(50), -- 'post', 'comment'
    target_id INTEGER,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. 게시글 신고 테이블
CREATE TABLE IF NOT EXISTS public.post_reports (
    id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL REFERENCES public.posts(id) ON DELETE CASCADE,
    reporter_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    reason VARCHAR(100) NOT NULL, -- 'spam', 'inappropriate', 'duplicate', 'other'
    description TEXT,
    status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'reviewed', 'resolved'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 7. 댓글 신고 테이블
CREATE TABLE IF NOT EXISTS public.comment_reports (
    id SERIAL PRIMARY KEY,
    comment_id INTEGER NOT NULL REFERENCES public.comments(id) ON DELETE CASCADE,
    reporter_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    reason VARCHAR(100) NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 8. 게시글 북마크 테이블
CREATE TABLE IF NOT EXISTS public.post_bookmarks (
    id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL REFERENCES public.posts(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(post_id, user_id)
);

-- 9. 사용자 팔로우 테이블
CREATE TABLE IF NOT EXISTS public.user_follows (
    id SERIAL PRIMARY KEY,
    follower_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    following_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(follower_id, following_id)
);

-- 10. 게시글 조회수 테이블
CREATE TABLE IF NOT EXISTS public.post_views (
    id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL REFERENCES public.posts(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL, -- 익명 조회도 허용
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- posts 테이블에 새로운 컬럼들 추가
ALTER TABLE public.posts 
ADD COLUMN IF NOT EXISTS category_id INTEGER REFERENCES public.post_categories(id) ON DELETE SET NULL,
ADD COLUMN IF NOT EXISTS view_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS comment_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS is_pinned BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS is_locked BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS is_nsfw BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS last_activity_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();

-- profiles 테이블에 새로운 컬럼들 추가
ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS bio TEXT,
ADD COLUMN IF NOT EXISTS avatar_url TEXT,
ADD COLUMN IF NOT EXISTS website TEXT,
ADD COLUMN IF NOT EXISTS location TEXT,
ADD COLUMN IF NOT EXISTS post_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS comment_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS reputation INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS is_verified BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS is_moderator BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS last_seen_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();

-- comments 테이블에 새로운 컬럼들 추가
ALTER TABLE public.comments 
ADD COLUMN IF NOT EXISTS upvotes_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS downvotes_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS is_edited BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS edited_at TIMESTAMP WITH TIME ZONE,
ADD COLUMN IF NOT EXISTS is_deleted BOOLEAN DEFAULT FALSE;

-- 기본 카테고리 할당
UPDATE public.posts 
SET category_id = (SELECT id FROM public.post_categories WHERE name = '기타')
WHERE category_id IS NULL;

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_posts_category ON public.posts(category_id);
CREATE INDEX IF NOT EXISTS idx_posts_views ON public.posts(view_count DESC);
CREATE INDEX IF NOT EXISTS idx_posts_activity ON public.posts(last_activity_at DESC);
CREATE INDEX IF NOT EXISTS idx_post_tags_post ON public.post_tags(post_id);
CREATE INDEX IF NOT EXISTS idx_post_tags_tag ON public.post_tags(tag_id);
CREATE INDEX IF NOT EXISTS idx_user_activities_user ON public.user_activities(user_id);
CREATE INDEX IF NOT EXISTS idx_user_activities_type ON public.user_activities(activity_type);
CREATE INDEX IF NOT EXISTS idx_notifications_user ON public.notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_read ON public.notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_post_reports_status ON public.post_reports(status);
CREATE INDEX IF NOT EXISTS idx_comment_reports_status ON public.comment_reports(status);
CREATE INDEX IF NOT EXISTS idx_post_bookmarks_user ON public.post_bookmarks(user_id);
CREATE INDEX IF NOT EXISTS idx_user_follows_follower ON public.user_follows(follower_id);
CREATE INDEX IF NOT EXISTS idx_user_follows_following ON public.user_follows(following_id);
CREATE INDEX IF NOT EXISTS idx_post_views_post ON public.post_views(post_id);
CREATE INDEX IF NOT EXISTS idx_post_views_user ON public.post_views(user_id);

-- 댓글 투표 테이블
CREATE TABLE IF NOT EXISTS public.comment_votes (
    id SERIAL PRIMARY KEY,
    comment_id INTEGER NOT NULL REFERENCES public.comments(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    vote_type SMALLINT NOT NULL CHECK (vote_type IN (1, -1)),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(comment_id, user_id)
);

-- 댓글 투표 카운트 업데이트 함수
CREATE OR REPLACE FUNCTION public.update_comment_vote_counts()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        IF NEW.vote_type = 1 THEN
            UPDATE public.comments SET upvotes_count = upvotes_count + 1 WHERE id = NEW.comment_id;
        ELSE
            UPDATE public.comments SET downvotes_count = downvotes_count + 1 WHERE id = NEW.comment_id;
        END IF;
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        IF OLD.vote_type = 1 THEN
            UPDATE public.comments SET upvotes_count = upvotes_count - 1 WHERE id = OLD.comment_id;
        ELSE
            UPDATE public.comments SET downvotes_count = downvotes_count - 1 WHERE id = OLD.comment_id;
        END IF;
        IF NEW.vote_type = 1 THEN
            UPDATE public.comments SET upvotes_count = upvotes_count + 1 WHERE id = NEW.comment_id;
        ELSE
            UPDATE public.comments SET downvotes_count = downvotes_count + 1 WHERE id = NEW.comment_id;
        END IF;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        IF OLD.vote_type = 1 THEN
            UPDATE public.comments SET upvotes_count = upvotes_count - 1 WHERE id = OLD.comment_id;
        ELSE
            UPDATE public.comments SET downvotes_count = downvotes_count - 1 WHERE id = OLD.comment_id;
        END IF;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- 댓글 투표 트리거
DROP TRIGGER IF EXISTS comment_votes_trigger ON public.comment_votes;
CREATE TRIGGER comment_votes_trigger
    AFTER INSERT OR UPDATE OR DELETE ON public.comment_votes
    FOR EACH ROW EXECUTE FUNCTION public.update_comment_vote_counts();

-- 게시글 댓글 수 업데이트 함수
CREATE OR REPLACE FUNCTION public.update_post_comment_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE public.posts 
        SET comment_count = comment_count + 1, last_activity_at = NOW()
        WHERE id = NEW.post_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE public.posts 
        SET comment_count = comment_count - 1
        WHERE id = OLD.post_id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- 게시글 댓글 수 트리거
DROP TRIGGER IF EXISTS post_comment_count_trigger ON public.comments;
CREATE TRIGGER post_comment_count_trigger
    AFTER INSERT OR DELETE ON public.comments
    FOR EACH ROW EXECUTE FUNCTION public.update_post_comment_count();

-- RLS 정책 설정
ALTER TABLE public.post_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.post_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.post_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.comment_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.post_bookmarks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_follows ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.post_views ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.comment_votes ENABLE ROW LEVEL SECURITY;

-- 카테고리와 태그는 모든 사용자가 읽기 가능
CREATE POLICY "Categories are viewable by everyone" ON public.post_categories FOR SELECT USING (true);
CREATE POLICY "Tags are viewable by everyone" ON public.tags FOR SELECT USING (true);
CREATE POLICY "Post tags are viewable by everyone" ON public.post_tags FOR SELECT USING (true);

-- 사용자 활동은 본인만 읽기 가능
CREATE POLICY "Users can view own activities" ON public.user_activities FOR SELECT USING (auth.uid() = user_id);

-- 알림은 본인만 읽기/수정 가능
CREATE POLICY "Users can manage own notifications" ON public.notifications FOR ALL USING (auth.uid() = user_id);

-- 신고는 본인이 작성한 것만 관리 가능
CREATE POLICY "Users can manage own reports" ON public.post_reports FOR ALL USING (auth.uid() = reporter_id);
CREATE POLICY "Users can manage own comment reports" ON public.comment_reports FOR ALL USING (auth.uid() = reporter_id);

-- 북마크는 본인만 관리 가능
CREATE POLICY "Users can manage own bookmarks" ON public.post_bookmarks FOR ALL USING (auth.uid() = user_id);

-- 팔로우는 본인이 관련된 것만 관리 가능
CREATE POLICY "Users can manage own follows" ON public.user_follows FOR ALL USING (auth.uid() = follower_id OR auth.uid() = following_id);

-- 조회수는 모든 사용자가 기록 가능
CREATE POLICY "Anyone can record post views" ON public.post_views FOR INSERT WITH CHECK (true);

-- 댓글 투표는 인증된 사용자만 가능
CREATE POLICY "Authenticated users can vote on comments" ON public.comment_votes FOR ALL USING (auth.uid() = user_id);
