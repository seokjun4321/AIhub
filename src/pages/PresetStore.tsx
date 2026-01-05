import { useState } from "react";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import PresetCard from "@/components/preset-store/PresetCard";
import PresetDetailModal from "@/components/preset-store/PresetDetailModal";
import { Preset } from "@/types/preset";
import { Search, FileText, Sparkles, Link, Layout, Image as ImageIcon, Users, ChevronRight, Upload, Star } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";

// MOCK_PRESETS removed. Using DB data.

const CREATORS = [
    {
        name: "비즈니스팀",
        role: "프롬프트 · 자동화",
        sales: "1250개 판매",
        rating: 4.9,
        image: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&q=80&w=200",
        tags: ["프롬프트", "자동화"]
    },
    {
        name: "크리에이티브스튜디오",
        role: "디자인 · 프롬프트",
        sales: "980개 판매",
        rating: 4.8,
        image: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&q=80&w=200",
        tags: ["디자인", "프롬프트"]
    },
    {
        name: "오토메이션랩",
        role: "자동화 · 워크플로우",
        sales: "850개 판매",
        rating: 4.9,
        image: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=200",
        tags: ["자동화", "워크플로우"]
    }
];

const CATEGORIES = [
    { name: "프롬프트 템플릿", icon: FileText },
    { name: "Gem / GPT / Artifact", icon: Sparkles },
    { name: "자동화 워크플로우", icon: Link },
    { name: "Notion / Sheets 템플릿", icon: Layout },
    { name: "AI 생성 디자인", icon: ImageIcon },
    { name: "크리에이터 서비스", icon: Users },
];

const fetchPresets = async (): Promise<Preset[]> => {
    // Cast supabase to any to bypass type check for now since presets table is not in types yet
    const { data, error } = await (supabase as any)
        .from('presets')
        .select('*');

    if (error) throw error;

    // Map DB structure to Frontend Preset structure
    // missing fields are filled with placeholders for now
    return (data || []).map((item: any) => ({
        id: item.id,
        title: item.title,
        description: item.description,
        category: item.category,
        tag: item.tags?.[0] || "General",
        price: item.price,
        isFree: item.price === 0,
        aiModel: "ChatGPT", // Default or fetch if exists
        imageUrl: item.image_url,
        rating: Number(item.rating),
        reviewCount: item.review_count,
        creator: "Admin", // Placeholder
        productType: item.category,
        overview: item.detailed_info?.overview || {
            summary: item.description,
            whenToUse: [],
            expectedResults: [],
            promptMaster: "AIHub"
        },
        examples: item.detailed_info?.examples || [],
        prompt: item.detailed_info?.prompt || { content: "" },
        variables: item.detailed_info?.variables || {
            guide: [],
            exampleInput: "",
            usageSteps: []
        }
    }));
};

