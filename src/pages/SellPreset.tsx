import { useState, useRef } from "react";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Card } from "@/components/ui/card";
import { FileText, Sparkles, Link as LinkIcon, LayoutGrid, Image as ImageIcon, Upload, CheckCircle2, X } from "lucide-react";
import { cn } from "@/lib/utils";
import { useNavigate } from "react-router-dom";
import { supabase } from "@/integrations/supabase/client";
import { useToast } from "@/components/ui/use-toast";

const CATEGORIES = [
    { id: "prompt", name: "프롬프트", icon: FileText, desc: "GPT, Claude 등 프롬프트 템플릿" },
    { id: "agent", name: "AI 에이전트", icon: Sparkles, desc: "특화된 커스텀 GPT/챗봇" },
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
    const [tags, setTags] = useState("");

    // Dynamic Fields
    const [promptContent, setPromptContent] = useState("");
    const [inputExample, setInputExample] = useState("");
    const [outputExample, setOutputExample] = useState("");
    const [agentUrl, setAgentUrl] = useState("");
    const [agentGuide, setAgentGuide] = useState("");
    const [linkUrl, setLinkUrl] = useState("");
    const [installGuide, setInstallGuide] = useState("");
    const [designPrompt, setDesignPrompt] = useState("");

    // New fields for Prompt type
    const [difficulty, setDifficulty] = useState("Beginner");
    const [compatibleTools, setCompatibleTools] = useState("");
    const [tips, setTips] = useState("");
    const [promptEn, setPromptEn] = useState("");
    const [variables, setVariables] = useState("");

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

            // 2. Prepare Content JSON based on category
            let contentData: any = {
                price: Number(price) || 0,
                tags: tags.split(',').map(t => t.trim()).filter(Boolean),
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
                    variables: variables ? JSON.parse(variables) : []
                };
            } else if (selectedCategory === 'agent') {
                contentData = { ...contentData, url: agentUrl, instructions: [agentGuide] };
            } else if (selectedCategory === 'workflow' || selectedCategory === 'template') {
                contentData = { ...contentData, url: linkUrl, setup_steps: [installGuide] };
            } else if (selectedCategory === 'design') {
                contentData = { ...contentData, prompt_text: designPrompt, before_image: beforeImageUrl, after_image: afterImageUrl };
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

                            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div className="space-y-2">
                                    <Label htmlFor="price">판매 가격 (원) <span className="text-red-500">*</span></Label>
                                    <div className="relative">
                                        <Input id="price" type="number" value={price} onChange={e => setPrice(e.target.value)} placeholder="0" min="0" required className="h-11 pr-8" />
                                        <span className="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 text-sm">원</span>
                                    </div>
                                    <p className="text-xs text-slate-400">0원 입력 시 무료로 배포됩니다.</p>
                                </div>
                                <div className="space-y-2">
                                    <Label htmlFor="tags">태그 (쉼표로 구분)</Label>
                                    <Input id="tags" value={tags} onChange={e => setTags(e.target.value)} placeholder="예: 생산성, 마케팅, 글쓰기" className="h-11" />
                                </div>
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
                                            <select
                                                className="flex h-11 w-full items-center justify-between rounded-xl border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
                                                value={difficulty}
                                                onChange={e => setDifficulty(e.target.value)}
                                            >
                                                <option value="Beginner">초급 (Beginner)</option>
                                                <option value="Intermediate">중급 (Intermediate)</option>
                                                <option value="Advanced">고급 (Advanced)</option>
                                            </select>
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

                                    <div className="space-y-2">
                                        <Label>변수 설정 (JSON 형식) - 선택사항</Label>
                                        <Textarea
                                            value={variables}
                                            onChange={e => setVariables(e.target.value)}
                                            placeholder='예: [{"name": "topic", "placeholder": "주제", "example": "마케팅"}]'
                                            className="font-mono text-sm h-24"
                                        />
                                    </div>

                                    <div className="space-y-2">
                                        <Label>사용 팁 (쉼표로 구분)</Label>
                                        <Textarea value={tips} onChange={e => setTips(e.target.value)} placeholder="예: 구체적인 상황을 입력하면 더 좋습니다, 영어로 입력하면 정확도가 올라갑니다" className="h-20" />
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
                                    <div className="space-y-2">
                                        <Label>에이전트 URL <span className="text-red-500">*</span></Label>
                                        <Input value={agentUrl} onChange={e => setAgentUrl(e.target.value)} placeholder="https://chat.openai.com/g/..." required />
                                    </div>
                                    <div className="space-y-2">
                                        <Label>사용 가이드 / 설명</Label>
                                        <Textarea value={agentGuide} onChange={e => setAgentGuide(e.target.value)} placeholder="이 에이전트의 활용법을 적어주세요." className="h-32" />
                                    </div>
                                </div>
                            )}

                            {(selectedCategory === 'workflow' || selectedCategory === 'template') && (
                                <div className="space-y-4">
                                    <div className="space-y-2">
                                        <Label>템플릿 / 워크플로우 링크 <span className="text-red-500">*</span></Label>
                                        <Input value={linkUrl} onChange={e => setLinkUrl(e.target.value)} placeholder="https://notion.so/..." required />
                                    </div>
                                    <div className="space-y-2">
                                        <Label>설치/사용 방법</Label>
                                        <Textarea value={installGuide} onChange={e => setInstallGuide(e.target.value)} placeholder="복제 및 설치 방법을 적어주세요." className="h-32" />
                                    </div>
                                </div>
                            )}

                            {selectedCategory === 'design' && (
                                <div className="space-y-4">
                                    <div className="grid grid-cols-2 gap-4">
                                        <div className="space-y-2">
                                            <Label>Before 이미지 (선택)</Label>
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
                                        <div className="space-y-2">
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
                                    <div className="space-y-2">
                                        <Label>사용된 프롬프트 / 파라미터 <span className="text-red-500">*</span></Label>
                                        <Textarea value={designPrompt} onChange={e => setDesignPrompt(e.target.value)} placeholder="Midjourney v6, --ar 16:9 ..." className="h-24 font-mono" required />
                                    </div>
                                </div>
                            )}
                        </div>
                    </Card>

                    {/* 4. Images & Submit */}
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
