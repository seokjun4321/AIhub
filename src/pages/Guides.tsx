import { useMemo, useState, useEffect } from "react";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { Badge } from "@/components/ui/badge";
import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Search, Clock, Video, FileText, ExternalLink, Sparkles, BookOpen, Lightbulb } from "lucide-react";
import { Input } from "@/components/ui/input";
import { useAuth } from "@/hooks/useAuth";

const TOTAL_CHAPTERS = 10;

// Supabase에서 프롬프트 엔지니어링 진행도 가져오기
const fetchPromptEngineeringProgressCount = async (userId: string | undefined): Promise<number> => {
  if (!userId) return 0;

  const { data, error } = await (supabase as any)
    .from('prompt_engineering_progress')
    .select('chapter_id')
    .eq('user_id', userId)
    .eq('completed', true);

  if (error) {
    console.error('Failed to load prompt engineering progress', error);
    return 0;
  }

  return data?.length || 0;
};

// 카테고리별 가이드북 가져오기
const fetchGuidesByCategory = async (categoryName: string) => {
  // 먼저 카테고리 ID 가져오기
  const { data: categoryData, error: categoryError } = await supabase
    .from('categories')
    .select('id')
    .eq('name', categoryName)
    .single();

  if (categoryError || !categoryData) {
    console.error(`❌ ${categoryName} 카테고리 찾기 에러:`, categoryError);
    return [];
  }

  // 기본 guides 테이블 조회 (우선 단일 카테고리만 지원)
  const { data, error } = await supabase
    .from('guides')
    .select(`
      id,
      title,
      description,
      image_url,
      difficulty_level,
      estimated_time,
      created_at,
      categories(name),
      ai_models(name, logo_url),
      profiles(username)
    `)
    .eq('category_id', categoryData.id)
    .order('created_at', { ascending: false })
    .limit(4);

  if (error) {
    console.error(`❌ ${categoryName} 카테고리 가이드북 가져오기 에러:`, error);
    return [];
  }

  return data || [];
};

// 모든 카테고리 가져오기
const fetchCategories = async () => {
  const { data, error } = await supabase
    .from('categories')
    .select('id, name, description')
    .order('name');

  if (error) {
    console.error('❌ 카테고리 가져오기 에러:', error);
    return [];
  }

  return data || [];
};

// 모든 가이드북 가져오기 (검색용)
const fetchAllGuides = async () => {
  const { data, error } = await supabase
    .from('guides')
    .select(`
      id,
      title,
      description,
      difficulty_level,
      estimated_time,
      categories(name),
      ai_models(name, logo_url)
    `)
    .order('created_at', { ascending: false });

  if (error) {
    console.error('❌ 가이드북 가져오기 에러:', error);
    return [] as any[];
  }

  return (data || []) as any[];
};

// 레벨 표시 함수
const getLevelBadge = (level: string | null) => {
  if (!level) return null;

  const levelMap: Record<string, { label: string; variant: "default" | "secondary" | "destructive" | "outline" }> = {
    'beginner': { label: 'Lv.1 초급', variant: 'default' },
    'intermediate': { label: 'Lv.2 중급', variant: 'secondary' },
    'advanced': { label: 'Lv.3 고급', variant: 'destructive' },
  };

  const levelInfo = levelMap[level.toLowerCase()] || { label: level, variant: 'outline' as const };

  return (
    <Badge variant={levelInfo.variant} className="text-xs">
      {levelInfo.label}
    </Badge>
  );
};

// 포맷 표시 함수 (임시로 estimated_time 기반으로 결정)
const getFormatIcon = (time: number | null) => {
  // 실제로는 DB에 format 필드가 있어야 하지만, 임시로 시간 기반으로 결정
  if (!time) return <FileText className="w-4 h-4" />;
  if (time > 25) return <Video className="w-4 h-4" />;
  return <FileText className="w-4 h-4" />;
};

const getFormatText = (time: number | null) => {
  if (!time) return '텍스트 가이드';
  if (time > 25) return '비디오 + PDF';
  if (time > 15) return '실습형';
  return '텍스트 가이드';
};

