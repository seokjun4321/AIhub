import { useMemo, useState } from "react";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { Badge } from "@/components/ui/badge";
import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Search, Sparkles, Crown, RefreshCw } from "lucide-react";

// --- 가이드북 추천으로 변경 ---
const fetchUseCases = async () => {
  // Now also fetches the category name for display
  const { data, error } = await supabase.from('use_cases').select('*, categories(name)');
  if (error) throw new Error(error.message);
  return data;
};

const fetchRecommendedGuides = async (useCaseId: number | null) => {
  if (!useCaseId) return [];
  
  // use_case_guides 테이블을 통해 연결된 가이드북 가져오기
  // 타입 정의가 없으므로 any로 타입 단언
  const { data, error } = await (supabase as any)
    .from('use_case_guides')
    .select(`
      priority,
      guides (
        id,
        title,
        description,
        image_url,
        created_at,
        categories(name),
        profiles(username),
        ai_models(name, logo_url, provider)
      )
    `)
    .eq('use_case_id', useCaseId)
    .order('priority', { ascending: true })
    .order('created_at', { ascending: false });
  
  if (error) {
    console.error('❌ fetchRecommendedGuides 에러:', error);
    throw new Error(error.message);
  }
  
  console.log('📊 use_case_guides 쿼리 결과:', data);
  
  // guides 데이터 추출 및 평탄화
  const guides = data
    ?.map((item: any) => {
      // Supabase 관계형 쿼리 결과 구조 확인
      const guide = item.guides;
      if (guide && Array.isArray(guide)) {
        return guide[0]; // 배열인 경우 첫 번째 요소
      }
      return guide; // 객체인 경우 그대로 반환
    })
    .filter((guide: any) => guide !== null && guide !== undefined) || [];
  
  console.log('📚 추출된 가이드북:', guides);
  
  // 연결된 가이드북이 없으면 빈 배열 반환
  return guides;
};


