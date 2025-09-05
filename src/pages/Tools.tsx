import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import { supabase } from '@/integrations/supabase/client';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Skeleton } from '@/components/ui/skeleton';
import { StarRating } from '@/components/ui/StarRating';
import { 
  Search, 
  Filter, 
  Star, 
  ExternalLink, 
  Grid3X3, 
  List,
  TrendingUp,
  Clock,
  Users,
  Zap,
  GitCompare
} from 'lucide-react';
import Navbar from '@/components/ui/navbar';

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

interface Category {
  id: number;
  name: string;
  description: string | null;
}

const Tools = () => {
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<string>('all');
  const [sortBy, setSortBy] = useState<string>('rating');
  const [viewMode, setViewMode] = useState<'grid' | 'list'>('grid');
  const [priceFilter, setPriceFilter] = useState<string>('all');
  const [compareTools, setCompareTools] = useState<number[]>([]);

  // AI 모델 데이터 가져오기
  const { data: aiModels, isLoading: modelsLoading } = useQuery({
    queryKey: ['aiModels', searchQuery, selectedCategory, sortBy, priceFilter],
    queryFn: async () => {
      let query = supabase
        .from('ai_models')
        .select('*')
        .order('created_at', { ascending: false });

      // 검색 필터
      if (searchQuery) {
        query = query.or(`name.ilike.%${searchQuery}%, description.ilike.%${searchQuery}%`);
      }

      // 카테고리 필터 (ai_models 테이블에 category_id가 없으므로 일단 전체 조회)
      // TODO: 나중에 ai_models 테이블에 category_id 추가 필요

      // 정렬
      switch (sortBy) {
        case 'rating':
          query = query.order('average_rating', { ascending: false });
          break;
        case 'name':
          query = query.order('name', { ascending: true });
          break;
        case 'newest':
          query = query.order('created_at', { ascending: false });
          break;
        case 'popular':
          query = query.order('rating_count', { ascending: false });
          break;
      }

      const { data, error } = await query;
      if (error) throw error;
      return data as AIModel[];
    },
  });

  // 카테고리 데이터 가져오기
  const { data: categories, isLoading: categoriesLoading } = useQuery({
    queryKey: ['categories'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('categories')
        .select('*')
        .order('name');
      
      if (error) throw error;
      return data as Category[];
    },
  });

  const filteredModels = aiModels?.filter(model => {
    // 가격 필터 (간단한 텍스트 매칭)
    if (priceFilter !== 'all') {
      const pricing = model.pricing_info?.toLowerCase() || '';
      if (priceFilter === 'free' && !pricing.includes('free')) return false;
      if (priceFilter === 'paid' && pricing.includes('free')) return false;
    }
    return true;
  });

  const toggleCompare = (toolId: number) => {
    if (compareTools.includes(toolId)) {
      setCompareTools(compareTools.filter(id => id !== toolId));
    } else if (compareTools.length < 4) {
      setCompareTools([...compareTools, toolId]);
    } else {
      alert('최대 4개까지 비교할 수 있습니다.');
    }
  };

  const goToCompare = () => {
    if (compareTools.length < 2) {
      alert('최소 2개 이상의 도구를 선택해주세요.');
      return;
    }
    window.location.href = `/tools/compare?tools=${compareTools.join(',')}`;
  };

  const renderSkeleton = () => (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      {Array.from({ length: 6 }).map((_, i) => (
        <Card key={i}>
          <CardHeader>
            <div className="flex items-center gap-3">
              <Skeleton className="w-12 h-12 rounded-lg" />
              <div className="flex-1">
                <Skeleton className="h-6 w-32 mb-2" />
                <Skeleton className="h-4 w-24" />
              </div>
            </div>
          </CardHeader>
          <CardContent>
            <Skeleton className="h-4 w-full mb-2" />
            <Skeleton className="h-4 w-3/4 mb-4" />
            <div className="flex gap-2 mb-4">
              <Skeleton className="h-6 w-16" />
              <Skeleton className="h-6 w-20" />
            </div>
            <Skeleton className="h-8 w-full" />
          </CardContent>
        </Card>
      ))}
    </div>
  );

  const renderModelCard = (model: AIModel) => (
    <Card key={model.id} className={`hover:shadow-lg transition-shadow ${compareTools.includes(model.id) ? 'ring-2 ring-primary' : ''}`}>
      <CardHeader>
        <div className="flex items-start gap-3">
          <div className="w-12 h-12 bg-gradient-to-br from-blue-500 to-purple-600 rounded-lg flex items-center justify-center text-white font-bold text-lg">
            {model.logo_url ? (
              <img src={model.logo_url} alt={model.name} className="w-8 h-8 rounded" />
            ) : (
              model.name.charAt(0).toUpperCase()
            )}
          </div>
          <div className="flex-1 min-w-0">
            <CardTitle className="text-lg mb-1 truncate">{model.name}</CardTitle>
            <p className="text-sm text-muted-foreground truncate">
              {model.provider || 'Unknown Provider'}
            </p>
          </div>
          <div className="flex items-center gap-2">
            <div className="flex items-center gap-1">
              <Star className="w-4 h-4 fill-yellow-400 text-yellow-400" />
              <span className="text-sm font-medium">
                {model.average_rating.toFixed(1)}
              </span>
              <span className="text-xs text-muted-foreground">
                ({model.rating_count})
              </span>
            </div>
            <Button
              variant={compareTools.includes(model.id) ? "default" : "outline"}
              size="sm"
              onClick={() => toggleCompare(model.id)}
              className="h-8 w-8 p-0"
            >
              <GitCompare className="w-4 h-4" />
            </Button>
          </div>
        </div>
      </CardHeader>
      <CardContent>
        <p className="text-sm text-muted-foreground mb-4 line-clamp-2">
          {model.description || '설명이 없습니다.'}
        </p>
        
        <div className="flex flex-wrap gap-2 mb-4">
          {model.features?.slice(0, 3).map((feature, index) => (
            <Badge key={index} variant="secondary" className="text-xs">
              {feature}
            </Badge>
          ))}
          {model.features && model.features.length > 3 && (
            <Badge variant="outline" className="text-xs">
              +{model.features.length - 3}
            </Badge>
          )}
        </div>

        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2 text-sm text-muted-foreground">
            <Clock className="w-4 h-4" />
            <span>{model.pricing_info || '가격 정보 없음'}</span>
          </div>
          <div className="flex gap-2">
            <Button asChild size="sm" variant="outline">
              <Link to={`/tools/${model.id}`}>
                자세히 보기
              </Link>
            </Button>
            {model.website_url && (
              <Button asChild size="sm">
                <a href={model.website_url} target="_blank" rel="noopener noreferrer">
                  <ExternalLink className="w-4 h-4" />
                </a>
              </Button>
            )}
          </div>
        </div>
      </CardContent>
    </Card>
  );

  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      <main className="pt-24 pb-12">
        <div className="container mx-auto px-6">
          {/* 헤더 */}
          <div className="text-center mb-12">
            <h1 className="text-4xl md:text-5xl font-bold mb-4">AI 도구 디렉토리</h1>
            <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
              검증된 AI 도구들을 카테고리별로 찾아보고, 사용자 리뷰와 평점을 확인해보세요
            </p>
          </div>

          {/* 검색 및 필터 */}
          <div className="mb-8">
            <div className="flex flex-col lg:flex-row gap-4 mb-6">
              {/* 검색바 */}
              <div className="relative flex-1">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground w-4 h-4" />
                <Input
                  placeholder="AI 도구를 검색해보세요..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="pl-10"
                />
              </div>

              {/* 카테고리 필터 */}
              <Select value={selectedCategory} onValueChange={setSelectedCategory}>
                <SelectTrigger className="w-full lg:w-48">
                  <SelectValue placeholder="카테고리 선택" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">전체 카테고리</SelectItem>
                  {categories?.map((category) => (
                    <SelectItem key={category.id} value={category.id.toString()}>
                      {category.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>

              {/* 가격 필터 */}
              <Select value={priceFilter} onValueChange={setPriceFilter}>
                <SelectTrigger className="w-full lg:w-32">
                  <SelectValue placeholder="가격" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">전체</SelectItem>
                  <SelectItem value="free">무료</SelectItem>
                  <SelectItem value="paid">유료</SelectItem>
                </SelectContent>
              </Select>

              {/* 정렬 */}
              <Select value={sortBy} onValueChange={setSortBy}>
                <SelectTrigger className="w-full lg:w-32">
                  <SelectValue placeholder="정렬" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="rating">평점순</SelectItem>
                  <SelectItem value="name">이름순</SelectItem>
                  <SelectItem value="newest">최신순</SelectItem>
                  <SelectItem value="popular">인기순</SelectItem>
                </SelectContent>
              </Select>

              {/* 뷰 모드 */}
              <div className="flex border rounded-lg">
                <Button
                  variant={viewMode === 'grid' ? 'default' : 'ghost'}
                  size="sm"
                  onClick={() => setViewMode('grid')}
                  className="rounded-r-none"
                >
                  <Grid3X3 className="w-4 h-4" />
                </Button>
                <Button
                  variant={viewMode === 'list' ? 'default' : 'ghost'}
                  size="sm"
                  onClick={() => setViewMode('list')}
                  className="rounded-l-none"
                >
                  <List className="w-4 h-4" />
                </Button>
              </div>
            </div>

            {/* 결과 통계 및 비교 버튼 */}
            <div className="flex items-center justify-between text-sm text-muted-foreground">
              <span>
                총 {filteredModels?.length || 0}개의 AI 도구를 찾았습니다
                {compareTools.length > 0 && (
                  <span className="ml-2 text-primary font-medium">
                    ({compareTools.length}개 선택됨)
                  </span>
                )}
              </span>
              <div className="flex items-center gap-4">
                {compareTools.length > 0 && (
                  <Button onClick={goToCompare} className="bg-primary hover:bg-primary/90">
                    <GitCompare className="w-4 h-4 mr-2" />
                    비교하기 ({compareTools.length})
                  </Button>
                )}
                <div className="flex items-center gap-1">
                  <TrendingUp className="w-4 h-4" />
                  <span>인기 도구</span>
                </div>
                <div className="flex items-center gap-1">
                  <Users className="w-4 h-4" />
                  <span>커뮤니티 검증</span>
                </div>
                <div className="flex items-center gap-1">
                  <Zap className="w-4 h-4" />
                  <span>실시간 업데이트</span>
                </div>
              </div>
            </div>
          </div>

          {/* AI 도구 목록 */}
          <div className="mb-8">
            {modelsLoading ? (
              renderSkeleton()
            ) : filteredModels && filteredModels.length > 0 ? (
              <div className={`grid gap-6 ${
                viewMode === 'grid' 
                  ? 'grid-cols-1 md:grid-cols-2 lg:grid-cols-3' 
                  : 'grid-cols-1'
              }`}>
                {filteredModels.map(renderModelCard)}
              </div>
            ) : (
              <div className="text-center py-12">
                <div className="w-24 h-24 bg-muted rounded-full flex items-center justify-center mx-auto mb-4">
                  <Search className="w-12 h-12 text-muted-foreground" />
                </div>
                <h3 className="text-xl font-semibold mb-2">검색 결과가 없습니다</h3>
                <p className="text-muted-foreground mb-4">
                  다른 검색어나 필터를 시도해보세요
                </p>
                <Button onClick={() => {
                  setSearchQuery('');
                  setSelectedCategory('all');
                  setPriceFilter('all');
                }}>
                  필터 초기화
                </Button>
              </div>
            )}
          </div>

          {/* 추천 섹션 */}
          <div className="bg-muted/50 rounded-lg p-8">
            <h2 className="text-2xl font-bold mb-4">추천 AI 도구</h2>
            <p className="text-muted-foreground mb-6">
              커뮤니티에서 가장 인기 있는 AI 도구들을 확인해보세요
            </p>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div className="bg-background rounded-lg p-4 border">
                <div className="flex items-center gap-3 mb-3">
                  <div className="w-10 h-10 bg-gradient-to-br from-green-500 to-blue-600 rounded-lg flex items-center justify-center text-white font-bold">
                    C
                  </div>
                  <div>
                    <h3 className="font-semibold">ChatGPT</h3>
                    <p className="text-sm text-muted-foreground">OpenAI</p>
                  </div>
                </div>
                <div className="flex items-center gap-1 mb-2">
                  <Star className="w-4 h-4 fill-yellow-400 text-yellow-400" />
                  <span className="text-sm font-medium">4.8</span>
                  <span className="text-xs text-muted-foreground">(1,234)</span>
                </div>
                <p className="text-sm text-muted-foreground">범용 대화형 AI</p>
              </div>
              
              <div className="bg-background rounded-lg p-4 border">
                <div className="flex items-center gap-3 mb-3">
                  <div className="w-10 h-10 bg-gradient-to-br from-purple-500 to-pink-600 rounded-lg flex items-center justify-center text-white font-bold">
                    M
                  </div>
                  <div>
                    <h3 className="font-semibold">Midjourney</h3>
                    <p className="text-sm text-muted-foreground">Midjourney Inc.</p>
                  </div>
                </div>
                <div className="flex items-center gap-1 mb-2">
                  <Star className="w-4 h-4 fill-yellow-400 text-yellow-400" />
                  <span className="text-sm font-medium">4.9</span>
                  <span className="text-xs text-muted-foreground">(856)</span>
                </div>
                <p className="text-sm text-muted-foreground">AI 이미지 생성</p>
              </div>
              
              <div className="bg-background rounded-lg p-4 border">
                <div className="flex items-center gap-3 mb-3">
                  <div className="w-10 h-10 bg-gradient-to-br from-orange-500 to-red-600 rounded-lg flex items-center justify-center text-white font-bold">
                    G
                  </div>
                  <div>
                    <h3 className="font-semibold">GitHub Copilot</h3>
                    <p className="text-sm text-muted-foreground">GitHub</p>
                  </div>
                </div>
                <div className="flex items-center gap-1 mb-2">
                  <Star className="w-4 h-4 fill-yellow-400 text-yellow-400" />
                  <span className="text-sm font-medium">4.7</span>
                  <span className="text-xs text-muted-foreground">(2,156)</span>
                </div>
                <p className="text-sm text-muted-foreground">AI 코드 어시스턴트</p>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
};

export default Tools;
