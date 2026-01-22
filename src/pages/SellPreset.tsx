import { useState, useRef } from "react";
import { useQuery } from "@tanstack/react-query";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Card } from "@/components/ui/card";
import { FileText, Sparkles, Link as LinkIcon, LayoutGrid, Image as ImageIcon, Upload, CheckCircle2, X } from "lucide-react";
import { cn } from "@/lib/utils";
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from "@/components/ui/select";
import { useNavigate } from "react-router-dom";
import { supabase } from "@/integrations/supabase/client";
import { useToast } from "@/components/ui/use-toast";

const CATEGORIES = [
    { id: "prompt", name: "프롬프트", icon: FileText, desc: "GPT, Claude 등 프롬프트 템플릿" },
    { id: "agent", name: "Gem / GPT / Artifact", icon: Sparkles, desc: "특화된 커스텀 GPT/챗봇" },
    { id: "workflow", name: "워크플로우", icon: LinkIcon, desc: "n8n, Make 자동화 시나리오" },
    { id: "template", name: "템플릿", icon: LayoutGrid, desc: "Notion, Sheets 생산성 도구" },
    { id: "design", name: "디자인", icon: ImageIcon, desc: "AI 생성 이미지 및 소스" },
];

const SellPreset = () => {
    const navigate = useNavigate();
    const { toast } = useToast();
    const [selectedCategory, setSelectedCategory] = useState<string>("prompt");
    const [isSubmitting, setIsSubmitting] = useState(false);

    // Form States
    const [title, setTitle] = useState("");
    const [oneLiner, setOneLiner] = useState("");
    const [price, setPrice] = useState("");

    // Dynamic Fields
    const [promptContent, setPromptContent] = useState("");
    const [inputExample, setInputExample] = useState("");
    const [outputExample, setOutputExample] = useState("");
    const [agentUrl, setAgentUrl] = useState("");
    const [agentGuide, setAgentGuide] = useState("");
    const [linkUrl, setLinkUrl] = useState("");
    const [installGuide, setInstallGuide] = useState("");
    const [designPrompt, setDesignPrompt] = useState("");

    const { data: userProfile } = useQuery({
        queryKey: ['userProfile'],
        queryFn: async () => {
            const { data: { user } } = await supabase.auth.getUser();
            if (!user) return null;
            return user;
        }
    });

    // Fetch AI Models for Design dropdown
    useQuery({
        queryKey: ['aiModels'],
        queryFn: async () => {
            const { data, error } = await supabase
                .from('ai_models')
                .select('id, name')
                .order('name');
            if (error) throw error;
            if (data) setAiModels(data);
            return data;
        },
        enabled: selectedCategory === 'design' || selectedCategory === 'template'
    });

    // New fields for Prompt type
    const [difficulty, setDifficulty] = useState("Beginner");
    const [compatibleTools, setCompatibleTools] = useState("");
    const [tips, setTips] = useState("");
    const [promptEn, setPromptEn] = useState("");

    // Replaced single string state with array of objects for variables
    const [promptVariables, setPromptVariables] = useState<{ name: string; label: string; example: string }[]>([]);
    const [tags, setTags] = useState("");

    // New fields for Agent type
    const [agentPlatform, setAgentPlatform] = useState("ChatGPT");
    const [agentCapabilities, setAgentCapabilities] = useState<string[]>([]);
    const [agentSystemPrompt, setAgentSystemPrompt] = useState("");
    const [agentRequirements, setAgentRequirements] = useState("");
    const [agentExampleInput, setAgentExampleInput] = useState("");
    const [agentExampleOutput, setAgentExampleOutput] = useState("");
    const [agentExampleQuestions, setAgentExampleQuestions] = useState(""); // Add example questions state

    // New fields for Workflow type
    const [workflowTools, setWorkflowTools] = useState("");
    const [workflowComplexity, setWorkflowComplexity] = useState("Medium");
    const [workflowDuration, setWorkflowDuration] = useState("");
    const [workflowDiagramUrl, setWorkflowDiagramUrl] = useState("");
    const [workflowDownloadUrl, setWorkflowDownloadUrl] = useState("");
    const [workflowRequirements, setWorkflowRequirements] = useState("");
    // const [workflowCredentials, setWorkflowCredentials] = useState(""); // Removed as per schema
    const [workflowWarnings, setWorkflowWarnings] = useState("");
    const [workflowDescription, setWorkflowDescription] = useState("");
    const [workflowPlatform, setWorkflowPlatform] = useState("n8n"); // Added platform
    const [workflowImportInfo, setWorkflowImportInfo] = useState(""); // Added import info
    const [workflowSteps, setWorkflowSteps] = useState<{ title: string; description: string }[]>([{ title: "", description: "" }]);

    const addWorkflowStep = () => {
        setWorkflowSteps([...workflowSteps, { title: "", description: "" }]);
    };

    const updateWorkflowStep = (index: number, field: 'title' | 'description', value: string) => {
        const newSteps = [...workflowSteps];
        newSteps[index][field] = value;
        setWorkflowSteps(newSteps);
    };

    const removeWorkflowStep = (index: number) => {
        if (workflowSteps.length > 1) {
            setWorkflowSteps(workflowSteps.filter((_, i) => i !== index));
        }
    };

    // New fields for Template type
    const [templateFormat, setTemplateFormat] = useState("Notion");
    const [templatePreviewUrl, setTemplatePreviewUrl] = useState("");
    const [templateDescription, setTemplateDescription] = useState(""); // Detailed description
    const [templateIncludes, setTemplateIncludes] = useState(""); // Components included
    const [templateImages, setTemplateImages] = useState<File[]>([]); // Multiple files

    const templateImageRef = useRef<HTMLInputElement>(null);

    const handleTemplateImageChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        if (e.target.files) {
            const newFiles = Array.from(e.target.files);
            setTemplateImages(prev => [...prev, ...newFiles].slice(0, 3)); // Max 3 images
        }
    };

    const removeTemplateImage = (index: number) => {
        setTemplateImages(prev => prev.filter((_, i) => i !== index));
    };

    // New fields for Design type
    const [designModel, setDesignModel] = useState("");
    const [designAspectRatio, setDesignAspectRatio] = useState("");
    const [designType, setDesignType] = useState<"text-to-image" | "image-to-image">("text-to-image");
    const [designDescription, setDesignDescription] = useState(""); // Detailed description
    const [designTips, setDesignTips] = useState(""); // Input tips
    const [selectedAiModelId, setSelectedAiModelId] = useState<string>(""); // Selected AI Model ID
    const [aiModels, setAiModels] = useState<{ id: number, name: string }[]>([]);

    // Files
    const [mainImage, setMainImage] = useState<File | null>(null);
    const [beforeImage, setBeforeImage] = useState<File | null>(null);
    const [afterImage, setAfterImage] = useState<File | null>(null);

    const mainImageRef = useRef<HTMLInputElement>(null);
    const beforeImageRef = useRef<HTMLInputElement>(null);
    const afterImageRef = useRef<HTMLInputElement>(null);

    const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>, setFile: (f: File | null) => void) => {
        if (e.target.files && e.target.files[0]) {
            setFile(e.target.files[0]);
        }
    };

    const uploadFile = async (file: File, path: string) => {
        const fileExt = file.name.split('.').pop();
        const fileName = `${Math.random().toString(36).substring(2)}.${fileExt}`;
        const filePath = `${path}/${fileName}`;

        const { error: uploadError } = await supabase.storage
            .from('submission-assets')
            .upload(filePath, file);

        if (uploadError) throw uploadError;

        const { data } = supabase.storage
            .from('submission-assets')
            .getPublicUrl(filePath);

        return data.publicUrl;
    };

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();

        const { data: { user } } = await supabase.auth.getUser();
        if (!user) {
            toast({ title: "로그인이 필요합니다", variant: "destructive" });
            navigate("/auth");
            return;
        }

        setIsSubmitting(true);

        try {
            // Validation for Tags (Prompt)
            if (selectedCategory === 'prompt' && !tags.trim()) {
                toast({
                    title: "태그 입력 필수",
                    description: "최소 1개 이상의 태그를 입력해주세요.",
                    variant: "destructive"
                });
                setIsSubmitting(false);
                return;
            }

            // Validation for Template Images
            if (selectedCategory === 'template' && templateImages.length === 0) {
                toast({
                    title: "이미지 필수",
                    description: "최소 1장 이상의 미리보기 이미지를 업로드해주세요.",
                    variant: "destructive"
                });
                setIsSubmitting(false);
                return;
            }

            // 1. Upload Images
            let mainImageUrl = null;
            if (mainImage) {
                mainImageUrl = await uploadFile(mainImage, `${user.id}/main`);
            }

            let beforeImageUrl = null;
            let afterImageUrl = null;

            if (selectedCategory === 'design') {
                if (beforeImage) beforeImageUrl = await uploadFile(beforeImage, `${user.id}/design_before`);
                if (afterImage) afterImageUrl = await uploadFile(afterImage, `${user.id}/design_after`);
            }

            const templateImageUrls: string[] = [];
            if (selectedCategory === 'template') {
                for (let i = 0; i < templateImages.length; i++) {
                    const url = await uploadFile(templateImages[i], `${user.id}/template_${i}`);
                    if (url) templateImageUrls.push(url);
                }
            }

            // 2. Prepare Content JSON based on category
            let contentData: any = {
                price: Number(price) || 0,
                one_liner: oneLiner,
            };

            const imagesArray = [mainImageUrl].filter(Boolean) as string[];

            if (selectedCategory === 'prompt') {
                contentData = {
                    ...contentData,
                    prompt: promptContent,
                    example_io: { input: inputExample, output: outputExample },
                    difficulty,
                    compatible_tools: compatibleTools.split(',').map(t => t.trim()).filter(Boolean),
                    tips: tips.split(',').map(t => t.trim()).filter(Boolean),
                    prompt_en: promptEn,
                    prompt_en: promptEn,
                    // Map local state to schema format: {name, placeholder, example}
                    variables: promptVariables.map(v => ({
                        name: v.name,
                        placeholder: v.label,
                        example: v.example
                    })),
                    tags: tags.split(',').map(t => t.trim()).filter(Boolean)
                };
            } else if (selectedCategory === 'agent') {
                contentData = {
                    ...contentData,
                    url: agentUrl,
                    // instructions: agentGuide is for 'Usage Guide', system_prompt is for 'System Instructions'
                    // We map agentGuide to 'description' or keep as separate 'guide'?
                    // AgentModal uses 'instructions' for the prompt preview and list.
                    // Let's map system_prompt to instructions (split by newline for list)
                    instructions: agentSystemPrompt.split('\n').filter(Boolean),

                    // Map agentGuide to description if needed, or keep separate. 
                    // AgentModal uses 'description' from DB. 
                    // Let's store agentGuide as 'description' in the content JSON for now, or 'usage_guide'.
                    description: agentGuide,

                    platform: agentPlatform,
                    capabilities: agentCapabilities,

                    // Format requirements as array (assuming comma separated)
                    requirements: agentRequirements.split(',').map(r => r.trim()).filter(Boolean),

                    // Format example questions as array
                    example_questions: agentExampleQuestions.split(',').map(q => q.trim()).filter(Boolean),

                    // Format as conversation array
                    example_conversation: [
                        { role: 'user', content: agentExampleInput },
                        { role: 'assistant', content: agentExampleOutput }
                    ].filter(msg => msg.content) // Only include if content exists
                };
            } else if (selectedCategory === 'workflow') {
                contentData = {
                    ...contentData,
                    url: workflowDownloadUrl || linkUrl, // Use download URL as main URL
                    download_url: workflowDownloadUrl,
                    diagram_url: workflowDiagramUrl,
                    duration: workflowDuration,
                    steps: workflowSteps.filter(s => s.title), // Filter empty steps
                    requirements: workflowRequirements.split(',').map(t => t.trim()).filter(Boolean),
                    warnings: workflowWarnings.split(',').map(t => t.trim()).filter(Boolean),
                    apps: workflowTools.split(',').map(t => t.trim()).filter(Boolean).map(t => ({ name: t })), // Map to object array
                    tools_used: workflowTools.split(',').map(t => t.trim()).filter(Boolean), // Keep for backward compatibility if needed
                    complexity: workflowComplexity,
                    description: workflowDescription, // Detailed description
                    platform: workflowPlatform, // Added platform
                    import_info: workflowImportInfo, // Added import info
                    related_ai_model_id: selectedAiModelId ? Number(selectedAiModelId) : null
                };
            } else if (selectedCategory === 'template') {
                contentData = {
                    ...contentData,
                    url: linkUrl,
                    setup_steps: [installGuide],
                    format: templateFormat,
                    preview_url: templatePreviewUrl,
                    description: templateDescription, // Detailed description
                    includes: templateIncludes.split(',').map(t => t.trim()).filter(Boolean), // Array of included items
                    related_ai_model_id: selectedAiModelId ? Number(selectedAiModelId) : null
                };
                // Add all template images to images array
                // The first one will be treated as main image if it exists
                if (templateImageUrls.length > 0) {
                    imagesArray.push(...templateImageUrls);
                }
            } else if (selectedCategory === 'design') {
                contentData = {
                    ...contentData,
                    prompt_text: designPrompt,
                    before_image: beforeImageUrl,
                    after_image: afterImageUrl,
                    model_info: designModel,
                    aspect_ratio: designAspectRatio,
                    generation_type: designType,
                    description: designDescription || oneLiner, // Use detailed description or fallback
                    input_tips: designTips.split(',').map(t => t.trim()).filter(Boolean),
                    related_ai_model_id: selectedAiModelId ? Number(selectedAiModelId) : null
                };
                if (beforeImageUrl) imagesArray.push(beforeImageUrl);
                if (afterImageUrl) imagesArray.push(afterImageUrl);
            }

            // 3. Insert into content_submissions
            const { error } = await supabase
                .from('content_submissions' as any)
                .insert({
                    user_id: user.id,
                    type: selectedCategory,
                    title: title,
                    status: 'pending',
                    content: contentData,
                    images: imagesArray,
                });

            if (error) throw error;

            toast({
                title: "제출 성공!",
                description: "관리자 검토 후 스토어에 등록됩니다.",
            });
            navigate("/presets");

        } catch (error: any) {
            console.error(error);
            toast({
                title: "제출 실패",
                description: error.message,
                variant: "destructive"
            });
        } finally {
            setIsSubmitting(false);
        }
    };

    return (
        <div className="min-h-screen bg-slate-50 font-sans">
            <Navbar />

            <main className="pt-24 pb-24 px-4 max-w-3xl mx-auto">
                <div className="mb-8 text-center">
                    <h1 className="text-3xl font-bold text-slate-900 mb-2">나만의 프롬프트/템플릿 판매하기</h1>
                    <p className="text-slate-500">당신의 노하우를 수익으로 만들어보세요.</p>
                </div>

                <form onSubmit={handleSubmit} className="space-y-8">
                    {/* 1. Category Selection */}
                    <section className="space-y-4">
                        <Label className="text-lg font-semibold text-slate-800">어떤 종류의 상품인가요?</Label>
                        <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
                            {CATEGORIES.map((cat) => {
                                const Icon = cat.icon;
                                const isSelected = selectedCategory === cat.id;
                                return (
                                    <div
                                        key={cat.id}
                                        onClick={() => setSelectedCategory(cat.id)}
                                        className={cn(
                                            "cursor-pointer p-4 rounded-xl border-2 transition-all duration-200 flex flex-col items-center justify-center gap-2 text-center h-32",
                                            isSelected
                                                ? "border-blue-600 bg-blue-50/50"
                                                : "border-slate-200 bg-white hover:border-slate-300 hover:bg-slate-50"
                                        )}
                                    >
                                        <div className={cn("p-2 rounded-full", isSelected ? "bg-blue-100 text-blue-600" : "bg-slate-100 text-slate-500")}>
                                            <Icon className="w-6 h-6" />
                                        </div>
                                        <div className="space-y-0.5">
                                            <div className={cn("font-bold text-sm", isSelected ? "text-blue-700" : "text-slate-700")}>{cat.name}</div>
                                            <div className="text-[10px] text-slate-400 leading-tight">{cat.desc}</div>
                                        </div>
                                    </div>
                                );
                            })}
                        </div>
                    </section>

                    {/* 2. Basic Info */}
                    <Card className="p-6 space-y-6 bg-white border-slate-200 shadow-sm rounded-xl">
                        <div className="space-y-4">
                            <h2 className="text-lg font-semibold text-slate-800 border-b border-slate-100 pb-2">기본 정보</h2>

                            <div className="space-y-2">
                                <Label htmlFor="title">상품명 <span className="text-red-500">*</span></Label>
                                <Input id="title" value={title} onChange={e => setTitle(e.target.value)} placeholder="예: 스타트업을 위한 사업계획서 생성 프롬프트" required className="h-11" />
                            </div>

                            <div className="space-y-2">
                                <Label htmlFor="oneLiner">한 줄 소개 <span className="text-red-500">*</span></Label>
                                <Input id="oneLiner" value={oneLiner} onChange={e => setOneLiner(e.target.value)} placeholder="예: 키워드 3개만 넣으면 1분 만에 초안 완성!" required className="h-11" />
                                <p className="text-xs text-slate-400">검색 결과와 목록에 노출되는 중요한 문구입니다.</p>
                            </div>

                            <div className="space-y-2">
                                <Label htmlFor="price">판매 가격 (원) <span className="text-red-500">*</span></Label>
                                <div className="relative">
                                    <Input id="price" type="number" value={price} onChange={e => setPrice(e.target.value)} placeholder="0" min="0" required className="h-11 pr-8" />
                                    <span className="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 text-sm">원</span>
                                </div>
                                <p className="text-xs text-slate-400">0원 입력 시 무료로 배포됩니다.</p>
                            </div>
                        </div>
                    </Card>

                    {/* 3. Detailed Content (Conditional) */}
                    <Card className="p-6 space-y-6 bg-white border-slate-200 shadow-sm rounded-xl">
                        <div className="space-y-4">
                            <h2 className="text-lg font-semibold text-slate-800 border-b border-slate-100 pb-2">상세 정보</h2>

                            {selectedCategory === 'prompt' && (
                                <div className="space-y-4">
                                    <div className="grid grid-cols-2 gap-4">
                                        <div className="space-y-2">
                                            <Label>난이도</Label>
                                            <Select value={difficulty} onValueChange={setDifficulty}>
                                                <SelectTrigger className="h-11 rounded-xl bg-background">
                                                    <SelectValue placeholder="난이도 선택" />
                                                </SelectTrigger>
                                                <SelectContent>
                                                    <SelectItem value="Beginner">초급 (Beginner)</SelectItem>
                                                    <SelectItem value="Intermediate">중급 (Intermediate)</SelectItem>
                                                    <SelectItem value="Advanced">고급 (Advanced)</SelectItem>
                                                </SelectContent>
                                            </Select>
                                        </div>
                                        <div className="space-y-2">
                                            <Label>호환되는 도구 (쉼표로 구분)</Label>
                                            <Input value={compatibleTools} onChange={e => setCompatibleTools(e.target.value)} placeholder="예: ChatGPT, Claude, Gemini" />
                                        </div>
                                    </div>

                                    <div className="space-y-2">
                                        <Label>프롬프트 내용 (한글) <span className="text-red-500">*</span></Label>
                                        <Textarea value={promptContent} onChange={e => setPromptContent(e.target.value)} placeholder="여기에 프롬프트 전체 내용을 입력해주세요." className="min-h-[200px] font-mono text-sm leading-relaxed" required />
                                    </div>

                                    <div className="space-y-2">
                                        <Label>프롬프트 내용 (English) - 선택사항</Label>
                                        <Textarea value={promptEn} onChange={e => setPromptEn(e.target.value)} placeholder="영문 버전이 있다면 입력해주세요." className="min-h-[150px] font-mono text-sm leading-relaxed" />
                                    </div>

                                    <div className="space-y-4">
                                        <div className="flex items-center justify-between">
                                            <Label>변수 설정 (선택사항)</Label>
                                            <Button
                                                type="button"
                                                variant="outline"
                                                size="sm"
                                                onClick={() => setPromptVariables([...promptVariables, { name: "", label: "", example: "" }])}
                                            >
                                                + 변수 추가
                                            </Button>
                                        </div>
                                        {promptVariables.length === 0 && (
                                            <p className="text-sm text-slate-500 bg-slate-50 p-4 rounded-lg text-center border border-dashed border-slate-200">
                                                설정된 변수가 없습니다. 프롬프트에 사용된 변수가 있다면 추가해주세요.
                                            </p>
                                        )}
                                        {promptVariables.map((variable, index) => (
                                            <div key={index} className="grid grid-cols-[1fr_1fr_1fr_auto] gap-2 items-start p-3 bg-slate-50 rounded-lg border border-slate-200">
                                                <div className="space-y-1">
                                                    <Label className="text-xs text-slate-500">변수명 (영어)</Label>
                                                    <Input
                                                        value={variable.name}
                                                        onChange={e => {
                                                            const newVars = [...promptVariables];
                                                            newVars[index].name = e.target.value;
                                                            setPromptVariables(newVars);
                                                        }}
                                                        placeholder="topic"
                                                        className="h-8 text-sm"
                                                    />
                                                </div>
                                                <div className="space-y-1">
                                                    <Label className="text-xs text-slate-500">표시 이름 (한글)</Label>
                                                    <Input
                                                        value={variable.label}
                                                        onChange={e => {
                                                            const newVars = [...promptVariables];
                                                            newVars[index].label = e.target.value;
                                                            setPromptVariables(newVars);
                                                        }}
                                                        placeholder="주제"
                                                        className="h-8 text-sm"
                                                    />
                                                </div>
                                                <div className="space-y-1">
                                                    <Label className="text-xs text-slate-500">예시 값</Label>
                                                    <Input
                                                        value={variable.example}
                                                        onChange={e => {
                                                            const newVars = [...promptVariables];
                                                            newVars[index].example = e.target.value;
                                                            setPromptVariables(newVars);
                                                        }}
                                                        placeholder="마케팅"
                                                        className="h-8 text-sm"
                                                    />
                                                </div>
                                                <Button
                                                    type="button"
                                                    variant="ghost"
                                                    size="icon"
                                                    className="mt-6 h-8 w-8 text-red-500 hover:text-red-600 hover:bg-red-50"
                                                    onClick={() => {
                                                        const newVars = promptVariables.filter((_, i) => i !== index);
                                                        setPromptVariables(newVars);
                                                    }}
                                                >
                                                    <X className="w-4 h-4" />
                                                </Button>
                                            </div>
                                        ))}
                                    </div>

                                    <div className="space-y-2">
                                        <Label>사용 팁 (쉼표로 구분)</Label>
                                        <Textarea value={tips} onChange={e => setTips(e.target.value)} placeholder="예: 구체적인 상황을 입력하면 더 좋습니다, 영어로 입력하면 정확도가 올라갑니다" className="h-20" />
                                    </div>

                                    <div className="space-y-2">
                                        <Label>태그 (쉼표로 구분) <span className="text-red-500">*</span></Label>
                                        <Input value={tags} onChange={e => setTags(e.target.value)} placeholder="예: 마케팅, 비즈니스, 스타트업" required />
                                    </div>

                                    <div className="space-y-2">
                                        <Label>사용 예시 (Input / Output)</Label>
                                        <div className="grid grid-cols-1 gap-4">
                                            <Textarea value={inputExample} onChange={e => setInputExample(e.target.value)} placeholder="Input 예시" className="h-24" />
                                            <Textarea value={outputExample} onChange={e => setOutputExample(e.target.value)} placeholder="Output 예시" className="h-32" />
                                        </div>
                                    </div>
                                </div>
                            )}

                            {selectedCategory === 'agent' && (
                                <div className="space-y-4">
                                    <div className="grid grid-cols-2 gap-4">
                                        <div className="space-y-2">
                                            <Label>플랫폼</Label>
                                            <Select value={agentPlatform} onValueChange={setAgentPlatform}>
                                                <SelectTrigger className="h-11 rounded-xl bg-background">
                                                    <SelectValue placeholder="플랫폼 선택" />
                                                </SelectTrigger>
                                                <SelectContent>
                                                    <SelectItem value="ChatGPT">ChatGPT (GPTs)</SelectItem>
                                                    <SelectItem value="Gemini">Gemini (Gems)</SelectItem>
                                                </SelectContent>
                                            </Select>
                                        </div>
                                        <div className="space-y-2">
                                            <Label>기능 (쉼표로 구분)</Label>
                                            <Input
                                                value={agentCapabilities.join(', ')}
                                                onChange={e => setAgentCapabilities(e.target.value.split(',').map(t => t.trim()))}
                                                placeholder="예: Web Browsing, DALL-E, Code Interpreter"
                                            />
                                        </div>
                                    </div>
                                    <div className="space-y-2">
                                        <Label>에이전트 URL <span className="text-red-500">*</span></Label>
                                        <Input value={agentUrl} onChange={e => setAgentUrl(e.target.value)} placeholder="https://chat.openai.com/g/..." required />
                                    </div>
                                    <div className="space-y-2">
                                        <Label>사용 가이드 / 설명</Label>
                                        <Textarea value={agentGuide} onChange={e => setAgentGuide(e.target.value)} placeholder="이 에이전트의 활용법을 적어주세요." className="h-32" />
                                    </div>
                                    <div className="space-y-2">
                                        <Label>시스템 지침 / 프롬프트 미리보기</Label>
                                        <Textarea
                                            value={agentSystemPrompt}
                                            onChange={e => setAgentSystemPrompt(e.target.value)}
                                            placeholder="공개해도 되는 범위 내에서 프롬프트나 지침을 입력해주세요."
                                            className="h-32 font-mono text-sm"
                                        />
                                    </div>
                                    <div className="space-y-2">
                                        <Label>추천 질문 예시 (쉼표로 구분)</Label>
                                        <Input
                                            value={agentExampleQuestions}
                                            onChange={e => setAgentExampleQuestions(e.target.value)}
                                            placeholder="예: 이 엑셀 함수 어떻게 써?, 피벗 테이블 만드는 법 알려줘"
                                        />
                                    </div>
                                    <div className="space-y-2">
                                        <Label>사용 전 필수 조건 (선택)</Label>
                                        <Input
                                            value={agentRequirements}
                                            onChange={e => setAgentRequirements(e.target.value)}
                                            placeholder="예: URL 또는 서지 정보 입력 필요"
                                        />
                                    </div>
                                    <div className="space-y-2">
                                        <Label>예시 대화 (Input / Output)</Label>
                                        <div className="grid grid-cols-1 gap-4">
                                            <Textarea
                                                value={agentExampleInput}
                                                onChange={e => setAgentExampleInput(e.target.value)}
                                                placeholder="User: 예시 질문 입력"
                                                className="h-20"
                                            />
                                            <Textarea
                                                value={agentExampleOutput}
                                                onChange={e => setAgentExampleOutput(e.target.value)}
                                                placeholder="Agent: 예시 답변 입력"
                                                className="h-24"
                                            />
                                        </div>
                                    </div>
                                </div>
                            )}

                            {selectedCategory === 'workflow' && (
                                <div className="space-y-4">
                                    <div className="space-y-2">
                                        <Label>상세 설명 (Description)</Label>
                                        <Textarea value={workflowDescription} onChange={e => setWorkflowDescription(e.target.value)} placeholder="워크플로우에 대한 상세한 설명을 적어주세요." className="h-32" />
                                    </div>

                                    <div className="grid grid-cols-2 gap-4">
                                        <div className="space-y-2">
                                            <Label>플랫폼</Label>
                                            <Select value={workflowPlatform} onValueChange={setWorkflowPlatform}>
                                                <SelectTrigger className="h-11 rounded-xl bg-background">
                                                    <SelectValue placeholder="플랫폼 선택" />
                                                </SelectTrigger>
                                                <SelectContent>
                                                    <SelectItem value="n8n">n8n</SelectItem>
                                                    <SelectItem value="Make">Make</SelectItem>
                                                    <SelectItem value="Zapier">Zapier</SelectItem>
                                                    <SelectItem value="Other">Other</SelectItem>
                                                </SelectContent>
                                            </Select>
                                        </div>
                                        <div className="space-y-2">
                                            <Label>복잡도</Label>
                                            <Select value={workflowComplexity} onValueChange={setWorkflowComplexity}>
                                                <SelectTrigger className="h-11 rounded-xl bg-background">
                                                    <SelectValue placeholder="복잡도 선택" />
                                                </SelectTrigger>
                                                <SelectContent>
                                                    <SelectItem value="Simple">초급 (Simple)</SelectItem>
                                                    <SelectItem value="Medium">중급 (Medium)</SelectItem>
                                                    <SelectItem value="Complex">고급 (Complex)</SelectItem>
                                                </SelectContent>
                                            </Select>
                                        </div>
                                    </div>

                                    <div className="grid grid-cols-2 gap-4">
                                        <div className="space-y-2">
                                            <Label>소요 시간 (예: 15분)</Label>
                                            <Input value={workflowDuration} onChange={e => setWorkflowDuration(e.target.value)} placeholder="15분" />
                                        </div>
                                        <div className="space-y-2">
                                            <Label>사용된 도구 (쉼표로 구분)</Label>
                                            <Input value={workflowTools} onChange={e => setWorkflowTools(e.target.value)} placeholder="예: Notion, Slack, Gmail" />
                                        </div>
                                    </div>

                                    <div className="grid grid-cols-2 gap-4">
                                        <div className="space-y-2">
                                            <Label>다운로드/템플릿 링크 <span className="text-red-500">*</span></Label>
                                            <Input value={workflowDownloadUrl} onChange={e => setWorkflowDownloadUrl(e.target.value)} placeholder="https://..." required />
                                        </div>
                                        <div className="space-y-2">
                                            <Label>다이어그램 이미지 URL (선택)</Label>
                                            <Input value={workflowDiagramUrl} onChange={e => setWorkflowDiagramUrl(e.target.value)} placeholder="https://..." />
                                        </div>
                                    </div>

                                    <div className="space-y-4">
                                        <div className="flex items-center justify-between">
                                            <Label>단계별 설명 (Steps)</Label>
                                            <Button type="button" variant="outline" size="sm" onClick={addWorkflowStep}>
                                                + 단계 추가
                                            </Button>
                                        </div>
                                        {workflowSteps.map((step, index) => (
                                            <div key={index} className="grid grid-cols-1 md:grid-cols-[1fr_2fr_auto] gap-3 items-start p-4 bg-slate-50 rounded-lg border border-slate-200">
                                                <div className="space-y-2">
                                                    <Label className="text-xs text-slate-500">단계 제목</Label>
                                                    <Input
                                                        value={step.title}
                                                        onChange={e => updateWorkflowStep(index, 'title', e.target.value)}
                                                        placeholder={`Step ${index + 1}`}
                                                    />
                                                </div>
                                                <div className="space-y-2">
                                                    <Label className="text-xs text-slate-500">설명</Label>
                                                    <Textarea
                                                        value={step.description}
                                                        onChange={e => updateWorkflowStep(index, 'description', e.target.value)}
                                                        placeholder="이 단계에 대한 설명..."
                                                        className="h-20"
                                                    />
                                                </div>
                                                <Button
                                                    type="button"
                                                    variant="ghost"
                                                    size="icon"
                                                    className="mt-8 text-red-500 hover:text-red-600 hover:bg-red-50"
                                                    onClick={() => removeWorkflowStep(index)}
                                                    disabled={workflowSteps.length === 1}
                                                >
                                                    <X className="w-4 h-4" />
                                                </Button>
                                            </div>
                                        ))}
                                    </div>

                                    <div className="space-y-2">
                                        <Label>필수 요구사항 (쉼표로 구분)</Label>
                                        <Input value={workflowRequirements} onChange={e => setWorkflowRequirements(e.target.value)} placeholder="예: Notion API Key, Gmail 계정" />
                                    </div>

                                    <div className="space-y-2">
                                        <Label>가져오기 정보 (Import Info / JSON Code)</Label>
                                        <Textarea value={workflowImportInfo} onChange={e => setWorkflowImportInfo(e.target.value)} placeholder="JSON 코드나 임포트 관련 정보를 입력하세요." className="h-24 font-mono text-xs" />
                                    </div>

                                    <div className="space-y-2">
                                        <Label>주의사항 (쉼표로 구분)</Label>
                                        <Input value={workflowWarnings} onChange={e => setWorkflowWarnings(e.target.value)} placeholder="예: API 호출 제한 주의" />
                                    </div>
                                </div>
                            )}

                            {selectedCategory === 'template' && (
                                <div className="space-y-4">
                                    <div className="grid grid-cols-2 gap-4">
                                        <div className="space-y-2">
                                            <Label>포맷</Label>
                                            <Select value={templateFormat} onValueChange={setTemplateFormat}>
                                                <SelectTrigger className="h-11 rounded-xl bg-background">
                                                    <SelectValue placeholder="포맷 선택" />
                                                </SelectTrigger>
                                                <SelectContent>
                                                    <SelectItem value="Notion">Notion</SelectItem>
                                                    <SelectItem value="Google Sheets">Google Sheets</SelectItem>
                                                    <SelectItem value="Excel">Excel</SelectItem>
                                                    <SelectItem value="Figma">Figma</SelectItem>
                                                    <SelectItem value="Other">기타</SelectItem>
                                                </SelectContent>
                                            </Select>
                                        </div>
                                        <div className="space-y-2">
                                            <Label>미리보기 URL (선택)</Label>
                                            <Input value={templatePreviewUrl} onChange={e => setTemplatePreviewUrl(e.target.value)} placeholder="https://..." />
                                        </div>
                                    </div>
                                    <div className="space-y-2">
                                        <Label>템플릿 링크 <span className="text-red-500">*</span></Label>
                                        <Input value={linkUrl} onChange={e => setLinkUrl(e.target.value)} placeholder="https://..." required />
                                    </div>

                                    <div className="space-y-2">
                                        <Label>포함된 구성요소 (쉼표로 구분)</Label>
                                        <Input value={templateIncludes} onChange={e => setTemplateIncludes(e.target.value)} placeholder="예: 대시보드 페이지, 일정 관리 데이터베이스, 미팅 노트 템플릿" />
                                    </div>

                                    <div className="space-y-2">
                                        <Label>사용 가이드</Label>
                                        <Textarea value={installGuide} onChange={e => setInstallGuide(e.target.value)} placeholder="템플릿 복제 및 사용 방법을 적어주세요." className="h-32" />
                                    </div>

                                    <div className="space-y-2">
                                        <Label>상세 설명 (Description)</Label>
                                        <Textarea value={templateDescription} onChange={e => setTemplateDescription(e.target.value)} placeholder="템플릿에 대한 상세한 설명을 적어주세요." className="h-32" />
                                    </div>

                                    <div className="space-y-2">
                                        <Label>관련 AI 모델 (선택)</Label>
                                        <Select value={selectedAiModelId} onValueChange={setSelectedAiModelId}>
                                            <SelectTrigger className="h-11 rounded-xl bg-background">
                                                <SelectValue placeholder="AI 모델 선택 (예: Notion AI)" />
                                            </SelectTrigger>
                                            <SelectContent>
                                                {aiModels.map(model => (
                                                    <SelectItem key={model.id} value={model.id.toString()}>{model.name}</SelectItem>
                                                ))}
                                            </SelectContent>
                                        </Select>
                                    </div>

                                    <div className="space-y-2">
                                        <Label>미리보기 이미지 (최대 3장) - 첫 번째 사진이 대표 이미지가 됩니다.</Label>
                                        <div className="grid grid-cols-3 gap-4">
                                            {templateImages.map((file, index) => (
                                                <div key={index} className="relative aspect-video rounded-lg overflow-hidden border border-slate-200 group">
                                                    <img src={URL.createObjectURL(file)} alt={`Preview ${index}`} className="w-full h-full object-cover" />
                                                    <div
                                                        onClick={() => removeTemplateImage(index)}
                                                        className="absolute inset-0 bg-black/50 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity cursor-pointer text-white"
                                                    >
                                                        <X className="w-6 h-6" />
                                                    </div>
                                                </div>
                                            ))}
                                            {templateImages.length < 3 && (
                                                <div
                                                    onClick={() => templateImageRef.current?.click()}
                                                    className="aspect-video rounded-lg border-2 border-dashed border-slate-200 flex flex-col items-center justify-center text-slate-400 hover:border-slate-300 hover:bg-slate-50 transition-colors cursor-pointer"
                                                >
                                                    <Upload className="w-6 h-6 mb-1" />
                                                    <span className="text-xs">추가</span>
                                                </div>
                                            )}
                                        </div>
                                        <input type="file" ref={templateImageRef} onChange={handleTemplateImageChange} className="hidden" accept="image/*" multiple />
                                    </div>
                                </div>
                            )}

                            {selectedCategory === 'design' && (
                                <div className="space-y-6">
                                    <div className="space-y-4">
                                        <Label>생성 방식</Label>
                                        <div className="grid grid-cols-2 gap-4">
                                            <div
                                                onClick={() => setDesignType("text-to-image")}
                                                className={`border-2 rounded-xl p-4 cursor-pointer transition-all flex flex-col items-center gap-2 ${designType === "text-to-image"
                                                    ? "border-blue-500 bg-blue-50/50"
                                                    : "border-slate-200 hover:border-slate-300"
                                                    }`}
                                            >
                                                <div className="font-semibold text-sm">Text-to-Image</div>
                                                <div className="text-xs text-slate-500 text-center">텍스트로 이미지 생성</div>
                                            </div>
                                            <div
                                                onClick={() => setDesignType("image-to-image")}
                                                className={`border-2 rounded-xl p-4 cursor-pointer transition-all flex flex-col items-center gap-2 ${designType === "image-to-image"
                                                    ? "border-blue-500 bg-blue-50/50"
                                                    : "border-slate-200 hover:border-slate-300"
                                                    }`}
                                            >
                                                <div className="font-semibold text-sm">Image-to-Image</div>
                                                <div className="text-xs text-slate-500 text-center">이미지로 이미지 변환</div>
                                            </div>
                                        </div>
                                    </div>

                                    <div className="grid grid-cols-2 gap-6">
                                        {/* Conditionally Show Before Image */}
                                        {designType === "image-to-image" && (
                                            <div className="space-y-2">
                                                <Label>Before 이미지 (원본) <span className="text-red-500">*</span></Label>
                                                <div
                                                    onClick={() => beforeImageRef.current?.click()}
                                                    className="border-2 border-dashed border-slate-200 rounded-xl h-40 flex flex-col items-center justify-center text-slate-400 hover:border-slate-300 hover:bg-slate-50 transition-colors cursor-pointer relative overflow-hidden"
                                                >
                                                    {beforeImage ? (
                                                        <img src={URL.createObjectURL(beforeImage)} alt="Before" className="w-full h-full object-cover" />
                                                    ) : (
                                                        <>
                                                            <Upload className="w-6 h-6 mb-2" />
                                                            <span className="text-xs">클릭하여 업로드</span>
                                                        </>
                                                    )}
                                                    <input type="file" ref={beforeImageRef} onChange={(e) => handleFileChange(e, setBeforeImage)} className="hidden" accept="image/*" />
                                                </div>
                                            </div>
                                        )}

                                        <div className={designType === "text-to-image" ? "col-span-2 space-y-2" : "space-y-2"}>
                                            <Label>After 이미지 (결과물) <span className="text-red-500">*</span></Label>
                                            <div
                                                onClick={() => afterImageRef.current?.click()}
                                                className="border-2 border-dashed border-slate-200 rounded-xl h-40 flex flex-col items-center justify-center text-slate-400 hover:border-slate-300 hover:bg-slate-50 transition-colors cursor-pointer relative overflow-hidden"
                                            >
                                                {afterImage ? (
                                                    <img src={URL.createObjectURL(afterImage)} alt="After" className="w-full h-full object-cover" />
                                                ) : (
                                                    <>
                                                        <Upload className="w-6 h-6 mb-2" />
                                                        <span className="text-xs">클릭하여 업로드</span>
                                                    </>
                                                )}
                                                <input type="file" ref={afterImageRef} onChange={(e) => handleFileChange(e, setAfterImage)} className="hidden" accept="image/*" />
                                            </div>
                                        </div>
                                    </div>
                                    <div className="grid grid-cols-2 gap-4">
                                        <div className="space-y-2">
                                            <Label>사용 모델 (AI Model)</Label>
                                            <Select value={selectedAiModelId} onValueChange={setSelectedAiModelId}>
                                                <SelectTrigger className="h-11 rounded-xl bg-background">
                                                    <SelectValue placeholder="AI 모델 선택" />
                                                </SelectTrigger>
                                                <SelectContent>
                                                    {aiModels.map(model => (
                                                        <SelectItem key={model.id} value={model.id.toString()}>{model.name}</SelectItem>
                                                    ))}
                                                </SelectContent>
                                            </Select>
                                        </div>
                                        <div className="space-y-2">
                                            <Label>사용 모델 상세 버전</Label>
                                            <Input value={designModel} onChange={e => setDesignModel(e.target.value)} placeholder="예: Midjourney v6" />
                                        </div>
                                    </div>

                                    <div className="space-y-2">
                                        <Label>비율 (Aspect Ratio)</Label>
                                        <Input value={designAspectRatio} onChange={e => setDesignAspectRatio(e.target.value)} placeholder="예: 16:9" />
                                    </div>

                                    <div className="space-y-2">
                                        <Label>사용된 프롬프트 / 파라미터 <span className="text-red-500">*</span></Label>
                                        <Textarea value={designPrompt} onChange={e => setDesignPrompt(e.target.value)} placeholder="Midjourney v6, --ar 16:9 ..." className="h-24 font-mono" required />
                                    </div>

                                    <div className="space-y-2">
                                        <Label>상세 설명 (Description)</Label>
                                        <Textarea value={designDescription} onChange={e => setDesignDescription(e.target.value)} placeholder="이 디자인에 대한 상세한 설명을 적어주세요." className="h-32" />
                                    </div>

                                    <div className="space-y-2">
                                        <Label>입력 팁 (Input Tips) - 쉼표로 구분</Label>
                                        <Input value={designTips} onChange={e => setDesignTips(e.target.value)} placeholder="예: 고해상도, 흑백, 사이버펑크" />
                                    </div>
                                </div>
                            )}
                        </div>
                    </Card>

                    {/* 4. Images & Submit (Hidden for Prompt, Design, Agent, and Template types) */}
                    {!['prompt', 'design', 'agent', 'template'].includes(selectedCategory) && (
                        <Card className="p-6 space-y-6 bg-white border-slate-200 shadow-sm rounded-xl">
                            <div className="space-y-4">
                                <h2 className="text-lg font-semibold text-slate-800 border-b border-slate-100 pb-2">대표 이미지</h2>
                                <div
                                    onClick={() => mainImageRef.current?.click()}
                                    className="border-2 border-dashed border-slate-200 rounded-xl h-48 flex flex-col items-center justify-center text-slate-400 hover:border-slate-300 hover:bg-slate-50 transition-colors cursor-pointer group relative overflow-hidden"
                                >
                                    {mainImage ? (
                                        <img src={URL.createObjectURL(mainImage)} alt="Main" className="w-full h-full object-cover" />
                                    ) : (
                                        <>
                                            <div className="w-12 h-12 rounded-full bg-slate-100 flex items-center justify-center mb-3 group-hover:bg-slate-200 transition-colors">
                                                <ImageIcon className="w-6 h-6 text-slate-400 group-hover:text-slate-500" />
                                            </div>
                                            <span className="text-sm font-medium text-slate-600">대표 이미지 업로드</span>
                                            <span className="text-xs text-slate-400 mt-1">1200x630px 권장 (최대 5MB)</span>
                                        </>
                                    )}
                                    <input type="file" ref={mainImageRef} onChange={(e) => handleFileChange(e, setMainImage)} className="hidden" accept="image/*" />
                                </div>
                            </div>
                        </Card>
                    )}

                    <div className="pt-4 flex justify-end gap-3 sticky bottom-4">
                        <Button type="button" variant="outline" size="lg" className="rounded-xl" onClick={() => navigate(-1)}>취소</Button>
                        <Button
                            type="submit"
                            size="lg"
                            className={cn("rounded-xl min-w-[150px]", isSubmitting ? "bg-slate-800" : "bg-blue-600 hover:bg-blue-700")}
                            disabled={isSubmitting}
                        >
                            {isSubmitting ? (
                                <>
                                    <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin mr-2" />
                                    등록 중...
                                </>
                            ) : (
                                <>
                                    <CheckCircle2 className="w-4 h-4 mr-2" />
                                    판매 등록하기
                                </>
                            )}
                        </Button>
                    </div>
                </form>
            </main>

            <Footer />
        </div>
    );
};

export default SellPreset;
