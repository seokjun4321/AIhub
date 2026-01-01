-- Add comparison_data column to ai_models table if it doesn't exist
ALTER TABLE ai_models ADD COLUMN IF NOT EXISTS comparison_data JSONB DEFAULT '{}'::jsonb;

-- Update ChatGPT (assuming name like 'ChatGPT%')
UPDATE ai_models
SET comparison_data = '{
  "performance_score": 4.5,
  "cost_efficiency_score": 4.0,
  "korean_support_score": 4.3,
  "learning_curve_score": 4.5,
  "radar_chart": {
    "performance": 4.5,
    "community": 5.0,
    "value_for_money": 4.0,
    "korean_quality": 4.3,
    "ease_of_use": 4.5,
    "automation": 3.5
  },
  "pros": ["범용 텍스트, 코딩, 학습까지 모두 커버", "가장 강력한 추론 능력", "방대한 플러그인 생태계"],
  "cons": ["무료 버전 제한", "최신 정보 반영 딜레이"],
  "target_users": ["대학생", "취준생", "일반 사용자"],
  "security_features": ["Enterprise 플랜 제공", "데이터 암호화", "학습 데이터 옵트아웃"],
  "integrations": ["API", "Zapier", "Notion", "Slack", "Microsoft Teams"],
  "summary_text": "텍스트 작업과 학습 중심이라면 ChatGPT가 가장 균형 잡힌 선택입니다."
}'::jsonb
WHERE name ILIKE '%ChatGPT%';

-- Update Gemini (assuming name like 'Gemini%')
UPDATE ai_models
SET comparison_data = '{
  "performance_score": 4.3,
  "cost_efficiency_score": 4.2,
  "korean_support_score": 3.8,
  "learning_curve_score": 4.3,
  "radar_chart": {
    "performance": 4.3,
    "community": 4.0,
    "value_for_money": 4.2,
    "korean_quality": 3.8,
    "ease_of_use": 4.5,
    "automation": 4.5
  },
  "pros": ["Google 생태계(Docs, Gmail) 연동", "긴 컨텍스트 윈도우", "멀티모달 강점"],
  "cons": ["일부 답변의 환각 현상", "한국어 뉘앙스 처리 부족"],
  "target_users": ["Google Workspace 사용자", "팀 협업"],
  "security_features": ["Google 보안 표준", "데이터 학습 분리 정책"],
  "integrations": ["Google Workspace", "Gmail", "Docs", "Sheets", "Drive"],
  "summary_text": "가성비와 Google 생태계 연동이 중요하다면 Gemini를 추천합니다."
}'::jsonb
WHERE name ILIKE '%Gemini%';

-- Update Cursor (assuming name like 'Cursor%')
UPDATE ai_models
SET comparison_data = '{
  "performance_score": 4.2,
  "cost_efficiency_score": 3.9,
  "korean_support_score": 3.5,
  "learning_curve_score": 3.8,
  "radar_chart": {
    "performance": 4.2,
    "community": 3.5,
    "value_for_money": 3.9,
    "korean_quality": 3.5,
    "ease_of_use": 3.8,
    "automation": 5.0
  },
  "pros": ["VS Code 기반의 강력한 코딩 특화", "코드베이스 전체 이해", "자동 디버깅"],
  "cons": ["개발자 외에는 사용 어려움", "비싼 프로 플랜"],
  "target_users": ["개발자", "프로그래머"],
  "security_features": ["로컬 코드 처리 옵션", "SOC 2 준수"],
  "integrations": ["VS Code", "Git", "GitHub", "GitLab"],
  "summary_text": "개발/코딩 자동화에 집중한다면 Cursor가 적합합니다."
}'::jsonb
WHERE name ILIKE '%Cursor%';
