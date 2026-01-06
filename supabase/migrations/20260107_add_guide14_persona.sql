-- Add persona section for Guide 14
-- This defines who the guide is recommended for

DELETE FROM guide_sections WHERE guide_id = 14 AND section_type = 'persona';

INSERT INTO guide_sections (guide_id, section_type, section_order, title, data) VALUES
(14, 'persona', 1, '이런 분께 추천', $$[
  "콘텐츠 제작에 관심 있지만 영상 편집 경험이 전혀 없는 입문자",
  "블로그/유튜브를 운영 중이며 영상 콘텐츠로 확장하고 싶은 크리에이터",
  "마케팅 영상이 필요하지만 외주 비용이 부담스러운 1인 사업자",
  "AI 도구를 배우고 싶지만 어디서부터 시작해야 할지 모르는 분",
  "프롬프트 엔지니어링 스킬을 실전 프로젝트에 적용하고 싶은 분"
]$$::jsonb);
