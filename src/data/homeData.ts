// Type Definitions
export interface Guidebook {
    title: string;
    desc: string;
    icon: string;
    tags: string[];
}

export interface Preset {
    title: string;
    desc: string;
    tool: string;
}

export interface Tool {
    name: string;
    desc: string;
    icon: string;
}

export interface CommunityItem {
    title: string;
    time: string;
    text: string;
    tags: string[];
    comments: number;
    icon: string;
}

// Data Arrays
export const logos: string[] = [
    "OpenAI", "Anthropic", "Hugging Face", "Stability AI", "Midjourney",
    "Google DeepMind", "Microsoft Copilot", "Runway", "Jasper", "Notion AI", "Adobe Firefly"
];

export const guidebooks: Guidebook[] = [
    { title: "n8n 워크플로우 입문", desc: "노코드로 업무 자동화 시작하기", icon: "⚡", tags: ["노코드"] },
    { title: "Claude로 리서치 효율화", desc: "대화형 AI로 정보 수집 속도 UP", icon: "🔍", tags: ["리서치"] },
    { title: "AI 기반 고객 서비스 구축", desc: "챗봇부터 FAQ 자동화까지 가이드", icon: "💬", tags: ["CS"] },
    { title: "Stable Diffusion 설치", desc: "내 컴퓨터에서 이미지 생성 무제한", icon: "🖥️", tags: ["이미지"] },
    { title: "GPT-4o 블로그 자동화", desc: "키워드 선정부터 발행까지 자동", icon: "📝", tags: ["자동화"] },
    { title: "Midjourney 마스터", desc: "프롬프트 작성법부터 스타일까지", icon: "🎨", tags: ["디자인"] }
];

export const presets: Preset[] = [
    { title: "이메일 뉴스레터 자동화", desc: "RSS 피드 기반 뉴스레터 발송", tool: "n8n" },
    { title: "제품 설명서 작성기", desc: "특징 입력 시 매력적인 설명", tool: "Claude" },
    { title: "코드 리뷰 자동화 Bot", desc: "GitHub PR에 자동 댓글 달기", tool: "GitHub" },
    { title: "소셜 미디어 캘린더", desc: "30일치 콘텐츠 아이디어 생성", tool: "ChatGPT" },
    { title: "고객 문의 자동 답변", desc: "FAQ 기반 친절한 답변 생성", tool: "CS Tool" },
    { title: "유튜브 스크립트 생성", desc: "주제만 주면 대본부터 썸네일", tool: "Jasper" }
];

export const tools: Tool[] = [
    { name: "Cursor", desc: "AI 코드 에디터", icon: "💻" },
    { name: "GitHub Copilot", desc: "AI 코딩 어시스턴트", icon: "🐙" },
    { name: "Descript", desc: "AI 영상 편집", icon: "🎥" },
    { name: "Otter.ai", desc: "AI 회의록 작성", icon: "🎙️" },
    { name: "Synthesia", desc: "AI 아바타 영상", icon: "👤" },
    { name: "Fireflies", desc: "미팅 AI 어시스턴트", icon: "🧚" },
    { name: "Luma AI", desc: "3D 캡처 & 생성", icon: "🧊" },
    { name: "Gamma", desc: "AI 프레젠테이션", icon: "📊" },
    { name: "Copy.ai", desc: "AI 카피라이팅", icon: "✍️" },
    { name: "Jasper", desc: "마케팅 AI", icon: "💎" },
    { name: "Midjourney", desc: "AI 이미지 생성", icon: "🎨" },
    { name: "Notion AI", desc: "워크스페이스 AI", icon: "📓" }
];

export const communityQuestions: CommunityItem[] = [
    { title: "프롬프트러너", time: "2시간 전", text: "Claude vs GPT-4, 긴 문서 요약에 뭐가 더 나을까요?", tags: ["비교", "요약"], comments: 12, icon: "🧑‍💻" },
    { title: "디자이너K", time: "5시간 전", text: "Midjourney에서 일관된 캐릭터 스타일 유지하는 팁", tags: ["이미지", "Midjourney"], comments: 8, icon: "🎨" },
    { title: "자동화마스터", time: "8시간 전", text: "n8n에서 OpenAI API 연동 시 토큰 한도 관리법", tags: ["n8n", "API"], comments: 5, icon: "⚡" }
];

export const solvedProblems: CommunityItem[] = [
    { title: "스타트업CEO", time: "1일 전", text: "Zapier 대신 n8n으로 비용 90% 절감한 후기", tags: ["자동화", "비용절감"], comments: 24, icon: "🚀" },
    { title: "데이터분석가", time: "2일 전", text: "GPT-4로 엑셀 데이터 정제 자동화 성공!", tags: ["데이터", "자동화"], comments: 18, icon: "📊" }
];
