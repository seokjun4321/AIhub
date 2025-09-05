import { useState, useEffect } from 'react';
import { useSearchParams, Link } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import { supabase } from '@/integrations/supabase/client';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Skeleton } from '@/components/ui/skeleton';
import { 
  Star, 
  ExternalLink, 
  Plus,
  X,
  CheckCircle,
  XCircle,
  DollarSign,
  Users,
  Zap,
  Shield,
  Clock,
  ArrowLeft,
  Search
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

const ToolCompare = () => {
  const [searchParams, setSearchParams] = useSearchParams();
  const [selectedTools, setSelectedTools] = useState<number[]>([]);
  const [searchQuery, setSearchQuery] = useState('');
  const [showSearch, setShowSearch] = useState(false);

  // URL에서 비교할 도구 ID들 가져오기
  useEffect(() => {
    const toolIds = searchParams.get('tools')?.split(',').map(Number).filter(Boolean) || [];
    setSelectedTools(toolIds);
  }, [searchParams]);

  // AI 모델 목록 가져오기 (검색용)
  const { data: allTools, isLoading: toolsLoading } = useQuery({
    queryKey: ['allTools', searchQuery],
    queryFn: async () => {
      let query = supabase
        .from('ai_models')
        .select('*')
        .order('name');

      if (searchQuery) {
        query = query.or(`name.ilike.%${searchQuery}%, description.ilike.%${searchQuery}%`);
      }

      const { data, error } = await query;
      if (error) throw error;
      return data as AIModel[];
    },
  });

  // 선택된 도구들의 상세 정보 가져오기
  const { data: selectedToolsData, isLoading: selectedToolsLoading } = useQuery({
    queryKey: ['selectedTools', selectedTools],
    queryFn: async () => {
      if (selectedTools.length === 0) return [];
      
      const { data, error } = await supabase
        .from('ai_models')
        .select('*')
        .in('id', selectedTools);
      
      if (error) throw error;
      return data as AIModel[];
    },
    enabled: selectedTools.length > 0,
  });

  const addTool = (toolId: number) => {
    if (selectedTools.length >= 4) {
      alert('최대 4개까지 비교할 수 있습니다.');
      return;
    }
    if (selectedTools.includes(toolId)) {
      alert('이미 추가된 도구입니다.');
      return;
    }
    
    const newTools = [...selectedTools, toolId];
    setSelectedTools(newTools);
    setSearchParams({ tools: newTools.join(',') });
    setShowSearch(false);
  };

  const removeTool = (toolId: number) => {
    const newTools = selectedTools.filter(id => id !== toolId);
    setSelectedTools(newTools);
    if (newTools.length === 0) {
      setSearchParams({});
    } else {
      setSearchParams({ tools: newTools.join(',') });
    }
  };

  const clearAll = () => {
    setSelectedTools([]);
    setSearchParams({});
  };

  const renderComparisonTable = () => {
    if (!selectedToolsData || selectedToolsData.length === 0) {
      return (
        <div className="text-center py-12">
          <div className="w-24 h-24 bg-muted rounded-full flex items-center justify-center mx-auto mb-4">
            <Search className="w-12 h-12 text-muted-foreground" />
          </div>
          <h3 className="text-xl font-semibold mb-2">비교할 AI 도구를 선택하세요</h3>
          <p className="text-muted-foreground mb-4">
            최대 4개까지 AI 도구를 선택하여 비교할 수 있습니다
          </p>
          <Button onClick={() => setShowSearch(true)}>
            <Plus className="w-4 h-4 mr-2" />
            AI 도구 추가하기
          </Button>
        </div>
      );
    }

    return (
      <div className="overflow-x-auto">
        <table className="w-full border-collapse">
          <thead>
            <tr className="border-b">
              <th className="text-left p-4 font-semibold">항목</th>
              {selectedToolsData.map((tool) => (
                <th key={tool.id} className="text-center p-4 min-w-[200px]">
                  <div className="flex items-center justify-center gap-2 mb-2">
                    <div className="w-8 h-8 bg-gradient-to-br from-blue-500 to-purple-600 rounded-lg flex items-center justify-center text-white font-bold text-sm">
                      {tool.logo_url ? (
                        <img src={tool.logo_url} alt={tool.name} className="w-6 h-6 rounded" />
                      ) : (
                        tool.name.charAt(0).toUpperCase()
                      )}
                    </div>
                    <span className="font-semibold text-sm">{tool.name}</span>
                    <Button
                      variant="ghost"
                      size="sm"
                      onClick={() => removeTool(tool.id)}
                      className="h-6 w-6 p-0 text-muted-foreground hover:text-destructive"
                    >
                      <X className="w-3 h-3" />
                    </Button>
                  </div>
                  <p className="text-xs text-muted-foreground">{tool.provider}</p>
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {/* 기본 정보 */}
            <tr className="border-b">
              <td className="p-4 font-medium">설명</td>
              {selectedToolsData.map((tool) => (
                <td key={tool.id} className="p-4 text-sm text-muted-foreground">
                  {tool.description || '설명 없음'}
                </td>
              ))}
            </tr>
            
            <tr className="border-b">
              <td className="p-4 font-medium">타입</td>
              {selectedToolsData.map((tool) => (
                <td key={tool.id} className="p-4">
                  <Badge variant="secondary">{tool.model_type || 'AI Tool'}</Badge>
                </td>
              ))}
            </tr>
            
            <tr className="border-b">
              <td className="p-4 font-medium">평점</td>
              {selectedToolsData.map((tool) => (
                <td key={tool.id} className="p-4">
                  <div className="flex items-center gap-1">
                    <Star className="w-4 h-4 fill-yellow-400 text-yellow-400" />
                    <span className="font-semibold">{tool.average_rating.toFixed(1)}</span>
                    <span className="text-xs text-muted-foreground">({tool.rating_count})</span>
                  </div>
                </td>
              ))}
            </tr>
            
            <tr className="border-b">
              <td className="p-4 font-medium">가격</td>
              {selectedToolsData.map((tool) => (
                <td key={tool.id} className="p-4 text-sm">
                  {tool.pricing_info || '정보 없음'}
                </td>
              ))}
            </tr>
            
            {/* 주요 기능 */}
            <tr className="border-b">
              <td className="p-4 font-medium">주요 기능</td>
              {selectedToolsData.map((tool) => (
                <td key={tool.id} className="p-4">
                  {tool.features && tool.features.length > 0 ? (
                    <div className="space-y-1">
                      {tool.features.slice(0, 3).map((feature, index) => (
                        <div key={index} className="flex items-center gap-1 text-sm">
                          <CheckCircle className="w-3 h-3 text-green-500" />
                          <span>{feature}</span>
                        </div>
                      ))}
                      {tool.features.length > 3 && (
                        <div className="text-xs text-muted-foreground">
                          +{tool.features.length - 3}개 더
                        </div>
                      )}
                    </div>
                  ) : (
                    <span className="text-sm text-muted-foreground">정보 없음</span>
                  )}
                </td>
              ))}
            </tr>
            
            {/* 사용 사례 */}
            <tr className="border-b">
              <td className="p-4 font-medium">사용 사례</td>
              {selectedToolsData.map((tool) => (
                <td key={tool.id} className="p-4">
                  {tool.use_cases && tool.use_cases.length > 0 ? (
                    <div className="space-y-1">
                      {tool.use_cases.slice(0, 2).map((useCase, index) => (
                        <div key={index} className="text-sm text-muted-foreground">
                          • {useCase}
                        </div>
                      ))}
                      {tool.use_cases.length > 2 && (
                        <div className="text-xs text-muted-foreground">
                          +{tool.use_cases.length - 2}개 더
                        </div>
                      )}
                    </div>
                  ) : (
                    <span className="text-sm text-muted-foreground">정보 없음</span>
                  )}
                </td>
              ))}
            </tr>
            
            {/* 제한사항 */}
            <tr className="border-b">
              <td className="p-4 font-medium">제한사항</td>
              {selectedToolsData.map((tool) => (
                <td key={tool.id} className="p-4">
                  {tool.limitations && tool.limitations.length > 0 ? (
                    <div className="space-y-1">
                      {tool.limitations.slice(0, 2).map((limitation, index) => (
                        <div key={index} className="flex items-start gap-1 text-sm">
                          <XCircle className="w-3 h-3 text-red-500 mt-0.5 flex-shrink-0" />
                          <span>{limitation}</span>
                        </div>
                      ))}
                      {tool.limitations.length > 2 && (
                        <div className="text-xs text-muted-foreground">
                          +{tool.limitations.length - 2}개 더
                        </div>
                      )}
                    </div>
                  ) : (
                    <span className="text-sm text-muted-foreground">정보 없음</span>
                  )}
                </td>
              ))}
            </tr>
            
            {/* 액션 버튼 */}
            <tr>
              <td className="p-4 font-medium">액션</td>
              {selectedToolsData.map((tool) => (
                <td key={tool.id} className="p-4">
                  <div className="flex flex-col gap-2">
                    <Button asChild size="sm" className="w-full">
                      <Link to={`/tools/${tool.id}`}>
                        자세히 보기
                      </Link>
                    </Button>
                    {tool.website_url && (
                      <Button asChild size="sm" variant="outline" className="w-full">
                        <a href={tool.website_url} target="_blank" rel="noopener noreferrer">
                          <ExternalLink className="w-3 h-3 mr-1" />
                          웹사이트
                        </a>
                      </Button>
                    )}
                  </div>
                </td>
              ))}
            </tr>
          </tbody>
        </table>
      </div>
    );
  };

  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      <main className="pt-24 pb-12">
        <div className="container mx-auto px-6">
          {/* 헤더 */}
          <div className="flex items-center justify-between mb-8">
            <div>
              <div className="flex items-center gap-4 mb-4">
                <Button variant="ghost" size="sm" asChild>
                  <Link to="/tools">
                    <ArrowLeft className="w-4 h-4 mr-2" />
                    AI 도구 목록
                  </Link>
                </Button>
              </div>
              <h1 className="text-4xl md:text-5xl font-bold mb-2">AI 도구 비교</h1>
              <p className="text-xl text-muted-foreground">
                여러 AI 도구를 나란히 비교하여 최적의 선택을 하세요
              </p>
            </div>
            <div className="flex gap-2">
              {selectedTools.length > 0 && (
                <Button variant="outline" onClick={clearAll}>
                  전체 초기화
                </Button>
              )}
              <Button onClick={() => setShowSearch(true)} disabled={selectedTools.length >= 4}>
                <Plus className="w-4 h-4 mr-2" />
                도구 추가 ({selectedTools.length}/4)
              </Button>
            </div>
          </div>

          {/* 검색 모달 */}
          {showSearch && (
            <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
              <Card className="w-full max-w-2xl max-h-[80vh] overflow-hidden">
                <CardHeader>
                  <div className="flex items-center justify-between">
                    <CardTitle>AI 도구 검색</CardTitle>
                    <Button variant="ghost" size="sm" onClick={() => setShowSearch(false)}>
                      <X className="w-4 h-4" />
                    </Button>
                  </div>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    <div className="relative">
                      <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground w-4 h-4" />
                      <input
                        type="text"
                        placeholder="AI 도구를 검색해보세요..."
                        value={searchQuery}
                        onChange={(e) => setSearchQuery(e.target.value)}
                        className="w-full pl-10 pr-4 py-2 border rounded-lg"
                      />
                    </div>
                    
                    <div className="max-h-96 overflow-y-auto">
                      {toolsLoading ? (
                        <div className="space-y-2">
                          {Array.from({ length: 5 }).map((_, i) => (
                            <div key={i} className="flex items-center gap-3 p-3 border rounded-lg">
                              <Skeleton className="w-10 h-10 rounded-lg" />
                              <div className="flex-1">
                                <Skeleton className="h-4 w-32 mb-1" />
                                <Skeleton className="h-3 w-24" />
                              </div>
                            </div>
                          ))}
                        </div>
                      ) : allTools && allTools.length > 0 ? (
                        <div className="space-y-2">
                          {allTools
                            .filter(tool => !selectedTools.includes(tool.id))
                            .map((tool) => (
                              <div
                                key={tool.id}
                                className="flex items-center gap-3 p-3 border rounded-lg hover:bg-muted/50 cursor-pointer"
                                onClick={() => addTool(tool.id)}
                              >
                                <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-lg flex items-center justify-center text-white font-bold">
                                  {tool.logo_url ? (
                                    <img src={tool.logo_url} alt={tool.name} className="w-8 h-8 rounded" />
                                  ) : (
                                    tool.name.charAt(0).toUpperCase()
                                  )}
                                </div>
                                <div className="flex-1">
                                  <h3 className="font-medium">{tool.name}</h3>
                                  <p className="text-sm text-muted-foreground">{tool.provider}</p>
                                </div>
                                <div className="flex items-center gap-1">
                                  <Star className="w-4 h-4 fill-yellow-400 text-yellow-400" />
                                  <span className="text-sm font-medium">
                                    {tool.average_rating.toFixed(1)}
                                  </span>
                                </div>
                              </div>
                            ))}
                        </div>
                      ) : (
                        <div className="text-center py-8">
                          <p className="text-muted-foreground">검색 결과가 없습니다.</p>
                        </div>
                      )}
                    </div>
                  </div>
                </CardContent>
              </Card>
            </div>
          )}

          {/* 비교 테이블 */}
          <Card>
            <CardContent className="p-0">
              {selectedToolsLoading ? (
                <div className="p-8">
                  <Skeleton className="h-64 w-full" />
                </div>
              ) : (
                renderComparisonTable()
              )}
            </CardContent>
          </Card>

          {/* 추천 섹션 */}
          {selectedTools.length > 0 && (
            <div className="mt-8 bg-muted/50 rounded-lg p-6">
              <h2 className="text-xl font-semibold mb-4">비교 결과 요약</h2>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div className="bg-background rounded-lg p-4 border">
                  <h3 className="font-medium mb-2">최고 평점</h3>
                  {selectedToolsData && selectedToolsData.length > 0 && (
                    <div className="flex items-center gap-2">
                      <div className="w-8 h-8 bg-gradient-to-br from-green-500 to-blue-600 rounded-lg flex items-center justify-center text-white font-bold text-sm">
                        {selectedToolsData.reduce((max, tool) => 
                          tool.average_rating > max.average_rating ? tool : max
                        ).name.charAt(0).toUpperCase()}
                      </div>
                      <div>
                        <p className="font-medium">
                          {selectedToolsData.reduce((max, tool) => 
                            tool.average_rating > max.average_rating ? tool : max
                          ).name}
                        </p>
                        <p className="text-sm text-muted-foreground">
                          {selectedToolsData.reduce((max, tool) => 
                            tool.average_rating > max.average_rating ? tool : max
                          ).average_rating.toFixed(1)}점
                        </p>
                      </div>
                    </div>
                  )}
                </div>
                
                <div className="bg-background rounded-lg p-4 border">
                  <h3 className="font-medium mb-2">가장 인기</h3>
                  {selectedToolsData && selectedToolsData.length > 0 && (
                    <div className="flex items-center gap-2">
                      <div className="w-8 h-8 bg-gradient-to-br from-purple-500 to-pink-600 rounded-lg flex items-center justify-center text-white font-bold text-sm">
                        {selectedToolsData.reduce((max, tool) => 
                          tool.rating_count > max.rating_count ? tool : max
                        ).name.charAt(0).toUpperCase()}
                      </div>
                      <div>
                        <p className="font-medium">
                          {selectedToolsData.reduce((max, tool) => 
                            tool.rating_count > max.rating_count ? tool : max
                          ).name}
                        </p>
                        <p className="text-sm text-muted-foreground">
                          {selectedToolsData.reduce((max, tool) => 
                            tool.rating_count > max.rating_count ? tool : max
                          ).rating_count}개 리뷰
                        </p>
                      </div>
                    </div>
                  )}
                </div>
                
                <div className="bg-background rounded-lg p-4 border">
                  <h3 className="font-medium mb-2">비교 도구 수</h3>
                  <div className="flex items-center gap-2">
                    <div className="w-8 h-8 bg-gradient-to-br from-orange-500 to-red-600 rounded-lg flex items-center justify-center text-white font-bold text-sm">
                      {selectedTools.length}
                    </div>
                    <div>
                      <p className="font-medium">{selectedTools.length}개 도구</p>
                      <p className="text-sm text-muted-foreground">비교 중</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          )}
        </div>
      </main>
    </div>
  );
};

export default ToolCompare;
