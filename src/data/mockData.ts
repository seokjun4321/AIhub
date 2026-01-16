import { FileText, Sparkles, Link, LayoutGrid, Image, LucideIcon } from "lucide-react";

export type CategoryDetails = {
    id: string;
    name: string;
    subTitle: string;
    icon: LucideIcon;
};

export const CATEGORIES: CategoryDetails[] = [
    { id: "prompt", name: "프롬프트 템플릿", subTitle: "다양한 작업에 최적화된 프롬프트", icon: FileText },
    { id: "agent", name: "Gem / GPT / Artifact", subTitle: "특화된 AI 에이전트", icon: Sparkles },
    { id: "workflow", name: "자동화 워크플로우", subTitle: "업무 자동화 시스템", icon: Link },
    { id: "template", name: "Notion / Sheets 템플릿", subTitle: "생산성 도구 템플릿", icon: LayoutGrid },
    { id: "design", name: "AI 생성 디자인", subTitle: "고품질 AI 이미지 소스", icon: Image },
];

export interface BaseItem {
    id: string;
    title: string;
    author: string;
    date?: string;
}

export interface PromptTemplate extends BaseItem {
    description: string;
    badges: { text: string; color: "green" | "yellow" | "red" | "blue" }[];
    tags: string[];
    // Details
    oneLiner: string;
    compatibleTools: string[];
    difficulty: "Beginner" | "Intermediate" | "Advanced";
    prompt: string;
    prompt_en?: string;
    variables: { name: string; placeholder: string; example: string }[];
    exampleIO: { input: string; output: string };
    tips: string[];
}

export interface AgentItem extends BaseItem {
    platform: "GPT" | "Claude" | "Gemini" | "Perplexity";
    description: string;
    exampleQuestions: string[];
    url: string;
    // Details
    oneLiner: string;
    instructions: string[];
    requirements: string[];
    exampleConversation: { role: "user" | "assistant"; content: string }[];
    tags: string[];
}

export interface WorkflowItem extends BaseItem {
    description: string;
    complexity: "Simple" | "Medium" | "Complex";
    duration: string;
    apps: { name: string; icon?: string }[];
    // Details
    oneLiner: string;
    diagramUrl: string;
    steps: { title: string; description: string }[];
    requirements: string[];
    credentials: string[];
    warnings?: string[];
}

export interface TemplateItem extends BaseItem {
    price: number;
    category: "Notion" | "Sheets";
    includes: string[];
    imageUrl: string;
    // Details
    oneLiner: string;
    previewImages: string[];
    previewUrl: string;
    duplicateUrl: string;
    setupSteps: string[];
    tags: string[];
}

export interface DesignItem extends BaseItem {
    beforeImage: string;
    afterImage: string;
    tags: string[];
    // Details
    oneLiner: string;
    promptText: string;
    params: { key: string; value: string }[];
    inputTips: string[];
}

// --- MOCK DATA ---

