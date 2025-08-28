import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Link } from "react-router-dom";
import { ArrowRight, BrainCircuit, Code, Pencil, Palette } from "lucide-react";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { Skeleton } from "@/components/ui/skeleton";

// --- ▼▼▼ 타입 정의 추가 (에러 해결의 핵심) ▼▼▼ ---
interface Guide {
  id: number;
}

interface AiModel {
  id: number;
  full_name: string;
  guides: Guide[];
}

interface Recommendation {
  reason: string;
  ai_models: AiModel | null; // ai_models가 null일 수 있음을 명시
}

interface UseCase {
  id: number;
  category: string;
  situation: string;
  summary: string;
  recommendations: Recommendation[];
}

interface CategoryData {
  category: string;
  scenarios: UseCase[];
}
// --- ▲▲▲ 타입 정의 끝 ▲▲▲ ---


// Supabase에서 모든 추천 데이터를 JOIN해서 가져오는 함수
const fetchRecommendations = async (): Promise<CategoryData[]> => { // 반환 타입 명시
  const { data, error } = await supabase
    .from('use_cases')
    .select(`
      id,
      category,
      situation,
      summary,
      recommendations (
        reason,
        ai_models (
          id,
          full_name,
          guides ( id )
        )
      )
    `)
    .order('id');

  if (error) throw new Error(error.message);

  // 카테고리별로 데이터 그룹화
  const groupedData = data.reduce<Record<string, UseCase[]>>((acc, current) => {
    const category = current.category;
    if (!acc[category]) {
      acc[category] = [];
    }
    acc[category].push(current as UseCase); // 타입을 단언하여 에러 해결
    return acc;
  }, {});
  
  return Object.entries(groupedData).map(([category, scenarios]) => ({ category, scenarios }));
};


const Recommend = () => {
  const { data: recommendationData, isLoading, error } = useQuery<CategoryData[]>({ // useQuery에 타입 적용
    queryKey: ['recommendations'],
    queryFn: fetchRecommendations,
  });

  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      <main className="pt-24 pb-12">
        <div className="container mx-auto px-6">
          <div className="text-center mb-16">
            <h1 className="text-4xl md:text-5xl font-bold">AI 추천</h1>
            <p className="text-xl text-muted-foreground mt-4 max-w-2xl mx-auto">
              어떤 AI를 써야 할지 고민되시나요? <br />
              AIHub가 당신의 상황에 딱 맞는 AI와 가이드북을 추천해 드립니다.
            </p>
          </div>

          {isLoading ? (
             <div className="space-y-12">
              {[...Array(2)].map((_, i) => (
                <section key={i}>
                  <div className="flex items-center gap-4 mb-6">
                    <Skeleton className="w-14 h-14 rounded-xl" />
                    <Skeleton className="h-9 w-48" />
                  </div>
                  <div className="grid md:grid-cols-2 gap-6">
                    <Skeleton className="h-64 w-full" />
                    <Skeleton className="h-64 w-full" />
                  </div>
                </section>
              ))}
            </div>
          ) : error ? (
            <div className="text-center text-red-500">
              데이터를 불러오는 중 오류가 발생했습니다: {error.message}
            </div>
          ) : (
            <div className="space-y-12">
              {recommendationData?.map((categoryData) => (
                <section key={categoryData.category}>
                  <div className="flex items-center gap-4 mb-6">
                    <div className="p-3 rounded-xl bg-gradient-to-r from-primary to-primary/80 shadow-lg">
                      {categoryData.category === '개발' && <Code className="w-8 h-8 text-primary-foreground" />}
                      {categoryData.category === '글쓰기' && <Pencil className="w-8 h-8 text-primary-foreground" />}
                      {categoryData.category === '디자인' && <Palette className="w-8 h-8 text-primary-foreground" />}
                    </div>
                    <h2 className="text-3xl font-bold">{categoryData.category}</h2>
                  </div>
                  <div className="grid md:grid-cols-2 gap-6">
                    {categoryData.scenarios.flatMap((scenario) =>
                      scenario.recommendations
                        .filter(rec => rec.ai_models) // ai_models가 null인 경우를 걸러냅니다.
                        .map(rec => {
                          // 위에서 필터링 했으므로, 이제 rec.ai_models는 null이 아님
                          const aiModel = rec.ai_models!;
                          const guideId = aiModel.guides?.[0]?.id;

                          return (
                            <Card key={`${scenario.id}-${aiModel.id}`} className="h-full flex flex-col justify-between hover:border-primary/50 transition-colors">
                              <CardHeader>
                                <CardTitle>{scenario.situation}</CardTitle>
                                <CardDescription>{scenario.summary}</CardDescription>
                              </CardHeader>
                              <CardContent>
                                <div className="bg-muted p-4 rounded-lg space-y-2 mb-4">
                                  <div className="flex items-center gap-2">
                                    <BrainCircuit className="w-5 h-5 text-primary"/>
                                    <h4 className="font-semibold">추천 AI: {aiModel.full_name}</h4>
                                  </div>
                                  <p className="text-sm text-muted-foreground">{rec.reason}</p>
                                </div>
                                <Button asChild className="w-full group" disabled={!guideId}>
                                  <Link to={guideId ? `/guides/${guideId}` : '#'}>
                                    가이드북 보기
                                    <ArrowRight className="ml-2 w-4 h-4 group-hover:translate-x-1 transition-transform" />
                                  </Link>
                                </Button>
                              </CardContent>
                            </Card>
                          )
                        })
                    )}
                  </div>
                </section>
              ))}
            </div>
          )}
        </div>
      </main>
      <Footer />
    </div>
  );
};

export default Recommend;