UPDATE ai_models
SET
  pros = ARRAY[
    '무료/저렴한 유지비 (Self-hosted)',
    '강력한 AI/LangChain 통합',
    '복잡한 로직(분기/반복) 처리 탁월',
    '1000+ 정식 연동 및 모든 API 연결 가능'
  ],
  cons = ARRAY[
    '초기 설치 및 서버 관리 필요 (Self-hosted)',
    '비개발자에게는 다소 높은 진입 장벽',
    'UI/문서가 100% 영어'
  ],
  comparison_data = '{
    "pros": [
      "무료/저렴한 유지비 (Self-hosted)",
      "강력한 AI/LangChain 통합",
      "복잡한 로직(분기/반복) 처리 탁월",
      "1000+ 정식 연동 및 모든 API 연결 가능"
    ],
    "cons": [
      "초기 설치 및 서버 관리 필요 (Self-hosted)",
      "비개발자에게는 다소 높은 진입 장벽",
      "UI/문서가 100% 영어"
    ],
    "radar_chart": {
      "community": 4.5,
      "automation": 5.0,
      "ease_of_use": 3.5,
      "performance": 4.8,
      "korean_quality": 2.5,
      "value_for_money": 5.0
    },
    "integrations": [
      "Google Workspace",
      "Slack/Discord",
      "OpenAI/Anthropic",
      "Supabase/Postgres",
      "LangChain",
      "Mattermost"
    ],
    "summary_text": "개발자 친화적인 노드 기반 자동화 툴. 내 서버에 설치하면 무료로 무제한 워크플로우를 돌릴 수 있으며, 최근 AI 에이전트 구축 기능이 대폭 강화되었습니다.",
    "target_users": [
      "백엔드 개발자",
      "자동화 엔지니어",
      "1인 창업가",
      "AI 에이전트 빌더"
    ],
    "security_features": [
      "Self-hosted (데이터 100% 소유)",
      "GDPR 준수 (자가 관리)",
      "Role-based Access Control",
      "SSO (Enterprise)"
    ],
    "performance_score": 4.8,
    "korean_support_score": 2.5,
    "learning_curve_score": 3.5,
    "cost_efficiency_score": 5.0
  }'::jsonb
WHERE name = 'n8n';