export const MOCK_PROMPTS: PromptTemplate[] = [
    {
        id: "p1",
        title: "블로그 포스트 생성기",
        oneLiner: "키워드만 넣으면 SEO 최적화된 블로그 글이 완성됩니다.",
        description: "SEO 최적화된 블로그 글을 자동으로 작성합니다. 제목, 소제목, 본문 구성을 논리적으로 구조화하여 가독성 높은 글을 만들어줍니다.",
        badges: [{ text: "초급", color: "green" }],
        difficulty: "Beginner",
        tags: ["콘텐츠", "블로그", "SEO"],
        author: "김작가",
        date: "2024.01.15",
        compatibleTools: ["ChatGPT", "Claude"],
        prompt: "당신은 전문 블로그 작가입니다. 다음 주제에 대해 SEO에 최적화된 블로그 포스트를 작성해주세요.\n\n주제: {topic}\n타겟 독자: {target_audience}\n키워드: {keywords}\n\n글의 구조:\n1. 독자의 흥미를 끄는 도입부\n2. 3~4개의 소제목을 포함한 본문\n3. 결론 및 행동 유도(CTA)\n\n톤앤매너: {tone}",
        prompt_en: "You are a professional blog writer. Please write an SEO-optimized blog post on the following topic.\n\nTopic: {topic}\nTarget Audience: {target_audience}\nKeywords: {keywords}\n\nStructure:\n1. Introduction that hooks the reader\n2. Body with 3-4 subheadings\n3. Conclusion and Call to Action (CTA)\n\nTone & Manner: {tone}",
        variables: [
            { name: "topic", placeholder: "예: 재택근무의 장단점", example: "재택근무의 효율성을 높이는 방법" },
            { name: "target_audience", placeholder: "예: 직장인", example: "30대 직장인" },
            { name: "keywords", placeholder: "예: 재택근무, 생산성", example: "재택근무, 시간관리, 생산성 도구" },
            { name: "tone", placeholder: "예: 친근한, 전문적인", example: "전문적이면서도 이해하기 쉬운" }
        ],
        exampleIO: {
            input: "주제: 재택근무\n타겟: 직장인",
            output: "# 재택근무, 더 똑똑하게 하는 법\n\n안녕하세요! 재택근무가 일상이 된 요즘..."
        },
        tips: [
            "구체적인 타겟 독자를 설정하면 더 공감 가는 글이 나옵니다.",
            "키워드는 3개 이상 입력하는 것이 좋습니다.",
            "톤앤매너를 브랜드 보이스에 맞춰 조정하세요."
        ]
    },
    {
        id: "p2",
        title: "이메일 답장 도우미",
        oneLiner: "무례하지 않으면서 단호한 거절, 비즈니스 이메일의 정석.",
        description: "상황에 맞는 프로페셔널한 이메일 답장을 생성합니다. 정중한 거절, 일정 조율, 감사 인사 등 다양한 상황에 대응할 수 있습니다.",
        badges: [{ text: "초급", color: "green" }],
        difficulty: "Beginner",
        tags: ["비즈니스", "이메일", "커뮤니케이션"],
        author: "박대리",
        date: "2024.01.14",
        compatibleTools: ["ChatGPT", "Gemini"],
        prompt: "받은 이메일 내용에 대해 {attitude} 태도로 답장을 작성해주세요.\n\n받은 이메일:\n{email_content}\n\n답장 포인트:\n{key_points}",
        prompt_en: "Please draft a reply to the received email with a {attitude} attitude.\n\nReceived Email:\n{email_content}\n\nReply Points:\n{key_points}",
        variables: [
            { name: "attitude", placeholder: "예: 정중한, 친근한", example: "정중하고 비즈니스적인" },
            { name: "email_content", placeholder: "받은 메일 붙여넣기", example: "프로젝트 마감 기한 연장 요청 메일..." },
            { name: "key_points", placeholder: "답장에 포함할 핵심 내용", example: "1일 연장 가능, 그 이상은 불가능함" }
        ],
        exampleIO: {
            input: "요청: 마감 연장\n태도: 정중함",
            output: "안녕하세요, 000님.\n\n요청주신 마감 기한 연장에 대해 내부적으로 논의해보았습니다..."
        },
        tips: [
            "받은 이메일의 전체 내용을 넣으면 문맥 파악이 더 정확해집니다.",
            "거절 메일의 경우 대안을 제시하는 포인트를 추가해보세요."
        ]
    },
    // ... Add more enriched prompts if needed ...
];

