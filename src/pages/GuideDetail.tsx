import { useState, useEffect } from "react";
import { useParams, Link } from "react-router-dom";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { Skeleton } from "@/components/ui/skeleton";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogFooter } from "@/components/ui/dialog";
import StarRating from "@/components/ui/StarRating";
import { useAuth } from "@/hooks/useAuth";
import { toast } from "sonner";
import { UserCircle, Calendar, Star } from "lucide-react";
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import { cn } from "@/lib/utils";

// 페이지에 필요한 모든 데이터를 한 번에 가져오는 함수 (이 방식이 가장 효율적입니다)
const fetchGuideById = async (id: string) => {
  const numericId = parseInt(id, 10);
  if (isNaN(numericId)) throw new Error("Invalid ID provided");
  const { data, error } = await supabase
    .from('guides')
    .select(`*, ai_models(*), profiles(username), categories(name)`)
    .eq('id', numericId)
    .single();
  if (error) throw new Error(error.message);
  return data;
};

// 사용자의 평점을 가져오는 함수
const fetchUserRating = async (aiModelId: number, userId: string) => {
  const { data, error } = await supabase
    .from('ratings')
    .select('rating')
    .eq('ai_model_id', aiModelId)
    .eq('user_id', userId)
    .single();
  if (error && error.code !== 'PGRST116') throw new Error(error.message);
  return data;
};

