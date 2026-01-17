import { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { supabase } from '@/integrations/supabase/client';
import { useAuth } from '@/hooks/useAuth';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogTrigger } from '@/components/ui/dialog';
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
  CheckCircle,
  XCircle,
  Zap,
  Shield,
  Target,
  Lightbulb,
  Users,
  Search,
  Globe,
  Monitor,
  Smartphone,
  Video
} from 'lucide-react';
import Navbar from '@/components/ui/navbar';
import { toast } from '@/hooks/use-toast';
import BookmarkForm from '@/components/tools/BookmarkForm';

interface AIModel {
  id: number;
  name: string;
  description: string | null;
  provider: string | null;
  website_url?: string | null;
  logo_url?: string | null;
  average_rating: number;
  rating_count: number;
  created_at: string;
  updated_at: string;

  // New Fields
  meta_info?: {
    korean_support?: boolean;
    login_required?: string;
    platforms?: string[];
    target_audience?: string;
  } | null;
  pricing_model?: string | null;
  free_tier_note?: string | null;
  pricing_plans?: PricingPlan[] | null;
  pros?: string[] | null;
  cons?: string[] | null;
  key_features?: { name: string; description: string }[] | null;
  recommendations?: {
    recommended: { target: string; badge: string; reason: string }[];
    not_recommended: { target: string; reason: string }[];
  } | null;
  usage_tips?: string[] | null;
  privacy_info?: {
    training_data?: string;
    privacy_protection?: string;
    enterprise_security?: string;
  } | null;
  alternatives?: { name: string; description: string }[] | null;
  media_info?: { title: string; url: string; platform: string }[] | null;

  // Legacy Fields (kept for fallback)
  features?: string[] | null;
  use_cases?: string[] | null;
}

interface GuideSummary {
  id: number;
  title: string;
  description: string | null;
  image_url?: string | null;
}

interface Rating {
  id?: number;
  user_id: string;
  ai_model_id: number;
  rating: number;
  review?: string | null;
  created_at: string;
  updated_at?: string;
  profiles?: {
    username: string;
    avatar_url: string | null;
  };
}

interface PricingPlan {
  plan: string;
  price: string;
  target?: string;
  features?: string;
}

