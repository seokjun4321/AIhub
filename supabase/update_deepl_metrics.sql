-- 1. Check existing format (optional, to verify structure)
SELECT name, comparison_data 
FROM public.ai_models 
WHERE name IN ('ChatGPT', 'Gemini');

-- 2. Update DeepL with detailed metrics
UPDATE public.ai_models
SET comparison_data = '{
  "performance_score": 4.8,
  "cost_efficiency_score": 4.5,
  "korean_support_score": 4.9,
  "learning_curve_score": 4.8,
  "radar_chart": {
    "performance": 4.8,
    "community": 3.5,
    "value_for_money": 4.5,
    "korean_quality": 4.9,
    "ease_of_use": 4.8,
    "automation": 3.5
  },
  "pros": [
    "압도적인 번역 품질과 자연스러운 뉘앙스",
    "강력한 문맥 파악 능력",
    "직관적인 인터페이스"
  ],
  "cons": [
    "무료 버전 글자 수 제한",
    "지원 언어 수가 구글 번역보다 적음"
  ],
  "target_users": [
    "전문 번역가",
    "해외 논문 연구자",
    "비즈니스 이메일 작성자"
  ],
  "security_features": [
    "데이터 암호화 (Pro)",
    "번역 데이터 즉시 삭제 (Pro)"
  ],
  "integrations": [
    "Chrome/Edge 확장 프로그램",
    "Windows/Mac 데스크톱 앱"
  ],
  "summary_text": "단순 번역을 넘어 뉘앙스까지 파악하는 세계 최고의 번역 도구입니다. 논문이나 비즈니스 메일 작성 시 가장 자연스러운 결과물을 제공합니다."
}'::jsonb
WHERE name LIKE 'DeepL%';

-- 3. Verify the update
SELECT name, comparison_data 
FROM public.ai_models 
WHERE name LIKE 'DeepL%';
