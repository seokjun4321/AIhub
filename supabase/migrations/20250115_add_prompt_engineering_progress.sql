-- 프롬프트 엔지니어링 진행도 추적 테이블 생성
-- 사용자별로 프롬프트 엔지니어링 챕터 완료 상태를 저장

-- 1. prompt_engineering_progress 테이블 생성
CREATE TABLE IF NOT EXISTS public.prompt_engineering_progress (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    chapter_id INTEGER NOT NULL CHECK (chapter_id >= 0 AND chapter_id <= 9),
    completed BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, chapter_id)
);

-- 2. 인덱스 생성 (조회 성능 향상)
CREATE INDEX IF NOT EXISTS idx_prompt_engineering_progress_user_id 
    ON public.prompt_engineering_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_prompt_engineering_progress_chapter_id 
    ON public.prompt_engineering_progress(chapter_id);
CREATE INDEX IF NOT EXISTS idx_prompt_engineering_progress_user_chapter 
    ON public.prompt_engineering_progress(user_id, chapter_id);

-- 3. updated_at 자동 업데이트 트리거 함수
CREATE OR REPLACE FUNCTION update_prompt_engineering_progress_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 4. updated_at 트리거 생성
CREATE TRIGGER trigger_update_prompt_engineering_progress_updated_at
    BEFORE UPDATE ON public.prompt_engineering_progress
    FOR EACH ROW
    EXECUTE FUNCTION update_prompt_engineering_progress_updated_at();

-- 5. RLS (Row Level Security) 활성화
ALTER TABLE public.prompt_engineering_progress ENABLE ROW LEVEL SECURITY;

-- 6. RLS 정책 설정
-- 사용자는 본인의 진행도만 조회 가능
CREATE POLICY "Users can view own prompt engineering progress" 
    ON public.prompt_engineering_progress 
    FOR SELECT 
    USING (auth.uid() = user_id);

-- 사용자는 본인의 진행도만 생성/수정/삭제 가능
CREATE POLICY "Users can manage own prompt engineering progress" 
    ON public.prompt_engineering_progress 
    FOR ALL 
    USING (auth.uid() = user_id);

-- 7. completed_at 자동 설정 트리거 함수
CREATE OR REPLACE FUNCTION set_prompt_engineering_progress_completed_at()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.completed = TRUE AND OLD.completed = FALSE THEN
        NEW.completed_at = NOW();
    ELSIF NEW.completed = FALSE THEN
        NEW.completed_at = NULL;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 8. completed_at 트리거 생성
CREATE TRIGGER trigger_set_prompt_engineering_progress_completed_at
    BEFORE UPDATE ON public.prompt_engineering_progress
    FOR EACH ROW
    EXECUTE FUNCTION set_prompt_engineering_progress_completed_at();

