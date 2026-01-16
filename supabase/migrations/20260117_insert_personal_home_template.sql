-- Insert Personal Home Template
INSERT INTO preset_templates (
  title,
  one_liner,
  description,
  category,
  price,
  includes,
  image_url,
  preview_images,
  tags,
  author,
  preview_url,
  duplicate_url,
  setup_steps
) VALUES (
  '[Notion] Personal Home (개인 대시보드)',
  '노션을 처음 시작할 때 가장 적합한 기본 홈 화면입니다. 일기, 할 일, 여행 계획 등을 한눈에 모아봅니다.',
  '노션을 처음 사용할 때 가장 막막한 것이 "첫 화면을 어떻게 꾸밀까"입니다. 이 템플릿은 일기, 할 일 관리, 여행 계획, 영화 리스트 등 개인 생활에 필요한 핵심 페이지들을 깔끔한 대시보드 형태로 모아두었습니다. 스마트폰 위젯으로 설정해두면 내비게이션처럼 활용하기 좋습니다.',
  'Notion',
  0, -- 무료
  ARRAY['5개 이상의 하위 페이지 링크 구조'],
  'https://images.unsplash.com/photo-1481487484168-9b930d5b7d9d?auto=format&fit=crop&q=80&w=1000', -- Generic cozy home office/planner image
  ARRAY[
    'https://images.unsplash.com/photo-1481487484168-9b930d5b7d9d?auto=format&fit=crop&q=80&w=1000'
  ],
  ARRAY['대시보드', '시작페이지', '입문용', '홈화면', '정리'],
  'Notion Official',
  'https://www.notion.so/templates/personal-home',
  'https://www.notion.so/templates/personal-home',
  ARRAY[
    '링크 접속 후 우측 상단 ''Get this template(이 템플릿 사용하기)'' 버튼 클릭.',
    '''Daily Life'' 섹션의 기본 링크들을 내 생활 패턴(예: 운동, 공부)에 맞게 이름만 바꿉니다.',
    '자주 쓰는 외부 사이트(유튜브, 뉴스 등)를 즐겨찾기처럼 링크로 추가합니다.'
  ]
);
