import { useState } from "react";
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
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                {useCases?.map((useCase) => (
                  <Card key={useCase.id} onClick={() => setSelectedUseCase(useCase)} className={`cursor-pointer transition-all ${selectedUseCase?.id === useCase.id ? 'border-primary ring-2 ring-primary' : 'hover:border-primary/50'}`}>
                    <CardHeader>
                      {/* --- 🔧 FIX 2: Displaying related category name --- */}
                      {useCase.categories?.name && <Badge variant="secondary" className="mb-2 w-fit">{useCase.categories.name}</Badge>}
                      <CardTitle>{useCase.situation}</CardTitle>
                      <CardDescription>{useCase.summary}</CardDescription>
                    </CardHeader>
                  </Card>
                ))}
              </div>
            )}
          </div>

          {selectedUseCase && (
            <div>
              <h2 className="text-2xl font-semibold mb-6 text-center">2. 이 AI는 어떠세요?</h2>
              {recommendationsLoading ? renderSkeleton() : (
                <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
                  {recommendations?.map((rec, index) => {
                    // Find the first available guide for the recommended AI model to link to.
                    const firstGuide = rec.ai_models?.guides?.[0];
                    if (!rec.ai_models || !firstGuide) return null; // Don't render if there's no model or guide

                    return (
                      <Link to={`/guides/${firstGuide.id}`} key={index} className="h-full">
                        <Card className="h-full cursor-pointer hover:shadow-lg transition-shadow flex flex-col justify-between">
                          <CardHeader>
                            <div className="flex justify-between items-start">
                              <div>
                                {/* --- 🔧 FIX 3: Using correct properties from ai_models --- */}
                                <Badge variant="secondary" className="mb-2">{rec.ai_models.provider}</Badge>
                                <CardTitle>{rec.ai_models.name}</CardTitle>
                              </div>
                              <div className="text-right flex-shrink-0 pl-2">
                                <StarRating rating={rec.ai_models.average_rating || 0} readOnly />
                                <p className="text-xs text-muted-foreground mt-1">({rec.ai_models.rating_count || 0}명 참여)</p>
                              </div>
                            </div>
                            <CardDescription>{rec.ai_models.description}</CardDescription>
                          </CardHeader>
                          <CardContent>
                            <p className="text-sm bg-muted p-3 rounded-md flex items-start gap-2 h-full">
                              <ThumbsUp className="w-5 h-5 mt-0.5 flex-shrink-0 text-primary" />
                              <span>{rec.reason}</span>
                            </p>
                          </CardContent>
                        </Card>
                      </Link>
                    )
                  })}
                </div>
              )}
            </div>
          )}
        </div>
      </main>
      <Footer />
    </div>
  );
};

export default Recommend;