export const MOCK_AGENTS: AgentItem[] = [
    {
        id: "a1",
        title: "Excel 마스터",
        oneLiner: "복잡한 함수도 말 한마디면 뚝딱! 당신의 엑셀 비서.",
        platform: "GPT",
        description: "복잡한 엑셀 함수와 매크로를 쉽게 설명해줍니다. 데이터 분석부터 시각화까지 엑셀과 관련된 모든 궁금증을 해결해드립니다.",
        author: "SheetWizard",
        tags: ["생산성", "오피스", "데이터"],
        exampleQuestions: ["VLOOKUP과 XLOOKUP 차이가 뭐예요?", "피벗테이블 만드는 법 알려주세요", "매크로로 자동 합계 구하는 코드 짜줘"],
        url: "https://chat.openai.com",
        instructions: [
            "사용자의 엑셀 버전을 먼저 물어보세요.",
            "가능한 한 단계별로 따라할 수 있게 설명하세요.",
            "수식은 코드 블록으로 제공하세요."
        ],
        requirements: ["ChatGPT Plus 구독 필요"],
        exampleConversation: [
            { role: "user", content: "A열에 있는 날짜에서 '월'만 뽑아내고 싶어." },
            { role: "assistant", content: "`=MONTH(A1)` 함수를 사용하시면 됩니다! 만약 '1월'처럼 텍스트로 보고 싶으시다면 `=TEXT(A1, \"m월\")`을 사용해보세요." }
        ]
    },
    {
        id: "a2",
        title: "법률 상담 도우미",
        oneLiner: "일상 속 법률 고민, 쉽고 빠르게 초기 가이드를 받아보세요.",
        platform: "Claude",
        description: "일상적인 법률 질문에 대해 기초 정보를 제공합니다. 임대차 계약, 근로 계약 등 생활 밀착형 법률 정보를 알기 쉽게 풀어서 설명해줍니다.",
        author: "LawBot",
        tags: ["전문지식", "법률", "상담"],
        exampleQuestions: ["전세 계약 시 주의할 점은?", "퇴직금 계산 방법이 궁금해요", "내용증명 작성하는 법"],
        url: "https://claude.ai",
        instructions: [
            "항상 법적 책임이 없음을 고지하세요.",
            "최신 판례보다는 일반적인 법리를 설명하세요.",
            "변호사 상담을 권유하는 문구를 포함하세요."
        ],
        requirements: ["Claude Pro 권장"],
        exampleConversation: [
            { role: "user", content: "전세 보증금을 못 받고 있어요." },
            { role: "assistant", content: "매우 난처한 상황이시군요. 우선 임차권등기명령 신청을 고려해보셔야 합니다. 이는 이사를 가더라도 대항력을 유지할 수 있는 제도입니다..." }
        ]
    }
];

export const MOCK_WORKFLOWS: WorkflowItem[] = [
    {
        id: "w1",
        title: "블로그 자동 발행 시스템",
        oneLiner: "Notion에 글만 쓰세요. 발행은 자동으로 됩니다.",
        description: "Notion에서 글 작성 → 자동으로 WordPress 블로그에 포스팅됩니다. 이미지 업로드와 태그 설정까지 한 번에 처리하세요.",
        complexity: "Medium",
        duration: "약 30분",
        apps: [{ name: "Notion" }, { name: "Make" }, { name: "WordPress" }],
        author: "AutomationPro",
        diagramUrl: "https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&q=80&w=1000",
        steps: [
            { title: "Notion 데이터베이스 설정", description: "'발행 상태' 속성을 가진 데이터베이스를 준비합니다." },
            { title: "Make 시나리오 생성", description: "Notion 'Watch Database items' 모듈을 연결합니다." },
            { title: "WordPress 연결", description: "Create a Post 모듈을 연결하여 제목과 본문을 매핑합니다." },
            { title: "테스트 및 활성화", description: "글을 작성하고 'Ready' 상태로 변경하여 테스트합니다." }
        ],
        requirements: ["Notion API Key", "WordPress Admin 계정"],
        credentials: ["Make.com 계정"]
    },
    {
        id: "w2",
        title: "이메일 자동 분류 및 알림",
        oneLiner: "중요한 메일만 슬랙으로 받아보세요.",
        description: "중요 이메일을 자동으로 분류하고 슬랙으로 전송합니다. 송신자, 제목 키워드를 기반으로 필터링하여 업무 집중도를 높여줍니다.",
        complexity: "Simple",
        duration: "약 15분",
        apps: [{ name: "Gmail" }, { name: "Zapier" }, { name: "Slack" }],
        author: "ProductivityGuru",
        diagramUrl: "https://images.unsplash.com/photo-1512758017271-d7b84c2113f1?auto=format&fit=crop&q=80&w=1000",
        steps: [
            { title: "Gmail 필터 설정", description: "중요한 메일의 조건을 설정합니다." },
            { title: "Zapier 트리거", description: "New Email Matching Search 트리거를 사용합니다." },
            { title: "Slack 메시지 포맷팅", description: "보낸 사람과 제목, 요약을 슬랙 채널로 보냅니다." }
        ],
        requirements: ["Gmail 계정"],
        credentials: ["Zapier Free Plan 이상", "Slack 워크스페이스"]
    }
];

