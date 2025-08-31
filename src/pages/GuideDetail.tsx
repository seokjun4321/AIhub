import { useState, useEffect } from "react";
import { useParams, Link } from "react-router-dom";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { Skeleton } from "@/components/ui/skeleton";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogFooter } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import StarRating from "@/components/ui/StarRating";
import { useAuth } from "@/hooks/useAuth";
import { toast } from "sonner";
import { UserCircle, Calendar, Star, Search, ArrowRight, CheckCircle, XCircle, BookOpen, Presentation, FileText, Globe, Users, Zap, Target, Lightbulb } from "lucide-react";
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
  const [searchQuery, setSearchQuery] = useState("");
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
    <div className="min-h-screen bg-gray-50">
      <Navbar />
      <main className="pt-24 pb-12">
        <div className="container mx-auto px-6 max-w-7xl">
          {/* 상단 섹션 - 로고, 제목, 액션 버튼 */}
          <div className="bg-white rounded-xl shadow-sm border p-8 mb-8">
            <div className="flex items-start justify-between">
              <div className="flex items-center gap-6">
                <div className="w-16 h-16 bg-gradient-to-br from-green-400 to-green-600 rounded-xl flex items-center justify-center">
                  <Globe className="w-8 h-8 text-white" />
                </div>
                <div>
                  <h1 className="text-3xl font-bold text-gray-900 mb-2">{aiModel.name}</h1>
                  <p className="text-lg text-gray-600 mb-4">{guide.description}</p>
                  <div className="flex items-center gap-4">
                    <Button className="bg-blue-600 hover:bg-blue-700 text-white">
                      바로 사용해보기
                    </Button>
                    <Button variant="outline" className="border-blue-600 text-blue-600 hover:bg-blue-50">
                      공식 사이트 가기
                    </Button>
                  </div>
                </div>
              </div>
                              <div className="flex items-center gap-4">
                  <div className="flex items-center gap-3 bg-gray-50 px-4 py-2 rounded-lg">
                    <div className="flex items-center gap-2">
                      <StarRating key={`avg-${(uiAverage ?? aiModel.average_rating)}-${(uiCount ?? aiModel.rating_count)}`} rating={Number(uiAverage ?? aiModel.average_rating) || 0} size={20} readOnly />
                      <span className="font-bold text-lg text-gray-900">
                        {(Number(uiAverage ?? aiModel.average_rating) || 0).toFixed(1)}
                      </span>
                    </div>
                    <div className="text-sm text-gray-600">
                      <div className="font-medium">{(uiCount ?? aiModel.rating_count) || 0}개의 평가</div>
                      <div className="text-xs">사용자 평점</div>
                    </div>
                  </div>
                  <Button 
                    className="bg-yellow-500 hover:bg-yellow-600 text-white border-0" 
                    size="sm" 
                    onClick={() => setIsModalOpen(true)}
                  >
                    <Star className="w-4 h-4 mr-2" />평점 남기기
                  </Button>
                </div>
            </div>
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
            {/* 왼쪽 컬럼 */}
            <div className="lg:col-span-2 space-y-8">
              {/* 가격 및 출시사 정보 */}
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Target className="w-5 h-5" />
                    가격 및 정보
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="grid grid-cols-3 gap-4 mb-4">
                    <div className="text-center p-4 bg-gray-50 rounded-lg">
                      <div className="font-bold text-lg text-green-600">무료</div>
                      <div className="text-sm text-gray-600">$0/월</div>
                    </div>
                    <div className="text-center p-4 bg-gray-50 rounded-lg">
                      <div className="font-bold text-lg text-blue-600">Pro</div>
                      <div className="text-sm text-gray-600">$20/월</div>
                    </div>
                    <div className="text-center p-4 bg-gray-50 rounded-lg">
                      <div className="font-bold text-lg text-purple-600">Team</div>
                      <div className="text-sm text-gray-600">$25/월</div>
                    </div>
                  </div>
                  <div className="flex items-center justify-between">
                    <div className="text-sm text-gray-600">
                      <span className="font-medium">출시사:</span> {aiModel.provider || 'Unknown'}
                    </div>
                    <div className="text-sm text-gray-600">
                      <span className="font-medium">특징:</span> 한국어 지원, 앱 제공
                    </div>
                  </div>
                </CardContent>
              </Card>

              {/* 사용법 튜토리얼 */}
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <BookOpen className="w-5 h-5" />
                    사용법 (튜토리얼!)
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    <div className="flex items-start gap-3">
                      <div className="w-6 h-6 bg-blue-600 text-white rounded-full flex items-center justify-center text-sm font-bold">1</div>
                      <div>
                        <p className="font-medium">계정 생성 후 로그인</p>
                        <p className="text-sm text-gray-600">AI 모델 공식 사이트에서 계정을 만들고 로그인합니다.</p>
                      </div>
                    </div>
                    <div className="flex items-start gap-3">
                      <div className="w-6 h-6 bg-blue-600 text-white rounded-full flex items-center justify-center text-sm font-bold">2</div>
                      <div>
                        <p className="font-medium">첫 프롬프트 작성하기</p>
                        <p className="text-sm text-gray-600">원하는 작업에 대한 구체적인 프롬프트를 작성합니다.</p>
                      </div>
                    </div>
                    <div className="flex items-start gap-3">
                      <div className="w-6 h-6 bg-blue-600 text-white rounded-full flex items-center justify-center text-sm font-bold">3</div>
                      <div>
                        <p className="font-medium">프롬프트 최적화</p>
                        <p className="text-sm text-gray-600">더 나은 결과를 위해 프롬프트를 개선하고 반복합니다.</p>
                      </div>
                    </div>
                    <div className="flex items-start gap-3">
                      <div className="w-6 h-6 bg-blue-600 text-white rounded-full flex items-center justify-center text-sm font-bold">4</div>
                      <div>
                        <p className="font-medium">실용적 활용</p>
                        <p className="text-sm text-gray-600">보고서, PPT, 코드 작성 등 다양한 작업에 활용합니다.</p>
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>

              {/* 실용적 예시 */}
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Lightbulb className="w-5 h-5" />
                    실용적 예시
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div className="flex items-center gap-3 p-4 bg-gray-50 rounded-lg">
                      <FileText className="w-8 h-8 text-blue-600" />
                      <div>
                        <p className="font-medium">번역 및 문서 작성</p>
                        <p className="text-sm text-gray-600">DeepL과 함께 활용하여 고품질 번역</p>
                      </div>
                    </div>
                    <div className="flex items-center gap-3 p-4 bg-gray-50 rounded-lg">
                      <Presentation className="w-8 h-8 text-green-600" />
                      <div>
                        <p className="font-medium">PPT 및 프레젠테이션</p>
                        <p className="text-sm text-gray-600">Canva와 연동하여 멋진 슬라이드 제작</p>
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>

              {/* 추천 대체 도구 */}
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Users className="w-5 h-5" />
                    추천 대체 도구
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    <div className="relative">
                      <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-4 h-4" />
                      <Input
                        placeholder="AI 도구를 검색해보세요..."
                        value={searchQuery}
                        onChange={(e) => setSearchQuery(e.target.value)}
                        className="pl-10"
                      />
                    </div>
                    <Button className="w-full bg-blue-600 hover:bg-blue-700 text-white">
                      바로 사용해보기
                    </Button>
                  </div>
                </CardContent>
              </Card>
            </div>

            {/* 오른쪽 컬럼 */}
            <div className="space-y-8">
              {/* 장단점 */}
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Zap className="w-5 h-5" />
                    장단점 분석
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    <div>
                      <h4 className="font-medium text-green-600 mb-2 flex items-center gap-2">
                        <CheckCircle className="w-4 h-4" />
                        장점
                      </h4>
                      <ul className="space-y-1 text-sm text-gray-600">
                        <li>• 빠른 응답 속도</li>
                        <li>• 깊이 있는 분석</li>
                        <li>• 다양한 언어 지원</li>
                        <li>• 사용자 친화적 인터페이스</li>
                      </ul>
                    </div>
                    <div>
                      <h4 className="font-medium text-red-600 mb-2 flex items-center gap-2">
                        <XCircle className="w-4 h-4" />
                        단점
                      </h4>
                      <ul className="space-y-1 text-sm text-gray-600">
                        <li>• 최신 정보 부족</li>
                        <li>• 무료 버전 제한</li>
                        <li>• 인터넷 연결 필요</li>
                      </ul>
                    </div>
                  </div>
                </CardContent>
              </Card>

              {/* AI 도구 비교 */}
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Target className="w-5 h-5" />
                    AI 도구 비교
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    <div className="grid grid-cols-3 gap-2 text-xs font-medium text-gray-600">
                      <div>도구</div>
                      <div>장점</div>
                      <div>단점</div>
                    </div>
                    <div className="grid grid-cols-3 gap-2 text-sm">
                      <div className="font-medium">Claude</div>
                      <div className="text-green-600">최신 정보</div>
                      <div className="text-red-600">-</div>
                    </div>
                    <div className="grid grid-cols-3 gap-2 text-sm">
                      <div className="font-medium">Gemini</div>
                      <div className="text-green-600">무료</div>
                      <div className="text-red-600">제한적</div>
                    </div>
                    <div className="grid grid-cols-3 gap-2 text-sm">
                      <div className="font-medium">Perplexity</div>
                      <div className="text-green-600">실시간</div>
                      <div className="text-red-600">불안정</div>
                    </div>
                  </div>
                </CardContent>
              </Card>

              {/* 별점 및 평가 */}
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Star className="w-5 h-5 text-yellow-500" />
                    별점 및 평가
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    <div className="text-center">
                      <div className="flex justify-center mb-2">
                        <StarRating 
                          key={`sidebar-${(uiAverage ?? aiModel.average_rating)}-${(uiCount ?? aiModel.rating_count)}`} 
                          rating={Number(uiAverage ?? aiModel.average_rating) || 0} 
                          size={24} 
                          readOnly 
                        />
                      </div>
                      <div className="text-2xl font-bold text-gray-900 mb-1">
                        {(Number(uiAverage ?? aiModel.average_rating) || 0).toFixed(1)}
                      </div>
                      <div className="text-sm text-gray-600 mb-3">
                        {(uiCount ?? aiModel.rating_count) || 0}개의 평가
                      </div>
                      <Button 
                        className="w-full bg-yellow-500 hover:bg-yellow-600 text-white" 
                        onClick={() => setIsModalOpen(true)}
                      >
                        <Star className="w-4 h-4 mr-2" />
                        내 평점 남기기
                      </Button>
                    </div>
                    
                    {/* 별점 분포 */}
                    <div className="space-y-2">
                      <div className="flex items-center gap-2">
                        <span className="text-xs text-gray-600 w-8">5점</span>
                        <div className="flex-1 bg-gray-200 rounded-full h-2">
                          <div className="bg-yellow-500 h-2 rounded-full" style={{width: '70%'}}></div>
                        </div>
                        <span className="text-xs text-gray-600 w-8">70%</span>
                      </div>
                      <div className="flex items-center gap-2">
                        <span className="text-xs text-gray-600 w-8">4점</span>
                        <div className="flex-1 bg-gray-200 rounded-full h-2">
                          <div className="bg-yellow-500 h-2 rounded-full" style={{width: '20%'}}></div>
                        </div>
                        <span className="text-xs text-gray-600 w-8">20%</span>
                      </div>
                      <div className="flex items-center gap-2">
                        <span className="text-xs text-gray-600 w-8">3점</span>
                        <div className="flex-1 bg-gray-200 rounded-full h-2">
                          <div className="bg-yellow-500 h-2 rounded-full" style={{width: '7%'}}></div>
                        </div>
                        <span className="text-xs text-gray-600 w-8">7%</span>
                      </div>
                      <div className="flex items-center gap-2">
                        <span className="text-xs text-gray-600 w-8">2점</span>
                        <div className="flex-1 bg-gray-200 rounded-full h-2">
                          <div className="bg-yellow-500 h-2 rounded-full" style={{width: '2%'}}></div>
                        </div>
                        <span className="text-xs text-gray-600 w-8">2%</span>
                      </div>
                      <div className="flex items-center gap-2">
                        <span className="text-xs text-gray-600 w-8">1점</span>
                        <div className="flex-1 bg-gray-200 rounded-full h-2">
                          <div className="bg-yellow-500 h-2 rounded-full" style={{width: '1%'}}></div>
                        </div>
                        <span className="text-xs text-gray-600 w-8">1%</span>
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>

              {/* 사용자 피드백 */}
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <UserCircle className="w-5 h-5" />
                    사용자 피드백
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-3">
                    <div className="flex items-start gap-3">
                      <div className="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center">
                        <UserCircle className="w-4 h-4 text-blue-600" />
                      </div>
                      <div>
                        <div className="flex items-center gap-1 mb-1">
                          <StarRating rating={5} size={12} readOnly />
                        </div>
                        <p className="text-sm font-medium">알바생</p>
                        <p className="text-xs text-gray-600">근무 중에도 유용하게 사용하고 있습니다!</p>
                      </div>
                    </div>
                    <div className="flex items-start gap-3">
                      <div className="w-8 h-8 bg-green-100 rounded-full flex items-center justify-center">
                        <UserCircle className="w-4 h-4 text-green-600" />
                      </div>
                      <div>
                        <div className="flex items-center gap-1 mb-1">
                          <StarRating rating={4} size={12} readOnly />
                        </div>
                        <p className="text-sm font-medium">개발자</p>
                        <p className="text-xs text-gray-600">코드 작성에 매우 도움이 됩니다.</p>
                      </div>
                    </div>
                    <div className="flex items-start gap-3">
                      <div className="w-8 h-8 bg-purple-100 rounded-full flex items-center justify-center">
                        <UserCircle className="w-4 h-4 text-purple-600" />
                      </div>
                      <div>
                        <div className="flex items-center gap-1 mb-1">
                          <StarRating rating={5} size={12} readOnly />
                        </div>
                        <p className="text-sm font-medium">학생</p>
                        <p className="text-xs text-gray-600">과제 작성할 때 정말 유용해요!</p>
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>

              {/* 프리미엄 업그레이드 */}
              <Card className="bg-gradient-to-br from-blue-600 to-blue-700 text-white">
                <CardContent className="pt-6">
                  <div className="text-center">
                    <h3 className="font-bold text-lg mb-2">프리미엄으로 업그레이드</h3>
                    <p className="text-sm text-blue-100 mb-4">더 많은 기능과 고급 AI 모델을 사용해보세요</p>
                    <Button className="w-full bg-white text-blue-600 hover:bg-gray-100">
                      프리미엄 업그레이드하기
                    </Button>
                  </div>
                </CardContent>
              </Card>
            </div>
          </div>

          {/* 가이드 상세 내용 */}
          <Card className="mt-8">
            <CardHeader>
              <CardTitle>상세 가이드</CardTitle>
            </CardHeader>
            <CardContent>
              <div className={cn("prose dark:prose-invert max-w-none")}>
                <ReactMarkdown remarkPlugins={[remarkGfm]}>{guide.content || ""}</ReactMarkdown>
              </div>
            </CardContent>
          </Card>
        </div>
      </main>
      <Footer />

      <Dialog open={isModalOpen} onOpenChange={setIsModalOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <Star className="w-5 h-5 text-yellow-500" />
              {aiModel?.name} 평점 남기기
            </DialogTitle>
            <DialogDescription>이 AI 도구에 대한 솔직한 평점을 남겨주세요!</DialogDescription>
          </DialogHeader>
          <div className="py-6">
            <div className="text-center space-y-4">
              <div className="flex justify-center">
                <StarRating 
                  rating={currentRating} 
                  size={40} 
                  onRate={handleRate} 
                  readOnly={!user || rateMutation.isPending} 
                />
              </div>
              <div className="text-lg font-medium text-gray-900">
                {currentRating > 0 ? `${currentRating}점을 선택하셨습니다` : '별점을 선택해주세요'}
              </div>
              {currentRating > 0 && (
                <div className="text-sm text-gray-600">
                  {currentRating === 5 && '매우 만족스러워요! 😍'}
                  {currentRating === 4 && '좋아요! 👍'}
                  {currentRating === 3 && '보통이에요 😊'}
                  {currentRating === 2 && '아쉬워요 😕'}
                  {currentRating === 1 && '별로예요 😞'}
                </div>
              )}
              {rateMutation.isPending && (
                <div className="flex items-center justify-center gap-2 text-sm text-blue-600">
                  <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-blue-600"></div>
                  평점을 등록하는 중...
                </div>
              )}
              {!user && (
                <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
                  <p className="text-sm text-yellow-800">
                    평점을 남기려면 <Link to="/auth" className="text-blue-600 underline font-medium">로그인</Link>이 필요합니다.
                  </p>
                </div>
              )}
            </div>
          </div>
          <DialogFooter className="flex gap-2">
            <Button variant="outline" onClick={() => setIsModalOpen(false)}>
              취소
            </Button>
            {user && (
              <Button 
                onClick={() => setIsModalOpen(false)}
                disabled={currentRating === 0 || rateMutation.isPending}
                className="bg-yellow-500 hover:bg-yellow-600 text-white"
              >
                평점 등록하기
              </Button>
            )}
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
};

export default GuideDetail;