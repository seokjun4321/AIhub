-- Insert 9 Additional Notion Templates

-- 2. Task List
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
  '[Notion] Task List (심플 할 일 관리)',
  '복잡한 기능 없이 ''해야 할 일''과 ''완료한 일'' 딱 두 가지만 관리하는 직관적인 리스트입니다.',
  '투두리스트의 정석입니다. 복잡한 관계형 데이터베이스 없이 보드 뷰 하나로 ''할 일'', ''하는 중'', ''완료'' 상태를 관리합니다. 카드 드래그 앤 드롭으로 성취감을 느껴보세요.',
  'Notion',
  0,
  ARRAY['1개 (보드 뷰 - To Do, Doing, Done)'],
  'https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?auto=format&fit=crop&q=80&w=1000',
  ARRAY['https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?auto=format&fit=crop&q=80&w=1000'],
  ARRAY['투두리스트', '할일', '체크리스트', '생산성', '심플'],
  'Notion Official',
  'https://www.notion.so/templates/task-list',
  'https://www.notion.so/templates/task-list',
  ARRAY[
    '''To Do'' 칸에 생각나는 할 일들을 모두 적습니다.',
    '일을 시작하면 카드를 드래그해서 ''Doing''으로 옮깁니다.',
    '다 끝나면 ''Done''으로 넘깁니다. (성취감!)'
  ]
);

-- 3. Habit Tracker
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
  '[Notion] Habit Tracker (습관 트래커)',
  '운동, 명상, 독서 등 매일의 루틴을 체크박스로 기록하고 달성률을 확인합니다.',
  '좋은 습관을 만드는 가장 좋은 방법은 기록입니다. 매일 실천 여부를 체크하고, 하단의 자동 계산 기능을 통해 이번 달 달성률을 확인해보세요.',
  'Notion',
  0,
  ARRAY['1개 (표 뷰)'],
  'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?auto=format&fit=crop&q=80&w=1000',
  ARRAY['https://images.unsplash.com/photo-1434030216411-0b793f4b4173?auto=format&fit=crop&q=80&w=1000'],
  ARRAY['습관', '루틴', '갓생', '자기관리', '기록'],
  'Notion Official',
  'https://www.notion.so/templates/simple-habit-tracker',
  'https://www.notion.so/templates/simple-habit-tracker',
  ARRAY[
    '표의 상단(속성) 이름을 내가 만들고 싶은 습관(예: 물 2L 마시기)으로 수정합니다.',
    '필요 없는 열은 삭제합니다.',
    '매일 날짜를 추가하고 실천 여부를 체크합니다.'
  ]
);

-- 4. Cornell Notes System
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
  '[Notion] Cornell Notes System (코넬식 노트 필기)',
  '효율적인 공부법으로 유명한 ''코넬 노트'' 양식을 노션에 그대로 구현했습니다.',
  '대학생과 수험생에게 강력 추천하는 노트 필기법입니다. 강의 내용을 적는 Notes, 키워드를 적는 Cue, 요약을 적는 Summary 3단 구성으로 복습 효과를 극대화합니다.',
  'Notion',
  0,
  ARRAY['1개 (리스트 뷰)', '내부 템플릿(Cue, Notes, Summary)'],
  'https://images.unsplash.com/photo-1517842645767-c639042777db?auto=format&fit=crop&q=80&w=1000',
  ARRAY['https://images.unsplash.com/photo-1517842645767-c639042777db?auto=format&fit=crop&q=80&w=1000'],
  ARRAY['공부', '필기', '대학생', '수험생', '요약'],
  'Notion Official',
  'https://www.notion.so/templates/cornell-notes-system',
  'https://www.notion.so/templates/cornell-notes-system',
  ARRAY[
    '강의를 들으며 우측 ''Notes'' 칸에 내용을 받아 적습니다.',
    '복습할 때 좌측 ''Cue'' 칸에 핵심 키워드나 질문을 적습니다.',
    '공부를 마치고 하단 ''Summary''에 3줄 요약을 남깁니다.'
  ]
);

-- 5. Simple Budget
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
  '[Notion] Simple Budget (간편 가계부)',
  '수입과 지출을 기록하고 태그별로 분류하여 잔액을 계산해주는 금전 출납부입니다.',
  '복잡한 엑셀 수식 없이도 직관적으로 돈 관리를 할 수 있습니다. 태그별로 지출 내역을 분류하고 합계 기능을 통해 현재 재정 상태를 파악하세요.',
  'Notion',
  0,
  ARRAY['1개 (표 뷰)'],
  'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?auto=format&fit=crop&q=80&w=1000',
  ARRAY['https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?auto=format&fit=crop&q=80&w=1000'],
  ARRAY['가계부', '용돈기입장', '돈관리', '절약', '재테크'],
  'Notion Official',
  'https://www.notion.so/templates/simple-budget',
  'https://www.notion.so/templates/simple-budget',
  ARRAY[
    '수입은 양수(+), 지출은 음수(-)로 금액을 입력합니다.',
    '''태그'' 속성을 식비, 교통비, 월급 등으로 설정합니다.',
    '표 하단의 ''Sum(합계)'' 기능을 켜서 현재 잔액을 확인합니다.'
  ]
);