export const MOCK_TEMPLATES: TemplateItem[] = [
    {
        id: "t1",
        title: "스타트업 OKR 대시보드",
        oneLiner: "목표 달성을 위한 가장 직관적인 OKR 관리 템플릿.",
        category: "Notion",
        price: 0,
        includes: ["대시보드 페이지", "Objective DB", "Key Result DB", "미팅 노트 템플릿"],
        imageUrl: "https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&q=80&w=500",
        previewImages: [
            "https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&q=80&w=1000",
            "https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&q=80&w=1000"
        ],
        tags: ["스타트업", "목표관리", "생산성"],
        author: "NotionMaster",
        previewUrl: "https://notion.so/...",
        duplicateUrl: "https://notion.so/...",
        setupSteps: [
            "템플릿을 본인의 워크스페이스로 복제하세요.",
            "팀원들을 초대한 후 각자의 목표를 입력하게 하세요.",
            "주간 미팅 때 진행률 바를 업데이트하세요."
        ]
    },
    {
        id: "t3",
        title: "가계부 자동화 시트",
        oneLiner: "카드 내역 복붙하면 끝! 자동으로 분류되는 가계부.",
        category: "Sheets",
        price: 0,
        includes: ["수입/지출 시트", "자동 대시보드", "월별 리포트"],
        imageUrl: "https://images.unsplash.com/photo-1554224155-6726b3ff858f?auto=format&fit=crop&q=80&w=500",
        previewImages: [
            "https://images.unsplash.com/photo-1554224155-6726b3ff858f?auto=format&fit=crop&q=80&w=1000"
        ],
        tags: ["재테크", "가계부", "구글시트"],
        author: "SheetGenius",
        previewUrl: "https://docs.google.com/...",
        duplicateUrl: "https://docs.google.com/...",
        setupSteps: [
            "사본 만들기를 클릭하여 드라이브에 저장하세요.",
            "카드사에서 다운받은 엑셀 내역을 '입력' 시트에 붙여넣으세요.",
            "'대시보드' 탭에서 이번 달 소비 현황을 확인하세요."
        ]
    }
];

export const MOCK_DESIGNS: DesignItem[] = [
    {
        id: "d1",
        title: "판타지 풍경 배경",
        oneLiner: "이세계 감성의 신비로운 풍경, 클릭 한 번으로.",
        beforeImage: "https://images.unsplash.com/photo-1472214103451-9374bd1c798e?auto=format&fit=crop&q=80&w=500",
        afterImage: "https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&q=80&w=500",
        tags: ["판타지", "배경", "고화질"],
        author: "ArtAI",
        promptText: "Epic fantasy landscape, floating islands, waterfalls, ethereal glowing plants, hyperrealistic, 8k resolution, cinematic lighting --ar 16:9",
        params: [
            { key: "Model", value: "Midjourney v6" },
            { key: "Aspect Ratio", value: "16:9" },
            { key: "Stylize", value: "500" }
        ],
        inputTips: [
            "풍경 위주의 구도에서 가장 잘 작동합니다.",
            "색상 키워드(예: blue, purple)를 변경하여 분위기를 바꿀 수 있습니다."
        ]
    },
    {
        id: "d2",
        title: "미래 도시 컨셉 아트",
        oneLiner: "사이버펑크 스타일의 네온 도시 야경.",
        beforeImage: "https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?auto=format&fit=crop&q=80&w=500",
        afterImage: "https://images.unsplash.com/photo-1535868463750-c78d9543614f?auto=format&fit=crop&q=80&w=500",
        tags: ["SF", "도시", "건축"],
        author: "FutureDesign",
        promptText: "Futuristic cyberpunk city street level, neon lights, rain reflection, flying cars, towering skyscrapers, dystopian atmosphere --v 6.0",
        params: [
            { key: "Model", value: "Midjourney v6" },
            { key: "Chaos", value: "20" }
        ],
        inputTips: [
            "밤 시간대 배경에 적합합니다.",
            "건물 디자인 참조용으로 좋습니다."
        ]
    }
];
