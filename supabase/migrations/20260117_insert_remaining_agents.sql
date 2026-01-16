-- Insert 5 Remaining Agents with Bilingual Support

-- 6. Python Code Explainer
INSERT INTO preset_agents (
  title,
  one_liner,
  description,
  description_en,
  platform,
  author,
  tags,
  example_questions,
  url,
  instructions,
  instructions_en,
  requirements,
  example_conversation,
  example_conversation_en
) VALUES (
  'Python Code Explainer',
  '이해 안 되는 코드를 한 줄씩 주석을 달아 설명해주는 튜터',
  '코딩 과제나 오픈소스를 분석할 때 유용합니다. 복잡한 코드 블록을 주면, 각 라인이 어떤 역할을 하는지 초보자 눈높이에서 주석(Comment)과 함께 설명을 제공합니다.',
  'Useful for analyzing coding assignments or open source code. Provide a complex code block, and it provides comments and explanations for each line at a beginner''s level.',
  'Gemini',
  'GitHub (Developers)',
  ARRAY['코딩', '파이썬', 'CS전공', '개발자', '코드분석'],
  ARRAY['이 파이썬 코드가 무슨 역할을 하는지 설명해줘.', '이 함수에 버그가 있는지 확인해줘.', '이 코드를 더 효율적으로 짤 수 있어?'],
  '#',
  ARRAY[
    '당신은 코드 설명가 역할을 수행해 주세요. 저는 코드 스니펫(Python, C++, 또는 Java)을 제공할 것입니다.',
    '당신의 임무는 다음과 같습니다:',
    '1. 코드의 전체 기능을 한 단락으로 설명합니다.',
    '2. 각 부분이 무엇을 하는지 설명하는 주석을 코드 한 줄씩 추가합니다.',
    '3. 존재한다면 잠재적인 버그나 비효율성을 지적합니다.',
    '여기 코드가 있습니다:',
    '[PASTE CODE HERE]'
  ],
  ARRAY[
    'I want you to act as a code explainer. I will provide a snippet of code (Python, C++, or Java).',
    'Your task is to:',
    '1. Explain the overall functionality of the code in one paragraph.',
    '2. Add comments to the code line-by-line explaining what each part does.',
    '3. Point out any potential bugs or inefficiencies if they exist.',
    'Here is the code:',
    '[PASTE CODE HERE]'
  ],
  ARRAY['코드 복사 후 붙여넣기'],
  '[
    {"role": "user", "content": "코드: def fib(n): return n if n < 2 else fib(n-1) + fib(n-2)"},
    {"role": "assistant", "content": "1. **전체 기능:** 이 코드는 재귀를 사용하여 n번째 피보나치 수를 계산하는 함수입니다.\n\n2. **주석 설명:**\n```python\ndef fib(n):\n    # n이 2보다 작으면(0 또는 1) 그대로 n을 반환 (기저 조건)\n    return n if n < 2 else fib(n-1) + fib(n-2)\n    # 그렇지 않으면 앞의 두 수를 더해서 반환 (재귀 호출)\n```\n\n3. **잠재적 문제:** 큰 n에 대해서는 중복 계산이 많아 매우 비효율적입니다. 메모이제이션을 사용하거나 반복문으로 변경하는 것이 좋습니다."}
  ]'::jsonb,
  '[
    {"role": "user", "content": "Code: def fib(n): return n if n < 2 else fib(n-1) + fib(n-2)"},
    {"role": "assistant", "content": "1. **Overall Functionality:** This code calculates the nth Fibonacci number using recursion.\n\n2. **Line-by-line Comments:**\n```python\ndef fib(n):\n    # If n is less than 2 (0 or 1), return n (Base case)\n    return n if n < 2 else fib(n-1) + fib(n-2)\n    # Otherwise, return the sum of the two preceding numbers (Recursive call)\n```\n\n3. **Potential Issues:** This recursive approach is inefficient for large n due to redundant calculations. Consider using memoization or an iterative approach."}
  ]'::jsonb
);

