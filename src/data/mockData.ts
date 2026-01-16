import { FileText, Sparkles, Link, LayoutGrid, Image, LucideIcon } from "lucide-react";

export type CategoryDetails = {
    id: string;
    name: string;
    subTitle: string;
    icon: LucideIcon;
};

export const CATEGORIES: CategoryDetails[] = [
    { id: "design", name: "AI 생성 디자인", subTitle: "고품질 AI 이미지 소스", icon: Image },
    { id: "prompt", name: "프롬프트 템플릿", subTitle: "다양한 작업에 최적화된 프롬프트", icon: FileText },
    { id: "agent", name: "Gem / GPT / Artifact", subTitle: "특화된 AI 에이전트", icon: Sparkles },
    { id: "workflow", name: "자동화 워크플로우", subTitle: "업무 자동화 시스템", icon: Link },
    { id: "template", name: "Notion / Sheets 템플릿", subTitle: "생산성 도구 템플릿", icon: LayoutGrid },
];

export interface BaseItem {
    id: string;
    title: string;
    author: string;
    user_id?: string;
    price?: number;
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
    description_en?: string;
    exampleQuestions: string[];
    url: string;
    // Details
    oneLiner: string;
    instructions: string[];
    instructions_en?: string[];
    requirements: string[];
    exampleConversation: { role: "user" | "assistant"; content: string }[];
    exampleConversation_en?: { role: "user" | "assistant"; content: string }[];
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
    download_url?: string;
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
    afterImage?: string; // Optional for Single Image Generation
    tags: string[];
    // Details
    oneLiner: string;
    promptText: string;
    params: { key: string; value: string }[];
    inputTips: string[];
}
