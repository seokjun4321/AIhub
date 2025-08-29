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

// 가이드 데이터를 가져오는 함수 (연결된 AI 모델 정보도 함께 가져오도록 수정)
const fetchGuideById = async (id: string) => {
  const numericId = parseInt(id, 10);
  if (isNaN(numericId)) throw new Error("Invalid ID provided");
  const { data, error } = await supabase
    .from('guides')
    .select(`*, ai_models (*, ai_families(*))`) // ai_models와 ai_families 정보 JOIN
    .eq('id', numericId)
    .single();
  if (error) throw new Error(error.message);
  return data;
};

// 사용자의 기존 평점을 가져오는 함수
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
  const queryClient = useQueryClient();
  const { user } = useAuth();

  const { data: guide, isLoading, error } = useQuery({
    queryKey: ['guide', id],
    queryFn: () => fetchGuideById(id!),
    enabled: !!id,
  });

  const aiModel = guide?.ai_models;

  const userRatingQuery = useQuery({
    queryKey: ['userRating', aiModel?.id, user?.id],
    queryFn: () => {
      if (!user?.id || !aiModel?.id) return null;
      return fetchUserRating(aiModel.id, user.id);
    },
    enabled: !!aiModel && !!user,
  });

  useEffect(() => {
    if (userRatingQuery.data) {
      setCurrentRating(userRatingQuery.data.rating || 0);
    } else {
      setCurrentRating(0);
    }
  }, [userRatingQuery.data]);

  const rateMutation = useMutation({
    mutationFn: async ({ rating }: { rating: number }) => {
      if (!user || !aiModel) throw new Error("로그인이 필요합니다.");
      const { error } = await supabase.rpc(
        'rate_model',
        {
          model_id: aiModel.id,
          user_id: user.id,
          new_rating: rating
        }
      );
      if (error) throw new Error(error.message);
    },
    onSuccess: () => {
      toast.success("평점이 등록되었습니다!");
      // ▼▼▼ [수정됨] 쿼리 무효화 로직 변경 ▼▼▼
      // 1. 현재 가이드 페이지의 데이터를 최신화합니다.
      queryClient.invalidateQueries({ queryKey: ['guide', id] });
      // 2. 사용자의 특정 평점 정보를 최신화합니다.
      queryClient.invalidateQueries({ queryKey: ['userRating', aiModel?.id, user?.id] });
      // 3. (가장 중요) 'recommendations'로 시작하는 모든 쿼리를 무효화하여
      //    추천 페이지로 돌아갔을 때 새로운 평점이 반영되도록 합니다.
      queryClient.invalidateQueries({ queryKey: ['recommendations'] });
      // ▲▲▲ [수정됨] 여기까지 ▲▲▲
    },
    onError: (error) => {
      toast.error(`오류가 발생했습니다: ${error.message}`);
    }
  });

  const handleRate = (rating: number) => {
    setCurrentRating(rating);
    rateMutation.mutate({ rating });
  };

  if (isLoading) {
    return (
        <div className="min-h-screen">
          <Navbar />
          <main className="pt-24 container mx-auto px-6 max-w-4xl">
            <Skeleton className="h-12 w-3/4 mb-4" />
            <Skeleton className="h-6 w-1/2 mb-8" />
            <div className="flex items-center gap-8 mb-8 text-sm text-muted-foreground">
              <Skeleton className="h-5 w-24" />
              <Skeleton className="h-5 w-32" />
            </div>
            <Skeleton className="aspect-video w-full mb-8" />
            <div className="space-y-4">
              <Skeleton className="h-4 w-full" />
              <Skeleton className="h-4 w-full" />
              <Skeleton className="h-4 w-5/6" />
            </div>
          </main>
          <Footer />
        </div>
      );
  }
  if (error) { return <div>Error loading guide: {error.message}</div>; }
  if (!guide) { return <div>Guide not found.</div> }

  return (
    <div className="min-h-screen">
      <Navbar />
      <main className="pt-24 pb-12">
        <article className="container mx-auto px-6 max-w-4xl">
          <header className="mb-8">
            <Badge variant="outline" className="mb-4">{guide.category}</Badge>
            <h1 className="text-4xl md:text-5xl font-bold tracking-tight">{guide.title}</h1>
            <p className="text-xl text-muted-foreground mt-4">{guide.description}</p>
            <div className="flex flex-wrap items-center justify-between gap-4 mt-6">
              <div className="flex items-center gap-8 text-sm text-muted-foreground">
                <div className="flex items-center gap-2"><UserCircle className="w-4 h-4" /><span>by {guide.author}</span></div>
                <div className="flex items-center gap-2"><Calendar className="w-4 h-4" /><span>{new Date(guide.created_at).toLocaleString()}</span></div>
              </div>
              {aiModel && (
                <div className="flex items-center gap-4">
                  <div className="flex items-center">
                    <StarRating rating={aiModel.average_rating || 0} size={16} readOnly />
                    <span className="ml-2 text-sm text-muted-foreground">({aiModel.rating_count || 0}명)</span>
                  </div>
                  <Button variant="outline" size="sm" onClick={() => setIsModalOpen(true)}>
                    <Star className="w-4 h-4 mr-2" />이 AI 평가하기
                  </Button>
                </div>
              )}
            </div>
          </header>
          
          <div className="aspect-video w-full bg-muted rounded-lg mb-8 overflow-hidden">
            <img src={guide.imageurl || "/placeholder.svg"} alt={guide.title} className="w-full h-full object-cover" />
          </div>
          
          <div className={cn("prose dark:prose-invert max-w-none", "[&_h4]:bg-muted [&_h4]:px-6 [&_h4]:py-4 [&_h4]:rounded-t-xl", "[&_h4]:border-x [&_h4]:border-t [&_h4]:font-semibold [&_h4]:mb-0", "[&_h4+ul]:bg-card [&_h4+ul]:border-x [&_h4+ul]:border-b [&_h4+ul]:rounded-b-xl", "[&_h4+ul]:p-6 [&_h4+ul]:mt-0", "[&_h4+ul_li]:my-1")}>
            <ReactMarkdown remarkPlugins={[remarkGfm]}>{guide.content || ""}</ReactMarkdown>
          </div>
        </article>
      </main>
      <Footer />

      <Dialog open={isModalOpen} onOpenChange={setIsModalOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{aiModel?.full_name}</DialogTitle>
            <DialogDescription>이 AI 도구에 대한 평가를 남겨주세요!</DialogDescription>
          </DialogHeader>
          <div className="py-4">
            <h3 className="text-lg font-medium mb-2 text-center">내 평점</h3>
            <div className="flex justify-center">
              <StarRating rating={currentRating} size={32} onRate={handleRate} readOnly={!user || rateMutation.isPending} />
            </div>
            {rateMutation.isPending && <p className="text-center text-sm text-muted-foreground mt-2">평점을 등록 중입니다...</p>}
            {!user && (
              <p className="text-center text-sm text-muted-foreground mt-4">
                <Link to="/auth" className="text-primary underline">로그인</Link> 후 평점을 남길 수 있습니다.
              </p>
            )}
          </div>
          <DialogFooter><Button onClick={() => setIsModalOpen(false)}>닫기</Button></DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
};

export default GuideDetail;