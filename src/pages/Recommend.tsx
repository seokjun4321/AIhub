import { useMemo, useState } from "react";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { Badge } from "@/components/ui/badge";
import { Link } from "react-router-dom";
import StarRating from "@/components/ui/StarRating";
import { ThumbsUp } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Search, Sparkles, Crown, RefreshCw } from "lucide-react";

// --- 🔧 FIX 1: Fetch queries updated for the new schema ---
const fetchUseCases = async () => {
  // Now also fetches the category name for display
  const { data, error } = await supabase.from('use_cases').select('*, categories(name)');
  if (error) throw new Error(error.message);
  return data;
};

const fetchRecommendations = async (useCaseId: number) => {
  const { data, error } = await supabase
    .from('recommendations')
    .select(`
      reason,
      ai_models ( *, guides ( id ) )
    `)
    .eq('use_case_id', useCaseId);
  if (error) throw new Error(error.message);
  return data;
};


const Recommend = () => {
  // Type inference will handle the data types, so we remove the outdated explicit types.
  const [selectedUseCase, setSelectedUseCase] = useState<any | null>(null);
  const [highlight, setHighlight] = useState<string>("top");

  const { data: useCases, isLoading: useCasesLoading } = useQuery({
    queryKey: ['use_cases'],
    queryFn: fetchUseCases
  });

  const { data: recommendations, isLoading: recommendationsLoading } = useQuery({
    queryKey: ['recommendations', selectedUseCase?.id],
    queryFn: () => {
      if (!selectedUseCase?.id) return [];
      return fetchRecommendations(selectedUseCase.id);
    },
    enabled: !!selectedUseCase,
  });

  const sortedRecommendations = useMemo(() => {
    if (!recommendations) return [] as any[];
    // 간단 정렬: highlight 기준 가중치
    return [...recommendations].sort((a: any, b: any) => {
      const ar = Number(a?.ai_models?.average_rating || 0);
      const br = Number(b?.ai_models?.average_rating || 0);
      const ac = Number(a?.ai_models?.rating_count || 0);
      const bc = Number(b?.ai_models?.rating_count || 0);
      if (highlight === 'top') return br - ar; // 평점순
      if (highlight === 'popular') return bc - ac; // 참여자수 순
      return 0;
    });
  }, [recommendations, highlight]);

  const renderSkeleton = () => (
    <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
      {[...Array(3)].map((_, i) => (
        <Card key={i}>
          <CardHeader><Skeleton className="h-6 w-3/4" /><Skeleton className="h-4 w-1/2 mt-2" /></CardHeader>
          <CardContent><Skeleton className="h-10 w-full" /><Skeleton className="h-8 w-1/2 mt-4" /></CardContent>
        </Card>
      ))}
    </div>
  );

  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      <main className="pt-24 pb-12">
        <div className="container mx-auto px-6">
          <div className="text-center mb-12">
            <h1 className="text-4xl md:text-5xl font-bold">맞춤 AI 추천</h1>
            <p className="text-xl text-muted-foreground mt-4 max-w-2xl mx-auto">
              어떤 AI를 써야 할지 막막하신가요? 지금 나의 상황에 꼭 맞는 AI를 추천해 드립니다.
            </p>
          </div>

          <div className="mb-12">
            <h2 className="text-2xl font-semibold mb-4 text-center">1. 지금 어떤 상황이신가요?</h2>
            {useCasesLoading ? (
              <div className="flex justify-center gap-4"><Skeleton className="h-24 w-64" /><Skeleton className="h-24 w-64" /><Skeleton className="h-24 w-64" /></div>
            ) : (
              <>
                {/* 선택 칩 가로 스크롤 */}
                <div className="flex gap-2 overflow-x-auto no-scrollbar pb-2 mb-4">
                  {useCases?.map((useCase) => (
                    <button
                      key={`chip-${useCase.id}`}
                      onClick={() => setSelectedUseCase(useCase)}
                      className={`whitespace-nowrap rounded-full border px-4 py-2 text-sm transition-colors ${selectedUseCase?.id === useCase.id ? 'bg-primary text-primary-foreground border-primary' : 'hover:bg-muted'}`}
                    >
                      {useCase.situation}
                    </button>
                  ))}
                </div>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                  {useCases?.map((useCase) => (
                    <Card key={useCase.id} onClick={() => setSelectedUseCase(useCase)} className={`cursor-pointer transition-all ${selectedUseCase?.id === useCase.id ? 'border-primary ring-2 ring-primary' : 'hover:border-primary/50'}`}>
                      <CardHeader>
                        {useCase.categories?.name && <Badge variant="secondary" className="mb-2 w-fit">{useCase.categories.name}</Badge>}
                        <CardTitle className="text-xl flex items-center gap-2">
                          <Sparkles className="w-5 h-5 text-primary" />{useCase.situation}
                        </CardTitle>
                        <CardDescription>{useCase.summary}</CardDescription>
                      </CardHeader>
                    </Card>
                  ))}
                </div>
              </>
            )}
          </div>

          {selectedUseCase && (
            <div>
              <div className="flex items-center justify-between mb-6">
                <h2 className="text-2xl font-semibold">2. 이 AI는 어떠세요?</h2>
                <div className="flex items-center gap-2">
                  <Button variant={highlight === 'top' ? 'default' : 'outline'} size="sm" onClick={() => setHighlight('top')}>평점순</Button>
                  <Button variant={highlight === 'popular' ? 'default' : 'outline'} size="sm" onClick={() => setHighlight('popular')}>인기순</Button>
                  <Button variant="ghost" size="sm" onClick={() => setSelectedUseCase(null)}>
                    <RefreshCw className="w-4 h-4 mr-1" /> 다시 선택
                  </Button>
                </div>
              </div>
              {recommendationsLoading ? renderSkeleton() : (
                <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
                  {sortedRecommendations?.map((rec, index) => {
                    // 가이드가 없으면 도구 상세 페이지로 폴백
                    if (!rec.ai_models) return null;
                    const firstGuide = rec.ai_models?.guides?.[0];
                    const linkTarget = firstGuide ? `/guides/${firstGuide.id}` : `/tools/${rec.ai_models.id}`;

                    return (
                      <Link to={linkTarget} key={index} className="relative h-full block">
                        {/* 랭킹 배지 */}
                        <div className="absolute -top-3 -left-3 z-10">
                          <span className="inline-flex items-center gap-1 rounded-full bg-yellow-400 text-black text-xs font-bold px-2 py-1 shadow">
                            <Crown className="w-3.5 h-3.5" /> {index + 1}위
                          </span>
                        </div>
                        <Card className="h-full hover:shadow-lg transition-shadow flex flex-col justify-between">
                          <CardHeader>
                            <div className="flex justify-between items-start gap-3">
                              <div className="flex items-start gap-3">
                                <div className="w-12 h-12 flex items-center justify-center bg-muted rounded-lg overflow-hidden">
                                  {rec.ai_models.logo_url ? (
                                    <img src={rec.ai_models.logo_url} alt={rec.ai_models.name} className="w-12 h-12 object-contain" />
                                  ) : (
                                    <div className="w-12 h-12 bg-gradient-to-br from-blue-500 to-purple-600 rounded-lg flex items-center justify-center text-white font-bold text-lg">
                                      {String(rec.ai_models.name || '?').charAt(0).toUpperCase()}
                                    </div>
                                  )}
                                </div>
                                <div>
                                  <Badge variant="secondary" className="mb-2">{rec.ai_models.provider}</Badge>
                                  <CardTitle className="text-xl">{rec.ai_models.name}</CardTitle>
                                </div>
                              </div>
                              <div className="text-right flex-shrink-0 pl-2">
                                <StarRating rating={rec.ai_models.average_rating || 0} readOnly />
                                <p className="text-xs text-muted-foreground mt-1">({rec.ai_models.rating_count || 0}명 참여)</p>
                              </div>
                            </div>
                            <CardDescription>{rec.ai_models.description}</CardDescription>
                          </CardHeader>
                          <CardContent>
                            <div className="space-y-4">
                              <p className="text-sm bg-muted p-3 rounded-md flex items-start gap-2">
                                <ThumbsUp className="w-5 h-5 mt-0.5 flex-shrink-0 text-primary" />
                                <span>{rec.reason}</span>
                              </p>
                              <div className="flex items-center justify-between gap-2">
                                <Button className="flex-1">
                                  {firstGuide ? '가이드 보기' : '도구 상세 보기'}
                                </Button>
                                {rec.ai_models.website_url && (
                                  <Button
                                    variant="outline"
                                    className="flex-1"
                                    onClick={(e) => { e.preventDefault(); window.open(rec.ai_models.website_url, '_blank', 'noopener,noreferrer'); }}
                                  >
                                    공식 사이트
                                  </Button>
                                )}
                              </div>
                            </div>
                          </CardContent>
                        </Card>
                      </Link>
                    )
                  })}
                </div>
              )}
            </div>
          )}

          {!selectedUseCase && !useCasesLoading && (
            <div className="mt-16 text-center text-muted-foreground">
              <div className="w-20 h-20 bg-muted rounded-full flex items-center justify-center mx-auto mb-4">
                <Search className="w-8 h-8" />
              </div>
              <p className="text-lg">상황을 선택하면, 맞춤형 AI 추천을 보여드려요.</p>
            </div>
          )}
        </div>
      </main>
      <Footer />
    </div>
  );
};

export default Recommend;