-- 7. Bibliographer (Citation Helper)
INSERT INTO preset_agents (
  title,
  one_liner,
  description,
  description_en,
  platform,
  author,
  tags,
  example_questions,
  url,
  instructions,
  instructions_en,
  requirements,
  example_conversation,
  example_conversation_en
) VALUES (
  'Bibliographer (Citation Helper)',
  '웹 링크나 정보를 APA, MLA 등 학술 인용 형식으로 변환',
  '과제 제출 시 참고문헌 정리는 필수지만 번거롭습니다. URL이나 책 제목, 저자 정보를 던져주면 학교에서 요구하는 특정 포맷(APA 7th, MLA 9th 등)으로 정확하게 변환해줍니다.',
  'Generating citations is necessary but tedious. Provide a URL, book title, or author info, and it accurately converts it into the specific format required by your school (APA 7th, MLA 9th, etc.).',
  'Perplexity',
  'Academic Writing Communities',
  ARRAY['참고문헌', '인용', 'APA', 'MLA', '리포트'],
  ARRAY['이 웹사이트를 APA 7판 형식으로 인용해줘.', '해리포터 책을 MLA 형식으로 바꿔줘.', '이 논문의 인용 정보를 시카고 스타일로 만들어줘.'],
  '#',
  ARRAY[
    '당신은 인용 생성기 역할을 수행해 주세요. 저는 출처에 대한 정보(책, 웹사이트, 학술지 논문)를 제공할 것입니다. 당신은 지정된 형식에 맞는 전체 참고문헌과 본문 내 인용을 생성해야 합니다.',
    '필요한 형식:',
    '[e.g., APA 7th Edition / MLA 9th Edition]',
    '출처 정보:',
    '[PASTE URL OR BOOK INFO HERE]'
  ],
  ARRAY[
    'Please act as a citation generator. I will provide you with information about a source (book, website, journal article). You will generate the full citation and the in-text citation for the specified format.',
    'Format required: [e.g., APA 7th Edition / MLA 9th Edition]',
    'Source Info:',
    '[PASTE URL OR BOOK INFO HERE]'
  ],
  ARRAY['URL 또는 서지 정보 입력'],
  '[
    {"role": "user", "content": "형식: APA 7th, 출처: https://www.science.org/doi/10.1126/science.ade0123"},
    {"role": "assistant", "content": "**참고문헌 목록 (Reference List):**\nAuthor, A. A. (Year). Title of article. *Title of Periodical*, *xx*(x), pp-pp. https://doi.org/...\n\n**본문 내 인용 (In-text Citation):**\n(Author, Year)"}
  ]'::jsonb,
  '[
    {"role": "user", "content": "Format: APA 7th, Source: https://www.science.org/doi/10.1126/science.ade0123"},
    {"role": "assistant", "content": "**Reference List:**\nAuthor, A. A. (Year). Title of article. *Title of Periodical*, *xx*(x), pp-pp. https://doi.org/...\n\n**In-text Citation:**\n(Author, Year)"}
  ]'::jsonb
);