-- 6. Job Applications
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
  '[Notion] Job Applications (취업 지원 현황)',
  '지원한 회사 목록, 서류 통과 여부, 면접 일정 등을 단계별로 관리합니다.',
  '이직이나 취업 준비 시 수십 군데의 지원 현황을 헷갈리지 않게 관리할 수 있습니다. 각 회사별 전형 단계와 마감일, 제출한 서류를 한곳에서 추적하세요.',
  'Notion',
  0,
  ARRAY['1개 (보드 뷰)'],
  'https://images.unsplash.com/photo-1586281380349-632531db7ed4?auto=format&fit=crop&q=80&w=1000',
  ARRAY['https://images.unsplash.com/photo-1586281380349-632531db7ed4?auto=format&fit=crop&q=80&w=1000'],
  ARRAY['취업', '이직', '커리어', '면접', '포트폴리오'],
  'Notion Official',
  'https://www.notion.so/templates/job-applications',
  'https://www.notion.so/templates/job-applications',
  ARRAY[
    '''지원 예정'', ''지원 완료'', ''면접'', ''결과 대기'' 등으로 그룹을 나눕니다.',
    '회사별 카드를 만들고 채용 공고 링크를 붙여넣습니다.',
    '자소서 마감일을 날짜 속성에 입력해 알림을 받습니다.'
  ]
);

-- 7. Reading List
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
  '[Notion] Reading List (독서 리스트)',
  '읽고 싶은 책과 읽은 책을 갤러리 형태로 예쁘게 정리하는 서재 템플릿입니다.',
  '나만의 디지털 서재를 만들어보세요. 읽은 책의 표지를 전시하고 평점과 서평을 남길 수 있습니다. 영화나 드라마 감상문으로도 활용 가능합니다.',
  'Notion',
  0,
  ARRAY['1개 (갤러리 뷰 + 리스트 뷰)'],
  'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?auto=format&fit=crop&q=80&w=1000',
  ARRAY['https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?auto=format&fit=crop&q=80&w=1000'],
  ARRAY['독서', '책', '서평', '취미', '기록'],
  'Notion Official',
  'https://www.notion.so/templates/reading-list',
  'https://www.notion.so/templates/reading-list',
  ARRAY[
    '''상태'' 속성을 ''읽을 예정'', ''읽는 중'', ''완독''으로 구분합니다.',
    '책 표지 이미지를 구글에서 찾아 붙여넣으면 갤러리 뷰가 완성됩니다.',
    '별점(1~5점) 속성을 추가해 나만의 평점을 매깁니다.'
  ]
);

