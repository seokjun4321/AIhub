import { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { supabase } from '@/integrations/supabase/client';
import { useAuth } from '@/hooks/useAuth';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Skeleton } from '@/components/ui/skeleton';
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
  Shield
} from 'lucide-react';
import Navbar from '@/components/ui/navbar';
import { toast } from '@/hooks/use-toast';
import Rating from '@/components/ui/tool/Rating';
import { PricingPlans, PricingPlan } from '@/components/ui/tool/PricingPlans';
import { QuickActions } from '@/components/ui/tool/QuickActions';
import { MetaChips } from '@/components/ui/tool/MetaChips';
import { RelatedResources } from '@/components/ui/tool/RelatedResources';
import { SimilarTools } from '@/components/ui/tool/SimilarTools';
import { ComparisonTable } from '@/components/ui/tool/ComparisonTable';

interface AIModel {
  id: number;
  name: string;
  description: string | null;
  provider: string | null;
  model_type: string | null;
  pricing_info: string | null;
  features: string[] | null;
  use_cases: string[] | null;
  limitations: string[] | null;
  website_url: string | null;
  api_documentation_url: string | null;
  average_rating: number;
  rating_count: number;
  logo_url: string | null;
  created_at: string;
  updated_at: string;
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

  // AI 모델 상세 정보 가져오기
  const { data: aiModel, isLoading: modelLoading } = useQuery({
    queryKey: ['aiModel', id],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('ai_models')
        .select('*')
        .eq('id', id)
        .single();
      
      if (error) throw error;
      return data as AIModel;
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
        .eq('ai_model_id', id)
        .order('created_at', { ascending: false });
      
      if (error) throw error;
      return data as Rating[];
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
        .eq('ai_model_id', id)
        .eq('user_id', user.id)
        .single();
      
      if (error && error.code !== 'PGRST116') throw error;
      return data as Rating | null;
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

  // 사용자 리뷰 데이터가 로드되면 상태 업데이트
  useEffect(() => {
    if (userRatingData) {
      setUserRating(userRatingData.rating);
      setUserReview(userRatingData.review || '');
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

  // AI 도구별 실제 요금 정보
  const getPricingPlans = (modelName: string): PricingPlan[] => {
    switch (modelName) {
      case 'ChatGPT':
        return [
    {
      id: 'free',
            name: '무료',
            price: '$0 /월',
            features: ['GPT-3.5 (기본 챗)', '제한된 사용량'],
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'plus',
            name: 'Plus',
            price: '$20 /월',
            features: ['GPT-4o', '이미지 생성', '고속 응답'],
            isPopular: true,
      ctaUrl: aiModel?.website_url || undefined,
    },
    {
      id: 'pro',
      name: 'Pro',
            price: '$200 /월',
            features: ['고급 기능', '우선 지원'],
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'team',
            name: '팀 플랜',
            price: '$25-30 /월/인',
            features: ['팀 협업', '관리자 도구'],
            ctaUrl: aiModel?.website_url || undefined,
          },
        ];
      
      case 'Gemini':
        return [
          {
            id: 'free',
            name: '무료',
            price: '$0 /월',
            features: ['Gemini 1.5 Flash (기본형)'],
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'starter',
            name: '스타터',
            price: '$8.4 /월',
            features: ['고급 기능', '더 많은 사용량'],
            isPopular: true,
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'advanced',
            name: '고급',
            price: '₩29,000 /월',
            features: ['한국 특화', '최고 성능'],
            ctaUrl: aiModel?.website_url || undefined,
          },
        ];

      case 'Midjourney':
        return [
          {
            id: 'basic',
            name: '기본',
            price: '$10 /월',
            features: ['기본 이미지 생성'],
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'standard',
            name: '표준',
            price: '$30 /월',
            features: ['더 많은 생성량', '고급 기능'],
            isPopular: true,
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'pro',
            name: '프로',
            price: '$60 /월',
            features: ['무제한 생성', '우선 처리'],
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'mega',
            name: '메가',
            price: '$120 /월',
            features: ['최고 성능', '연간 구독 시 20% 할인'],
            ctaUrl: aiModel?.website_url || undefined,
          },
        ];

      case 'DALL-E':
        return [
          {
            id: 'plus',
            name: 'ChatGPT Plus',
            price: '$20 /월',
            features: ['DALL-E 포함', 'GPT-4o', '이미지 생성'],
            isPopular: true,
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'api',
            name: 'API',
            price: '$0.04-0.08 /이미지',
            features: ['개발자용', 'API 접근'],
            ctaUrl: aiModel?.api_documentation_url || undefined,
          },
        ];

      case 'Adobe Firefly':
        return [
          {
            id: 'standard',
            name: '스탠다드',
            price: '$9.99 /월',
            features: ['기본 이미지 생성'],
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'pro',
            name: '프로',
            price: '$29.99 /월',
            features: ['고급 기능', '상업적 사용'],
            isPopular: true,
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'enterprise',
            name: '엔터프라이즈',
            price: '$199.99 /월',
            features: ['팀 라이선스', '전용 지원'],
            ctaUrl: aiModel?.website_url || undefined,
          },
        ];

      case 'Stable Diffusion':
        return [
          {
            id: 'opensource',
            name: '오픈소스',
            price: '무료',
            features: ['로컬 실행', '커스터마이징'],
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'dreamstudio',
            name: 'DreamStudio',
            price: '$8.33 /월',
            features: ['클라우드 서비스', '이미지당 $0.02'],
            isPopular: true,
            ctaUrl: aiModel?.website_url || undefined,
          },
        ];

      case 'Notion AI':
        return [
          {
            id: 'free',
            name: '무료 시작',
            price: '$0 /월',
            features: ['기본 기능'],
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'personal',
            name: '개인',
            price: '$10 /월',
            features: ['AI 기능', '연간 구독'],
            isPopular: true,
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'team',
            name: '팀',
            price: '$20-24 /월',
            features: ['팀 협업', '고급 기능'],
            ctaUrl: aiModel?.website_url || undefined,
          },
        ];

      case 'Grammarly':
        return [
          {
            id: 'free',
            name: '무료',
            price: '$0 /월',
            features: ['기본 문법 검사'],
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'premium',
            name: '프리미엄',
            price: '$12 /월',
            features: ['고급 문법', '스타일 개선', '연간 구독'],
            isPopular: true,
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'monthly',
            name: '월간',
            price: '$30 /월',
            features: ['월간 구독'],
            ctaUrl: aiModel?.website_url || undefined,
          },
        ];

      case 'Jasper':
        return [
          {
            id: 'creator',
            name: '크리에이터',
            price: '$39-49 /월',
            features: ['마케팅 콘텐츠', '개인 사용'],
            isPopular: true,
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'team',
            name: '팀',
            price: '$125 /월',
            features: ['팀 협업', '고급 기능'],
            ctaUrl: aiModel?.website_url || undefined,
          },
        ];

      case 'Copy.ai':
        return [
          {
            id: 'free',
            name: '무료 체험',
            price: '$0 /월',
            features: ['제한된 사용량'],
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'pro',
            name: '프로',
            price: '$35 /월',
            features: ['무제한 생성', '연간 구독'],
            isPopular: true,
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'monthly',
            name: '월간',
            price: '$49 /월',
            features: ['월간 구독'],
            ctaUrl: aiModel?.website_url || undefined,
          },
        ];

      case 'GitHub Copilot':
        return [
          {
            id: 'individual',
            name: '개인',
            price: '$10 /월',
            features: ['개인 사용', 'AI 코드 완성'],
            isPopular: true,
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'business',
            name: '비즈니스',
            price: '$19 /월',
            features: ['팀 사용', '관리자 도구'],
            ctaUrl: aiModel?.website_url || undefined,
          },
        ];

      case 'Replit':
        return [
          {
            id: 'free',
            name: '무료 시작',
            price: '$0 /월',
            features: ['기본 기능'],
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'core',
            name: '코어',
            price: '$20 /월',
            features: ['고급 기능', '연간 구독'],
            isPopular: true,
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'team',
            name: '팀',
            price: '$40 /월',
            features: ['팀 협업', '관리자 도구'],
            ctaUrl: aiModel?.website_url || undefined,
          },
        ];

      case 'Tabnine':
        return [
          {
            id: 'free',
            name: '무료 플랜',
            price: '$0 /월',
            features: ['기본 코드 완성'],
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'pro',
            name: '프로',
            price: '$9 /월',
            features: ['고급 기능', '연간 구독'],
            isPopular: true,
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'enterprise',
            name: '엔터프라이즈',
            price: '$39 /월',
            features: ['팀 사용', '관리자 도구'],
            ctaUrl: aiModel?.website_url || undefined,
          },
        ];

      case 'Synthesia':
        return [
          {
            id: 'starter',
            name: '스타터',
            price: '$22 /월',
            features: ['기본 동영상 생성'],
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'creator',
            name: '크리에이터',
            price: '$67 /월',
            features: ['고급 기능', '더 많은 생성량'],
            isPopular: true,
            ctaUrl: aiModel?.website_url || undefined,
          },
        ];

      case 'ElevenLabs':
        return [
          {
            id: 'starter',
            name: '스타터',
            price: '$4.17 /월',
            features: ['기본 음성 생성', '연간 구독'],
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'creator',
            name: '크리에이터',
            price: '$11 /월',
            features: ['고급 기능', '더 많은 사용량'],
            isPopular: true,
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'pro',
            name: '프로',
            price: '$82.5 /월',
            features: ['무제한 생성', '우선 처리'],
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'scale',
            name: '스케일',
            price: '$275-330 /월',
            features: ['대용량 처리', '전용 지원'],
            ctaUrl: aiModel?.website_url || undefined,
          },
        ];

      case 'Suno':
        return [
          {
            id: 'free',
            name: '무료 플랜',
            price: '$0 /월',
            features: ['기본 음악 생성'],
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'pro',
            name: '프로',
            price: '$10 /월',
            features: ['고급 기능', '더 많은 생성량'],
            isPopular: true,
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'premium',
            name: '프리미엄',
            price: '$30 /월',
            features: ['무제한 생성', '우선 처리'],
            ctaUrl: aiModel?.website_url || undefined,
          },
        ];

      case 'Zapier':
        return [
          {
            id: 'free',
            name: '무료 플랜',
            price: '$0 /월',
            features: ['기본 자동화'],
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'starter',
            name: '스타터',
            price: '$29.99 /월',
            features: ['고급 자동화', '더 많은 앱'],
            isPopular: true,
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'pro',
            name: '프로',
            price: '$79 /월',
            features: ['무제한 자동화', '우선 지원'],
            ctaUrl: aiModel?.website_url || undefined,
          },
        ];

      case 'Canva':
        return [
          {
            id: 'free',
            name: '무료 플랜',
            price: '$0 /월',
            features: ['기본 디자인 도구'],
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'pro',
            name: '프로',
            price: '$12.99 /월',
            features: ['AI 디자인', '고급 기능'],
      isPopular: true,
      ctaUrl: aiModel?.website_url || undefined,
    },
    {
      id: 'enterprise',
            name: '엔터프라이즈',
            price: '별도 문의',
            features: ['팀 라이선스', '전용 지원'],
      ctaUrl: aiModel?.website_url || undefined,
    },
  ];

      default:
        return [
          {
            id: 'free',
            name: '무료',
            price: '$0 /월',
            features: ['기본 기능'],
            ctaUrl: aiModel?.website_url || undefined,
          },
          {
            id: 'pro',
            name: '프로',
            price: '$29 /월',
            features: ['고급 기능', '우선 지원'],
            isPopular: true,
            ctaUrl: aiModel?.website_url || undefined,
          },
        ];
    }
  };

  const defaultPlans = getPricingPlans(aiModel?.name || '');

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
    <div className="min-h-screen bg-background">
      <Navbar />
      <main className="pt-24 pb-12">
        <div className="container mx-auto px-6">
          <div className="flex items-center gap-4 mb-8">
            <Button variant="ghost" size="sm" asChild>
              <Link to="/tools">
                <ArrowLeft className="w-4 h-4 mr-2" />뒤로가기
              </Link>
            </Button>
          </div>

          {/* 헤더 영역 */}
          <Card className="mb-6">
            <CardHeader>
              <div className="flex items-start gap-4">
                <div className="w-16 h-16 flex items-center justify-center">
                  {aiModel.logo_url ? (
                    <img src={aiModel.logo_url} alt={aiModel.name} className="w-16 h-16 object-contain" />
                  ) : (
                    <div className="w-16 h-16 bg-gradient-to-br from-blue-500 to-purple-600 rounded-lg flex items-center justify-center text-white font-bold text-2xl">
                      {aiModel.name.charAt(0).toUpperCase()}
                    </div>
                  )}
                </div>
                <div className="flex-1">
                  <CardTitle className="text-3xl mb-2">{aiModel.name}</CardTitle>
                  <div className="text-muted-foreground mb-3">{aiModel.provider || 'Unknown Provider'}</div>
                  <div className="flex items-center gap-4">
                    <Rating score={aiModel.average_rating} count={aiModel.rating_count} />
                    <Badge variant="secondary" className="text-sm">{aiModel.model_type || 'AI Tool'}</Badge>
                  </div>
                </div>
                <div className="flex gap-2">
                  <Button variant="outline" size="sm"><Heart className="w-4 h-4 mr-2" />북마크</Button>
                  <Button variant="outline" size="sm"><Share2 className="w-4 h-4 mr-2" />공유</Button>
                </div>
              </div>
            </CardHeader>
            <CardContent>
              <p className="text-muted-foreground text-lg leading-relaxed">{aiModel.description || '설명이 없습니다.'}</p>
            </CardContent>
          </Card>

          {/* 본문: 탭 + 사이드바 레이아웃 */}
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
            <div className="lg:col-span-8 space-y-6">
              <Tabs defaultValue="overview" className="w-full">
                <TabsList className="grid w-full grid-cols-5 md:grid-cols-5 overflow-x-auto no-scrollbar gap-1">
                  <TabsTrigger value="overview">개요</TabsTrigger>
                  <TabsTrigger value="usecases">사용 사례</TabsTrigger>
                  <TabsTrigger value="comparison">비교</TabsTrigger>
                  <TabsTrigger value="reviews">리뷰·Q&A</TabsTrigger>
                  <TabsTrigger value="stats">통계</TabsTrigger>
                </TabsList>

                <TabsContent value="overview" className="mt-6">
                  <div className="space-y-6">
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

                    <Card>
                      <CardHeader>
                        <CardTitle className="flex items-center gap-2"><DollarSign className="w-5 h-5" />요금제</CardTitle>
                      </CardHeader>
                      <CardContent>
                        <PricingPlans plans={defaultPlans} />
                      </CardContent>
                    </Card>
                  </div>
                </TabsContent>

                <TabsContent value="usecases" className="mt-6">
                  <Card>
                    <CardHeader>
                      <CardTitle className="flex items-center gap-2"><BookOpen className="w-5 h-5" />사용 사례</CardTitle>
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
                        <p className="text-muted-foreground">사용 사례 정보가 없습니다.</p>
                      )}
                    </CardContent>
                  </Card>
                </TabsContent>

                <TabsContent value="comparison" className="mt-6">
                  <ComparisonTable currentModel={aiModel} />
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

            {/* 사이드바 */}
            <aside className="lg:col-span-4 space-y-6">
              <QuickActions websiteUrl={aiModel.website_url} apiDocsUrl={aiModel.api_documentation_url} />
              <MetaChips platforms={['Web', 'Mobile', 'API']} languages={['English', 'Spanish', 'French', 'German', 'Chinese', 'Japanese']} tags={[aiModel.model_type || 'AI', 'Automation']} />
              <RelatedResources items={[
                { id: 'getting-started', title: '시작하기 가이드', subtitle: '기본을 익혀보세요', href: aiModel.website_url || '#' },
                { id: 'best-practices', title: '모범 사례', subtitle: '전문가 팁과 노하우', href: aiModel.api_documentation_url || '#' }
              ]} />
              <SimilarTools items={[{ id: 1, name: 'ContentAI', rating: 4.3, category: 'Content Generation' }, { id: 2, name: 'DataSmart', rating: 4.1, category: 'Analytics' }, { id: 3, name: 'AutoFlow', rating: 4.5, category: 'Automation' }]} />
              <Button asChild variant="outline">
                <Link to={`/tools/compare?tools=${aiModel.id}`}>
                  자세히 비교
                </Link>
              </Button>
            </aside>
          </div>
        </div>
      </main>
    </div>
  );
};

export default ToolDetail;