-- 8. Debate Opponent (Critical Thinking)
INSERT INTO preset_agents (
  title,
  one_liner,
  description,
  description_en,
  platform,
  author,
  tags,
  example_questions,
  url,
  instructions,
  instructions_en,
  requirements,
  example_conversation,
  example_conversation_en
) VALUES (
  'Debate Opponent',
  '내 주장에 대해 반박하고 논리적 허점을 찾아주는 토론 파트너',
  '발표 준비나 토론 과제를 할 때 사용합니다. 나의 주장이나 발표 스크립트를 입력하면, 반대 입장에서 강력한 반박 질문(Counter-arguments)을 제시하여 논리를 탄탄하게 다지도록 돕습니다.',
  'Used for presentation prep or debate assignments. Input your argument or script, and it presents strong counter-arguments from the opposing view to help solidify your logic.',
  'Claude',
  'Reddit (r/PromptEngineering)',
  ARRAY['토론', '발표준비', '비판적사고', '면접준비'],
  ARRAY['원자력 발전 찬성 입장에 대해 반박해줘.', '최저임금 인상 주장의 허점이 뭐야?', '내 에세이 논리의 약점을 찾아줘.'],
  '#',
  ARRAY[
    '당신은 숙련된 토론가이자 비판적 사고자 역할을 수행해 주세요. 저는 어떤 주제에 대한 입장이나 주장을 제시할 것입니다.',
    '당신의 역할은 다음과 같습니다:',
    '1. 제 주장 속의 약점을 식별합니다.',
    '2. 반대 입장에서 3개의 강력한 반박 논거를 제공합니다.',
    '3. 제 입장을 시험할 수 있는 도전적인 질문 2개를 제시합니다.',
    '제 입장은 다음과 같습니다:',
    '[INSERT YOUR ARGUMENT HERE]'
  ],
  ARRAY[
    'I want you to act as a skilled debater and critical thinker. I will present a position or an argument on a topic.',
    'Your role is to:',
    '1. Identify the weak points in my argument.',
    '2. Provide 3 strong counter-arguments from the opposing view.',
    '3. Ask me 2 challenging questions that would test my position.',
    'My position is:',
    '[INSERT YOUR ARGUMENT HERE]'
  ],
  ARRAY['주장 내용을 텍스트로 입력'],
  '[
    {"role": "user", "content": "입장: 동물원 폐지 찬성. 동물권 보호를 위해."},
    {"role": "assistant", "content": "1. **약점 식별:** 멸종 위기 종 보존이라는 순기능을 간과하고 있습니다.\n2. **반박 논거:**\n- 교육적 가치: 아이들이 동물을 실제로 보며 자연에 대한 흥미를 가집니다.\n- 보존 활동: 야생에서 생존 불가능한 개체를 보호합니다.\n3. **도전적 질문:** 만약 동물원이 없다면 멸종 위기 종을 어디서 효과적으로 보호하고 연구할 수 있을까요?"}
  ]'::jsonb,
  '[
    {"role": "user", "content": "Position: Ban zoos to protect animal rights."},
    {"role": "assistant", "content": "1. **Weak Points:** You overlook the conservation role of zoos for endangered species.\n2. **Counter-arguments:**\n- Educational Value: Zoos inspire children to care about nature.\n- Conservation: They protect animals that cannot survive in the wild.\n3. **Challenging Questions:** Without zoos, where would we effectively protect and study endangered species?"}
  ]'::jsonb
);

-- 9. Presentation Slide Outliner
INSERT INTO preset_agents (
  title,
  one_liner,
  description,
  description_en,
  platform,
  author,
  tags,
  example_questions,
  url,
  instructions,
  instructions_en,
  requirements,
  example_conversation,
  example_conversation_en
) VALUES (
  'Presentation Slide Outliner',
  '주제만 주면 PPT 슬라이드 목차와 장표별 내용을 구성',
  '발표 자료를 만들 때 "무슨 내용을 넣을지" 고민하는 시간을 줄여줍니다. 주제와 타겟 청중을 알려주면 서론-본론-결론 구조에 맞춰 슬라이드별 핵심 내용과 추천 이미지를 제안합니다.',
  'Reduces time spent worrying about "what to include" in presentation slides. Provide the topic and audience, and it constructs the key content and visual suggestions for each slide formatted in an Intro-Body-Conclusion structure.',
  'GPT',
  'Productivity Hackers',
  ARRAY['PPT', '발표', '조별과제', '슬라이드', '기획'],
  ARRAY['마케팅 전략 발표 슬라이드 10장 구성해줘.', '기후 변화에 대한 발표 자료 아웃라인 짜줘.', '졸업 작품 발표용 PPT 목차 추천해줘.'],
  '#',
  ARRAY[
    '저는 대학 수업을 위한 프레젠테이션 슬라이드 자료를 만들어야 합니다.',
    '주제: [TOPIC]',
    '대상 청중: [AUDIENCE]',
    '슬라이드 수: [e.g., 10]',
    '각 슬라이드에 대해 다음을 포함한 상세한 개요를 제공해 주세요:',
    '1. 슬라이드 제목',
    '2. 핵심 불릿 포인트(내용)',
    '3. 슬라이드에 포함할 추천 시각 자료/차트'
  ],
  ARRAY[
    'I need to create a presentation slide deck for a university class.',
    'Topic: [TOPIC]',
    'Target Audience: [AUDIENCE, e.g., Classmates and Professor]',
    'Number of Slides: [e.g., 10]',
    'Please provide a detailed outline for each slide containing:',
    '1. Slide Title',
    '2. Key Bullet Points (Content)',
    '3. Suggested Visuals/Charts to include on the slide.'
  ],
  ARRAY['주제 및 청중 정보 입력'],
  '[
    {"role": "user", "content": "주제: 인공지능의 윤리, 청중: 대학생, 슬라이드: 5장"},
    {"role": "assistant", "content": "**Slide 1: 서론**\n- 제목: AI 윤리, 왜 중요한가?\n- 내용: AI의 급속한 발전과 일상 침투\n- 시각자료: 로봇과 인간이 악수하는 이미지\n\n**Slide 2: 편향성 문제**..."}
  ]'::jsonb,
  '[
    {"role": "user", "content": "Topic: AI Ethics, Audience: Uni Students, Slides: 5"},
    {"role": "assistant", "content": "**Slide 1: Introduction**\n- Title: Why AI Ethics Matters?\n- Content: Rapid growth of AI\n- Visual: Robot shaking hands with human\n\n**Slide 2: Bias Issues**..."}
  ]'::jsonb
);