-- 8. Weekly Agenda
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
  '[Notion] Weekly Agenda (주간 일정표)',
  '월화수목금토일, 요일별로 해야 할 일을 정리하는 주간 플래너입니다.',
  '매주 반복되는 주간 계획을 깔끔하게 정리하세요. 요일별 컬럼에 할 일을 나열하고 완료한 항목은 지워나가는 단순하지만 강력한 일정 관리 도구입니다.',
  'Notion',
  0,
  ARRAY['요일별 컬럼 구조 페이지'],
  'https://images.unsplash.com/photo-1506784983877-45594efa4cbe?auto=format&fit=crop&q=80&w=1000',
  ARRAY['https://images.unsplash.com/photo-1506784983877-45594efa4cbe?auto=format&fit=crop&q=80&w=1000'],
  ARRAY['일정', '주간계획', '플래너', '스케줄', '시간관리'],
  'Notion Official',
  'https://www.notion.so/templates/weekly-agenda',
  'https://www.notion.so/templates/weekly-agenda',
  ARRAY[
    '이번 주 중요한 약속과 할 일을 요일 칸에 적습니다.',
    '완료한 일은 취소선(단축키: Ctrl/Cmd + Shift + S)을 긋거나 지웁니다.',
    '일요일 저녁에 ''Template'' 버튼을 눌러 다음 주 빈 양식을 생성합니다.'
  ]
);

-- 9. Meeting Notes
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
  '[Notion] Meeting Notes (회의록)',
  '회의 안건, 참석자, 결정 사항(Action Item)을 체계적으로 기록하고 공유합니다.',
  '효율적인 회의를 위한 필수 템플릿입니다. 안건을 미리 공유하고, 회의 중 결정된 액션 아이템을 담당자에게 할당하여 실행력을 높이세요.',
  'Notion',
  0,
  ARRAY['1개 (리스트 뷰)'],
  'https://images.unsplash.com/photo-1556761175-4b46a572b786?auto=format&fit=crop&q=80&w=1000',
  ARRAY['https://images.unsplash.com/photo-1556761175-4b46a572b786?auto=format&fit=crop&q=80&w=1000'],
  ARRAY['업무', '회의', '협업', '팀워크', '비즈니스'],
  'Notion Official',
  'https://www.notion.so/templates/meeting-notes',
  'https://www.notion.so/templates/meeting-notes',
  ARRAY[
    '회의 전, 새 페이지를 열고 ''안건(Agenda)''을 미리 작성해 공유합니다.',
    '회의 중 결정된 사항은 체크박스로 만들어 담당자를 태그(@이름)합니다.',
    '회의 후 관련 문서를 페이지 안에 첨부합니다.'
  ]
);

-- 10. Content Calendar
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
  '[Notion] Content Calendar (콘텐츠/SNS 관리)',
  '블로그, 인스타, 유튜브 등 업로드 일정을 달력으로 관리하는 크리에이터용 템플릿입니다.',
  '콘텐츠 아이디어 스케치부터 발행 일정 관리까지 한 번에 가능합니다. 캘린더 뷰에서 드래그 앤 드롭으로 발행일을 조정하고 플랫폼별로 분류해보세요.',
  'Notion',
  0,
  ARRAY['1개 (캘린더 뷰 + 보드 뷰)'],
  'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&q=80&w=1000',
  ARRAY['https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&q=80&w=1000'],
  ARRAY['SNS', '블로그', '마케팅', '일정관리', '아이디어'],
  'Notion Official',
  'https://www.notion.so/templates/content-calendar',
  'https://www.notion.so/templates/content-calendar',
  ARRAY[
    '떠오르는 아이디어를 날짜 없이 카드만 만들어 ''아이디어'' 칸에 둡니다.',
    '작성이 시작되면 ''진행 중''으로 옮깁니다.',
    '발행일을 확정하고 달력 뷰에서 해당 날짜로 카드를 끌어다 놓습니다.'
  ]
);