const Recommend = () => {
  // Type inference will handle the data types, so we remove the outdated explicit types.
  const [selectedUseCase, setSelectedUseCase] = useState<any | null>(null);
  const [highlight, setHighlight] = useState<string>("top");

  const { data: useCases, isLoading: useCasesLoading } = useQuery({
    queryKey: ['use_cases'],
    queryFn: fetchUseCases
  });

  const { data: recommendedGuides, isLoading: guidesLoading } = useQuery({
    queryKey: ['recommendedGuides', selectedUseCase?.id],
    queryFn: () => {
      if (!selectedUseCase?.id) return [];
      // use_case_id를 통해 연결된 가이드북 가져오기
      return fetchRecommendedGuides(selectedUseCase.id);
    },
    enabled: !!selectedUseCase?.id,
    staleTime: 0, // 캐시를 즉시 무효화하여 최신 데이터 가져오기
    refetchOnMount: 'always', // 컴포넌트 마운트 시 항상 다시 가져오기
  });

  const sortedGuides = useMemo(() => {
    if (!recommendedGuides) return [] as any[];
    // 정렬: highlight 기준
    return [...recommendedGuides].sort((a: any, b: any) => {
      if (highlight === 'top') {
        // 최신순 (created_at 기준)
        return new Date(b.created_at).getTime() - new Date(a.created_at).getTime();
      }
      if (highlight === 'popular') {
        // 제목 길이로 간단히 인기도 측정 (실제로는 조회수나 좋아요 수가 필요)
        return (b.title?.length || 0) - (a.title?.length || 0);
      }
      return 0;
    });
  }, [recommendedGuides, highlight]);

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
            <h1 className="text-4xl md:text-5xl font-bold">맞춤 가이드북 추천</h1>
            <p className="text-xl text-muted-foreground mt-4 max-w-2xl mx-auto">
              어떤 가이드북을 봐야 할지 막막하신가요? 지금 나의 상황에 꼭 맞는 가이드북을 추천해 드립니다.
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
                <h2 className="text-2xl font-semibold">2. 이 가이드북은 어떠세요?</h2>
                <div className="flex items-center gap-2">
                  <Button variant={highlight === 'top' ? 'default' : 'outline'} size="sm" onClick={() => setHighlight('top')}>최신순</Button>
                  <Button variant={highlight === 'popular' ? 'default' : 'outline'} size="sm" onClick={() => setHighlight('popular')}>인기순</Button>
                  <Button variant="ghost" size="sm" onClick={() => setSelectedUseCase(null)}>
                    <RefreshCw className="w-4 h-4 mr-1" /> 다시 선택
                  </Button>
                </div>
              </div>
              {guidesLoading ? renderSkeleton() : (
                sortedGuides && sortedGuides.length > 0 ? (
                  <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
                    {sortedGuides.map((guide: any, index: number) => (
                      <Link to={`/guides/${guide.id}`} key={guide.id} className="relative h-full block">
                        {/* 랭킹 배지 */}
                        <div className="absolute -top-3 -left-3 z-10">
                          <span className="inline-flex items-center gap-1 rounded-full bg-yellow-400 text-black text-xs font-bold px-2 py-1 shadow">
                            <Crown className="w-3.5 h-3.5" /> {index + 1}위
                          </span>
                        </div>
                        <Card className="h-full hover:shadow-lg transition-shadow flex flex-col">
                          <CardHeader>
                            <div className="aspect-video w-full bg-muted rounded-md mb-4 overflow-hidden">
                              <img 
                                src={guide.image_url || "/placeholder.svg"} 
                                alt={guide.title} 
                                className="w-full h-full object-cover"
                              />
                            </div>
                            <div className="flex items-center gap-2 mb-2">
                              {guide.categories?.name && (
                                <Badge variant="secondary">{guide.categories.name}</Badge>
                              )}
                            </div>
                            <CardTitle className="text-xl mb-2">{guide.title}</CardTitle>
                            <CardDescription className="line-clamp-2">
                              {guide.description || '설명이 없습니다.'}
                            </CardDescription>
                          </CardHeader>
                          <CardContent className="flex-1 flex flex-col justify-between">
                            <div className="space-y-3">
                              {guide.ai_models && (
                                <div className="flex items-center gap-2 text-sm text-muted-foreground">
                                  <div className="w-6 h-6 flex items-center justify-center bg-muted rounded overflow-hidden">
                                    {guide.ai_models.logo_url ? (
                                      <img src={guide.ai_models.logo_url} alt={guide.ai_models.name} className="w-6 h-6 object-contain" />
                                    ) : (
                                      <span className="text-xs font-bold">
                                        {String(guide.ai_models.name || '?').charAt(0).toUpperCase()}
                                      </span>
                                    )}
                                  </div>
                                  <span>{guide.ai_models.name}</span>
                                </div>
                              )}
                              {guide.profiles?.username && (
                                <p className="text-xs text-muted-foreground">
                                  작성자: {guide.profiles.username}
                                </p>
                              )}
                            </div>
                            <Button className="w-full mt-4">
                              가이드북 보기
                            </Button>
                          </CardContent>
                        </Card>
                      </Link>
                    ))}
                  </div>
                ) : (
                  <div className="text-center py-12">
                    <div className="w-20 h-20 bg-muted rounded-full flex items-center justify-center mx-auto mb-4">
                      <Search className="w-8 h-8" />
                    </div>
                    <p className="text-lg text-muted-foreground">
                      이 상황에 맞는 가이드북이 아직 없습니다.
                    </p>
                  </div>
                )
              )}
            </div>
          )}

          {!selectedUseCase && !useCasesLoading && (
            <div className="mt-16 text-center text-muted-foreground">
              <div className="w-20 h-20 bg-muted rounded-full flex items-center justify-center mx-auto mb-4">
                <Search className="w-8 h-8" />
              </div>
              <p className="text-lg">상황을 선택하면, 맞춤형 가이드북 추천을 보여드려요.</p>
            </div>
          )}
        </div>
      </main>
      <Footer />
    </div>
  );
};

export default Recommend;