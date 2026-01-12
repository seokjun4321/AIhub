import { useState } from "react";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Card } from "@/components/ui/card";
import { FileText, Sparkles, Link as LinkIcon, LayoutGrid, Image as ImageIcon, Upload, CheckCircle2 } from "lucide-react";
import { cn } from "@/lib/utils";
import { useNavigate } from "react-router-dom";

const CATEGORIES = [
    { id: "prompt", name: "프롬프트", icon: FileText, desc: "GPT, Claude 등 프롬프트 템플릿" },
    { id: "agent", name: "AI 에이전트", icon: Sparkles, desc: "특화된 커스텀 GPT/챗봇" },
    { id: "workflow", name: "워크플로우", icon: LinkIcon, desc: "n8n, Make 자동화 시나리오" },
    { id: "template", name: "템플릿", icon: LayoutGrid, desc: "Notion, Sheets 생산성 도구" },
    { id: "design", name: "디자인", icon: ImageIcon, desc: "AI 생성 이미지 및 소스" },
];

const SellPreset = () => {
    const navigate = useNavigate();
    const [selectedCategory, setSelectedCategory] = useState<string>("prompt");
    const [isSubmitting, setIsSubmitting] = useState(false);

    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();
        setIsSubmitting(true);

        // Mock submission delay
        setTimeout(() => {
            setIsSubmitting(false);
            alert("상품이 성공적으로 등록되었습니다! (데모)");
            navigate("/preset-store");
        }, 1500);
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
                                <Input id="title" placeholder="예: 스타트업을 위한 사업계획서 생성 프롬프트" required className="h-11" />
                            </div>

                            <div className="space-y-2">
                                <Label htmlFor="oneLiner">한 줄 소개 <span className="text-red-500">*</span></Label>
                                <Input id="oneLiner" placeholder="예: 키워드 3개만 넣으면 1분 만에 초안 완성!" required className="h-11" />
                                <p className="text-xs text-slate-400">검색 결과와 목록에 노출되는 중요한 문구입니다.</p>
                            </div>

                            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div className="space-y-2">
                                    <Label htmlFor="price">판매 가격 (원) <span className="text-red-500">*</span></Label>
                                    <div className="relative">
                                        <Input id="price" type="number" placeholder="0" min="0" required className="h-11 pr-8" />
                                        <span className="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 text-sm">원</span>
                                    </div>
                                    <p className="text-xs text-slate-400">0원 입력 시 무료로 배포됩니다.</p>
                                </div>
                                <div className="space-y-2">
                                    <Label htmlFor="tags">태그 (쉼표로 구분)</Label>
                                    <Input id="tags" placeholder="예: 생산성, 마케팅, 글쓰기" className="h-11" />
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
                                    <div className="space-y-2">
                                        <Label>프롬프트 내용 <span className="text-red-500">*</span></Label>
                                        <Textarea placeholder="여기에 프롬프트 전체 내용을 입력해주세요. 변수는 {variable} 형태로 작성하세요." className="min-h-[200px] font-mono text-sm leading-relaxed" />
                                    </div>
                                    <div className="space-y-2">
                                        <Label>사용 예시 (Input / Output)</Label>
                                        <div className="grid grid-cols-1 gap-4">
                                            <Textarea placeholder="Input 예시 (사용자가 입력할 내용)" className="h-24" />
                                            <Textarea placeholder="Output 예시 (AI가 답변할 내용)" className="h-32" />
                                        </div>
                                    </div>
                                </div>
                            )}

                            {selectedCategory === 'agent' && (
                                <div className="space-y-4">
                                    <div className="space-y-2">
                                        <Label>에이전트 URL (GPTs, Poe 등) <span className="text-red-500">*</span></Label>
                                        <Input placeholder="https://chat.openai.com/g/..." />
                                    </div>
                                    <div className="space-y-2">
                                        <Label>사용 가이드 / 설명</Label>
                                        <Textarea placeholder="이 에이전트는 어떤 데이터를 기반으로 답변하나요? 어떻게 활용하면 좋나요?" className="h-32" />
                                    </div>
                                </div>
                            )}

                            {(selectedCategory === 'workflow' || selectedCategory === 'template') && (
                                <div className="space-y-4">
                                    <div className="space-y-2">
                                        <Label>템플릿 / 워크플로우 링크 <span className="text-red-500">*</span></Label>
                                        <Input placeholder="https://notion.so/..." />
                                        <p className="text-xs text-slate-400">복제 가능한 공개 링크여야 합니다.</p>
                                    </div>
                                    <div className="space-y-2">
                                        <Label>설치/사용 방법</Label>
                                        <Textarea placeholder="1. 링크 접속 후 복제하기 클릭..." className="h-32" />
                                    </div>
                                </div>
                            )}

                            {selectedCategory === 'design' && (
                                <div className="space-y-4">
                                    <div className="grid grid-cols-2 gap-4">
                                        <div className="space-y-2">
                                            <Label>Before 이미지 (원본)</Label>
                                            <div className="border-2 border-dashed border-slate-200 rounded-xl h-40 flex flex-col items-center justify-center text-slate-400 hover:border-slate-300 hover:bg-slate-50 transition-colors cursor-pointer">
                                                <Upload className="w-6 h-6 mb-2" />
                                                <span className="text-xs">클릭하여 업로드</span>
                                            </div>
                                        </div>
                                        <div className="space-y-2">
                                            <Label>After 이미지 (결과물) <span className="text-red-500">*</span></Label>
                                            <div className="border-2 border-dashed border-slate-200 rounded-xl h-40 flex flex-col items-center justify-center text-slate-400 hover:border-slate-300 hover:bg-slate-50 transition-colors cursor-pointer">
                                                <Upload className="w-6 h-6 mb-2" />
                                                <span className="text-xs">클릭하여 업로드</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div className="space-y-2">
                                        <Label>사용된 프롬프트 / 파라미터</Label>
                                        <Textarea placeholder="Midjourney v6, --ar 16:9 ..." className="h-24 font-mono" />
                                    </div>
                                </div>
                            )}
                        </div>
                    </Card>

                    {/* 4. Images & Submit */}
                    <Card className="p-6 space-y-6 bg-white border-slate-200 shadow-sm rounded-xl">
                        <div className="space-y-4">
                            <h2 className="text-lg font-semibold text-slate-800 border-b border-slate-100 pb-2">대표 이미지</h2>
                            <div className="border-2 border-dashed border-slate-200 rounded-xl h-48 flex flex-col items-center justify-center text-slate-400 hover:border-slate-300 hover:bg-slate-50 transition-colors cursor-pointer group">
                                <div className="w-12 h-12 rounded-full bg-slate-100 flex items-center justify-center mb-3 group-hover:bg-slate-200 transition-colors">
                                    <ImageIcon className="w-6 h-6 text-slate-400 group-hover:text-slate-500" />
                                </div>
                                <span className="text-sm font-medium text-slate-600">대표 이미지 업로드</span>
                                <span className="text-xs text-slate-400 mt-1">1200x630px 권장 (최대 5MB)</span>
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
