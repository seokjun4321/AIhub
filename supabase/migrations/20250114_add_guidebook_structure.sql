-- 가이드북 구조 개선 마이그레이션
-- 새로운 가이드북 형식에 맞게 테이블 구조 확장

-- 1. guides 테이블에 메타 정보 필드 추가
ALTER TABLE public.guides 
ADD COLUMN IF NOT EXISTS platform TEXT,
ADD COLUMN IF NOT EXISTS pricing_info TEXT,
ADD COLUMN IF NOT EXISTS writing_purpose TEXT,
ADD COLUMN IF NOT EXISTS one_line_summary TEXT,
ADD COLUMN IF NOT EXISTS description TEXT;

-- 2. guide_steps 테이블 생성 (이미 존재할 수 있으므로 IF NOT EXISTS 사용)
CREATE TABLE IF NOT EXISTS public.guide_steps (
    id SERIAL PRIMARY KEY,
    guide_id INTEGER NOT NULL REFERENCES public.guides(id) ON DELETE CASCADE,
    step_order INTEGER NOT NULL,
    title TEXT NOT NULL,
    summary TEXT,
    content TEXT,
    parent_step_id INTEGER REFERENCES public.guide_steps(id) ON DELETE CASCADE,
    section_type TEXT, -- 'scenario', 'step', 'section' 등
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(guide_id, step_order)
);

-- 3. guide_scenarios 테이블 생성 (시나리오 정보)
CREATE TABLE IF NOT EXISTS public.guide_scenarios (
    id SERIAL PRIMARY KEY,
    guide_id INTEGER NOT NULL REFERENCES public.guides(id) ON DELETE CASCADE,
    scenario_order INTEGER NOT NULL,
    title TEXT NOT NULL,
    situation TEXT,
    goal TEXT,
    result TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(guide_id, scenario_order)
);

