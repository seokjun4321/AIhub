-- 1. Add detailed_info JSONB column
ALTER TABLE public.presets ADD COLUMN IF NOT EXISTS detailed_info JSONB;

-- 2. Update data for '사업계획서 자동 생성 프롬프트 세트'
UPDATE public.presets
SET detailed_info = '{
    "overview": {
        "summary": "사업계획서 작성의 모든 단계를 가이드합니다.",
        "whenToUse": ["IR 자료 작성 시", "정부지원사업 지원 시"],
        "expectedResults": ["전문적인 사업계획서 초안", "시장 분석 데이터"],
        "promptMaster": "비즈니스팀"
    },
    "examples": [],
    "prompt": { "content": "프롬프트 내용 테스트..." },
    "variables": { "guide": [], "exampleInput": "입력 예시", "usageSteps": ["1. 상황 설정", "2. 입력값 넣기"] }
}'::jsonb
WHERE title LIKE '사업계획서%';

-- 3. Update data for 'n8n 이메일 자동분류 워크플로우'
UPDATE public.presets
SET detailed_info = '{
    "overview": {
        "summary": "이메일 업무 효율을 극대화합니다.",
        "whenToUse": ["문의 메일이 많을 때", "자동 응답이 필요할 때"],
        "expectedResults": ["분류된 이메일", "자동화된 워크플로우"],
        "promptMaster": "오토메이션랩"
    },
    "examples": [],
    "prompt": { "content": "워크플로우 설정 가이드..." },
    "variables": { "guide": [], "exampleInput": "", "usageSteps": [] }
}'::jsonb
WHERE title LIKE 'n8n%';

-- 4. Update data for 'Gem - AI 학습코치'
UPDATE public.presets
SET detailed_info = '{
    "overview": {
        "summary": "개인 맞춤형 학습 커리큘럼을 제공합니다.",
        "whenToUse": ["새로운 기술 학습 시", "체계적인 공부가 필요할 때"],
        "expectedResults": ["주차별 커리큘럼", "학습 자료 리스트"],
        "promptMaster": "에듀테크팀"
    },
    "examples": [],
    "prompt": { "content": "당신은 AI 학습 코치입니다..." },
    "variables": { "guide": [], "exampleInput": "학습 목표: 파이썬 마스터", "usageSteps": [] }
}'::jsonb
WHERE title LIKE 'Gem%';

-- 5. Update data for 'Midjourney 캐릭터 프롬프트 팩'
UPDATE public.presets
SET detailed_info = '{
    "overview": {
        "summary": "고퀄리티 캐릭터 일러스트를 쉽게 생성하세요.",
        "whenToUse": ["게임 캐릭터 디자인", "동화책 삽화 작업"],
        "expectedResults": ["일관된 스타일의 이미지", "다양한 포즈 변형"],
        "promptMaster": "크리에이티브스튜디오"
    },
    "examples": [],
    "prompt": { "content": "/imagine prompt: cute character..." },
    "variables": { "guide": [], "exampleInput": "", "usageSteps": [] }
}'::jsonb
WHERE title LIKE 'Midjourney%';
