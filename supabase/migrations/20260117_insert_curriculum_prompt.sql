-- Insert Self-Designed Degree Curriculum Prompt Template
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
  '4년제 대학 커리큘럼 마스터 코스 (Self-Designed Degree)',
  'Advanced',
  '특정 스킬/지식 영역을 4년제 대학 수준으로 마스터하는 전체 커리큘럼+프로젝트+리소스 생성',
  '수십 년 경력 대학 교수처럼 행동하며, 초급→중급→고급 단계를 학기별(8학기)로 나누고, 각 학기마다 이론 강의+실습 프로젝트+평가 기준+추천 교재·논문을 포함한 완전한 학위 과정을 설계합니다. 최종 Capstone 프로젝트 포함.',
  ARRAY['자기주도학습', '커리큘럼설계', '4년계획', '프로젝트학습', '마스터플랜'],
  '[{"text": "고급", "color": "red"}]'::jsonb,
  'AIHub',
  ARRAY['ChatGPT', 'Claude'],
  E'당신은 {스킬/지식영역} 분야에서 수십 년의 경력과 관련 학문적 업적을 보유한, 명문 대학의 교수 역할을 맡습니다. {스킬/지식영역}을(를) 마스터하기 위한 종합 커리큘럼을 설계하세요.\n\n이 과정은 다음 요소들을 포함해야 합니다:\n\n## 과정 기간\n- {학습기간}에 걸친 전일제 프로그램으로 구성 (기본값: 4년 / 8학기)\n- 각 학기: 15주\n- 주당 학습 시간: 15-20시간 (전일제 학생 수준)\n\n## 커리큘럼 구조\n**1학년 (기초):**\n- 1학기: [Beginner topics 1-3]\n- 2학기: [Beginner topics 4-6]\n\n**2학년 (중급):**\n- 3학기: [Intermediate topics 1-3]\n- 4학기: [Intermediate topics 4-6]\n\n**3학년 (고급):**\n- 5학기: [Advanced topics 1-3]\n- 6학기: [Advanced topics 4-6]\n\n**4학년 (전문화):**\n- 7학기: [Elective specializations]\n- 8학기: [Capstone project]\n\n각 학기는 다음을 충족해야 합니다:\n- 논리적인 흐름을 가지며 이전 지식을 기반으로 확장될 것\n- 주차별 학습 목표 포함 (학기당 15개 목표)\n\n## 관련성 있고 정확한 정보\n- 최신의 기초 원리와 모범 사례를 모두 제공\n- 이론 개념과 실무 적용을 모두 다룰 것\n- 업계 리더들의 실제 사례 연구 포함\n- 최신 연구 논문(2020-2025) 참조\n\n## 프로젝트 및 과제\n실습 중심 프로젝트 시리즈를 포함하세요:\n- **초급**: 안내형 프로젝트 3개 (단계별 지침)\n- **중급**: 반(半)안내형 프로젝트 5개 (프레임워크 제공)\n- **고급**: 개방형 프로젝트 7개 (문제 정의만 제공)\n- **캡스톤**: 대형 프로젝트 1개 (논문/포트폴리오 수준)\n\n각 프로젝트마다 다음을 제공하세요:\n- 목표 & 산출물\n- 평가 루브릭 (창의성 30%, 효과성 40%, 문서화 30%)\n- 예시 해답 (초급 프로젝트에만)\n\n## 학습 자료\n공개적으로 이용 가능한 자료를 추천하세요:\n- 핵심 도서: 교과서 5권 (특정 챕터 포함)\n- 연구 논문: 핵심 논문 20편 (학기별로 정리)\n- 온라인 튜토리얼: 영상 강의 10개 (YouTube, Coursera 등)\n- 실습 플랫폼: 3-5개 도구/웹사이트\n- 커뮤니티 포럼: Reddit, Discord, Stack Exchange\n\n## 평가 및 마일스톤\n- 매주 퀴즈 (10문항, 자동 채점)\n- 학기 중간고사 (에세이 + 실기)\n- 학기말 프로젝트 (포트폴리오 작품)\n- 동료 평가 시스템 (동료 3명의 작업을 리뷰)\n\n## 선수 지식\n- 내 현재 수준: {현재수준}\n- 목표 성과: {목표수준}\n- 선호 학습 스타일: {선호학습스타일}\n\n전체 커리큘럼을 아래 마크다운 표 형식으로 출력하세요:\n| Semester | Week | Topic | Theory Hours | Practice Hours | Project | Resources |\n\n커리큘럼 이후, 다음을 추가하세요:\n- **커리어 경로**: 이 커리큘럼이 준비시키는 직무 3개\n- **자격증 추천**: 취득을 권장하는 업계 자격증\n- **멘토링 전략**: 이 분야에서 멘토를 찾을 수 있는 곳',
  E'You will assume the role of a professor at a prestigious university, with decades of experience in {스킬/지식영역} as well as relevant academic achievements. Design a comprehensive course to master {스킬/지식영역}.\n\nThe course should cover the following aspects:\n\n## Course Duration\n- Structured as a full-time program, spanning {학습기간} (default: 4 years / 8 semesters)\n- Each semester: 15 weeks\n- Weekly commitment: 15-20 hours (equivalent to full-time student)\n\n## Curriculum Structure\n**Year 1 (Foundation):**\n- Semester 1: [Beginner topics 1-3]\n- Semester 2: [Beginner topics 4-6]\n\n**Year 2 (Intermediate):**\n- Semester 3: [Intermediate topics 1-3]\n- Semester 4: [Intermediate topics 4-6]\n\n**Year 3 (Advanced):**\n- Semester 5: [Advanced topics 1-3]\n- Semester 6: [Advanced topics 4-6]\n\n**Year 4 (Specialization):**\n- Semester 7: [Elective specializations]\n- Semester 8: [Capstone project]\n\nEach semester should:\n- Have a logical flow and build upon previous knowledge\n- Include weekly learning objectives (15 objectives per semester)\n\n## Relevant and Accurate Information\n- Provide all necessary up-to-date foundational principles and best practices\n- Cover both theoretical concepts and practical applications\n- Include real-world case studies from industry leaders\n- Reference latest research papers (2020-2025)\n\n## Projects and Assignments\nInclude a series of hands-on projects:\n- **Beginner**: 3 guided projects (step-by-step instructions)\n- **Intermediate**: 5 semi-guided projects (framework provided)\n- **Advanced**: 7 open-ended projects (problem statement only)\n- **Capstone**: 1 major project (publication/portfolio quality)\n\nFor each project, provide:\n- Objective & deliverables\n- Evaluation rubric (creativity 30%, effectiveness 40%, documentation 30%)\n- Sample solutions (for beginner projects only)\n\n## Learning Resources\nRecommend publicly available resources:\n- Key books: 5 textbooks (with specific chapters)\n- Research papers: 20 seminal papers (organized by semester)\n- Online tutorials: 10 video courses (YouTube, Coursera, etc.)\n- Practice platforms: 3-5 tools/websites\n- Community forums: Reddit, Discord, Stack Exchange\n\n## Assessment & Milestones\n- Weekly quizzes (10 questions, auto-graded)\n- Mid-semester exams (essay + practical)\n- End-of-semester projects (portfolio piece)\n- Peer review system (review 3 classmates'' work)\n\n## Prerequisites\n- My current level: {현재수준}\n- Target outcome: {목표수준}\n- Preferred learning style: {선호학습스타일}\n\nOutput the full curriculum in markdown table format:\n| Semester | Week | Topic | Theory Hours | Practice Hours | Project | Resources |\n\nAfter the curriculum, add:\n- **Career Pathways**: 3 job roles this curriculum prepares for\n- **Certification Recommendations**: Industry certifications to pursue\n- **Mentorship Strategy**: Where to find mentors in this field',
  '[
    {"name": "스킬/지식영역", "placeholder": "예: Prompt Engineering", "example": "Prompt Engineering"},
    {"name": "현재수준", "placeholder": "예: ChatGPT 기본 사용 가능", "example": "ChatGPT 기본 사용 가능"},
    {"name": "목표수준", "placeholder": "예: 프롬프트 컨설턴트 수준", "example": "프롬프트 컨설턴트 수준"},
    {"name": "학습기간", "placeholder": "예: 2년 (선택)", "example": "2년"},
    {"name": "선호학습스타일", "placeholder": "예: Visual/Reading (선택)", "example": "Visual"}
  ]'::jsonb,
  '{"input": "영역: 프롬프트 엔지니어링, 기간: 1년", "output": "Year 1 Semester 1: 프롬프트 엔지니어링 기초 → 주차별 학습목표 15개 → 프로젝트 1: 챗봇 프롬프트 10개 작성..."}'::jsonb,
  ARRAY[
    '장기 목표(6개월~4년) 학습 계획 시 활용',
    '각 학기 종료 시 "진도 평가 + 다음 학기 조정" 요청',
    '프로젝트는 포트폴리오로 누적 가능',
    '멘토 찾기·스터디 그룹 추천 요청 가능',
    '취업 연계 시 "이 커리큘럼 기반 이력서 작성" 요청'
  ]
);
