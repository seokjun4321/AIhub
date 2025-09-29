import { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { supabase } from '@/integrations/supabase/client';
import { useAuth } from '@/hooks/useAuth';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogFooter } from '@/components/ui/dialog';
import { Input } from '@/components/ui/input';
import { Skeleton } from '@/components/ui/skeleton';
import StarRating from '@/components/ui/StarRating';
import { 
  Star, 
  ExternalLink, 
  BookOpen, 
  MessageSquare, 
  Heart,
  Share2,
  ArrowLeft,
  CheckCircle,
  XCircle,
  DollarSign,
  Zap,
  Shield,
  Target,
  Lightbulb,
  Users,
  UserCircle,
  Search,
  FileText,
  Presentation,
  Globe
} from 'lucide-react';
import Navbar from '@/components/ui/navbar';
import { toast } from '@/hooks/use-toast';

interface AIModel {
  id: number;
  name: string;
  description: string | null;
  provider: string | null;
  model_type?: string | null;
  pricing_info?: string | null;
  features?: string[] | null;
  use_cases?: string[] | null;
  limitations?: string[] | null;
  website_url?: string | null;
  api_documentation_url?: string | null;
  average_rating: number;
  rating_count: number;
  logo_url?: string | null;
  created_at: string;
  updated_at: string;
  version?: string;
}

interface Rating {
  id: number;
  user_id: string;
  ai_model_id: number;
  rating: number;
  review: string | null;
  created_at: string;
  profiles: {
    username: string;
    avatar_url: string | null;
  };
}

