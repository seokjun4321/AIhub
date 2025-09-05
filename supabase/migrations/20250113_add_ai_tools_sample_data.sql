-- AI 도구 샘플 데이터 추가 마이그레이션
-- 실제 AI 도구들의 정보를 추가하여 테스트할 수 있도록 함

-- 1. 카테고리 데이터 추가
INSERT INTO public.categories (name, description) VALUES
('텍스트 생성', 'AI 텍스트 생성 및 편집 도구'),
('이미지 생성', 'AI 이미지 생성 및 편집 도구'),
('코딩', 'AI 코딩 어시스턴트 및 개발 도구'),
('비즈니스', '비즈니스 및 생산성 도구'),
('교육', '교육 및 학습 도구'),
('음성', '음성 인식 및 생성 도구'),
('비디오', '비디오 생성 및 편집 도구'),
('데이터 분석', '데이터 분석 및 시각화 도구')
ON CONFLICT (name) DO NOTHING;

-- 2. AI 모델 샘플 데이터 추가
INSERT INTO public.ai_models (
  name, 
  description, 
  provider, 
  model_type, 
  pricing_info, 
  features, 
  use_cases, 
  limitations, 
  website_url, 
  api_documentation_url, 
  average_rating, 
  rating_count,
  logo_url
) VALUES
(
  'ChatGPT',
  'OpenAI의 대화형 AI 모델로 자연스러운 대화와 다양한 작업을 수행할 수 있습니다.',
  'OpenAI',
  '대화형 AI',
  '무료 플랜: 월 20회, 유료 플랜: $20/월',
  ARRAY['자연어 처리', '코드 작성', '번역', '요약', '창작'],
  ARRAY['고객 서비스', '콘텐츠 작성', '프로그래밍 도움', '학습 보조', '창작 활동'],
  ARRAY['2021년 이후 정보 부족', '실시간 정보 접근 제한', '개인정보 보호 필요'],
  'https://chat.openai.com',
  'https://platform.openai.com/docs',
  4.8,
  1250,
  'https://upload.wikimedia.org/wikipedia/commons/0/04/ChatGPT_logo.svg'
),
(
  'Midjourney',
  '텍스트 프롬프트를 통해 고품질 이미지를 생성하는 AI 아트 도구입니다.',
  'Midjourney Inc.',
  '이미지 생성 AI',
  '기본: $10/월, 표준: $30/월, 프로: $60/월',
  ARRAY['텍스트-이미지 생성', '다양한 스타일', '고해상도 출력', '이미지 편집'],
  ARRAY['디자인', '마케팅', '아트워크', '일러스트레이션', '콘텐츠 제작'],
  ARRAY['Discord에서만 사용', '학습 곡선 존재', '저작권 이슈 가능성'],
  'https://www.midjourney.com',
  'https://docs.midjourney.com',
  4.9,
  890,
  'https://upload.wikimedia.org/wikipedia/commons/4/4a/Midjourney_Emblem.png'
),
(
  'GitHub Copilot',
  'AI 기반 코드 어시스턴트로 실시간 코드 제안과 자동 완성을 제공합니다.',
  'GitHub',
  '코딩 AI',
  '개인: $10/월, 비즈니스: $19/월',
  ARRAY['코드 자동 완성', '다국어 지원', 'IDE 통합', '컨텍스트 이해'],
  ARRAY['소프트웨어 개발', '코드 리뷰', '학습', '프로토타이핑', '디버깅'],
  ARRAY['인터넷 연결 필요', '개인정보 보호 우려', '학습 데이터 의존성'],
  'https://github.com/features/copilot',
  'https://docs.github.com/en/copilot',
  4.7,
  2156,
  'https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png'
),
(
  'Claude',
  'Anthropic의 AI 어시스턴트로 안전하고 도움이 되는 대화를 제공합니다.',
  'Anthropic',
  '대화형 AI',
  '무료: 제한적 사용, Pro: $20/월',
  ARRAY['대화형 AI', '문서 분석', '코드 작성', '창작 지원', '윤리적 AI'],
  ARRAY['연구', '작문', '프로그래밍', '분석', '학습'],
  ARRAY['제한된 무료 사용량', '신규 서비스', '특정 지역 제한'],
  'https://claude.ai',
  'https://docs.anthropic.com',
  4.6,
  780,
  'https://pbs.twimg.com/profile_images/1673501671681/Claude_Avatar_400x400.png'
),
(
  'DALL-E 3',
  'OpenAI의 최신 이미지 생성 모델로 텍스트 설명을 통해 고품질 이미지를 생성합니다.',
  'OpenAI',
  '이미지 생성 AI',
  'ChatGPT Plus: $20/월, API: 사용량 기반',
  ARRAY['텍스트-이미지 생성', '고품질 출력', '다양한 스타일', '안전 필터'],
  ARRAY['마케팅', '디자인', '교육', '창작', '프로토타이핑'],
  ARRAY['API 비용', '사용량 제한', '저작권 고려 필요'],
  'https://openai.com/dall-e-3',
  'https://platform.openai.com/docs/guides/images',
  4.5,
  420,
  'https://openai.com/content/images/2023/09/DALL-E-3-1.png'
),
(
  'Notion AI',
  'Notion에 통합된 AI 어시스턴트로 문서 작성, 요약, 번역 등을 도와줍니다.',
  'Notion',
  '생산성 AI',
  'AI 기능: $8/월 (사용자당)',
  ARRAY['문서 작성', '요약', '번역', '아이디어 생성', 'Notion 통합'],
  ARRAY['문서 작성', '프로젝트 관리', '학습', '비즈니스', '개인 생산성'],
  ARRAY['Notion 구독 필요', '학습 곡선', '제한된 무료 사용량'],
  'https://www.notion.so/product/ai',
  'https://www.notion.so/help/ai-features',
  4.4,
  650,
  'https://upload.wikimedia.org/wikipedia/commons/4/45/Notion_app_logo.png'
),
(
  'Jasper AI',
  '마케팅 콘텐츠 작성을 위한 AI 플랫폼으로 다양한 브랜드 톤을 지원합니다.',
  'Jasper',
  '마케팅 AI',
  'Creator: $39/월, Teams: $99/월, Business: 맞춤 가격',
  ARRAY['콘텐츠 생성', '브랜드 톤', 'SEO 최적화', '다국어 지원', '템플릿'],
  ARRAY['마케팅', '콘텐츠 마케팅', '소셜 미디어', '블로그', '광고'],
  ARRAY['비용이 높음', '학습 필요', '브랜드 일관성 관리'],
  'https://www.jasper.ai',
  'https://docs.jasper.ai',
  4.3,
  320,
  'https://pbs.twimg.com/profile_images/1635320579/jasper_logo_400x400.png'
),
(
  'Runway ML',
  'AI 기반 비디오 편집 및 생성 플랫폼으로 창작자들을 위한 도구를 제공합니다.',
  'Runway',
  '비디오 AI',
  '무료: 제한적, Standard: $12/월, Pro: $28/월',
  ARRAY['비디오 편집', 'AI 생성', '배경 제거', '모션 그래픽', '색상 보정'],
  ARRAY['비디오 제작', '마케팅', '교육', '창작', '소셜 미디어'],
  ARRAY['고사양 하드웨어 필요', '학습 곡선', '렌더링 시간'],
  'https://runwayml.com',
  'https://help.runwayml.com',
  4.2,
  180,
  'https://runwayml.com/static/images/runway-logo.png'
),
(
  'Perplexity AI',
  '실시간 정보 검색과 AI 답변을 결합한 검색 엔진입니다.',
  'Perplexity',
  '검색 AI',
  '무료: 제한적, Pro: $20/월',
  ARRAY['실시간 검색', '소스 인용', '요약', '다국어', '이미지 검색'],
  ARRAY['연구', '학습', '뉴스', '분석', '정보 수집'],
  ARRAY['무료 사용량 제한', '신뢰성 검증 필요', '최신 정보 의존성'],
  'https://www.perplexity.ai',
  'https://docs.perplexity.ai',
  4.1,
  450,
  'https://pbs.twimg.com/profile_images/1664316507/perplexity_400x400.png'
),
(
  'ElevenLabs',
  '자연스러운 음성 합성을 위한 AI 플랫폼으로 다양한 언어와 목소리를 지원합니다.',
  'ElevenLabs',
  '음성 AI',
  '무료: 10,000자/월, Starter: $5/월, Creator: $22/월',
  ARRAY['음성 합성', '다국어 지원', '감정 표현', '음성 복제', 'API'],
  ARRAY['팟캐스트', '오디오북', '마케팅', '교육', '접근성'],
  ARRAY['음성 복제 윤리', '비용 증가', '품질 변동'],
  'https://elevenlabs.io',
  'https://docs.elevenlabs.io',
  4.0,
  280,
  'https://elevenlabs.io/static/images/logo.png'
);