const GuideDetail = () => {
  const { id } = useParams<{ id: string }>();
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [currentRating, setCurrentRating] = useState(0);
  const [uiAverage, setUiAverage] = useState<number | null>(null);
  const [uiCount, setUiCount] = useState<number | null>(null);
  const queryClient = useQueryClient();
  const { user } = useAuth();

  // 페이지 데이터를 위한 단일 쿼리
  const { data: guide, isLoading, error } = useQuery({
    queryKey: ['guide', id],
    queryFn: () => fetchGuideById(id!),
    enabled: !!id,
  });

  const aiModel = guide?.ai_models;

  // 서버 데이터 변경 시 표시값 동기화
  useEffect(() => {
    if (aiModel) {
      setUiAverage(Number(aiModel.average_rating) || 0);
      setUiCount(Number(aiModel.rating_count) || 0);
    }
  }, [aiModel?.average_rating, aiModel?.rating_count]);

  // 사용자 평점 쿼리
  const userRatingQuery = useQuery({
    queryKey: ['userRating', aiModel?.id, user?.id],
    queryFn: () => {
      if (!user?.id || !aiModel?.id) return null;
      return fetchUserRating(aiModel.id, user.id);
    },
    enabled: !!aiModel && !!user,
  });

  // Supabase Realtime: ai_models 업데이트를 실시간으로 반영
  useEffect(() => {
    if (!aiModel?.id) return;

    const channel = supabase
      .channel(`ai-model-${aiModel.id}`)
      .on(
        'postgres_changes',
        { event: 'UPDATE', schema: 'public', table: 'ai_models', filter: `id=eq.${aiModel.id}` },
        (payload) => {
          const next = payload.new as { average_rating?: number; rating_count?: number };
          queryClient.setQueryData(['guide', id], (prev: any) => {
            if (!prev?.ai_models) return prev;
            return {
              ...prev,
              ai_models: {
                ...prev.ai_models,
                average_rating: next.average_rating ?? prev.ai_models.average_rating,
                rating_count: next.rating_count ?? prev.ai_models.rating_count,
              },
            };
          });
          if (typeof next.average_rating === 'number') setUiAverage(next.average_rating);
          if (typeof next.rating_count === 'number') setUiCount(next.rating_count);
        }
      )
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, [aiModel?.id, id, queryClient]);

  useEffect(() => {
    setCurrentRating(userRatingQuery.data?.rating || 0);
  }, [userRatingQuery.data]);

  // 🔧 뮤테이션 로직: 낙관적 업데이트 + 백그라운드 동기화
  const rateMutation = useMutation({
    mutationFn: async ({ rating }: { rating: number }) => {
      if (!user || !aiModel) throw new Error("로그인이 필요합니다.");
      const { error } = await supabase.from('ratings').upsert({
        user_id: user.id,
        ai_model_id: aiModel.id,
        rating,
      });
      if (error) throw new Error(error.message);
    },
    onMutate: async ({ rating }: { rating: number }) => {
      // 관련 쿼리의 동시 갱신을 방지
      await queryClient.cancelQueries({ queryKey: ['guide', id] });

      const previousGuide: any = queryClient.getQueryData(['guide', id]);
      const previousUserRating = userRatingQuery.data?.rating ?? null;

      if (previousGuide?.ai_models) {
        const oldAi = previousGuide.ai_models;
        const oldCount = Number(oldAi.rating_count) || 0;
        const oldAverage = Number(oldAi.average_rating) || 0;

        let newCount = oldCount;
        if (previousUserRating == null) {
          newCount = oldCount + 1;
        }
        const baseSum = oldAverage * oldCount;
        const newSum = previousUserRating == null
          ? baseSum + rating
          : baseSum - Number(previousUserRating) + rating;
        const newAverage = newCount > 0 ? newSum / newCount : 0;

        const updatedGuide = {
          ...previousGuide,
          ai_models: {
            ...oldAi,
            average_rating: newAverage,
            rating_count: newCount,
          },
        };

        // 즉시 화면 반영
        queryClient.setQueryData(['guide', id], updatedGuide);
        setUiAverage(newAverage);
        setUiCount(newCount);
      }

      // 내 평점도 즉시 반영
      if (aiModel?.id && user?.id) {
        queryClient.setQueryData(['userRating', aiModel.id, user.id], { rating });
      }

      return { previousGuide };
    },
    onError: (error, _vars, context) => {
      // 실패 시 롤백
      if (context?.previousGuide) {
        queryClient.setQueryData(['guide', id], context.previousGuide);
      }
      toast.error(`오류가 발생했습니다: ${error.message}`);
    },
    onSuccess: async () => {
      toast.success("평점이 등록되었습니다!");

      // 즉시 강제 재요청으로 동기화 시도
      queryClient.refetchQueries({ queryKey: ['guide', id], type: 'active' });
      if (aiModel?.id && user?.id) {
        queryClient.refetchQueries({ queryKey: ['userRating', aiModel.id, user.id], type: 'active' });
      }
      queryClient.invalidateQueries({ queryKey: ['guides'] });
      queryClient.invalidateQueries({ queryKey: ['recommendations'] });

      // 트리거 지연을 고려해 ai_models 값을 직접 폴링하여 최종 동기화
      if (aiModel?.id) {
        const startAvg = Number(aiModel.average_rating) || 0;
        const startCnt = Number(aiModel.rating_count) || 0;
        const maxAttempts = 15; // 최대 ~3.75초 (250ms * 15)
        for (let i = 0; i < maxAttempts; i++) {
          await new Promise((r) => setTimeout(r, 250));
          const { data, error } = await supabase
            .from('ai_models')
            .select('average_rating, rating_count')
            .eq('id', aiModel.id)
            .single();
          if (!error && data && (data.average_rating !== startAvg || data.rating_count !== startCnt)) {
            queryClient.setQueryData(['guide', id], (prev: any) => {
              if (!prev?.ai_models) return prev;
              return {
                ...prev,
                ai_models: {
                  ...prev.ai_models,
                  average_rating: data.average_rating,
                  rating_count: data.rating_count,
                },
              };
            });
            break;
          }
        }
      }
    },
  });

  const handleRate = (rating: number) => {
    setCurrentRating(rating);
    rateMutation.mutate({ rating });
  };

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;
  if (!guide || !aiModel) return <div>Guide not found.</div>;

  return (
    // JSX 부분은 이전과 동일하게 완벽하므로 수정할 필요가 없습니다.
    <div className="min-h-screen">
      <Navbar />
      <main className="pt-24 pb-12">
        <article className="container mx-auto px-6 max-w-4xl">
          <header className="mb-8">
            <Badge variant="outline" className="mb-4">{guide.categories?.name || 'Uncategorized'}</Badge>
            <h1 className="text-4xl md:text-5xl font-bold tracking-tight">{guide.title}</h1>
            <p className="text-xl text-muted-foreground mt-4">{guide.description}</p>
            <div className="flex flex-wrap items-center justify-between gap-4 mt-6">
              <div className="flex items-center gap-8 text-sm text-muted-foreground">
                <div className="flex items-center gap-2"><UserCircle className="w-4 h-4" /><span>by {guide.profiles?.username || 'Unknown Author'}</span></div>
                <div className="flex items-center gap-2"><Calendar className="w-4 h-4" /><span>{new Date(guide.created_at).toLocaleString()}</span></div>
              </div>
              <div className="flex items-center gap-4">
                 <div className="flex items-center gap-2">
                    <StarRating key={`avg-${(uiAverage ?? aiModel.average_rating)}-${(uiCount ?? aiModel.rating_count)}`} rating={Number(uiAverage ?? aiModel.average_rating) || 0} size={16} readOnly />
                    <span className="font-semibold text-sm text-foreground">
                        {(Number(uiAverage ?? aiModel.average_rating) || 0).toFixed(1)}
                    </span>
                    <span className="text-sm text-muted-foreground">
                        ({(uiCount ?? aiModel.rating_count) || 0} ratings)
                    </span>
                </div>
                <Button variant="outline" size="sm" onClick={() => setIsModalOpen(true)}>
                  <Star className="w-4 h-4 mr-2" />Rate this AI
                </Button>
              </div>
            </div>
          </header>
          
          <div className="aspect-video w-full bg-muted rounded-lg mb-8 overflow-hidden">
            <img src={guide.image_url || "/placeholder.svg"} alt={guide.title} className="w-full h-full object-cover" />
          </div>
          
          <div className={cn("prose dark:prose-invert max-w-none")}>
            <ReactMarkdown remarkPlugins={[remarkGfm]}>{guide.content || ""}</ReactMarkdown>
          </div>
        </article>
      </main>
      <Footer />

      <Dialog open={isModalOpen} onOpenChange={setIsModalOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{aiModel?.name}</DialogTitle>
            <DialogDescription>Please leave a rating for this AI tool!</DialogDescription>
          </DialogHeader>
          <div className="py-4">
            <h3 className="text-lg font-medium mb-2 text-center">My Rating</h3>
            <div className="flex justify-center">
              <StarRating rating={currentRating} size={32} onRate={handleRate} readOnly={!user || rateMutation.isPending} />
            </div>
            {rateMutation.isPending && <p className="text-center text-sm text-muted-foreground mt-2">Submitting rating...</p>}
            {!user && (
              <p className="text-center text-sm text-muted-foreground mt-4">
                <Link to="/auth" className="text-primary underline">Log in</Link> to leave a rating.
              </p>
            )}
          </div>
          <DialogFooter><Button onClick={() => setIsModalOpen(false)}>Close</Button></DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
};

export default GuideDetail;