-- 10. Project/Study Planner
INSERT INTO preset_agents (
  title,
  one_liner,
  description,
  description_en,
  platform,
  author,
  tags,
  example_questions,
  url,
  instructions,
  instructions_en,
  requirements,
  example_conversation,
  example_conversation_en
) VALUES (
  'Project/Study Planner',
  '시험 범위나 프로젝트 마감일을 입력하면 일별 계획표 생성',
  '벼락치기를 방지하기 위한 도구입니다. 해야 할 분량과 남은 기간을 입력하면, 현실적으로 소화 가능한 분량으로 쪼개어 일별/주별 스케줄(To-Do List)을 만들어줍니다.',
  'A tool to prevent cramming. Input your workload and remaining time, and it breaks it down into manageable chunks, creating a realistic daily/weekly schedule.',
  'GPT',
  'Notion Template Community Inspiration',
  ARRAY['계획표', '시간관리', '시험공부', 'J성향', '플래너'],
  ARRAY['다음 주 미적분 시험 공부 계획 짜줘.', '3일 뒤 마감인 리포트 작성 스케줄 만들어줘.', '한 달 동안 토익 900점 달성 계획 세워줘.'],
  '#',
  ARRAY[
    '저는 학습 계획 또는 프로젝트 일정이 필요합니다.',
    '과제: [e.g., Study for Calculus Midterm]',
    '학습 범위: [e.g., Chapters 1 to 5, approx 150 pages]',
    '사용 가능한 시간: [e.g., 7 days, 3 hours per day]',
    '마감일: [Date]',
    '현실적으로 관리 가능한 단위로 학습 범위를 나누고, 복습 및 휴식 시간을 포함한 상세한 일별 계획표를 만들어 주세요. 표 형태로 제시해 주세요.'
  ],
  ARRAY[
    'I need a study plan/project schedule.',
    'Task: [e.g., Study for Calculus Midterm]',
    'Materials to cover: [e.g., Chapters 1 to 5, approx 150 pages]',
    'Time available: [e.g., 7 days, 3 hours per day]',
    'Deadline: [Date]',
    'Please create a detailed day-by-day schedule. Break down the materials into manageable chunks and include time for review/breaks. Present it as a table.'
  ],
  ARRAY['학습 분량 및 가용 시간 구체적으로 입력 시 정확도 향상'],
  '[
    {"role": "user", "content": "과제: 중간고사, 범위: 1-3장, 시간: 3일"},
    {"role": "assistant", "content": "| Day | Time | Activity |\n|---|---|---|\n| Day 1 | 09:00-11:00 | 1장 개념 정리 |\n| Day 1 | 11:00-12:00 | 1장 연습문제 풀이 |\n| Day 2 | ... | ... |"}
  ]'::jsonb,
  '[
    {"role": "user", "content": "Task: Midterm, Range: Ch 1-3, Time: 3 Days"},
    {"role": "assistant", "content": "| Day | Time | Activity |\n|---|---|---|\n| Day 1 | 09:00-11:00 | Ch 1 Concepts |\n| Day 1 | 11:00-12:00 | Ch 1 Practice Problems |\n| Day 2 | ... | ... |"}
  ]'::jsonb
);