// 카테고리별 섹션 정보는 이제 DB에서 가져옵니다
// 하드코딩 제거됨 - fetchCategories() 사용

const Guides = () => {
  const { user } = useAuth();
  const queryClient = useQueryClient();
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedCategory, setSelectedCategory] = useState("전체");
  const [selectedLevel, setSelectedLevel] = useState("전체");

  // 프롬프트 엔지니어링 진행도 가져오기
  const { data: promptEngineeringProgress = 0 } = useQuery({
    queryKey: ['promptEngineeringProgressCount', user?.id],
    queryFn: () => fetchPromptEngineeringProgressCount(user?.id),
    enabled: !!user,
  });

  // 프롬프트 엔지니어링 진행도 업데이트 리스너
  useEffect(() => {
    const handleProgressChange = () => {
      // React Query가 자동으로 refetch하도록 invalidate
      if (user) {
        queryClient.invalidateQueries({ queryKey: ['promptEngineeringProgressCount', user.id] });
      }
    };

    window.addEventListener('promptEngineeringProgressChanged', handleProgressChange);
    return () => {
      window.removeEventListener('promptEngineeringProgressChanged', handleProgressChange);
    };
  }, [user, queryClient]);

  // 카테고리 가져오기 (DB에서 동적으로)
  const { data: categories, isLoading: categoriesLoading } = useQuery({
    queryKey: ['categories'],
    queryFn: fetchCategories
  });

  // 모든 가이드를 한번에 가져오기 (Hooks 규칙 준수)
  const { data: allGuidesWithCategories, isLoading: allGuidesWithCategoriesLoading } = useQuery({
    queryKey: ['allGuidesWithCategories'],
    queryFn: fetchAllGuides
  });

  // 카테고리별로 가이드 그룹화
  const categoryGuidesMap = useMemo(() => {
    if (!allGuidesWithCategories || !categories) return {};

    const map: Record<string, any[]> = {};
    categories.forEach((category: any) => {
      map[category.name] = allGuidesWithCategories
        .filter((guide: any) => (guide.categories as any)?.name === category.name)
        .slice(0, 4); // 각 카테고리당 최대 4개
    });

    return map;
  }, [allGuidesWithCategories, categories]);

  // displayCategories는 categories 데이터 사용
  const displayCategories = categories || [];

  // 검색용 가이드북 가져오기
  const { data: allGuides, isLoading: allGuidesLoading } = useQuery({
    queryKey: ['allGuides'],
    queryFn: fetchAllGuides
  });

  // 검색 필터링
  const filteredGuides = useMemo(() => {
    if (!allGuides) return [];

    let filtered = [...allGuides] as any[];

    // 검색어 필터
    if (searchQuery) {
      filtered = filtered.filter((guide: any) =>
        guide.title?.toLowerCase().includes(searchQuery.toLowerCase()) ||
        guide.description?.toLowerCase().includes(searchQuery.toLowerCase())
      );
    }

    // 카테고리 필터
    if (selectedCategory !== "전체") {
      filtered = filtered.filter((guide: any) =>
        (guide.categories as any)?.name === selectedCategory
      );
    }

    // 레벨 필터
    if (selectedLevel !== "전체") {
      const levelMap: Record<string, string> = {
        '초급': 'beginner',
        '중급': 'intermediate',
        '고급': 'advanced'
      };
      filtered = filtered.filter((guide: any) =>
        guide.difficulty_level === levelMap[selectedLevel]
      );
    }

    return filtered;
  }, [allGuides, searchQuery, selectedCategory, selectedLevel]);

  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      <main className="pt-24 pb-12">
        <div className="container mx-auto px-6">
          {/* 메인 히어로 섹션 */}
          <div className="text-center mb-16">
            <h1 className="text-5xl md:text-6xl font-bold mb-6">AI 가이드북 라이브러리</h1>
            <p className="text-xl text-muted-foreground max-w-3xl mx-auto mb-8">
              AI를 진짜로 활용하는 방법을 배우세요 — 프롬프트 엔지니어링 기초부터 에세이 작성, 학습, 취업 준비, 스타트업 워크플로우까지.
            </p>
            <div className="relative max-w-2xl mx-auto">
              <Search className="absolute left-4 top-1/2 transform -translate-y-1/2 text-muted-foreground w-5 h-5" />
              <Input
                type="text"
                placeholder="예: 리포트 작성, 장학금 에세이, n8n 자동화..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="pl-12 h-14 text-lg"
              />
            </div>
          </div>

          {/* 프롬프트 엔지니어링 필수 섹션 */}
          <div className="mb-12">
            <Card className="bg-white border shadow-lg overflow-hidden">
              <CardContent className="p-6 md:p-8">
                <div>
                  {/* 메인 콘텐츠 */}
                  <div>
                    <div className="flex items-center gap-2 mb-3">
                      <Badge className="bg-blue-100 text-blue-700 border-blue-200 hover:bg-blue-100 text-xs px-3 py-1">
                        <Sparkles className="w-3 h-3 mr-1" />
                        AIHub 필수 입문
                      </Badge>
                    </div>
                    <h2 className="text-2xl md:text-3xl font-bold mb-3 text-foreground">
                      프롬프트 엔지니어링 가이드북
                    </h2>
                    <p className="text-base text-muted-foreground mb-6 leading-relaxed">
                      다른 AI 가이드북을 보기 전에, 프롬프트를 어떻게 설계해야 하는지 먼저 배울 수 있는 입문 가이드입니다.
                    </p>

                    {/* 토픽 태그들 */}
                    <div className="flex flex-wrap gap-2 mb-6">
                      <Badge variant="outline" className="bg-gray-50 text-gray-700 border-gray-200 text-xs px-3 py-1">
                        <BookOpen className="w-3 h-3 mr-1" />
                        프롬프트 구조 RCTFP
                      </Badge>
                      <Badge variant="outline" className="bg-gray-50 text-gray-700 border-gray-200 text-xs px-3 py-1">
                        <Lightbulb className="w-3 h-3 mr-1" />
                        Few-shot & Chain-of-Thought
                      </Badge>
                      <Badge variant="outline" className="bg-gray-50 text-gray-700 border-gray-200 text-xs px-3 py-1">
                        <Sparkles className="w-3 h-3 mr-1" />
                        나만의 마스터 프롬프트 만들기
                      </Badge>
                    </div>

                    {/* 버튼들 */}
                    <div className="flex flex-wrap gap-3">
                      <Button
                        asChild
                        size="default"
                        className="bg-blue-600 text-white hover:bg-blue-700 font-semibold"
                      >
                        <Link to="/prompt-engineering">
                          가이드북 시작하기
                        </Link>
                      </Button>
                      <Button
                        asChild
                        variant="outline"
                        size="default"
                        className="border-gray-300"
                      >
                        <Link to="/prompt-engineering">
                          자세히 보기
                        </Link>
                      </Button>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>

          {/* 검색 결과 또는 사용 목적별 가이드북 섹션 */}
          {searchQuery || selectedCategory !== "전체" || selectedLevel !== "전체" ? (
            /* 검색/필터 결과 섹션 */
            <div className="grid lg:grid-cols-[1fr,320px] gap-8">
              <div>
                <div className="flex items-center justify-between mb-6">
                  <div>
                    <h2 className="text-3xl font-bold mb-2">
                      {searchQuery ? `"${searchQuery}" 검색 결과` : "필터링된 가이드북"}
                    </h2>
                    <p className="text-muted-foreground">
                      {filteredGuides.length}개의 가이드북을 찾았습니다
                    </p>
                  </div>
                  <Button
                    variant="outline"
                    onClick={() => {
                      setSearchQuery("");
                      setSelectedCategory("전체");
                      setSelectedLevel("전체");
                    }}
                  >
                    필터 초기화
                  </Button>
                </div>

                {allGuidesLoading ? (
                  <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
                    {[...Array(6)].map((_, i) => (
                      <Card key={i}>
                        <CardHeader>
                          <Skeleton className="h-4 w-20 mb-2" />
                          <Skeleton className="h-6 w-full mb-2" />
                          <Skeleton className="h-4 w-3/4" />
                        </CardHeader>
                        <CardContent>
                          <Skeleton className="h-10 w-full" />
                        </CardContent>
                      </Card>
                    ))}
                  </div>
                ) : filteredGuides.length > 0 ? (
                  <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
                    {filteredGuides.map((guide: any) => (
                      <Link to={`/guides/${guide.id}`} key={guide.id}>
                        <Card className="h-full hover:shadow-lg transition-all hover:border-primary/50 flex flex-col group">
                          <CardHeader className="pb-3">
                            <div className="flex items-center gap-2 mb-3 flex-wrap">
                              {guide.ai_models && (
                                <Badge variant="outline" className="text-xs">
                                  {(guide.ai_models as any)?.name || 'AI 도구'}
                                </Badge>
                              )}
                              {getLevelBadge(guide.difficulty_level)}
                            </div>
                            <CardTitle className="text-lg mb-2 line-clamp-2 group-hover:text-primary transition-colors">
                              {guide.title}
                            </CardTitle>
                            <CardDescription className="line-clamp-2 text-sm">
                              {guide.description || '설명이 없습니다.'}
                            </CardDescription>
                          </CardHeader>
                          <CardContent className="flex-1 flex flex-col justify-between pt-0">
                            <div className="space-y-2 mb-4">
                              {guide.estimated_time && (
                                <div className="flex items-center gap-2 text-sm text-muted-foreground">
                                  <Clock className="w-4 h-4" />
                                  <span>{guide.estimated_time}분</span>
                                </div>
                              )}
                              <div className="flex items-center gap-2 text-sm text-muted-foreground">
                                {getFormatIcon(guide.estimated_time)}
                                <span>{getFormatText(guide.estimated_time)}</span>
                              </div>
                            </div>
                            <Button className="w-full" variant="default">
                              가이드 열기
                              <ExternalLink className="w-4 h-4 ml-2" />
                            </Button>
                          </CardContent>
                        </Card>
                      </Link>
                    ))}
                  </div>
                ) : (
                  <div className="text-center py-12">
                    <div className="w-20 h-20 bg-muted rounded-full flex items-center justify-center mx-auto mb-4">
                      <Search className="w-8 h-8 text-muted-foreground" />
                    </div>
                    <p className="text-lg text-muted-foreground mb-2">
                      검색 결과가 없습니다
                    </p>
                    <p className="text-sm text-muted-foreground">
                      다른 검색어나 필터를 시도해보세요
                    </p>
                  </div>
                )}
              </div>

              {/* 오른쪽 사이드바 (검색 결과 페이지에서도 동일) */}
              <div className="space-y-6 sticky-sidebar">
                {/* Sell Guidebook Button */}
                <Link to="/guide/new" className="block">
                  <div className="bg-gradient-to-r from-emerald-500 to-teal-600 text-white p-4 rounded-xl shadow-lg hover:shadow-xl transition-all hover:scale-[1.02] flex items-center justify-between group cursor-pointer">
                    <div>
                      <h3 className="font-bold text-lg">가이드북 판매하기</h3>
                      <p className="text-emerald-100 text-sm">나만의 노하우를 공유하세요</p>
                    </div>
                    <div className="bg-white/20 p-2 rounded-lg group-hover:bg-white/30 transition-colors">
                      <Sparkles className="w-5 h-5 text-white" />
                    </div>
                  </div>
                </Link>

                <Card>
                  <CardHeader>
                    <CardTitle className="text-lg">내 학습 진행</CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <div>
                      <div className="flex items-center justify-between mb-2">
                        <span className="text-sm font-medium">프롬프트 엔지니어링 가이드북</span>
                        <Badge variant="secondary" className="text-xs">진행 중</Badge>
                      </div>
                      <div className="space-y-2">
                        <div className="flex items-center justify-between text-sm text-muted-foreground">
                          <span>{promptEngineeringProgress}/{TOTAL_CHAPTERS} 챕터 완료</span>
                        </div>
                        <div className="w-full bg-muted rounded-full h-2 overflow-hidden">
                          <div
                            className="bg-primary h-full rounded-full transition-all duration-500"
                            style={{ width: `${(promptEngineeringProgress / TOTAL_CHAPTERS) * 100}%` }}
                          />
                        </div>
                      </div>
                    </div>
                  </CardContent>
                </Card>

                <Card>
                  <CardHeader>
                    <CardTitle className="text-lg">AIHub 추천 가이드</CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    {allGuides && allGuides.slice(0, 2).map((guide: any) => (
                      <Link to={`/guides/${guide.id}`} key={guide.id}>
                        <div className="p-3 rounded-lg border hover:bg-muted/50 transition-colors">
                          <div className="flex items-center gap-2 mb-2">
                            {guide.ai_models && (
                              <Badge variant="outline" className="text-xs">
                                {(guide.ai_models as any)?.name || 'AI 도구'}
                              </Badge>
                            )}
                            {getLevelBadge(guide.difficulty_level)}
                          </div>
                          <h4 className="font-semibold text-sm mb-1 line-clamp-2">{guide.title}</h4>
                          <div className="flex items-center gap-2 text-xs text-muted-foreground">
                            {guide.estimated_time && (
                              <>
                                <Clock className="w-3 h-3" />
                                <span>{guide.estimated_time}</span>
                              </>
                            )}
                          </div>
                        </div>
                      </Link>
                    ))}
                  </CardContent>
                </Card>
              </div>
            </div>
          ) : (
            <div className="grid lg:grid-cols-[1fr,320px] gap-8">
              {/* 메인 콘텐츠 영역 */}
              <div>
                {/* 카테고리별 가이드북 섹션들 */}
                {displayCategories.map((category: any) => {
                  const guides = categoryGuidesMap[category.name] || [];
                  const isLoading = categoriesLoading || allGuidesWithCategoriesLoading;

                  return (
                    <div key={category.name} className="mb-16">
                      <div className="flex items-center justify-between mb-6">
                        <div className="flex-1">
                          <h3 className="text-2xl font-bold mb-2">{category.name}</h3>
                          <p className="text-muted-foreground">{category.description}</p>
                        </div>
                        <Link
                          to={`/guides?category=${encodeURIComponent(category.name)}`}
                          className="text-primary hover:underline whitespace-nowrap ml-4"
                        >
                          전체 보기 &gt;
                        </Link>
                      </div>

                      {isLoading ? (
                        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
                          {[...Array(4)].map((_, i) => (
                            <Card key={i}>
                              <CardHeader>
                                <Skeleton className="h-4 w-20 mb-2" />
                                <Skeleton className="h-6 w-full mb-2" />
                                <Skeleton className="h-4 w-3/4" />
                              </CardHeader>
                              <CardContent>
                                <Skeleton className="h-10 w-full" />
                              </CardContent>
                            </Card>
                          ))}
                        </div>
                      ) : guides && guides.length > 0 ? (
                        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
                          {guides.map((guide: any) => (
                            <Link to={`/guides/${guide.id}`} key={guide.id} className="block h-full">
                              <Card className="h-full hover:shadow-lg transition-all hover:border-primary/50 flex flex-col group">
                                <CardHeader className="pb-3">
                                  <div className="flex items-center gap-2 mb-3 flex-wrap">
                                    {guide.ai_models && (
                                      <Badge variant="outline" className="text-xs">
                                        {(guide.ai_models as any)?.name || 'AI 도구'}
                                      </Badge>
                                    )}
                                    {getLevelBadge(guide.difficulty_level)}
                                  </div>
                                  <CardTitle className="text-lg mb-2 line-clamp-2 group-hover:text-primary transition-colors">
                                    {guide.title}
                                  </CardTitle>
                                  <CardDescription className="line-clamp-2 text-sm">
                                    {guide.description || '설명이 없습니다.'}
                                  </CardDescription>
                                </CardHeader>
                                <CardContent className="flex-1 flex flex-col justify-between pt-0">
                                  <div className="space-y-2 mb-4">
                                    {guide.estimated_time && (
                                      <div className="flex items-center gap-2 text-sm text-muted-foreground">
                                        <Clock className="w-4 h-4" />
                                        <span>{guide.estimated_time}</span>
                                      </div>
                                    )}
                                    <div className="flex items-center gap-2 text-sm text-muted-foreground">
                                      {getFormatIcon(guide.estimated_time)}
                                      <span>{getFormatText(guide.estimated_time)}</span>
                                    </div>
                                  </div>
                                  <Button className="w-full" variant="default">
                                    가이드 열기
                                    <ExternalLink className="w-4 h-4 ml-2" />
                                  </Button>
                                </CardContent>
                              </Card>
                            </Link>
                          ))}
                        </div>
                      ) : (
                        <div className="text-center py-8 text-muted-foreground">
                          <p>이 카테고리의 가이드북이 아직 없습니다.</p>
                        </div>
                      )}
                    </div>
                  );
                })}
              </div>

              {/* 오른쪽 사이드바 */}
              <div className="space-y-6 sticky-sidebar">
                {/* Sell Guidebook Button */}
                <Link to="/guide/new" className="block">
                  <div className="bg-gradient-to-r from-emerald-500 to-teal-600 text-white p-4 rounded-xl shadow-lg hover:shadow-xl transition-all hover:scale-[1.02] flex items-center justify-between group cursor-pointer">
                    <div>
                      <h3 className="font-bold text-lg">가이드북 판매하기</h3>
                      <p className="text-emerald-100 text-sm">나만의 노하우를 공유하세요</p>
                    </div>
                    <div className="bg-white/20 p-2 rounded-lg group-hover:bg-white/30 transition-colors">
                      <Sparkles className="w-5 h-5 text-white" />
                    </div>
                  </div>
                </Link>

                {/* 내 학습 진행 */}
                <Card>
                  <CardHeader>
                    <CardTitle className="text-lg">내 학습 진행</CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <div>
                      <div className="flex items-center justify-between mb-2">
                        <span className="text-sm font-medium">프롬프트 엔지니어링 가이드북</span>
                        <Badge variant="secondary" className="text-xs">진행 중</Badge>
                      </div>
                      <div className="space-y-2">
                        <div className="flex items-center justify-between text-sm text-muted-foreground">
                          <span>{promptEngineeringProgress}/{TOTAL_CHAPTERS} 챕터 완료</span>
                        </div>
                        <div className="w-full bg-muted rounded-full h-2 overflow-hidden">
                          <div
                            className="bg-primary h-full rounded-full transition-all duration-500"
                            style={{ width: `${(promptEngineeringProgress / TOTAL_CHAPTERS) * 100}%` }}
                          />
                        </div>
                      </div>
                    </div>
                  </CardContent>
                </Card>

                {/* AIHub 추천 가이드 */}
                <Card>
                  <CardHeader>
                    <CardTitle className="text-lg">AIHub 추천 가이드</CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    {allGuides && allGuides.slice(0, 2).map((guide: any) => (
                      <Link to={`/guides/${guide.id}`} key={guide.id}>
                        <div className="p-3 rounded-lg border hover:bg-muted/50 transition-colors">
                          <div className="flex items-center gap-2 mb-2">
                            {guide.ai_models && (
                              <Badge variant="outline" className="text-xs">
                                {(guide.ai_models as any)?.name || 'AI 도구'}
                              </Badge>
                            )}
                            {getLevelBadge(guide.difficulty_level)}
                          </div>
                          <h4 className="font-semibold text-sm mb-1 line-clamp-2">{guide.title}</h4>
                          <div className="flex items-center gap-2 text-xs text-muted-foreground">
                            {guide.estimated_time && (
                              <>
                                <Clock className="w-3 h-3" />
                                <span>{guide.estimated_time}분</span>
                              </>
                            )}
                          </div>
                        </div>
                      </Link>
                    ))}
                  </CardContent>
                </Card>
              </div>
            </div>
          )}
        </div>
      </main>
      <Footer />
    </div>
  );
};

export default Guides;