-- 4. guide_prompts 테이블 생성
CREATE TABLE IF NOT EXISTS public.guide_prompts (
    id SERIAL PRIMARY KEY,
    step_id INTEGER REFERENCES public.guide_steps(id) ON DELETE CASCADE,
    label TEXT NOT NULL,
    text TEXT NOT NULL,
    provider TEXT,
    prompt_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. guide_workbook_fields 테이블 생성
CREATE TABLE IF NOT EXISTS public.guide_workbook_fields (
    id SERIAL PRIMARY KEY,
    step_id INTEGER REFERENCES public.guide_steps(id) ON DELETE CASCADE,
    field_key TEXT NOT NULL,
    field_type TEXT NOT NULL, -- 'text', 'textarea', 'select', 'checkbox' 등
    label TEXT NOT NULL,
    placeholder TEXT,
    field_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. guide_sections 테이블 생성 (한 줄 요약, Persona, 핵심 기능 등)
CREATE TABLE IF NOT EXISTS public.guide_sections (
    id SERIAL PRIMARY KEY,
    guide_id INTEGER NOT NULL REFERENCES public.guides(id) ON DELETE CASCADE,
    section_type TEXT NOT NULL, -- 'summary', 'persona', 'features', 'pros_cons', 'comparison', 'warnings', 'comment'
    section_order INTEGER NOT NULL,
    title TEXT,
    content TEXT, -- 마크다운 형식의 내용
    data JSONB, -- 표 형식 데이터나 구조화된 데이터
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(guide_id, section_type, section_order)
);

-- 7. guide_progress 테이블 생성 (사용자 진행률 추적)
CREATE TABLE IF NOT EXISTS public.guide_progress (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    guide_id INTEGER NOT NULL REFERENCES public.guides(id) ON DELETE CASCADE,
    step_id INTEGER REFERENCES public.guide_steps(id) ON DELETE CASCADE,
    completed BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, step_id)
);

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_guide_steps_guide_id ON public.guide_steps(guide_id);
CREATE INDEX IF NOT EXISTS idx_guide_steps_parent ON public.guide_steps(parent_step_id);
CREATE INDEX IF NOT EXISTS idx_guide_scenarios_guide_id ON public.guide_scenarios(guide_id);
CREATE INDEX IF NOT EXISTS idx_guide_prompts_step_id ON public.guide_prompts(step_id);
CREATE INDEX IF NOT EXISTS idx_guide_workbook_fields_step_id ON public.guide_workbook_fields(step_id);
CREATE INDEX IF NOT EXISTS idx_guide_sections_guide_id ON public.guide_sections(guide_id);
CREATE INDEX IF NOT EXISTS idx_guide_progress_user_guide ON public.guide_progress(user_id, guide_id);
CREATE INDEX IF NOT EXISTS idx_guide_progress_step ON public.guide_progress(step_id);

-- RLS 활성화
ALTER TABLE public.guide_steps ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.guide_scenarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.guide_prompts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.guide_workbook_fields ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.guide_sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.guide_progress ENABLE ROW LEVEL SECURITY;

-- RLS 정책 설정
-- 모든 사용자가 읽기 가능
CREATE POLICY "Guide steps are viewable by everyone" ON public.guide_steps FOR SELECT USING (true);
CREATE POLICY "Guide scenarios are viewable by everyone" ON public.guide_scenarios FOR SELECT USING (true);
CREATE POLICY "Guide prompts are viewable by everyone" ON public.guide_prompts FOR SELECT USING (true);
CREATE POLICY "Guide workbook fields are viewable by everyone" ON public.guide_workbook_fields FOR SELECT USING (true);
CREATE POLICY "Guide sections are viewable by everyone" ON public.guide_sections FOR SELECT USING (true);

-- 진행률은 본인만 읽기/쓰기 가능
CREATE POLICY "Users can view own guide progress" ON public.guide_progress FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can manage own guide progress" ON public.guide_progress FOR ALL USING (auth.uid() = user_id);

-- 작성자만 수정 가능 (필요시)
CREATE POLICY "Authors can update own guides" ON public.guide_steps FOR UPDATE 
    USING (
        EXISTS (
            SELECT 1 FROM public.guides 
            WHERE guides.id = guide_steps.guide_id 
            AND guides.author_id = auth.uid()
        )
    );

CREATE POLICY "Authors can update own guide scenarios" ON public.guide_scenarios FOR UPDATE 
    USING (
        EXISTS (
            SELECT 1 FROM public.guides 
            WHERE guides.id = guide_scenarios.guide_id 
            AND guides.author_id = auth.uid()
        )
    );

CREATE POLICY "Authors can update own guide prompts" ON public.guide_prompts FOR UPDATE 
    USING (
        EXISTS (
            SELECT 1 FROM public.guide_steps 
            JOIN public.guides ON guides.id = guide_steps.guide_id
            WHERE guide_steps.id = guide_prompts.step_id 
            AND guides.author_id = auth.uid()
        )
    );

CREATE POLICY "Authors can update own guide workbook fields" ON public.guide_workbook_fields FOR UPDATE 
    USING (
        EXISTS (
            SELECT 1 FROM public.guide_steps 
            JOIN public.guides ON guides.id = guide_steps.guide_id
            WHERE guide_steps.id = guide_workbook_fields.step_id 
            AND guides.author_id = auth.uid()
        )
    );

CREATE POLICY "Authors can update own guide sections" ON public.guide_sections FOR UPDATE 
    USING (
        EXISTS (
            SELECT 1 FROM public.guides 
            WHERE guides.id = guide_sections.guide_id 
            AND guides.author_id = auth.uid()
        )
    );

-- updated_at 자동 업데이트 트리거 함수
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 트리거 생성
DROP TRIGGER IF EXISTS update_guide_steps_updated_at ON public.guide_steps;
CREATE TRIGGER update_guide_steps_updated_at
    BEFORE UPDATE ON public.guide_steps
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_guide_scenarios_updated_at ON public.guide_scenarios;
CREATE TRIGGER update_guide_scenarios_updated_at
    BEFORE UPDATE ON public.guide_scenarios
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_guide_prompts_updated_at ON public.guide_prompts;
CREATE TRIGGER update_guide_prompts_updated_at
    BEFORE UPDATE ON public.guide_prompts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_guide_workbook_fields_updated_at ON public.guide_workbook_fields;
CREATE TRIGGER update_guide_workbook_fields_updated_at
    BEFORE UPDATE ON public.guide_workbook_fields
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_guide_sections_updated_at ON public.guide_sections;
CREATE TRIGGER update_guide_sections_updated_at
    BEFORE UPDATE ON public.guide_sections
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_guide_progress_updated_at ON public.guide_progress;
CREATE TRIGGER update_guide_progress_updated_at
    BEFORE UPDATE ON public.guide_progress
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();








