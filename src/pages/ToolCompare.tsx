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
  Search,
  Share2
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
  const [hideIdentical, setHideIdentical] = useState(false);

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
      return data as unknown as AIModel[];
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

      // selectedTools 배열의 순서에 맞게 정렬
      const sortedData = selectedTools.map(id =>
        data.find(tool => tool.id === id)
      ).filter(Boolean) as unknown as AIModel[];

      return sortedData;
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

    // 새 도구를 맨 뒤에 추가
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

  const handleShare = () => {
    navigator.clipboard.writeText(window.location.href);
    alert('링크가 복사되었습니다!');
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

    const isIdentical = (key: keyof AIModel) => {
      if (selectedToolsData.length < 2) return false;
      const firstValue = JSON.stringify(selectedToolsData[0][key]);
      return selectedToolsData.every(tool => JSON.stringify(tool[key]) === firstValue);
    };

    const Row = ({ label, field, render }: { label: string, field?: keyof AIModel, render?: (tool: AIModel) => React.ReactNode }) => {
      if (hideIdentical && field && isIdentical(field)) return null;

      return (
        <tr className="border-b hover:bg-muted/50 transition-colors">
          <td className="p-4 font-medium w-32 sticky left-0 bg-background z-10 border-r">{label}</td>
          {selectedToolsData.map((tool) => (
            <td key={tool.id} className="p-4" style={{ width: `calc((100% - 8rem) / ${selectedToolsData.length})` }}>
              {render ? render(tool) : (field ? String(tool[field] || '-') : '-')}
            </td>
          ))}
        </tr>
      );
    };

    return (
      <div className="overflow-x-auto relative rounded-lg border">
        <table className="w-full border-collapse table-fixed min-w-[800px]">
          <thead>
            <tr className="border-b bg-muted/30">
              <th className="text-left p-4 font-semibold w-32 sticky left-0 bg-background z-20 border-r">
                <div className="flex flex-col gap-2">
                  <span>항목</span>
                  <div className="flex items-center space-x-2">
                    <input
                      type="checkbox"
                      id="hideIdentical"
                      checked={hideIdentical}
                      onChange={(e) => setHideIdentical(e.target.checked)}
                      className="rounded border-gray-300"
                    />
                    <label htmlFor="hideIdentical" className="text-xs font-normal cursor-pointer select-none">
                      차이점만 보기
                    </label>
                  </div>
                </div>
              </th>
              {selectedToolsData.map((tool) => (
                <th key={tool.id} className="text-center p-4 sticky top-0 bg-background z-10" style={{ width: `calc((100% - 8rem) / ${selectedToolsData.length})` }}>
                  <div className="flex flex-col items-center gap-3">
                    <div className="relative group">
                      <div className="w-12 h-12 bg-gradient-to-br from-blue-500 to-purple-600 rounded-xl flex items-center justify-center text-white font-bold text-lg shadow-md">
                        {tool.logo_url ? (
                          <img src={tool.logo_url} alt={tool.name} className="w-10 h-10 rounded-lg object-cover" />
                        ) : (
                          tool.name.charAt(0).toUpperCase()
                        )}
                      </div>
                      <Button
                        variant="ghost"
                        size="icon"
                        onClick={() => removeTool(tool.id)}
                        className="absolute -top-2 -right-2 h-6 w-6 rounded-full bg-destructive text-destructive-foreground opacity-0 group-hover:opacity-100 transition-opacity shadow-sm"
                      >
                        <X className="w-3 h-3" />
                      </Button>
                    </div>
                    <Link to={`/tools/${tool.id}`} className="font-bold hover:underline text-lg">
                      {tool.name}
                    </Link>
                  </div>
                </th>
              ))}
            </tr>
          </thead>
          <tbody className="divide-y">
            <Row label="설명" field="description" render={(tool) => <span className="text-sm text-muted-foreground line-clamp-3">{tool.description}</span>} />
            <Row label="제공사" field="provider" />
            <Row label="타입" field="model_type" render={(tool) => <Badge variant="secondary">{tool.model_type || 'AI Tool'}</Badge>} />
            <Row label="평점" field="average_rating" render={(tool) => (
              <div className="flex items-center gap-1">
                <Star className="w-4 h-4 fill-yellow-400 text-yellow-400" />
                <span className="font-bold">{tool.average_rating.toFixed(1)}</span>
                <span className="text-xs text-muted-foreground">({tool.rating_count})</span>
              </div>
            )} />
            <Row label="가격" field="pricing_info" render={(tool) => <span className="text-sm font-medium">{tool.pricing_info}</span>} />

            <Row label="주요 기능" field="features" render={(tool) => (
              tool.features && tool.features.length > 0 ? (
                <div className="space-y-1.5">
                  {tool.features.slice(0, 4).map((feature, index) => (
                    <div key={index} className="flex items-start gap-2 text-sm">
                      <CheckCircle className="w-3.5 h-3.5 text-green-500 mt-0.5 shrink-0" />
                      <span className="leading-tight">{feature}</span>
                    </div>
                  ))}
                  {tool.features.length > 4 && (
                    <div className="text-xs text-muted-foreground pl-5">
                      +{tool.features.length - 4}개 더
                    </div>
                  )}
                </div>
              ) : <span className="text-sm text-muted-foreground">-</span>
            )} />

            <Row label="제한사항" field="limitations" render={(tool) => (
              tool.limitations && tool.limitations.length > 0 ? (
                <div className="space-y-1.5">
                  {tool.limitations.slice(0, 3).map((limitation, index) => (
                    <div key={index} className="flex items-start gap-2 text-sm text-muted-foreground">
                      <XCircle className="w-3.5 h-3.5 text-red-400 mt-0.5 shrink-0" />
                      <span className="leading-tight">{limitation}</span>
                    </div>
                  ))}
                </div>
              ) : <span className="text-sm text-muted-foreground">-</span>
            )} />

            <tr className="bg-muted/10">
              <td className="p-4 font-medium w-32 sticky left-0 bg-background/95 backdrop-blur z-10 border-r">바로가기</td>
              {selectedToolsData.map((tool) => (
                <td key={tool.id} className="p-4">
                  <div className="flex flex-col gap-2">
                    <Button asChild size="sm" className="w-full">
                      <Link to={`/tools/${tool.id}`}>상세 정보</Link>
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
          <div className="flex flex-col md:flex-row items-start md:items-center justify-between mb-8 gap-4">
            <div>
              <Button variant="ghost" size="sm" asChild className="mb-2 pl-0 hover:bg-transparent hover:text-primary">
                <Link to="/tools" className="flex items-center gap-1">
                  <ArrowLeft className="w-4 h-4" />
                  목록으로 돌아가기
                </Link>
              </Button>
              <h1 className="text-3xl md:text-4xl font-bold">AI 도구 비교</h1>
            </div>
            <div className="flex gap-2 w-full md:w-auto">
              {selectedTools.length > 0 && (
                <>
                  <Button variant="outline" onClick={handleShare} className="flex-1 md:flex-none">
                    <Share2 className="w-4 h-4 mr-2" />
                    공유
                  </Button>
                  <Button variant="outline" onClick={clearAll} className="flex-1 md:flex-none">
                    초기화
                  </Button>
                </>
              )}
              <Button onClick={() => setShowSearch(true)} disabled={selectedTools.length >= 4} className="flex-1 md:flex-none">
                <Plus className="w-4 h-4 mr-2" />
                추가
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
