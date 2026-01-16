-- Insert 'Telegram PDF Inquiry' Workflow
INSERT INTO preset_workflows (
  title,
  one_liner,
  description,
  complexity,
  duration,
  apps,
  author,
  diagram_url,
  download_url,
  steps,
  requirements,
  credentials,
  warnings
) VALUES (
  'Telegram으로 PDF 문서와 대화하기 (시험 공부용)',
  '강의 자료(PDF)를 업로드하고 텔레그램으로 질문하면, AI가 문서 내용을 바탕으로 즉시 답변해 줍니다.',
  '시험 기간에 두꺼운 전공 서적이나 PDF 강의안을 일일이 찾아보며 공부하기 번거로움이 있습니다. 이 워크플로우를 사용하면 텔레그램 채팅방에 PDF를 던져두고, 이동 중이나 침대에서 "이 개념이 뭐였지?"라고 물어보면 AI가 즉시 답변해줍니다.',
  'Medium',
  '20분',
  '[{"name": "n8n"}, {"name": "Telegram"}, {"name": "OpenAI"}]'::jsonb,
  'enescingoz',
  'https://images.unsplash.com/photo-1517842645767-c639042777db?auto=format&fit=crop&q=80&w=1000', -- Generic study/laptop image
  'https://github.com/enescingoz/awesome-n8n-templates/blob/main/Telegram/Telegram%20chat%20with%20PDF.json',
  '[
    {"title": "Telegram Trigger", "description": "봇에게 파일이나 메시지가 오면 워크플로우를 실행합니다."},
    {"title": "PDF Loader", "description": "업로드된 PDF 파일을 텍스트로 변환합니다."},
    {"title": "Vector Store", "description": "변환된 텍스트를 임베딩하여 메모리에 저장합니다."},
    {"title": "AI Agent", "description": "질문과 관련 있는 텍스트 조각을 찾아 답변을 생성하고 전송합니다."}
  ]'::jsonb,
  ARRAY['Telegram Bot Token', 'OpenAI API Key'],
  ARRAY[]::text[], -- No special account levels mentioned, just API keys
  ARRAY['PDF 파일 크기가 크면 처리 시간이 길어질 수 있습니다.']
);
