-- Update n8n features as requested
UPDATE ai_models
SET features = ARRAY[
  'PDF 편집',
  'AI 요약',
  'AI 채팅',
  '번역',
  '주석',
  '변환'
]
WHERE name = 'n8n';