const PresetStore = () => {
    const [selectedPreset, setSelectedPreset] = useState<Preset | null>(null);

    const { data: presets = [], isLoading } = useQuery({
        queryKey: ['presets'],
        queryFn: fetchPresets
    });


    return (
        <div className="min-h-screen bg-slate-50 font-sans text-slate-900">
            <Navbar />

            <main className="pb-24">
                {/* Hero Section */}
                <section className="pt-20 pb-16 px-4 text-center bg-white border-b border-slate-100">
                    <div className="max-w-4xl mx-auto">
                        <h1 className="text-4xl md:text-5xl font-bold tracking-tight text-slate-900 mb-4">
                            필요한 AI 템플릿을 한 곳에서
                        </h1>
                        <p className="text-lg text-slate-500 mb-10">
                            프롬프트, 자동화, 워크플로우, Gem까지 모두 판매·구매할 수 있어요.
                        </p>

                        <div className="relative max-w-2xl mx-auto mb-8">
                            <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400" />
                            <Input
                                type="text"
                                placeholder="예: 스타트업 사업계획서 GPT"
                                className="pl-12 h-14 rounded-full border-slate-200 text-lg shadow-sm focus:ring-slate-900 focus:border-slate-900 transition-all hover:border-slate-300"
                            />
                        </div>

                        <div className="flex items-center justify-center gap-4">
                            <Button size="lg" className="rounded-full bg-slate-900 hover:bg-slate-800 text-white px-8 h-12">
                                카테고리 탐색
                            </Button>
                            <Button size="lg" variant="outline" className="rounded-full border-slate-200 hover:bg-slate-50 text-slate-700 px-8 h-12">
                                내 템플릿 판매하기
                            </Button>
                        </div>
                    </div>
                </section>

                <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 space-y-24 mt-20">
                    {/* Categories */}
                    <section>
                        <div className="text-center mb-10">
                            <h2 className="text-2xl font-bold mb-2">카테고리</h2>
                            <p className="text-slate-500">원하는 AI 템플릿을 찾아보세요</p>
                        </div>
                        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4">
                            {CATEGORIES.map((cat, idx) => (
                                <button key={idx} className="flex flex-col items-center justify-center p-6 bg-white rounded-2xl border border-slate-100 shadow-sm hover:shadow-md hover:border-slate-200 transition-all group">
                                    <div className="w-12 h-12 bg-slate-50 rounded-xl flex items-center justify-center mb-4 group-hover:scale-110 transition-transform text-slate-600 group-hover:text-slate-900">
                                        <cat.icon className="w-6 h-6" />
                                    </div>
                                    <span className="text-sm font-semibold text-slate-700 group-hover:text-slate-900">{cat.name}</span>
                                </button>
                            ))}
                        </div>
                    </section>

                    {/* Popular Templates */}
                    <section>
                        <div className="flex items-center justify-between mb-8">
                            <div>
                                <h2 className="text-2xl font-bold mb-1">인기 템플릿</h2>
                                <p className="text-slate-500">가장 많이 선택받은 프리셋</p>
                            </div>
                            <button className="text-sm font-medium text-slate-500 hover:text-slate-900">전체 보기</button>
                        </div>
                        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                            {isLoading ? (
                                <div className="col-span-3 text-center py-20">Loading presets...</div>
                            ) : (presets.slice(0, 3).map((preset) => (
                                <PresetCard
                                    key={preset.id}
                                    preset={preset}
                                    onClick={() => setSelectedPreset(preset)}
                                />
                            )))}
                        </div>
                    </section>

                    {/* New Arrivals */}
                    <section>
                        <div className="flex items-center justify-between mb-8">
                            <div>
                                <h2 className="text-2xl font-bold mb-1">신규 등록</h2>
                                <p className="text-slate-500">최근에 추가된 템플릿</p>
                            </div>
                            <div className="flex gap-2">
                                <button className="w-8 h-8 flex items-center justify-center rounded-full border border-slate-200 hover:bg-slate-50">
                                    <span className="sr-only">Previous</span>
                                    <ChevronRight className="w-4 h-4 rotate-180" />
                                </button>
                                <button className="w-8 h-8 flex items-center justify-center rounded-full border border-slate-200 hover:bg-slate-50">
                                    <span className="sr-only">Next</span>
                                    <ChevronRight className="w-4 h-4" />
                                </button>
                            </div>
                        </div>
                        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                            {isLoading ? (
                                <div className="col-span-4 text-center py-20">Loading...</div>
                            ) : (presets.slice(3, 7).map((preset) => (
                                <PresetCard
                                    key={preset.id}
                                    preset={preset}
                                    onClick={() => setSelectedPreset(preset)}
                                />
                            )))}
                        </div>
                    </section>

                    {/* Popular Creators */}
                    <section>
                        <div className="text-center mb-10">
                            <h2 className="text-2xl font-bold mb-2">인기 크리에이터</h2>
                            <p className="text-slate-500">검증된 크리에이터의 템플릿을 만나보세요</p>
                        </div>
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                            {CREATORS.map((creator, idx) => (
                                <div key={idx} className="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm flex items-center gap-4 hover:shadow-md transition-all">
                                    <img src={creator.image} alt={creator.name} className="w-16 h-16 rounded-full object-cover" />
                                    <div className="flex-1 min-w-0">
                                        <h3 className="font-bold text-slate-900 truncate">{creator.name}</h3>
                                        <div className="flex items-center gap-1 text-sm text-slate-500 mb-1">
                                            <Star className="w-3.5 h-3.5 fill-amber-400 text-amber-400" />
                                            <span className="font-medium text-slate-900">{creator.rating}</span>
                                            <span className="mx-1">·</span>
                                            <span>{creator.sales}</span>
                                        </div>
                                        <div className="flex gap-2">
                                            {creator.tags.map((tag, tIdx) => (
                                                <span key={tIdx} className="px-2 py-0.5 bg-slate-100 text-slate-600 text-xs rounded-sm font-medium">
                                                    {tag}
                                                </span>
                                            ))}
                                        </div>
                                    </div>
                                </div>
                            ))}
                        </div>
                    </section>

                    {/* CTA Layout */}
                    <section className="bg-white rounded-3xl p-12 text-center border border-slate-100 shadow-sm">
                        <h2 className="text-2xl font-bold mb-4 text-slate-900">당신도 템플릿을 판매해보세요</h2>
                        <p className="text-slate-500 mb-8 max-w-2xl mx-auto">
                            직접 만든 프롬프트, 워크플로우, Gem을 다른 창작자들과 공유하고 수익을 창출하세요
                        </p>
                        <div className="flex items-center justify-center gap-4">
                            <Button className="bg-slate-900 hover:bg-slate-800 text-white rounded-lg px-6 py-6 h-auto text-base font-semibold">
                                <Upload className="w-4 h-4 mr-2" />
                                템플릿 업로드하기
                            </Button>
                            <Button variant="outline" className="border-slate-200 hover:bg-slate-50 text-slate-700 rounded-lg px-6 py-6 h-auto text-base font-semibold">
                                판매 가이드 보기
                            </Button>
                        </div>
                        <p className="mt-8 text-xs text-slate-400">
                            AIHub는 판매 수익의 20%를 플랫폼 운영비로 사용합니다
                        </p>
                    </section>
                </div>
            </main>

            {selectedPreset && (
                <PresetDetailModal
                    preset={selectedPreset}
                    onClose={() => setSelectedPreset(null)}
                />
            )}

            <Footer />
        </div>
    );
};

export default PresetStore;