const ToolDetail = () => {
  const { id } = useParams<{ id: string }>();
  const { user } = useAuth();
  const queryClient = useQueryClient();
  const [userRating, setUserRating] = useState(0);
  const [userReview, setUserReview] = useState('');
  const [isSubmittingReview, setIsSubmittingReview] = useState(false);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isBookmarkOpen, setIsBookmarkOpen] = useState(false);
  const [isVideoOpen, setIsVideoOpen] = useState(false);

  const getEmbedUrl = (url: string) => {
    if (!url) return '';
    let videoId = '';
    if (url.includes('youtube.com/watch?v=')) {
      videoId = url.split('v=')[1].split('&')[0];
    } else if (url.includes('youtu.be/')) {
      videoId = url.split('youtu.be/')[1];
    }
    return videoId ? `https://www.youtube.com/embed/${videoId}?autoplay=1` : url;
  };
  const [currentRating, setCurrentRating] = useState(0);
  const [uiAverage, setUiAverage] = useState<number | null>(null);
  const [uiCount, setUiCount] = useState<number | null>(null);
  const [searchQuery, setSearchQuery] = useState("");

  const { data: aiModel, isLoading: modelLoading } = useQuery({
    queryKey: ['aiModel', id],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('ai_models')
        .select('*')
        .eq('id', parseInt(id!))
        .single();

      if (error) throw error;
      return data as AIModel;
    },
    enabled: !!id,
  });

  const { data: guides, isLoading: guidesLoading } = useQuery({
    queryKey: ['guidesByTool', id],
    queryFn: async () => {
      const toolId = parseInt(id!);
      if (isNaN(toolId)) throw new Error('Invalid tool id');
      const { data, error } = await supabase
        .from('guides')
        .select('id, title, description, image_url')
        .eq('ai_model_id', toolId)
        .order('id', { ascending: true });
      if (error) throw error;
      return data as GuideSummary[];
    },
    enabled: !!id,
  });

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
      return data as Rating[];
    },
    enabled: !!id,
  });

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
      return data as Rating | null;
    },
    enabled: !!id && !!user,
  });

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
      setIsModalOpen(false); // Close modal if open
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

  useEffect(() => {
    if (aiModel) {
      setUiAverage(Number(aiModel.average_rating) || 0);
      setUiCount(Number(aiModel.rating_count) || 0);
    }
  }, [aiModel?.average_rating, aiModel?.rating_count]);

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

    setIsSubmittingReview(true);
    submitReviewMutation.mutate({ rating: userRating, review: userReview });
  };

  const pricingPlans = (aiModel?.pricing_plans as PricingPlan[]) || [];

  if (modelLoading) {
    return (
      <div className="min-h-screen bg-background">
        <Navbar />
        <main className="pt-24 pb-12">
          <div className="container mx-auto px-6 space-y-8">
            <Skeleton className="h-48 w-full rounded-xl" />
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
              <div className="lg:col-span-2 space-y-6">
                <Skeleton className="h-64 w-full" />
                <Skeleton className="h-64 w-full" />
              </div>
              <Skeleton className="h-96 w-full" />
            </div>
          </div>
        </main>
      </div>
    );
  }

  if (!aiModel) return null;

  return (
    <div className="min-h-screen bg-gray-50/50">
      <Navbar />
      <main className="pt-24 pb-12">
        <div className="container mx-auto px-4 max-w-7xl">

          {/* 1. Header Section */}
          <div className="bg-white rounded-xl border p-8 mb-8 shadow-sm">
            <div className="flex flex-col md:flex-row items-start justify-between gap-6">
              <div className="flex items-start gap-6">
                <div className="w-20 h-20 bg-gray-50 rounded-xl border flex items-center justify-center shrink-0">
                  {aiModel.logo_url ? (
                    <img src={aiModel.logo_url} alt={aiModel.name} className="w-14 h-14 object-contain" />
                  ) : (
                    <Globe className="w-10 h-10 text-gray-400" />
                  )}
                </div>
                <div>
                  <div className="flex items-center gap-3 mb-2">
                    <h1 className="text-3xl font-bold text-gray-900">{aiModel.name}</h1>
                    <div className="flex items-center gap-1 bg-yellow-50 px-2 py-0.5 rounded text-yellow-700 text-sm font-medium">
                      <Star className="w-4 h-4 fill-yellow-500 text-yellow-500" />
                      {aiModel.average_rating.toFixed(1)} <span className="text-gray-400">({aiModel.rating_count}개 리뷰)</span>
                    </div>
                  </div>
                  <p className="text-gray-600 text-lg leading-relaxed max-w-2xl">
                    {aiModel.description || "설명이 없습니다."}
                  </p>
                </div>
              </div>

              <div className="flex gap-3 shrink-0">
                {aiModel.website_url && (
                  <Button className="bg-blue-600 hover:bg-blue-700 text-white gap-2" asChild>
                    <a href={aiModel.website_url} target="_blank" rel="noopener noreferrer">
                      사이트 방문 <ExternalLink className="w-4 h-4" />
                    </a>
                  </Button>
                )}
                {aiModel.media_info && aiModel.media_info.length > 0 && (
                  <>
                    <Button variant="outline" className="gap-2 hover:bg-red-50 hover:text-red-600 hover:border-red-200" onClick={() => setIsVideoOpen(true)}>
                      <Video className="w-4 h-4" /> 영상 보기
                    </Button>
                    <Dialog open={isVideoOpen} onOpenChange={setIsVideoOpen}>
                      <DialogContent className="sm:max-w-[900px] p-0 overflow-hidden bg-black/95 border-none">
                        <div className="relative w-full aspect-video">
                          <iframe
                            className="absolute top-0 left-0 w-full h-full"
                            src={getEmbedUrl(aiModel.media_info[0].url)}
                            title="YouTube video player"
                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                            allowFullScreen
                          />
                        </div>
                      </DialogContent>
                    </Dialog>
                  </>
                )}
                <Dialog open={isBookmarkOpen} onOpenChange={setIsBookmarkOpen}>
                  <DialogTrigger asChild>
                    <Button variant="outline" size="icon" className="hover:text-pink-500 hover:bg-pink-50 hover:border-pink-200">
                      <Heart className="w-5 h-5" />
                    </Button>
                  </DialogTrigger>
                  <DialogContent>
                    <DialogHeader>
                      <DialogTitle>나만의 도구함에 저장</DialogTitle>
                      <DialogDescription>이 도구를 저장할 폴더를 선택하세요.</DialogDescription>
                    </DialogHeader>
                    <BookmarkForm aiModelId={aiModel.id} onSuccess={() => setIsBookmarkOpen(false)} />
                  </DialogContent>
                </Dialog>
              </div>
            </div>
          </div>

          {/* 2. Main Content Grid */}
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">

            {/* Left Column (Content) */}
            <div className="lg:col-span-8 space-y-8">
              <Tabs defaultValue="overview" className="w-full">
                <TabsList className="bg-transparent border-b rounded-none w-full justify-start h-auto p-0 mb-6 gap-8">
                  <TabsTrigger value="overview" className="rounded-none border-b-2 border-transparent data-[state=active]:border-blue-600 data-[state=active]:text-blue-600 data-[state=active]:shadow-none px-1 py-3 text-base font-medium">개요</TabsTrigger>
                  <TabsTrigger value="guides" className="rounded-none border-b-2 border-transparent data-[state=active]:border-blue-600 data-[state=active]:text-blue-600 data-[state=active]:shadow-none px-1 py-3 text-base font-medium">가이드북</TabsTrigger>
                  <TabsTrigger value="presets" className="rounded-none border-b-2 border-transparent data-[state=active]:border-blue-600 data-[state=active]:text-blue-600 data-[state=active]:shadow-none px-1 py-3 text-base font-medium">프리셋</TabsTrigger>
                  <TabsTrigger value="qna" className="rounded-none border-b-2 border-transparent data-[state=active]:border-blue-600 data-[state=active]:text-blue-600 data-[state=active]:shadow-none px-1 py-3 text-base font-medium">리뷰</TabsTrigger>
                  <TabsTrigger value="updates" className="rounded-none border-b-2 border-transparent data-[state=active]:border-blue-600 data-[state=active]:text-blue-600 data-[state=active]:shadow-none px-1 py-3 text-base font-medium">업데이트</TabsTrigger>
                </TabsList>

                <TabsContent value="overview" className="space-y-8 animate-in fade-in slide-in-from-bottom-2 duration-500">

                  {/* Meta Chips */}
                  {aiModel.meta_info && (
                    <div className="flex flex-wrap gap-2">
                      {aiModel.pricing_model && (
                        <Badge variant="secondary" className="px-3 py-1.5 bg-blue-50 text-blue-700 hover:bg-blue-100 gap-1.5">
                          <DollarSignIcon className="w-3.5 h-3.5" /> {aiModel.pricing_model}
                        </Badge>
                      )}
                      {aiModel.meta_info.korean_support && (
                        <Badge variant="secondary" className="px-3 py-1.5 bg-green-50 text-green-700 hover:bg-green-100 gap-1.5">
                          <Globe className="w-3.5 h-3.5" /> 한국어 지원
                        </Badge>
                      )}
                      {aiModel.meta_info.platforms?.map(p => (
                        <Badge key={p} variant="outline" className="px-3 py-1.5 bg-white gap-1.5 text-gray-600">
                          <Monitor className="w-3.5 h-3.5" /> {p}
                        </Badge>
                      ))}
                      {aiModel.meta_info.login_required && (
                        <Badge variant="outline" className="px-3 py-1.5 bg-white text-gray-500">
                          {aiModel.meta_info.login_required}
                        </Badge>
                      )}
                    </div>
                  )}

                  {/* Pricing & Info */}
                  <Card className="border-blue-100 shadow-sm overflow-hidden">
                    <CardHeader className="bg-blue-50/50 border-b border-blue-100 pb-4">
                      <CardTitle className="flex items-center gap-2 text-lg text-blue-900">
                        <Target className="w-5 h-5 text-blue-600" /> 가격 및 정보
                      </CardTitle>
                    </CardHeader>
                    <CardContent className="pt-6">
                      <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                        <div>
                          <div className="text-sm font-semibold text-gray-500 mb-1">무료 범위</div>
                          <div className="text-gray-900 font-medium">{aiModel.free_tier_note || "정보 없음"}</div>
                        </div>
                        <div>
                          <div className="text-sm font-semibold text-gray-500 mb-1">유료 시작가</div>
                          <div className="text-blue-600 font-bold">{
                            pricingPlans.find((p: any) => p.plan === 'Plus' || p.price !== '무료')?.price || "정보 없음"
                          }</div>
                        </div>
                      </div>

                      {pricingPlans.length > 0 && (
                        <div className="border rounded-lg overflow-hidden">
                          <table className="w-full text-sm text-left">
                            <thead className="bg-gray-50 text-gray-500 border-b">
                              <tr>
                                <th className="px-4 py-3 font-medium">플랜</th>
                                <th className="px-4 py-3 font-medium">추천 대상</th>
                                <th className="px-4 py-3 font-medium">핵심 혜택</th>
                                <th className="px-4 py-3 font-medium text-right">가격</th>
                              </tr>
                            </thead>
                            <tbody className="divide-y">
                              {pricingPlans.map((plan, idx) => (
                                <tr key={idx} className="bg-white hover:bg-gray-50/50">
                                  <td className="px-4 py-3 font-semibold text-gray-900">{plan.plan}</td>
                                  <td className="px-4 py-3 text-gray-600">{plan.target || "-"}</td>
                                  <td className="px-4 py-3 text-gray-600">{plan.features || "-"}</td>
                                  <td className="px-4 py-3 text-right font-medium text-blue-600">{plan.price}</td>
                                </tr>
                              ))}
                            </tbody>
                          </table>
                        </div>
                      )}
                    </CardContent>
                  </Card>


                  {/* Recommendations */}
                  {aiModel.recommendations && (
                    <Card className="shadow-sm">
                      <CardHeader className="pb-4">
                        <CardTitle className="flex items-center gap-2 text-lg">
                          <Users className="w-5 h-5 text-purple-500" /> 이런 분께 추천 / 비추천
                        </CardTitle>
                      </CardHeader>
                      <CardContent>
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
                          <div>
                            <div className="flex items-center gap-2 mb-4 text-green-700 font-semibold text-sm uppercase tracking-wide">
                              <CheckCircle className="w-4 h-4" /> 추천
                            </div>
                            <div className="space-y-4">
                              {aiModel.recommendations.recommended.map((item, idx) => (
                                <div key={idx} className="bg-gray-50 p-3 rounded-lg border border-gray-100">
                                  <div className="flex items-center justify-between mb-1">
                                    <span className="font-bold text-gray-900 text-sm">{item.target}</span>
                                    {item.badge && <Badge variant="outline" className="text-xs py-0 h-5 border-green-200 text-green-700 bg-green-50">{item.badge}</Badge>}
                                  </div>
                                  <p className="text-xs text-gray-600 leading-snug">{item.reason}</p>
                                </div>
                              ))}
                            </div>
                          </div>
                          <div>
                            <div className="flex items-center gap-2 mb-4 text-red-700 font-semibold text-sm uppercase tracking-wide">
                              <XCircle className="w-4 h-4" /> 비추천
                            </div>
                            <div className="space-y-4">
                              {aiModel.recommendations.not_recommended.map((item, idx) => (
                                <div key={idx} className="bg-gray-50 p-3 rounded-lg border border-gray-100">
                                  <div className="flex items-center justify-between mb-1">
                                    <span className="font-bold text-gray-900 text-sm">{item.target}</span>
                                  </div>
                                  <p className="text-xs text-gray-600 leading-snug">{item.reason}</p>
                                </div>
                              ))}
                            </div>
                          </div>
                        </div>
                      </CardContent>
                    </Card>
                  )}

                  {/* Key Features */}
                  <Card className="shadow-sm">
                    <CardHeader className="pb-4">
                      <CardTitle className="flex items-center gap-2 text-lg">
                        <Zap className="w-5 h-5 text-yellow-500" /> 주요 기능
                      </CardTitle>
                    </CardHeader>
                    <CardContent>
                      {aiModel.key_features ? (
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                          {aiModel.key_features.map((feature, idx) => (
                            <div key={idx} className="flex items-start gap-3 p-3 rounded-lg hover:bg-gray-50 transition-colors">
                              <CheckCircle className="w-5 h-5 text-green-500 shrink-0 mt-0.5" />
                              <div>
                                <div className="font-semibold text-gray-900 text-sm">{feature.name}</div>
                                <div className="text-xs text-gray-500 mt-0.5">{feature.description}</div>
                              </div>
                            </div>
                          ))}
                        </div>
                      ) : aiModel.features ? (
                        /* Legacy Features Fallback */
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                          {aiModel.features.map((f, i) => (
                            <div key={i} className="flex items-center gap-2 text-sm"><CheckCircle className="w-4 h-4 text-green-500" />{f}</div>
                          ))}
                        </div>
                      ) : <div className="text-gray-400">정보가 없습니다.</div>}
                    </CardContent>
                  </Card>

                  {/* Usage Tips (Mistake Prevention) */}
                  {aiModel.usage_tips && (
                    <Card className="border-orange-100 bg-orange-50/30 shadow-sm">
                      <CardHeader className="pb-3">
                        <CardTitle className="flex items-center gap-2 text-lg text-orange-800">
                          <Lightbulb className="w-5 h-5 text-orange-500" /> 실수 방지 포인트
                        </CardTitle>
                      </CardHeader>
                      <CardContent>
                        <ul className="space-y-3">
                          {aiModel.usage_tips.map((tip, idx) => (
                            <li key={idx} className="flex items-start gap-3 text-sm text-gray-700 bg-white p-3 rounded border border-orange-100">
                              <span className="text-orange-500 font-bold shrink-0">!</span>
                              <span className="leading-relaxed">{tip}</span>
                            </li>
                          ))}
                        </ul>
                      </CardContent>
                    </Card>
                  )}

                  {/* Privacy Info */}
                  {aiModel.privacy_info && (
                    <Card className="shadow-sm">
                      <CardHeader className="pb-3">
                        <CardTitle className="flex items-center gap-2 text-lg">
                          <Shield className="w-5 h-5 text-gray-600" /> 데이터 / 프라이버시 요약
                        </CardTitle>
                      </CardHeader>
                      <CardContent>
                        <div className="space-y-3 text-sm text-gray-600">
                          {aiModel.privacy_info.training_data && (
                            <div className="flex items-start gap-2">
                              <div className="w-1.5 h-1.5 rounded-full bg-gray-400 mt-1.5" />
                              <span>{aiModel.privacy_info.training_data}</span>
                            </div>
                          )}
                          {aiModel.privacy_info.enterprise_security && (
                            <div className="flex items-start gap-2">
                              <div className="w-1.5 h-1.5 rounded-full bg-blue-400 mt-1.5" />
                              <span>{aiModel.privacy_info.enterprise_security}</span>
                            </div>
                          )}
                          {aiModel.privacy_info.privacy_protection && (
                            <div className="flex items-start gap-2">
                              <div className="w-1.5 h-1.5 rounded-full bg-green-400 mt-1.5" />
                              <span>{aiModel.privacy_info.privacy_protection}</span>
                            </div>
                          )}
                        </div>
                      </CardContent>
                    </Card>
                  )}

                  {/* Alternatives */}
                  <Card className="shadow-sm">
                    <CardHeader className="pb-4">
                      <CardTitle className="flex items-center gap-2 text-lg">
                        <Share2 className="w-5 h-5 text-blue-500" /> 추천 대체 도구
                      </CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="space-y-3">
                        {aiModel.alternatives?.map((alt, idx) => (
                          <div key={idx} className="flex items-center justify-between p-3 border rounded-lg hover:border-blue-300 transition-colors bg-white group">
                            <div>
                              <div className="font-semibold text-gray-900 text-sm flex items-center gap-2">
                                {alt.name}
                                <Star className="w-3 h-3 fill-yellow-400 text-yellow-400" />
                              </div>
                              <div className="text-xs text-gray-500">{alt.description}</div>
                            </div>
                            <Button variant="ghost" size="sm" className="opacity-0 group-hover:opacity-100 text-blue-600 hover:text-blue-700 bg-blue-50">
                              + 비교함 담기
                            </Button>
                          </div>
                        ))}
                      </div>
                    </CardContent>
                  </Card>

                </TabsContent>

                {/* Other Tabs (Guides, Reviews) - Simplified for brevity but functional */}
                <TabsContent value="guides" className="mt-6">
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    {guides?.length ? guides.map(g => (
                      <Link key={g.id} to={`/guidebook/${id}/${g.id}`} className="block group font-sans h-full">
                        <Card className="hover:shadow-md transition-shadow h-full border-gray-200 overflow-hidden bg-white flex flex-col">
                          <CardContent className="p-6 flex-1">
                            <div className="font-bold text-lg text-gray-900 mb-2 group-hover:text-blue-600 transition-colors line-clamp-1">{g.title}</div>
                            <div className="text-sm text-gray-500 line-clamp-3 leading-relaxed">{g.description}</div>
                          </CardContent>
                        </Card>
                      </Link>
                    )) : <div className="col-span-2 text-center py-12 text-gray-500">등록된 가이드북이 없습니다.</div>}
                  </div>
                </TabsContent>

                <TabsContent value="presets" className="mt-6">
                  <Card className="border-gray-200 shadow-sm bg-white h-64 flex items-center justify-center">
                    <div className="text-center text-gray-500">
                      <div className="text-lg font-medium mb-1">등록된 프리셋이 없습니다</div>
                      <p className="text-sm">이 도구와 관련된 프리셋 워크플로우가 곧 추가될 예정입니다.</p>
                    </div>
                  </Card>
                </TabsContent>

                <TabsContent value="qna" className="mt-6 space-y-6">
                  {/* Write Review Section */}
                  <Card className="border-gray-200 shadow-sm">
                    <CardHeader>
                      <CardTitle className="text-lg">리뷰 작성하기</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="space-y-4">
                        <div className="flex items-center gap-2">
                          <span className="text-sm font-medium">평점</span>
                          <StarRating rating={userRating} onRate={setUserRating} size={24} />
                        </div>
                        <textarea
                          className="w-full p-3 border rounded-md text-sm min-h-[100px]"
                          placeholder="사용 경험을 공유해주세요 (최소 10자)"
                          value={userReview}
                          onChange={(e) => setUserReview(e.target.value)}
                        />
                        <Button onClick={handleSubmitReview} disabled={isSubmittingReview} className="bg-blue-600 text-white">
                          {isSubmittingReview ? '등록 중...' : '리뷰 등록'}
                        </Button>
                      </div>
                    </CardContent>
                  </Card>

                  {/* Review List */}
                  <div className="space-y-4">
                    {ratings?.map((r) => (
                      <div key={r.id} className="bg-white p-4 border rounded-lg shadow-sm">
                        <div className="flex items-center gap-3 mb-2">
                          <div className="w-8 h-8 rounded-full bg-gray-200 overflow-hidden">
                            {r.profiles?.avatar_url && <img src={r.profiles.avatar_url} className="w-full h-full object-cover" />}
                          </div>
                          <div>
                            <div className="text-sm font-medium">{r.profiles?.username}</div>
                            <div className="flex text-xs text-yellow-500"><StarRating rating={r.rating} size={12} readOnly /></div>
                          </div>
                          <div className="ml-auto text-xs text-gray-400">{new Date(r.created_at).toLocaleDateString()}</div>
                        </div>
                        <p className="text-sm text-gray-700">{r.review}</p>
                      </div>
                    ))}
                  </div>
                </TabsContent>

                <TabsContent value="updates" className="mt-6">
                  <Card className="border-gray-200 shadow-sm bg-white h-64 flex items-center justify-center">
                    <div className="text-center text-gray-500">
                      <div className="text-lg font-medium mb-1">업데이트 정보가 없습니다</div>
                      <p className="text-sm">최신 업데이트 소식이 여기에 표시됩니다.</p>
                    </div>
                  </Card>
                </TabsContent>
              </Tabs>
            </div>

            {/* Right Sidebar */}
            <aside className="lg:col-span-4 space-y-6">

              {/* Pros & Cons Analysis (Sidebar) */}
              {(aiModel.pros || aiModel.cons) && (
                <Card className="border-gray-200 shadow-sm bg-white">
                  <CardHeader className="pb-3 border-b bg-gray-50/50">
                    <CardTitle className="text-base font-bold text-gray-900">장단점 분석</CardTitle>
                  </CardHeader>
                  <CardContent className="pt-4 space-y-6">
                    {/* Pros */}
                    <div>
                      <div className="flex items-center gap-2 mb-2 text-green-700 font-semibold text-sm">
                        <CheckCircle className="w-4 h-4" /> 장점
                      </div>
                      <ul className="space-y-2">
                        {aiModel.pros?.map((pro, idx) => (
                          <li key={idx} className="flex items-start gap-2 text-sm text-gray-700">
                            <div className="w-1 h-1 rounded-full bg-green-500 mt-2 shrink-0" />
                            <span className="leading-snug">{pro}</span>
                          </li>
                        ))}
                      </ul>
                    </div>

                    {/* Cons */}
                    <div>
                      <div className="flex items-center gap-2 mb-2 text-red-700 font-semibold text-sm">
                        <XCircle className="w-4 h-4" /> 단점
                      </div>
                      <ul className="space-y-2">
                        {aiModel.cons?.map((con, idx) => (
                          <li key={idx} className="flex items-start gap-2 text-sm text-gray-700">
                            <div className="w-1 h-1 rounded-full bg-red-500 mt-2 shrink-0" />
                            <span className="leading-snug">{con}</span>
                          </li>
                        ))}
                      </ul>
                    </div>
                  </CardContent>
                </Card>
              )}

              {/* Rating Distribution Card */}
              <Card className="border-gray-200 shadow-sm">
                <CardHeader className="pb-2">
                  <CardTitle className="text-lg flex items-center gap-2">
                    <Star className="w-5 h-5 text-yellow-500" /> 별점 및 평가
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="text-center mb-6">
                    <div className="text-4xl font-bold text-gray-900 mb-1">{aiModel.average_rating.toFixed(1)}</div>
                    <div className="flex justify-center mb-1">
                      <StarRating rating={aiModel.average_rating} size={20} readOnly />
                    </div>
                    <div className="text-sm text-gray-500">{aiModel.rating_count}개의 평가</div>
                  </div>

                  {/* Real Rating Distribution */}
                  <div className="space-y-2">
                    {[5, 4, 3, 2, 1].map((star) => {
                      const count = ratings?.filter((r) => r.rating === star).length || 0;
                      const total = ratings?.length || 0;
                      const percentage = total > 0 ? Math.round((count / total) * 100) : 0;

                      return (
                        <div key={star} className="flex items-center gap-3 text-sm">
                          <span className="w-3 font-medium text-gray-600">{star}</span>
                          <div className="flex-1 h-2 bg-gray-100 rounded-full overflow-hidden">
                            <div
                              className="h-full bg-yellow-400 rounded-full transition-all duration-500"
                              style={{ width: `${percentage}%` }}
                            />
                          </div>
                          <span className="w-9 text-right text-gray-400 text-xs">{percentage}%</span>
                        </div>
                      );
                    })}
                  </div>

                  <div className="mt-6 pt-6 border-t">
                    <div className="text-sm font-medium mb-3">사용자 피드백 (최근)</div>
                    <div className="space-y-3">
                      {ratings?.slice(0, 3).map((r) => (
                        <div key={r.id} className="text-sm text-gray-600 bg-gray-50 p-2 rounded">
                          "{r.review?.slice(0, 40)}{r.review?.length > 40 && '...'}"
                          <div className="text-xs text-gray-400 mt-1">- {r.profiles?.username}</div>
                        </div>
                      ))}
                    </div>
                  </div>
                </CardContent>
              </Card>

              {/* Upgrade CTA (Static) */}
              <Card className="bg-blue-50 border-blue-100">
                <CardContent className="p-6 text-center">
                  <div className="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-3 text-blue-600">
                    <Zap className="w-6 h-6" />
                  </div>
                  <h3 className="font-bold text-blue-900 mb-1">프리미엄으로 업그레이드</h3>
                  <p className="text-sm text-blue-700 mb-4">더 깊은 분석과 독점 가이드북을 확인하세요</p>
                  <Button className="w-full bg-blue-600 hover:bg-blue-700 text-white">
                    업그레이드 하기
                  </Button>
                </CardContent>
              </Card>
            </aside>

          </div>
        </div>
      </main>
    </div>
  );
};

// Helper component for icon
function DollarSignIcon(props: React.SVGProps<SVGSVGElement>) {
  return (
    <svg
      {...props}
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      <line x1="12" x2="12" y1="2" y2="22" />
      <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6" />
    </svg>
  );
}

export default ToolDetail;