-- 3. 샘플 평점 데이터 추가 (일부 사용자들이 리뷰를 남겼다고 가정)
INSERT INTO public.ratings (user_id, ai_model_id, rating, review) VALUES
-- ChatGPT 리뷰들
('00000000-0000-0000-0000-000000000001', 1, 5, '정말 유용한 도구입니다. 코딩부터 창작까지 다양한 작업에 도움이 됩니다.'),
('00000000-0000-0000-0000-000000000002', 1, 4, '좋은 성능이지만 때로는 부정확한 정보를 제공하기도 합니다.'),
('00000000-0000-0000-0000-000000000003', 1, 5, '혁신적인 도구입니다. 업무 효율성이 크게 향상되었습니다.'),

-- Midjourney 리뷰들
('00000000-0000-0000-0000-000000000001', 2, 5, '놀라운 이미지 품질입니다. 창작에 완전히 새로운 차원을 열어주었습니다.'),
('00000000-0000-0000-0000-000000000004', 2, 4, '학습 곡선이 있지만 결과물이 정말 훌륭합니다.'),
('00000000-0000-0000-0000-000000000005', 2, 5, '디자이너로서 필수 도구가 되었습니다.'),

-- GitHub Copilot 리뷰들
('00000000-0000-0000-0000-000000000002', 3, 5, '코딩 속도가 2배 이상 빨라졌습니다. 정말 놀라운 도구입니다.'),
('00000000-0000-0000-0000-000000000003', 3, 4, '대부분 정확하지만 때로는 이상한 코드를 제안하기도 합니다.'),
('00000000-0000-0000-0000-000000000006', 3, 5, '개발자라면 반드시 사용해야 할 도구입니다.'),

