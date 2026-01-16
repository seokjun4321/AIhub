-- Insert Deep Research Discussion Prompt Template
INSERT INTO preset_prompt_templates (
  title,
  difficulty,
  one_liner,
  description,
  tags,
  badges,
  author,
  compatible_tools,
  prompt,
  prompt_en,
  variables,
  example_io,
  tips
) VALUES (
  '학술 논문 Discussion 섹션 작성 (Deep Research Mode)',
  'Advanced',
  '미완성 논문 초안을 입력하면 문헌조사+논리전개+인용까지 포함된 Discussion 섹션을 자동 생성',
  '기능 생태학자처럼 행동하며, 업로드한 논문 초안(서론+결과)을 분석해 토론 섹션의 핵심 논점을 도출하고 최신 문헌을 자동 검색·인용하여 출판 수준의 Discussion을 작성합니다. 각 단락은 주제문→증거→분석→결론 구조로 체계화됩니다.\n\n추천 대상: 졸업논문·학술지 논문 작성 중인 대학원생, 학부 졸업프로젝트 학생',
  ARRAY['논문작성', 'Discussion섹션', '문헌조사', '학술글쓰기', 'DeepResearch', '인용자동화'],
  '[{"text": "고급", "color": "orange"}]'::jsonb,
  'AIHub',
  ARRAY['ChatGPT (Deep Research)'],
  E'## Your Role\n\n나는 네가 성실한 {전공분야} 전문가로서 행동하고, 미완성 논문을 위해 논의(Discussion) 포인트를 식별해주길 원해.\n\n## Your Task\n\n1. 서론을 읽고 이해하여 주제 내용을 파악하기\n2. 결과(Results)를 훑고 요약하기\n3. 결과를 서론과 연결하기\n4. 논의에서 다뤄야 할 포인트 세트를 정의하기. 논의 문단 3-4개를 개요로 잡고, 각 문단마다 다뤄야 할 내용 ~10개를 불릿 포인트로 제시하기\n5. 과학 논의가 어떻게 구조화되는지 생각하고, 이 문단들의 순서가 어떻게 되어야 하는지 제안하기. 나는 이미 논의 섹션에 몇 가지 아이디어를 적어두었으니({토론아이디어}), 필요하면 이를 수정하고 중요한 것과 덜 중요한 것을 정리해도 좋음\n6. 논의에서의 각 질문을 리서치하고, 내 결과와 서론을 사용해 어떻게 답변할지 제안하기\n7. 논의 문단 각각에 대한 답변을 작성하여, 가능한 한 출판 가능한 수준에 가깝게 다듬기\n\n## Writing Instructions\n\n형식적이고 권위 있는 톤으로 작성하되, 과학적 논증에서 **정확성과 깊이**를 보장해줘. 전문적인 생태학 용어를 자신 있게 사용하되, 필요한 경우 핵심 용어를 명확히 정의하거나 맥락화해줘. 문장은 정보 밀도가 높고 논리적으로 연결되도록 구성하며, 개념 간 관계를 충분히 명료하게 표현하기 위해 종종 복합적인 문장 구조를 활용해도 좋아. 중복을 피하면서도 이론적 틀과 방법론적 접근을 철저히 설명하여, 디테일과 간결함의 균형을 유지해줘. 완곡한 표현보다는 단정적인 진술을 사용해 논지를 분명히 제시하고, 확립된 이론과 실증적 발견을 인용해 주장을 강화해줘. 개념 간 전환을 세심하게 처리해 아이디어 흐름을 매끄럽게 만들고, 독자가 가설, 결과, 해석을 지적 엄밀성으로 따라올 수 있도록 안내해줘. 생태학적 현상을 구조적이고 개념적으로 풍부한 방식으로 프레이밍하되, 명료성과 기술적 정확성을 최우선으로 해줘.\n\n## Context\n- 목표 저널: {목표저널}\n\n## My unfinished manuscript:\n"""\n{미완성논문파일}\n"""',
  E'## Your Role\n\nI need you to act as a diligent {전공분야} and identify discussion points for my unfinished paper.\n\n## Your Task\n1. Read and understand the introduction to get an understanding of the subject matter\n2. Go through the results and sum them up\n3. Relate the results to the introduction.\n4. Define a set of points that need to be addressed in the discussion. Outline 3-4 paragraphs by using ~10 bullet points in each that need to be addressed.\n5. Think of how scientific discussions are structured and what the order of these paragraphs should be. I have written some ideas into the discussion section already ({토론아이디어}), feel free to revise them and sort out what\'s important.\n6. Research each question in the discussion and suggest how you would address it using my results and introduction.\n7. Write up answers to each of the discussion paragraph getting them as close to publication ready\n\n## Writing Instructions\nWrite with a formal, authoritative tone, ensuring precision and depth in scientific argumentation. Use specialized ecological terminology with confidence, clearly defining or contextualizing key terms when necessary. Structure sentences to be information-dense and logically connected, often employing complex sentence constructions to fully articulate relationships between concepts. Maintain a balance between detail and conciseness, avoiding redundancy while thoroughly explaining theoretical frameworks and methodological approaches. Present arguments assertively, using definitive statements rather than hedging, and integrate references to established theories and empirical findings to reinforce claims. Ensure a seamless flow of ideas by carefully transitioning between concepts, guiding the reader through hypotheses, results, and interpretations with intellectual rigor. Prioritize clarity and technical accuracy, framing ecological phenomena in a structured and conceptually rich manner.\n\n## Context\n- Target Journal: {목표저널}\n\n## My unfinished manuscript:\n"""\n{미완성논문파일}\n"""',
  '[
    {"name": "전공분야", "placeholder": "예: functional plant ecology", "example": "functional plant ecology"},
    {"name": "목표저널", "placeholder": "예: Journal of Ecology", "example": "Journal of Ecology"},
    {"name": "미완성논문파일", "placeholder": "서론+결과 포함 초안", "example": "[논문 초안 붙여넣기]"},
    {"name": "토론아이디어", "placeholder": "논의하고 싶은 아이디어 (선택)", "example": "- Trait plasticity increases under drought"}
  ]'::jsonb,
  '{"input": "미완성 논문 초안 (서론+결과)", "output": "Paragraph 1: Our findings reveal that trait variability increases under drought stress (Topic). Studies by Smith et al. (2023) and Chen (2024) confirm this pattern in Mediterranean ecosystems (Evidence). This suggests functional plasticity as an adaptation strategy (Analysis)."}'::jsonb,
  ARRAY[
    'ChatGPT **Deep Research 모드** 전용 (일반 모드보다 10배 정확)',
    '서론+방법+결과 섹션을 최소 70% 완성한 후 사용',
    '목표 저널명을 명시하면 해당 저널 스타일로 작성',
    'Writing Instructions 부분에 본인 글쓰기 스타일 예시 추가 권장',
    '출력된 문헌은 Consensus·SciSpace로 재검증 필수'
  ]
);
