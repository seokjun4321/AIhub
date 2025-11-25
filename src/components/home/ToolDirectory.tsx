import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { ArrowRight, Type, Image, Code, Search, Video, Music, MessageSquare, Briefcase, Sparkles } from "lucide-react";
import { Link } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { Skeleton } from "@/components/ui/skeleton";

interface CategoryData {
    id: number;
    name: string;
    count: number;
    icon: any;
    color: string;
    bg: string;
}

const categoryConfig: Record<string, { icon: any, color: string, bg: string }> = {
    "텍스트 생성": { icon: Type, color: "text-blue-500", bg: "bg-blue-500/10" },
    "이미지 생성": { icon: Image, color: "text-purple-500", bg: "bg-purple-500/10" },
    "코드 작성": { icon: Code, color: "text-green-500", bg: "bg-green-500/10" },
    "검색": { icon: Search, color: "text-orange-500", bg: "bg-orange-500/10" },
    "동영상 편집": { icon: Video, color: "text-red-500", bg: "bg-red-500/10" },
    "음성/음악": { icon: Music, color: "text-pink-500", bg: "bg-pink-500/10" },
    "챗봇": { icon: MessageSquare, color: "text-cyan-500", bg: "bg-cyan-500/10" },
    "생산성": { icon: Briefcase, color: "text-yellow-500", bg: "bg-yellow-500/10" },
};

const defaultConfig = { icon: Sparkles, color: "text-gray-500", bg: "bg-gray-500/10" };

const ToolDirectory = () => {
    const { data: categories, isLoading } = useQuery({
        queryKey: ['tool-directory-categories'],
        queryFn: async () => {
            // 1. 카테고리 가져오기
            const { data: categoriesData, error: categoriesError } = await supabase
                .from('categories')
                .select('id, name');

            if (categoriesError) throw categoriesError;

            // 2. 각 카테고리별 모델 수 가져오기 (ai_models 테이블에서 집계)
            // Note: 실제 운영 환경에서는 view를 만들거나 .select('*, ai_models(count)')를 사용하는 것이 좋음
            // 여기서는 간단하게 모든 모델의 category_id를 가져와서 계산
            const { data: modelsData, error: modelsError } = await supabase
                .from('ai_models')
                .select('category_id');

            if (modelsError) throw modelsError;

            // 카운트 계산
            const counts: Record<number, number> = {};
            (modelsData as any[])?.forEach(model => {
                if (model.category_id) {
                    counts[model.category_id] = (counts[model.category_id] || 0) + 1;
                }
            });

            // 데이터 매핑
            return categoriesData.map(cat => {
                const config = categoryConfig[cat.name] || defaultConfig;
                return {
                    id: cat.id,
                    name: cat.name,
                    count: counts[cat.id] || 0,
                    ...config
                };
            }).sort((a, b) => b.count - a.count).slice(0, 8); // 상위 8개만 표시
        }
    });

    const totalCount = categories?.reduce((acc, curr) => acc + curr.count, 0) || 0;

    if (isLoading) {
        return (
            <section className="py-20">
                <div className="container mx-auto px-6">
                    <div className="flex items-center justify-between mb-10">
                        <div>
                            <h2 className="text-3xl font-bold mb-2">AI 도구 디렉토리</h2>
                            <Skeleton className="h-4 w-48" />
                        </div>
                    </div>
                    <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                        {[1, 2, 3, 4, 5, 6, 7, 8].map((i) => (
                            <Skeleton key={i} className="h-20 w-full rounded-lg" />
                        ))}
                    </div>
                </div>
            </section>
        );
    }

    return (
        <section className="py-20">
            <div className="container mx-auto px-6">
                <div className="flex items-center justify-between mb-10">
                    <div>
                        <h2 className="text-3xl font-bold mb-2">AI 도구 디렉토리</h2>
                        <p className="text-muted-foreground">카테고리별로 정리된 {totalCount}+ AI 도구</p>
                    </div>
                    <Button variant="outline" asChild>
                        <Link to="/tools" className="flex items-center gap-2">
                            모든 도구 보기
                            <ArrowRight className="w-4 h-4" />
                        </Link>
                    </Button>
                </div>

                <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                    {categories?.map((category) => (
                        <Link key={category.id} to={`/tools?category=${category.name}`}>
                            <Card className="p-4 hover:shadow-md transition-all cursor-pointer group border hover:border-primary/20 h-full">
                                <div className="flex items-center gap-4">
                                    <div className={`w-10 h-10 rounded-lg ${category.bg} ${category.color} flex items-center justify-center group-hover:scale-110 transition-transform`}>
                                        <category.icon className="w-5 h-5" />
                                    </div>
                                    <div>
                                        <h3 className="font-medium text-sm">{category.name}</h3>
                                        <p className="text-xs text-muted-foreground">{category.count}개 +</p>
                                    </div>
                                </div>
                            </Card>
                        </Link>
                    ))}
                </div>
            </div>
        </section>
    );
};

export default ToolDirectory;