-- Claude 리뷰들
('00000000-0000-0000-0000-000000000004', 4, 4, '안전하고 도움이 되는 AI입니다. ChatGPT와 다른 장점이 있습니다.'),
('00000000-0000-0000-0000-000000000005', 4, 5, '윤리적 측면에서 더 안전하다고 느낍니다.'),
('00000000-0000-0000-0000-000000000007', 4, 4, '좋은 대안이지만 아직 ChatGPT만큼 인기있지는 않습니다.'),

-- DALL-E 3 리뷰들
('00000000-0000-0000-0000-000000000001', 5, 4, '이미지 품질이 정말 좋습니다. 하지만 비용이 부담스럽습니다.'),
('00000000-0000-0000-0000-000000000006', 5, 5, '텍스트를 이미지로 변환하는 정확도가 놀랍습니다.'),
('00000000-0000-0000-0000-000000000008', 5, 4, '창작에 많은 도움이 되지만 API 비용이 높습니다.');

-- 4. 평점 재계산 트리거 실행 (실제 평점 반영)
SELECT recalculate_ai_model_rating(1);
SELECT recalculate_ai_model_rating(2);
SELECT recalculate_ai_model_rating(3);
SELECT recalculate_ai_model_rating(4);
SELECT recalculate_ai_model_rating(5);
SELECT recalculate_ai_model_rating(6);
SELECT recalculate_ai_model_rating(7);
SELECT recalculate_ai_model_rating(8);
SELECT recalculate_ai_model_rating(9);
SELECT recalculate_ai_model_rating(10);