const ToolDetail = () => {
  const { id } = useParams<{ id: string }>();
  const { user } = useAuth();
  const queryClient = useQueryClient();
  const [userRating, setUserRating] = useState(0);
  const [userReview, setUserReview] = useState('');
  const [isSubmittingReview, setIsSubmittingReview] = useState(false);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [currentRating, setCurrentRating] = useState(0);
  const [uiAverage, setUiAverage] = useState<number | null>(null);
  const [uiCount, setUiCount] = useState<number | null>(null);
  const [searchQuery, setSearchQuery] = useState("");

  // AI 모델 상세 정보 가져오기
  const { data: aiModel, isLoading: modelLoading } = useQuery({
    queryKey: ['aiModel', id],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('ai_models')
        .select('*')
        .eq('id', parseInt(id!))
        .single();
      
      if (error) throw error;
      return data as any;
    },
    enabled: !!id,
  });

  // 리뷰 목록 가져오기
  const { data: ratings, isLoading: ratingsLoading } = useQuery({
    queryKey: ['ratings', id],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('ratings')
        .select(`
          *,
          profiles:user_id (
            username,
            avatar_url
          )
        `)
        .eq('ai_model_id', parseInt(id!))
        .order('created_at', { ascending: false });
      
      if (error) throw error;
      return data as any;
    },
    enabled: !!id,
  });

  // 사용자 리뷰 가져오기
  const { data: userRatingData } = useQuery({
    queryKey: ['userRating', id, user?.id],
    queryFn: async () => {
      if (!user) return null;
      const { data, error } = await supabase
        .from('ratings')
        .select('*')
        .eq('ai_model_id', parseInt(id!))
        .eq('user_id', user.id)
        .single();
      
      if (error && error.code !== 'PGRST116') throw error;
      return data as any;
    },
    enabled: !!id && !!user,
  });

  // 리뷰 제출 뮤테이션
  const submitReviewMutation = useMutation({
    mutationFn: async ({ rating, review }: { rating: number; review: string }) => {
      if (!user) throw new Error('로그인이 필요합니다');
      
      const { data, error } = await supabase
        .from('ratings')
        .upsert({
          user_id: user.id,
          ai_model_id: parseInt(id!),
          rating,
          review: review || null,
        })
        .select()
        .single();
      
      if (error) throw error;
      return data;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['ratings', id] });
      queryClient.invalidateQueries({ queryKey: ['aiModel', id] });
      queryClient.invalidateQueries({ queryKey: ['userRating', id, user?.id] });
      toast({
        title: "리뷰가 등록되었습니다",
        description: "소중한 의견 감사합니다!",
      });
      setIsSubmittingReview(false);
    },
    onError: (error) => {
      toast({
        title: "리뷰 등록 실패",
        description: error.message,
        variant: "destructive",
      });
      setIsSubmittingReview(false);
    },
  });

  // 서버 데이터 변경 시 표시값 동기화
  useEffect(() => {
    if (aiModel) {
      setUiAverage(Number(aiModel.average_rating) || 0);
      setUiCount(Number(aiModel.rating_count) || 0);
    }
  }, [aiModel?.average_rating, aiModel?.rating_count]);

  // 사용자 리뷰 데이터가 로드되면 상태 업데이트
  useEffect(() => {
    if (userRatingData) {
      setUserRating(userRatingData.rating);
      setUserReview(userRatingData.review || '');
      setCurrentRating(userRatingData.rating);
    }
  }, [userRatingData]);

  const handleSubmitReview = async () => {
    if (!user) {
      toast({
        title: "로그인이 필요합니다",
        description: "리뷰를 작성하려면 로그인해주세요.",
        variant: "destructive",
      });
      return;
    }

    if (userRating === 0) {
      toast({
        title: "평점을 선택해주세요",
        description: "1점부터 5점까지 평점을 선택해주세요.",
        variant: "destructive",
      });
      return;
    }

    if (userReview.length < 10) {
      toast({
        title: "리뷰 내용이 너무 짧습니다",
        description: "최소 10자 이상 작성해주세요.",
        variant: "destructive",
      });
      return;
    }

    setIsSubmittingReview(true);
    submitReviewMutation.mutate({ rating: userRating, review: userReview });
  };

  // 평점 제출 뮤테이션
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
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['aiModel', id] });
      queryClient.invalidateQueries({ queryKey: ['ratings', id] });
      queryClient.invalidateQueries({ queryKey: ['userRating', id, user?.id] });
      toast({
        title: "평점이 등록되었습니다!",
        description: "소중한 의견 감사합니다.",
      });
    },
    onError: (error) => {
      toast({
        title: "오류가 발생했습니다",
        description: error.message,
        variant: "destructive",
      });
    },
  });

  const handleRate = (rating: number) => {
    setCurrentRating(rating);
    rateMutation.mutate({ rating });
  };

  // AI 도구별 실제 요금 정보
  const getPricingPlans = (modelName: string) => {
    switch (modelName) {
      case 'ChatGPT':
        return [
          { name: '무료', price: '$0/월' },
          { name: 'Plus', price: '$20/월' },
          { name: 'Team', price: '$25/월' }
        ];
      case 'Gemini':
        return [
          { name: '무료', price: '$0/월' },
          { name: '스타터', price: '$8.4/월' },
          { name: '고급', price: '₩29,000/월' }
        ];
      case 'Midjourney':
        return [
          { name: '기본', price: '$10/월' },
          { name: '표준', price: '$30/월' },
          { name: '프로', price: '$60/월' }
        ];
      case 'DALL-E':
        return [
          { name: 'ChatGPT Plus', price: '$20/월' },
          { name: 'API', price: '$0.04-0.08/이미지' }
        ];
      case 'Adobe Firefly':
        return [
          { name: '스탠다드', price: '$9.99/월' },
          { name: '프로', price: '$29.99/월' },
          { name: '엔터프라이즈', price: '$199.99/월' }
        ];
      case 'Stable Diffusion':
        return [
          { name: '오픈소스', price: '무료' },
          { name: 'DreamStudio', price: '$8.33/월' }
        ];
      case 'Notion AI':
        return [
          { name: '무료 시작', price: '$0/월' },
          { name: '개인', price: '$10/월' },
          { name: '팀', price: '$20-24/월' }
        ];
      case 'Grammarly':
        return [
          { name: '무료', price: '$0/월' },
          { name: '프리미엄', price: '$12/월' },
          { name: '월간', price: '$30/월' }
        ];
      case 'Jasper':
        return [
          { name: '크리에이터', price: '$39-49/월' },
          { name: '팀', price: '$125/월' }
        ];
      case 'Copy.ai':
        return [
          { name: '무료 체험', price: '$0/월' },
          { name: '프로', price: '$35/월' },
          { name: '월간', price: '$49/월' }
        ];
      case 'GitHub Copilot':
        return [
          { name: '개인', price: '$10/월' },
          { name: '비즈니스', price: '$19/월' }
        ];
      case 'Replit':
        return [
          { name: '무료 시작', price: '$0/월' },
          { name: '코어', price: '$20/월' },
          { name: '팀', price: '$40/월' }
        ];
      case 'Tabnine':
        return [
          { name: '무료 플랜', price: '$0/월' },
          { name: '프로', price: '$9/월' },
          { name: '엔터프라이즈', price: '$39/월' }
        ];
      case 'Synthesia':
        return [
          { name: '스타터', price: '$22/월' },
          { name: '크리에이터', price: '$67/월' }
        ];
      case 'ElevenLabs':
        return [
          { name: '스타터', price: '$4.17/월' },
          { name: '크리에이터', price: '$11/월' },
          { name: '프로', price: '$82.5/월' }
        ];
      case 'Suno':
        return [
          { name: '무료 플랜', price: '$0/월' },
          { name: '프로', price: '$10/월' },
          { name: '프리미엄', price: '$30/월' }
        ];
      case 'Zapier':
        return [
          { name: '무료 플랜', price: '$0/월' },
          { name: '스타터', price: '$29.99/월' },
          { name: '프로', price: '$79/월' }
        ];
      case 'Canva':
        return [
          { name: '무료 플랜', price: '$0/월' },
          { name: '프로', price: '$12.99/월' },
          { name: '엔터프라이즈', price: '별도 문의' }
        ];
      default:
        return [
          { name: '무료', price: '$0/월' },
          { name: '프로', price: '$29/월' }
        ];
    }
  };

  const pricingPlans = getPricingPlans(aiModel?.name || '');

  const renderSkeleton = () => (
    <div className="space-y-8">
      <div className="flex items-center gap-4 mb-8">
        <Skeleton className="w-8 h-8" />
        <Skeleton className="h-8 w-32" />
      </div>
      
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <div className="lg:col-span-2 space-y-6">
          <Card>
            <CardHeader>
              <div className="flex items-center gap-4">
                <Skeleton className="w-16 h-16 rounded-lg" />
                <div className="flex-1">
                  <Skeleton className="h-8 w-48 mb-2" />
                  <Skeleton className="h-4 w-32" />
                </div>
              </div>
            </CardHeader>
            <CardContent>
              <Skeleton className="h-4 w-full mb-2" />
              <Skeleton className="h-4 w-3/4 mb-4" />
              <div className="flex gap-2">
                <Skeleton className="h-6 w-16" />
                <Skeleton className="h-6 w-20" />
                <Skeleton className="h-6 w-14" />
              </div>
            </CardContent>
          </Card>
        </div>
        
        <div className="space-y-6">
          <Skeleton className="h-32 w-full" />
          <Skeleton className="h-48 w-full" />
        </div>
      </div>
    </div>
  );

  if (modelLoading) {
    return (
      <div className="min-h-screen bg-background">
        <Navbar />
        <main className="pt-24 pb-12">
          <div className="container mx-auto px-6">
            {renderSkeleton()}
          </div>
        </main>
      </div>
    );
  }

  if (!aiModel) {
    return (
      <div className="min-h-screen bg-background">
        <Navbar />
        <main className="pt-24 pb-12">
          <div className="container mx-auto px-6">
            <div className="text-center py-12">
              <h1 className="text-2xl font-bold mb-4">AI 도구를 찾을 수 없습니다</h1>
              <p className="text-muted-foreground mb-6">
                요청하신 AI 도구가 존재하지 않거나 삭제되었습니다.
              </p>
              <Button asChild>
                <Link to="/tools">AI 도구 목록으로 돌아가기</Link>
              </Button>
            </div>
          </div>
        </main>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <Navbar />
      <main className="pt-24 pb-12">
        <div className="container mx-auto px-6 max-w-7xl">
          {/* 상단 섹션 - 로고, 제목, 액션 버튼 */}
          <div className="bg-white rounded-xl shadow-sm border p-8 mb-8">
            {/* 긴 텍스트에서도 레이아웃이 무너지지 않도록 반응형/비축소 처리 */}
            <div className="flex flex-col md:flex-row items-start justify-between gap-6">
              <div className="flex items-center gap-6">
                <div className="w-16 h-16 flex items-center justify-center">
                  {aiModel.logo_url ? (
                    <img src={aiModel.logo_url} alt={aiModel.name} className="w-16 h-16 object-contain" />
                  ) : (
                    <Globe className="w-16 h-16 text-gray-600" />
                  )}
                </div>
                <div className="min-w-0">
                  <h1 className="text-3xl font-bold text-gray-900 mb-2">{aiModel.name}</h1>
                  <p className="text-lg text-gray-600 mb-4">{aiModel.description || '설명이 없습니다.'}</p>
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
              <div className="flex items-center gap-4 md:self-start shrink-0 w-full md:w-auto justify-between md:justify-end">
                <div className="flex items-center gap-3 bg-gray-50 px-4 py-2 rounded-lg min-w-[200px] shrink-0">
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

          {/* 탭 섹션 */}
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
            <div className="lg:col-span-8 space-y-6">
              <Tabs defaultValue="overview" className="w-full">
                <TabsList className="grid w-full grid-cols-4 md:grid-cols-4 overflow-x-auto no-scrollbar gap-1">
                  <TabsTrigger value="overview">개요</TabsTrigger>
                  <TabsTrigger value="usecases">가이드북</TabsTrigger>
                  <TabsTrigger value="reviews">리뷰·Q&A</TabsTrigger>
                  <TabsTrigger value="stats">통계</TabsTrigger>
                </TabsList>

                <TabsContent value="overview" className="mt-6">
                  <div className="space-y-6">
                    {/* 가격 및 출시사 정보 */}
                    <Card>
                      <CardHeader>
                        <CardTitle className="flex items-center gap-2">
                          <Target className="w-5 h-5" />
                          가격 및 정보
                        </CardTitle>
                      </CardHeader>
                      <CardContent>
                        <div className={`grid gap-4 mb-4 ${pricingPlans.length === 2 ? 'grid-cols-2' : 'grid-cols-3'}`}>
                          {pricingPlans.map((plan, index) => (
                            <div key={index} className="text-center p-4 bg-gray-50 rounded-lg">
                              <div className={`font-bold text-lg ${
                                plan.name.includes('무료') || plan.name.includes('Free') ? 'text-green-600' :
                                plan.name.includes('Pro') || plan.name.includes('프로') ? 'text-blue-600' :
                                plan.name.includes('Team') || plan.name.includes('팀') ? 'text-purple-600' :
                                'text-gray-600'
                              }`}>
                                {plan.name}
                              </div>
                              <div className="text-sm text-gray-600">{plan.price}</div>
                            </div>
                          ))}
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

                    {/* 주요 기능 */}
                    <Card>
                      <CardHeader>
                        <CardTitle className="flex items-center gap-2"><Zap className="w-5 h-5" />주요 기능</CardTitle>
                      </CardHeader>
                      <CardContent>
                        {aiModel.features && aiModel.features.length > 0 ? (
                          <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                            {aiModel.features.map((feature, index) => (
                              <div key={index} className="flex items-center gap-2">
                                <CheckCircle className="w-4 h-4 text-green-500" />
                                <span>{feature}</span>
                              </div>
                            ))}
                          </div>
                        ) : (
                          <p className="text-muted-foreground">기능 정보가 없습니다.</p>
                        )}
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
                </TabsContent>

                <TabsContent value="usecases" className="mt-6">
                  <Card>
                    <CardHeader>
                      <CardTitle className="flex items-center gap-2"><BookOpen className="w-5 h-5" />가이드북</CardTitle>
                    </CardHeader>
                    <CardContent>
                      {aiModel.use_cases && aiModel.use_cases.length > 0 ? (
                        <div className="space-y-3">
                          {aiModel.use_cases.map((useCase, index) => (
                            <div key={index} className="flex items-start gap-3 p-3 bg-muted/50 rounded-lg">
                              <div className="w-6 h-6 bg-primary text-primary-foreground rounded-full flex items-center justify-center text-sm font-medium">{index + 1}</div>
                              <span>{useCase}</span>
                            </div>
                          ))}
                        </div>
                      ) : (
                        <p className="text-muted-foreground">가이드북 정보가 없습니다.</p>
                      )}
                    </CardContent>
                  </Card>
                </TabsContent>


                <TabsContent value="reviews" className="mt-6 space-y-6">
                  {user && (
                    <Card className="border-primary/20">
                      <CardHeader>
                        <CardTitle className="flex items-center gap-2"><MessageSquare className="w-5 h-5 text-primary" />리뷰 작성하기</CardTitle>
                        <p className="text-sm text-muted-foreground">{aiModel.name}에 대한 솔직한 리뷰를 작성해주세요. 다른 사용자들에게 도움이 됩니다.</p>
                      </CardHeader>
                      <CardContent className="space-y-6">
                        <div>
                          <label className="text-sm font-medium mb-3 block" htmlFor="rating-stars">평점 *</label>
                          <div className="flex items-center gap-2">
                            <div className="flex gap-1" id="rating-stars" aria-label="평점 선택">
                              {Array.from({ length: 5 }).map((_, i) => (
                                <button aria-label={`${i + 1}점 선택`} key={i} onClick={() => setUserRating(i + 1)} className={`p-1 transition-all duration-200 hover:scale-110 ${i < userRating ? 'text-yellow-400' : 'text-gray-300 hover:text-yellow-300'}`}>
                                  <Star className="w-8 h-8 fill-current" />
                                </button>
                              ))}
                            </div>
                            <div className="ml-4">
                              <span className="text-lg font-semibold">{userRating > 0 ? `${userRating}점` : '평점을 선택해주세요'}</span>
                            </div>
                          </div>
                        </div>
                        <div>
                          <label className="text-sm font-medium mb-3 block">리뷰 내용 *</label>
                          <textarea value={userReview} onChange={(e) => setUserReview(e.target.value)} placeholder="이 AI 도구를 사용해보신 경험을 자세히 공유해주세요..." className="w-full p-4 border rounded-lg resize-none h-32 focus:ring-2 focus:ring-primary focus:border-transparent transition-all" maxLength={500} />
                          <div className="flex justify-between items-center mt-2">
                            <div className="flex items-center gap-4 text-xs text-muted-foreground">
                              <span className={userReview.length >= 10 ? 'text-green-600' : ''}>✓ 최소 10자 이상</span>
                              <span className={userReview.length >= 50 ? 'text-green-600' : ''}>✓ 상세한 리뷰 (50자 이상 권장)</span>
                            </div>
                            <span className={`text-xs ${userReview.length > 450 ? 'text-orange-600' : 'text-muted-foreground'}`}>{userReview.length}/500자</span>
                          </div>
                        </div>
                        <div className="flex gap-3">
                          <Button onClick={handleSubmitReview} disabled={isSubmittingReview || userRating === 0 || userReview.length < 10} className="flex-1 h-12 text-base" size="lg">
                            {isSubmittingReview ? (<><div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin mr-2" />등록 중...</>) : (<><MessageSquare className="w-4 h-4 mr-2" />리뷰 등록하기</>)}
                          </Button>
                          {userRatingData && (
                            <Button variant="outline" onClick={() => { setUserRating(0); setUserReview(''); }} className="h-12">초기화</Button>
                          )}
                        </div>
                      </CardContent>
                    </Card>
                  )}

                  <Card>
                    <CardHeader>
                      <CardTitle className="flex items-center gap-2"><MessageSquare className="w-5 h-5" />사용자 리뷰 ({ratings?.length || 0})</CardTitle>
                    </CardHeader>
                    <CardContent>
                      {ratingsLoading ? (
                        <div className="space-y-4">
                          {Array.from({ length: 3 }).map((_, i) => (
                            <div key={i} className="flex gap-3">
                              <Skeleton className="w-10 h-10 rounded-full" />
                              <div className="flex-1 space-y-2">
                                <Skeleton className="h-4 w-24" />
                                <Skeleton className="h-4 w-full" />
                                <Skeleton className="h-4 w-3/4" />
                              </div>
                            </div>
                          ))}
                        </div>
                      ) : ratings && ratings.length > 0 ? (
                        <div className="space-y-6">
                          {ratings.map((rating) => (
                            <div key={rating.id} className="border-b pb-4 last:border-b-0">
                              <div className="flex items-start gap-3">
                                <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white font-medium">
                                  {rating.profiles.avatar_url ? (
                                    <img src={rating.profiles.avatar_url} alt={rating.profiles.username} className="w-10 h-10 rounded-full object-cover" />
                                  ) : (
                                    rating.profiles.username.charAt(0).toUpperCase()
                                  )}
                                </div>
                                <div className="flex-1">
                                  <div className="flex items-center gap-2 mb-1">
                                    <span className="font-medium">{rating.profiles.username}</span>
                                    <div className="flex items-center gap-1">
                                      {Array.from({ length: 5 }).map((_, i) => (
                                        <Star key={i} className={`w-4 h-4 ${i < rating.rating ? 'fill-yellow-400 text-yellow-400' : 'text-gray-300'}`} />
                                      ))}
                                    </div>
                                    <span className="text-sm text-muted-foreground">{new Date(rating.created_at).toLocaleDateString()}</span>
                                  </div>
                                  {rating.review && (<p className="text-muted-foreground">{rating.review}</p>)}
                                </div>
                              </div>
                            </div>
                          ))}
                        </div>
                      ) : (
                        <div className="text-center py-8">
                          <div className="w-16 h-16 bg-muted rounded-full flex items-center justify-center mx-auto mb-4">
                            <MessageSquare className="w-8 h-8 text-muted-foreground" />
                          </div>
                          <h3 className="text-lg font-semibold mb-2">아직 리뷰가 없습니다</h3>
                          <p className="text-muted-foreground mb-4">이 AI 도구를 사용해보신 첫 번째 리뷰어가 되어주세요!</p>
                          {!user && (<Button asChild><Link to="/auth">로그인하고 리뷰 작성하기</Link></Button>)}
                        </div>
                      )}
                    </CardContent>
                  </Card>
                </TabsContent>

                <TabsContent value="stats" className="mt-6">
                  <Card>
                    <CardHeader>
                      <CardTitle>통계 정보</CardTitle>
                    </CardHeader>
                    <CardContent className="space-y-4">
                      <div className="flex items-center justify-between"><span className="text-sm text-muted-foreground">평균 평점</span><span className="font-semibold">{aiModel.average_rating.toFixed(1)}/5</span></div>
                      <div className="flex items-center justify-between"><span className="text-sm text-muted-foreground">총 리뷰 수</span><span className="font-semibold">{aiModel.rating_count}개</span></div>
                      <div className="flex items-center justify-between"><span className="text-sm text-muted-foreground">등록일</span><span className="font-semibold">{new Date(aiModel.created_at).toLocaleDateString()}</span></div>
                      <div className="flex items-center justify-between"><span className="text-sm text-muted-foreground">업데이트</span><span className="font-semibold">{new Date(aiModel.updated_at).toLocaleDateString()}</span></div>
                    </CardContent>
                  </Card>
                </TabsContent>
              </Tabs>
            </div>

            {/* 오른쪽 사이드바 */}
            <aside className="lg:col-span-4 space-y-6">
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
            </aside>
          </div>
        </div>
      </main>

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

export default ToolDetail;
