-- 레벨 및 포인트 시스템 마이그레이션
-- 사용자의 활동에 따른 포인트 적립과 레벨 업 시스템

-- 1. profiles 테이블에 레벨 및 포인트 관련 컬럼 추가
ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS level INTEGER DEFAULT 1,
ADD COLUMN IF NOT EXISTS experience_points INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS total_points INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS points_this_week INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS points_this_month INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS streak_days INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS last_activity_date DATE DEFAULT CURRENT_DATE;

-- 2. 포인트 이력 테이블
CREATE TABLE IF NOT EXISTS public.point_history (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    action_type VARCHAR(50) NOT NULL, -- 'post_created', 'comment_added', 'vote_received', 'answer_accepted', 'daily_login', 'streak_bonus'
    points INTEGER NOT NULL,
    description TEXT,
    target_type VARCHAR(50), -- 'post', 'comment', 'user'
    target_id INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. 레벨 설정 테이블
CREATE TABLE IF NOT EXISTS public.level_config (
    id SERIAL PRIMARY KEY,
    level INTEGER NOT NULL UNIQUE,
    min_experience INTEGER NOT NULL,
    title VARCHAR(50) NOT NULL,
    badge_color VARCHAR(20) DEFAULT '#3B82F6',
    icon VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. 포인트 규칙 테이블
CREATE TABLE IF NOT EXISTS public.point_rules (
    id SERIAL PRIMARY KEY,
    action_type VARCHAR(50) NOT NULL UNIQUE,
    points INTEGER NOT NULL,
    daily_limit INTEGER DEFAULT 0, -- 0은 무제한
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. 업적 테이블
CREATE TABLE IF NOT EXISTS public.achievements (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    icon VARCHAR(50),
    badge_color VARCHAR(20) DEFAULT '#F59E0B',
    points_reward INTEGER DEFAULT 0,
    requirement_type VARCHAR(50) NOT NULL, -- 'posts', 'comments', 'votes', 'streak', 'level'
    requirement_value INTEGER NOT NULL,
    is_hidden BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. 사용자 업적 테이블
CREATE TABLE IF NOT EXISTS public.user_achievements (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    achievement_id INTEGER NOT NULL REFERENCES public.achievements(id) ON DELETE CASCADE,
    earned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, achievement_id)
);

-- 기본 레벨 설정 데이터 삽입
INSERT INTO public.level_config (level, min_experience, title, badge_color, icon) VALUES
    (1, 0, '새내기', '#6B7280', 'baby'),
    (2, 100, '학습자', '#10B981', 'book-open'),
    (3, 300, '탐험가', '#3B82F6', 'compass'),
    (4, 600, '전문가', '#8B5CF6', 'award'),
    (5, 1000, '마스터', '#F59E0B', 'crown'),
    (6, 1500, '그랜드마스터', '#EF4444', 'zap'),
    (7, 2200, '레전드', '#EC4899', 'star'),
    (8, 3000, '미스터리', '#06B6D4', 'moon'),
    (9, 4000, '신화', '#8B5CF6', 'gem'),
    (10, 5000, '전설', '#F59E0B', 'trophy')
ON CONFLICT (level) DO NOTHING;

-- 기본 포인트 규칙 데이터 삽입
INSERT INTO public.point_rules (action_type, points, daily_limit, description) VALUES
    ('post_created', 10, 50, '게시글 작성'),
    ('comment_added', 5, 100, '댓글 작성'),
    ('post_upvoted', 2, 0, '게시글 추천받음'),
    ('comment_upvoted', 1, 0, '댓글 추천받음'),
    ('answer_accepted', 15, 0, '답변 채택됨'),
    ('daily_login', 1, 1, '일일 로그인'),
    ('streak_bonus', 5, 1, '연속 활동 보너스'),
    ('first_post', 20, 1, '첫 게시글 작성'),
    ('first_comment', 10, 1, '첫 댓글 작성'),
    ('profile_completed', 5, 1, '프로필 완성'),
    ('helpful_answer', 8, 0, '도움이 되는 답변'),
    ('quality_post', 5, 0, '고품질 게시글')
ON CONFLICT (action_type) DO NOTHING;

-- 기본 업적 데이터 삽입
INSERT INTO public.achievements (name, description, icon, badge_color, points_reward, requirement_type, requirement_value) VALUES
    ('첫 발걸음', '첫 번째 게시글을 작성했습니다', 'footprints', '#10B981', 20, 'posts', 1),
    ('소통의 시작', '첫 번째 댓글을 작성했습니다', 'message-circle', '#3B82F6', 10, 'comments', 1),
    ('열정적인 참여자', '10개의 게시글을 작성했습니다', 'flame', '#F59E0B', 50, 'posts', 10),
    ('댓글 마스터', '50개의 댓글을 작성했습니다', 'messages-square', '#8B5CF6', 100, 'comments', 50),
    ('인기 작성자', '게시글이 100번 추천받았습니다', 'thumbs-up', '#EF4444', 200, 'votes', 100),
    ('도움의 손길', '답변이 10번 채택되었습니다', 'hand-heart', '#EC4899', 300, 'accepted_answers', 10),
    ('연속 활동가', '7일 연속으로 활동했습니다', 'calendar', '#06B6D4', 100, 'streak', 7),
    ('커뮤니티 기둥', '30일 연속으로 활동했습니다', 'pillar', '#8B5CF6', 500, 'streak', 30),
    ('레벨 5 달성', '레벨 5에 도달했습니다', 'award', '#F59E0B', 200, 'level', 5),
    ('레벨 10 달성', '레벨 10에 도달했습니다', 'crown', '#EF4444', 1000, 'level', 10)
ON CONFLICT (name) DO NOTHING;

-- 포인트 적립 함수
CREATE OR REPLACE FUNCTION public.add_points_to_user(
    p_user_id UUID,
    p_action_type VARCHAR(50),
    p_points INTEGER,
    p_description TEXT DEFAULT NULL,
    p_target_type VARCHAR(50) DEFAULT NULL,
    p_target_id INTEGER DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
    v_daily_limit INTEGER;
    v_today_points INTEGER;
    v_current_level INTEGER;
    v_next_level INTEGER;
    v_next_level_exp INTEGER;
    v_old_level INTEGER;
BEGIN
    -- 포인트 규칙 확인
    SELECT daily_limit INTO v_daily_limit 
    FROM public.point_rules 
    WHERE action_type = p_action_type AND is_active = TRUE;
    
    -- 일일 제한 확인
    IF v_daily_limit > 0 THEN
        SELECT COALESCE(SUM(points), 0) INTO v_today_points
        FROM public.point_history 
        WHERE user_id = p_user_id 
        AND action_type = p_action_type 
        AND created_at >= CURRENT_DATE;
        
        IF v_today_points >= v_daily_limit THEN
            RETURN FALSE; -- 일일 제한 초과
        END IF;
    END IF;
    
    -- 포인트 이력 기록
    INSERT INTO public.point_history (user_id, action_type, points, description, target_type, target_id)
    VALUES (p_user_id, p_action_type, p_points, p_description, p_target_type, p_target_id);
    
    -- 사용자 프로필 업데이트
    UPDATE public.profiles 
    SET 
        experience_points = experience_points + p_points,
        total_points = total_points + p_points,
        points_this_week = points_this_week + p_points,
        points_this_month = points_this_month + p_points,
        last_activity_date = CURRENT_DATE
    WHERE id = p_user_id;
    
    -- 레벨 업 확인
    SELECT level INTO v_current_level FROM public.profiles WHERE id = p_user_id;
    
    SELECT level, min_experience INTO v_next_level, v_next_level_exp
    FROM public.level_config 
    WHERE min_experience > (SELECT experience_points FROM public.profiles WHERE id = p_user_id)
    ORDER BY min_experience ASC 
    LIMIT 1;
    
    IF v_next_level IS NOT NULL AND v_next_level > v_current_level THEN
        UPDATE public.profiles SET level = v_next_level WHERE id = p_user_id;
        
        -- 레벨업 보너스 포인트
        INSERT INTO public.point_history (user_id, action_type, points, description)
        VALUES (p_user_id, 'level_up', 10, '레벨업 보너스!');
        
        UPDATE public.profiles 
        SET 
            experience_points = experience_points + 10,
            total_points = total_points + 10,
            points_this_week = points_this_week + 10,
            points_this_month = points_this_month + 10
        WHERE id = p_user_id;
    END IF;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 연속 활동 체크 함수
CREATE OR REPLACE FUNCTION public.check_streak()
RETURNS TRIGGER AS $$
DECLARE
    v_last_activity DATE;
    v_current_streak INTEGER;
BEGIN
    SELECT last_activity_date, streak_days 
    INTO v_last_activity, v_current_streak
    FROM public.profiles 
    WHERE id = NEW.user_id;
    
    -- 오늘 첫 활동인 경우
    IF v_last_activity < CURRENT_DATE THEN
        -- 어제 활동했으면 연속일 증가, 아니면 리셋
        IF v_last_activity = CURRENT_DATE - INTERVAL '1 day' THEN
            UPDATE public.profiles 
            SET streak_days = v_current_streak + 1
            WHERE id = NEW.user_id;
            
            -- 연속 활동 보너스 (7일마다)
            IF (v_current_streak + 1) % 7 = 0 THEN
                PERFORM public.add_points_to_user(
                    NEW.user_id, 
                    'streak_bonus', 
                    5, 
                    '연속 ' || (v_current_streak + 1) || '일 활동 보너스!'
                );
            END IF;
        ELSE
            UPDATE public.profiles 
            SET streak_days = 1
            WHERE id = NEW.user_id;
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 포인트 이력 트리거
DROP TRIGGER IF EXISTS check_streak_trigger ON public.point_history;
CREATE TRIGGER check_streak_trigger
    AFTER INSERT ON public.point_history
    FOR EACH ROW EXECUTE FUNCTION public.check_streak();

-- 업적 체크 함수
CREATE OR REPLACE FUNCTION public.check_achievements(p_user_id UUID)
RETURNS VOID AS $$
DECLARE
    v_achievement RECORD;
    v_count INTEGER;
    v_user_level INTEGER;
    v_user_streak INTEGER;
BEGIN
    -- 사용자 정보 가져오기
    SELECT level, streak_days INTO v_user_level, v_user_streak
    FROM public.profiles WHERE id = p_user_id;
    
    -- 모든 업적 확인
    FOR v_achievement IN 
        SELECT * FROM public.achievements 
        WHERE id NOT IN (
            SELECT achievement_id FROM public.user_achievements WHERE user_id = p_user_id
        )
    LOOP
        -- 요구사항에 따른 카운트 계산
        CASE v_achievement.requirement_type
            WHEN 'posts' THEN
                SELECT COUNT(*) INTO v_count FROM public.posts WHERE author_id = p_user_id;
            WHEN 'comments' THEN
                SELECT COUNT(*) INTO v_count FROM public.comments WHERE author_id = p_user_id;
            WHEN 'votes' THEN
                SELECT COALESCE(SUM(upvotes_count), 0) INTO v_count 
                FROM public.posts WHERE author_id = p_user_id;
            WHEN 'accepted_answers' THEN
                SELECT COUNT(*) INTO v_count 
                FROM public.comments 
                WHERE author_id = p_user_id AND is_accepted = TRUE;
            WHEN 'streak' THEN
                v_count := v_user_streak;
            WHEN 'level' THEN
                v_count := v_user_level;
            ELSE
                v_count := 0;
        END CASE;
        
        -- 업적 달성 확인
        IF v_count >= v_achievement.requirement_value THEN
            -- 업적 부여
            INSERT INTO public.user_achievements (user_id, achievement_id)
            VALUES (p_user_id, v_achievement.id);
            
            -- 포인트 보상
            IF v_achievement.points_reward > 0 THEN
                PERFORM public.add_points_to_user(
                    p_user_id,
                    'achievement_earned',
                    v_achievement.points_reward,
                    '업적 달성: ' || v_achievement.name
                );
            END IF;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 업적 체크 트리거 함수
CREATE OR REPLACE FUNCTION public.trigger_achievement_check()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM public.check_achievements(NEW.user_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 포인트 이력에 업적 체크 트리거 추가
DROP TRIGGER IF EXISTS achievement_check_trigger ON public.point_history;
CREATE TRIGGER achievement_check_trigger
    AFTER INSERT ON public.point_history
    FOR EACH ROW EXECUTE FUNCTION public.trigger_achievement_check();

-- RLS 정책 설정
ALTER TABLE public.point_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.level_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.point_rules ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_achievements ENABLE ROW LEVEL SECURITY;

-- 포인트 이력: 본인만 읽기 가능
CREATE POLICY "Users can view own point history" ON public.point_history FOR SELECT USING (auth.uid() = user_id);

-- 레벨 설정: 모든 사용자가 읽기 가능
CREATE POLICY "Level config is viewable by everyone" ON public.level_config FOR SELECT USING (true);

-- 포인트 규칙: 모든 사용자가 읽기 가능
CREATE POLICY "Point rules are viewable by everyone" ON public.point_rules FOR SELECT USING (true);

-- 업적: 모든 사용자가 읽기 가능
CREATE POLICY "Achievements are viewable by everyone" ON public.achievements FOR SELECT USING (true);

-- 사용자 업적: 본인만 읽기 가능
CREATE POLICY "Users can view own achievements" ON public.user_achievements FOR SELECT USING (auth.uid() = user_id);

-- 인덱스 생성 (성능 최적화)
CREATE INDEX IF NOT EXISTS idx_point_history_user_date ON public.point_history(user_id, created_at);
CREATE INDEX IF NOT EXISTS idx_point_history_action_date ON public.point_history(action_type, created_at);
CREATE INDEX IF NOT EXISTS idx_user_achievements_user ON public.user_achievements(user_id);
CREATE INDEX IF NOT EXISTS idx_profiles_level ON public.profiles(level);
CREATE INDEX IF NOT EXISTS idx_profiles_experience ON public.profiles(experience_points);

