import { useState, useEffect } from 'react';
import { useSearchParams, Link } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import { supabase } from '@/integrations/supabase/client';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Progress } from '@/components/ui/progress';
import { Skeleton } from '@/components/ui/skeleton';
import {
  Star,
  ExternalLink,
  Plus,
  X,
  CheckCircle,
  XCircle,
  Share2,
  ArrowLeft,
  Search,
  Zap,
  Lightbulb,
  Shield,
  Link as LinkIcon,
  AlertTriangle,
  Users
} from 'lucide-react';
import Navbar from '@/components/ui/navbar';
import {
  Radar,
  RadarChart,
  PolarGrid,
  PolarAngleAxis,
  PolarRadiusAxis,
  ResponsiveContainer,
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  PieChart,
  Pie,
  Cell
} from 'recharts';

interface ComparisonData {
  performance_score: number;
  cost_efficiency_score: number;
  korean_support_score: number;
  learning_curve_score: number;
  radar_chart: {
    performance: number;
    community: number;
    value_for_money: number;
    korean_quality: number;
    ease_of_use: number;
    automation: number;
  };
  pros: string[];
  cons: string[];
  target_users: string[];
  security_features: string[];
  integrations: string[];
  summary_text: string;
}

interface AIModel {
  id: number;
  name: string;
  description: string | null;
  provider: string | null;
  model_type: string | null;
  pricing_info: string | null;
  features: string[] | null;

  // New Schema Fields
  pricing_model: string | null;
  free_tier_note: string | null;
  pros: string[] | null;
  cons: string[] | null;
  difficulty_level: string | null;
  learning_curve: string | null;

  // Deprecated/Removed from View
  // use_cases: string[] | null;
  // limitations: string[] | null;

  website_url: string | null;
  api_documentation_url: string | null;
  average_rating: number;
  rating_count: number;
  logo_url: string | null;
  created_at: string;
  updated_at: string;
  comparison_data?: ComparisonData;
}

const COLORS = ['#3b82f6', '#10b981', '#ef4444', '#f59e0b'];

const ToolCompare = () => {
  const [searchParams, setSearchParams] = useSearchParams();
  const [selectedTools, setSelectedTools] = useState<number[]>([]);
  const [searchQuery, setSearchQuery] = useState('');
  const [hideIdentical, setHideIdentical] = useState(false);
  const [showSearch, setShowSearch] = useState(false);

  useEffect(() => {
    const toolIds = searchParams.get('tools')?.split(',').map(Number).filter(Boolean) || [];
    setSelectedTools(toolIds);
  }, [searchParams]);

  const { data: allTools, isLoading: toolsLoading } = useQuery({
    queryKey: ['allTools', searchQuery],
    queryFn: async () => {
      let query = supabase.from('ai_models').select('*').order('name');
      if (searchQuery) {
        query = query.or(`name.ilike.%${searchQuery}%, description.ilike.%${searchQuery}%`);
      }
      const { data, error } = await query;
      if (error) throw error;
      return data as unknown as AIModel[];
    },
  });

  const { data: selectedToolsData, isLoading: selectedToolsLoading } = useQuery({
    queryKey: ['selectedTools', selectedTools],
    queryFn: async () => {
      if (selectedTools.length === 0) return [];
      const { data, error } = await supabase.from('ai_models').select('*').in('id', selectedTools);
      if (error) throw error;
      if (!data) return [];

      return selectedTools.map(id => {
        const tool = data.find(t => t.id === id) as any;
        if (!tool) return null;

        // Parse comparison_data if it's a string
        if (typeof tool.comparison_data === 'string') {
          try {
            tool.comparison_data = JSON.parse(tool.comparison_data);
          } catch (e) {
            console.error('Failed to parse comparison_data', e);
            tool.comparison_data = {};
          }
        }
        return tool;
      }).filter(Boolean) as unknown as AIModel[];
    },
    enabled: selectedTools.length > 0,
  });

  const addTool = (toolId: number) => {
    if (selectedTools.length >= 4) {
      alert('최대 4개까지 비교할 수 있습니다.');
      return;
    }
    if (selectedTools.includes(toolId)) return;
    const newTools = [...selectedTools, toolId];
    setSelectedTools(newTools);
    setSearchParams({ tools: newTools.join(',') });
    setShowSearch(false);
  };

  const removeTool = (toolId: number) => {
    const newTools = selectedTools.filter(id => id !== toolId);
    setSelectedTools(newTools);
    setSearchParams(newTools.length > 0 ? { tools: newTools.join(',') } : {});
  };

  const clearAll = () => {
    setSelectedTools([]);
    setSearchParams({});
  };

  const handleShare = () => {
    navigator.clipboard.writeText(window.location.href);
    alert('링크가 복사되었습니다!');
  };

  const renderRadarChart = () => {
    if (!selectedToolsData || selectedToolsData.length === 0) return null;

    const data = [
      { subject: '성능', fullMark: 5 },
      { subject: '가격 대비 가치', fullMark: 5 },
      { subject: '한국어 품질', fullMark: 5 },
      { subject: '사용 용이성', fullMark: 5 },
      { subject: '자동화/연동성', fullMark: 5 },
      { subject: '커뮤니티', fullMark: 5 },
    ].map(dim => {
      const obj: any = { subject: dim.subject, fullMark: 5 };
      selectedToolsData.forEach(tool => {
        const key = dim.subject === '성능' ? 'performance' :
          dim.subject === '가격 대비 가치' ? 'value_for_money' :
            dim.subject === '한국어 품질' ? 'korean_quality' :
              dim.subject === '사용 용이성' ? 'ease_of_use' :
                dim.subject === '자동화/연동성' ? 'automation' : 'community';
        obj[tool.name] = tool.comparison_data?.radar_chart?.[key as keyof ComparisonData['radar_chart']] || 0;
      });
      return obj;
    });

    return (
      <div className="h-[300px] w-full">
        <ResponsiveContainer width="100%" height="100%">
          <RadarChart cx="50%" cy="50%" outerRadius="80%" data={data}>
            <PolarGrid stroke="#e5e7eb" />
            <PolarAngleAxis dataKey="subject" tick={{ fill: '#6b7280', fontSize: 12 }} />
            <PolarRadiusAxis angle={30} domain={[0, 5]} tick={false} axisLine={false} />
            {selectedToolsData.map((tool, index) => (
              <Radar
                key={tool.id}
                name={tool.name}
                dataKey={tool.name}
                stroke={COLORS[index % COLORS.length]}
                strokeWidth={3}
                fill={COLORS[index % COLORS.length]}
                fillOpacity={0.1}
              />
            ))}
            <Legend />
            <Tooltip />
          </RadarChart>
        </ResponsiveContainer>
      </div>
    );
  };

  // Helper to parse pricing info into multiple plans
  const parsePricingPlans = (pricingStr: string | null): { name: string; price: number }[] => {
    if (!pricingStr) return [];

    // Split by major separators: " / ", ", ", "\n"
    // We avoid splitting by simple "/" because it breaks units like "$10/mo" or "원/년"
    const chunks = pricingStr.split(/(?:\s\/\s|\s,\s|\n)/).filter(s => s.trim().length > 0);
    const plans: { name: string; price: number }[] = [];

    chunks.forEach(chunk => {
      let price = 0;
      let name = chunk.trim();
      const lowerChunk = chunk.toLowerCase();

      // Detect Free
      if (lowerChunk.includes('무료') || lowerChunk.includes('free')) {
        price = 0;
      } else {
        // Extract price
        const priceMatch = lowerChunk.replace(/,/g, '').match(/(\d+(\.\d+)?)/);
        if (priceMatch) {
          price = parseFloat(priceMatch[0]);

          // Currency conversion
          if (lowerChunk.includes('원') || lowerChunk.includes('krw')) {
            price = price / 1400;
          }

          // Timeframe normalization
          // 1. If it explicitly says Year/Yearly/Annual AND NOT Month/Monthly -> Divide by 12
          // 2. We must be careful of "$10/mo (billed annually)" -> This is already monthly.
          const isMonthly = lowerChunk.includes('/월') || lowerChunk.includes('/mo') || lowerChunk.includes('month');
          const isYearly = lowerChunk.includes('/년') || lowerChunk.includes('/ye') || lowerChunk.includes('연') || lowerChunk.includes('annua');

          if (isYearly && !isMonthly) {
            price = price / 12;
          }
        } else {
          return;
        }
      }

      // Clean up names for the chart label
      if (name.includes(':')) {
        name = name.split(':')[0].trim();
      } else {
        name = name.replace(/\(.*\)/, '').replace(/[\d,]+(원|\$|krw).*/i, '').replace(/(free|무료).*/i, 'Free').trim();
      }

      if (!name) name = 'Plan';

      if (price > 0 || lowerChunk.includes('free') || lowerChunk.includes('무료')) {
        plans.push({ name, price: Math.round(price * 10) / 10 });
      }
    });

    return plans.length > 0 ? plans : [{ name: 'Base', price: 0 }];
  };

  const renderBarChart = () => {
    if (!selectedToolsData || selectedToolsData.length === 0) return null;

    // Flatten data: Tool -> Plans -> Individual Bar Data
    const flatData: any[] = [];

    selectedToolsData.forEach((tool, index) => {
      const plans = parsePricingPlans(tool.pricing_info);
      plans.forEach(plan => {
        flatData.push({
          toolName: tool.name,
          planName: plan.name,
          fullName: `${tool.name} - ${plan.name}`,
          price: plan.price,
          color: COLORS[index % COLORS.length], // Same color for same tool
          originalInfo: tool.pricing_info
        });
      });
    });

    return (
      <div className="h-[300px] w-full">
        <ResponsiveContainer width="100%" height="100%">
          <BarChart data={flatData} margin={{ top: 20, right: 30, left: 20, bottom: 60 }}>
            <CartesianGrid strokeDasharray="3 3" vertical={false} />
            <XAxis
              dataKey="fullName"
              tick={({ x, y, payload }) => {
                const data = flatData[payload.index] || {};
                return (
                  <g transform={`translate(${x},${y})`}>
                    <text x={0} y={0} dy={16} textAnchor="middle" fill="#374151" fontSize={12} fontWeight="bold">
                      {data.planName}
                    </text>
                    <text x={0} y={0} dy={32} textAnchor="middle" fill="#9CA3AF" fontSize={10}>
                      {data.toolName}
                    </text>
                  </g>
                );
              }}
              interval={0}
              height={60}
              axisLine={false}
              tickLine={false}
            />
            <YAxis
              tickFormatter={(value) => `$${value}`}
              axisLine={false}
              tickLine={false}
              label={{ value: '월 예상 비용 (USD)', angle: -90, position: 'insideLeft', style: { fill: '#6b7280', fontSize: 12 } }}
            />
            <Tooltip
              cursor={{ fill: 'transparent' }}
              content={({ active, payload }) => {
                if (active && payload && payload.length) {
                  const data = payload[0].payload;
                  return (
                    <div className="bg-popover border rounded-lg shadow-lg p-3 text-sm">
                      <p className="font-bold mb-1">{data.toolName}</p>
                      <p className="text-muted-foreground mb-2">{data.planName}</p>
                      <div className="flex items-center gap-2">
                        <div className="w-2 h-2 rounded-full" style={{ backgroundColor: data.color }} />
                        <span className="font-medium">${data.price}</span>
                      </div>
                    </div>
                  );
                }
                return null;
              }}
            />
            <Bar dataKey="price" name="비용" radius={[4, 4, 0, 0]}>
              {flatData.map((entry, index) => (
                <Cell key={`cell-${index}`} fill={entry.color} />
              ))}
            </Bar>
          </BarChart>
        </ResponsiveContainer>
      </div>
    );
  };

  const renderPieChart = () => {
    if (!selectedToolsData || selectedToolsData.length === 0) return null;

    // Mock usage share data
    const data = selectedToolsData.map((tool, index) => ({
      name: tool.name,
      value: 100 / selectedToolsData.length // Distribute evenly for now or use rating_count
    }));

    return (
      <div className="h-[200px] w-full flex items-center justify-center">
        <ResponsiveContainer width="100%" height="100%">
          <PieChart>
            <Pie
              data={data}
              cx="50%"
              cy="50%"
              innerRadius={60}
              outerRadius={80}
              paddingAngle={5}
              dataKey="value"
            >
              {data.map((entry, index) => (
                <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
              ))}
            </Pie>
            <Tooltip />
            <Legend verticalAlign="bottom" height={36} />
          </PieChart>
        </ResponsiveContainer>
      </div>
    );
  };

  const renderComparisonTable = () => {
    if (!selectedToolsData || selectedToolsData.length === 0) return null;

    const isIdentical = (key: keyof AIModel | 'comparison_data') => {
      if (selectedToolsData.length < 2) return false;
      const firstValue = JSON.stringify(key === 'comparison_data' ? selectedToolsData[0].comparison_data : selectedToolsData[0][key]);
      return selectedToolsData.every(tool => JSON.stringify(key === 'comparison_data' ? tool.comparison_data : tool[key]) === firstValue);
    };

    const Row = ({ label, icon: Icon, render }: { label: string, icon?: any, render: (tool: AIModel, index: number) => React.ReactNode }) => (
      <tr className="border-b hover:bg-muted/50 transition-colors">
        <td className="p-4 font-medium sticky left-0 bg-background z-10 border-r" style={{ width: '10rem', minWidth: '10rem' }}>
          <div className="flex items-center gap-2">
            {Icon && <Icon className="w-4 h-4 text-muted-foreground" />}
            {label}
          </div>
        </td>
        {selectedToolsData.map((tool, index) => (
          <td key={tool.id} className="p-4 align-top" style={{ width: `calc((100% - 10rem) / ${selectedToolsData.length})` }}>
            {render(tool, index)}
          </td>
        ))}
      </tr>
    );

    return (
      <div className="overflow-x-auto relative rounded-lg border">
        <table className="w-full border-collapse table-fixed min-w-[800px]">
          <thead>
            <tr className="border-b bg-muted/30" style={{ display: 'table-row' }}>
              <td className="text-left p-4 font-semibold border-r" style={{ width: '10rem', minWidth: '10rem', display: 'table-cell' }}>
                <div className="flex flex-col gap-2">
                  <span>비교 항목</span>
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
              </td>
              {selectedToolsData.map((tool, index) => (
                <td
                  key={tool.id}
                  className="text-center p-4 border-b"
                  style={{ display: 'table-cell' }}
                >
                  <div className="flex flex-row items-center justify-center gap-3">
                    <div className="relative group">
                      <div className="w-12 h-12 bg-transparent rounded-xl flex items-center justify-center text-foreground font-bold text-lg">
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
                </td>
              ))}
            </tr>
          </thead>
          <tbody className="divide-y">
            <Row label="설명" icon={Lightbulb} render={(tool) => <span className="text-sm text-muted-foreground line-clamp-3">{tool.description}</span>} />
            <Row label="타입" icon={Zap} render={(tool) => <Badge variant="secondary">{tool.model_type || 'AI Tool'}</Badge>} />
            <Row label="평점" icon={Star} render={(tool) => (
              <div className="flex items-center gap-1 text-primary font-bold text-lg">
                {tool.average_rating.toFixed(1)} <span className="text-sm text-muted-foreground font-normal">/ 5.0</span>
              </div>
            )} />

            {/* New Schema Row: Pricing Model */}
            <Row label="요금 모델" icon={Zap} render={(tool) => (
              <span className="text-sm font-medium">{tool.pricing_model || '-'}</span>
            )} />

            <Row label="가격 정보" icon={Zap} render={(tool) => <span className="text-sm font-medium">{tool.pricing_info}</span>} />

            {/* New Schema Row: Free Tier */}
            <Row label="무료 플랜" icon={CheckCircle} render={(tool) => (
              <span className="text-sm text-muted-foreground">{tool.free_tier_note || '-'}</span>
            )} />

            {/* Pros */}
            <Row label="장점" icon={CheckCircle} render={(tool) => (
              <div className="space-y-1">
                {tool.pros?.map((p, i) => (
                  <div key={i} className="flex items-start gap-2 text-sm text-blue-600">
                    <span className="mt-1">+</span>
                    <span>{p}</span>
                  </div>
                ))}
                {!tool.pros && <span className="text-sm text-muted-foreground">-</span>}
              </div>
            )} />

            {/* Cons */}
            <Row label="단점" icon={AlertTriangle} render={(tool) => (
              <div className="space-y-1">
                {tool.cons?.map((c, i) => (
                  <div key={i} className="flex items-start gap-2 text-sm text-red-500">
                    <span className="mt-1">-</span>
                    <span>{c}</span>
                  </div>
                ))}
                {!tool.cons && <span className="text-sm text-muted-foreground">-</span>}
              </div>
            )} />

            {/* Difficulty & Learning Curve */}
            <Row label="난이도/학습" icon={Zap} render={(tool) => (
              <div className="flex flex-col gap-1 text-sm">
                <div className="flex justify-between">
                  <span className="text-muted-foreground">난이도:</span>
                  <span className="font-medium">{tool.difficulty_level || '-'}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-muted-foreground">학습 곡선:</span>
                  <span className="font-medium">{tool.learning_curve || '-'}</span>
                </div>
              </div>
            )} />

            <Row label="한국어 품질" icon={CheckCircle} render={(tool, index) => (
              <div className="space-y-1">
                <div className="flex justify-between text-sm">
                  <span className="font-medium">{tool.comparison_data?.korean_support_score || 0}</span>
                  <span className="text-muted-foreground">/ 5.0</span>
                </div>
                <Progress value={(tool.comparison_data?.korean_support_score || 0) * 20} className="h-2" />
                <p className="text-xs text-muted-foreground mt-1">
                  {tool.comparison_data?.korean_support_score && tool.comparison_data.korean_support_score >= 4.0 ? '매우 자연스러움' : '준수함'}
                </p>
              </div>
            )} />

            <Row label="가성비" icon={CheckCircle} render={(tool, index) => (
              <div className="space-y-1">
                <div className="flex justify-between text-sm">
                  <span className="font-medium">{tool.comparison_data?.cost_efficiency_score || 0}</span>
                  <span className="text-muted-foreground">/ 5.0</span>
                </div>
                <Progress value={(tool.comparison_data?.cost_efficiency_score || 0) * 20} className="h-2" />
              </div>
            )} />

            <Row label="주요 기능" icon={Zap} render={(tool) => (
              <div className="space-y-1">
                {tool.features?.slice(0, 5).map((f, i) => (
                  <div key={i} className="flex items-start gap-2 text-sm">
                    <span className="w-1.5 h-1.5 rounded-full bg-primary mt-1.5 shrink-0" />
                    <span>{f}</span>
                  </div>
                ))}
              </div>
            )} />

            <Row label="연동/자동화" icon={LinkIcon} render={(tool) => (
              <div className="flex flex-wrap gap-1">
                {tool.comparison_data?.integrations?.map((int, i) => (
                  <Badge key={i} variant="outline" className="text-xs">{int}</Badge>
                ))}
              </div>
            )} />

            <Row label="보안/프라이버시" icon={Shield} render={(tool) => (
              <div className="space-y-1">
                {tool.comparison_data?.security_features?.map((s, i) => (
                  <div key={i} className="flex items-start gap-2 text-sm text-muted-foreground">
                    <Shield className="w-3.5 h-3.5 text-blue-500 mt-0.5 shrink-0" />
                    <span>{s}</span>
                  </div>
                ))}
              </div>
            )} />

            <tr className="bg-muted/10">
              <td className="p-4 font-medium w-40 sticky left-0 bg-background/95 backdrop-blur z-10 border-r">액션</td>
              {selectedToolsData.map((tool) => (
                <td key={tool.id} className="p-4">
                  <div className="flex flex-col gap-2">
                    <Button asChild className="w-full bg-blue-500 hover:bg-blue-600">
                      <Link to={`/tools/${tool.id}`}>자세히 보기</Link>
                    </Button>
                    <Button asChild variant="outline" className="w-full">
                      <Link to="/presets">관련 프리셋 보기</Link>
                    </Button>
                  </div>
                </td>
              ))}
            </tr>
          </tbody>
        </table>
      </div>
    );
  };

  if (selectedTools.length === 0) {
    return (
      <div className="min-h-screen bg-background">
        <Navbar />
        <main className="pt-24 pb-12">
          <div className="container mx-auto px-6 text-center py-12">
            <div className="w-24 h-24 bg-muted rounded-full flex items-center justify-center mx-auto mb-4">
              <Search className="w-12 h-12 text-muted-foreground" />
            </div>
            <h3 className="text-xl font-semibold mb-2">비교할 AI 도구를 선택하세요</h3>
            <p className="text-muted-foreground mb-6">
              최대 4개까지 AI 도구를 선택하여 비교할 수 있습니다
            </p>
            <Button onClick={() => setShowSearch(true)} size="lg">
              <Plus className="w-4 h-4 mr-2" />
              AI 도구 추가하기
            </Button>
            {showSearch && (
              <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 text-left">
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
                            <Skeleton className="h-16 w-full" />
                            <Skeleton className="h-16 w-full" />
                          </div>
                        ) : allTools && allTools.length > 0 ? (
                          <div className="space-y-2">
                            {allTools.map((tool) => (
                              <div
                                key={tool.id}
                                className="flex items-center gap-3 p-3 border rounded-lg hover:bg-muted/50 cursor-pointer"
                                onClick={() => addTool(tool.id)}
                              >
                                <div className="w-10 h-10 bg-transparent rounded-lg flex items-center justify-center text-foreground font-bold">
                                  {tool.logo_url ? <img src={tool.logo_url} alt={tool.name} className="w-8 h-8 rounded" /> : tool.name.charAt(0)}
                                </div>
                                <div className="flex-1">
                                  <h3 className="font-medium">{tool.name}</h3>
                                  <p className="text-sm text-muted-foreground">{tool.provider}</p>
                                </div>
                                <Plus className="w-4 h-4 text-muted-foreground" />
                              </div>
                            ))}
                          </div>
                        ) : (
                          <p className="text-center py-4 text-muted-foreground">검색 결과가 없습니다.</p>
                        )}
                      </div>
                    </div>
                  </CardContent>
                </Card>
              </div>
            )}
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
          {/* Header */}
          <div className="flex flex-col md:flex-row items-start md:items-center justify-between mb-8 gap-4">
            <div>
              <h1 className="text-3xl md:text-4xl font-bold mb-2">AI 도구 비교</h1>
              <p className="text-muted-foreground">여러 AI 도구를 나란히 비교하여 최적의 선택을 하세요.</p>
            </div>
            <div className="flex gap-2">
              <Button variant="outline" onClick={clearAll}>전체 초기화</Button>
              <Button onClick={() => setShowSearch(true)} disabled={selectedTools.length >= 4}>
                <Plus className="w-4 h-4 mr-2" /> 도구 추가 ({selectedTools.length}/4)
              </Button>
            </div>
          </div>

          {/* Comparison Summary */}
          <Card className="mb-8 bg-blue-50/50 border-blue-100 dark:bg-blue-950/10 dark:border-blue-900">
            <CardContent className="p-6">
              <div className="flex items-start gap-3 mb-4">
                <Lightbulb className="w-5 h-5 text-blue-500 mt-1" />
                <div>
                  <h3 className="font-semibold text-lg mb-2">비교 요약</h3>
                  <p className="text-muted-foreground leading-relaxed">
                    {selectedToolsData?.map(t => t.comparison_data?.summary_text).filter(Boolean).join(' ') || '도구를 선택하여 비교 요약을 확인하세요.'}
                  </p>
                </div>
              </div>
              <div className="flex gap-2 flex-wrap">
                <Badge variant="secondary" className="bg-blue-100 text-blue-700 hover:bg-blue-200">최고 성능</Badge>
                <Badge variant="secondary" className="bg-green-100 text-green-700 hover:bg-green-200">최고 커뮤니티</Badge>
                <Badge variant="secondary" className="bg-purple-100 text-purple-700 hover:bg-purple-200">가성비 우수</Badge>
              </div>
            </CardContent>
          </Card>

          {/* Key Metrics Comparison */}
          <div className="mb-12">
            <h2 className="text-2xl font-bold mb-6">핵심 지표 비교</h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              {selectedToolsData?.map((tool, index) => (
                <Card key={tool.id} className="overflow-hidden">
                  <CardContent className="p-6">
                    <div className="flex items-center gap-3 mb-4">
                      <div className="w-10 h-10 bg-transparent rounded-lg flex items-center justify-center text-foreground font-bold">
                        {tool.logo_url ? <img src={tool.logo_url} alt={tool.name} className="w-8 h-8 rounded" /> : tool.name.charAt(0)}
                      </div>
                      <div>
                        <h3 className="font-bold">{tool.name}</h3>
                        <div className="flex items-center gap-1 text-sm text-muted-foreground">
                          <Star className="w-3 h-3 fill-yellow-400 text-yellow-400" />
                          <span className="font-medium text-foreground">{tool.average_rating.toFixed(1)}</span>
                          <span>/ 5.0</span>
                        </div>
                      </div>
                    </div>

                    <div className="space-y-4">
                      <div>
                        <div className="flex justify-between text-sm mb-1">
                          <span className="text-muted-foreground">성능</span>
                          <span className="font-medium">{tool.comparison_data?.performance_score || 0}</span>
                        </div>
                        <Progress value={(tool.comparison_data?.performance_score || 0) * 20} className="h-2" />
                      </div>
                      <div>
                        <div className="flex justify-between text-sm mb-1">
                          <span className="text-muted-foreground">가격 대비 가치</span>
                          <span className="font-medium">{tool.comparison_data?.cost_efficiency_score || 0}</span>
                        </div>
                        <Progress value={(tool.comparison_data?.cost_efficiency_score || 0) * 20} className="h-2" />
                      </div>
                      <div>
                        <div className="flex justify-between text-sm mb-1">
                          <span className="text-muted-foreground">한국어 품질</span>
                          <span className="font-medium">{tool.comparison_data?.korean_support_score || 0}</span>
                        </div>
                        <Progress value={(tool.comparison_data?.korean_support_score || 0) * 20} className="h-2" />
                      </div>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          </div>

          {/* Graphs */}
          <div className="mb-12">
            <h2 className="text-2xl font-bold mb-6">그래프</h2>
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              <Card>
                <CardHeader>
                  <CardTitle className="text-base">종합 성능 비교</CardTitle>
                </CardHeader>
                <CardContent>
                  {renderRadarChart()}
                </CardContent>
              </Card>
              <Card>
                <CardHeader>
                  <CardTitle className="text-base">가격 비교</CardTitle>
                </CardHeader>
                <CardContent>
                  {renderBarChart()}
                </CardContent>
              </Card>
            </div>
            <Card className="mt-6">
              <CardHeader>
                <CardTitle className="text-base">AIHub 내 사용 비율 (최근 30일 기준)</CardTitle>
              </CardHeader>
              <CardContent>
                {renderPieChart()}
              </CardContent>
            </Card>
          </div>

          {/* Detailed Comparison Table */}
          <div className="mb-12">
            <h2 className="text-2xl font-bold mb-6">상세 비교 테이블</h2>
            {renderComparisonTable()}
          </div>

          {/* Conclusion & Next Steps */}
          <div className="mb-12">
            <h2 className="text-2xl font-bold mb-6">결론 & 다음 단계</h2>
            <Card>
              <CardContent className="p-6 space-y-4">
                <h3 className="font-semibold text-lg flex items-center gap-2">
                  <Users className="w-5 h-5 text-primary" />
                  사용자 유형별 추천
                </h3>
                <div className="space-y-3">
                  {selectedToolsData?.map((tool, index) => (
                    <div key={tool.id} className="flex items-start gap-3 p-4 bg-muted/30 rounded-lg">
                      <div className={`w-6 h-6 rounded-full flex items-center justify-center text-white text-sm font-bold shrink-0`} style={{ backgroundColor: COLORS[index % COLORS.length] }}>
                        {index + 1}
                      </div>
                      <div>
                        <p className="font-medium">
                          {tool.comparison_data?.target_users?.[0] || '사용자'} — <span className="text-primary">{tool.name} 추천</span>
                        </p>
                        <p className="text-sm text-muted-foreground mt-1">
                          {tool.comparison_data?.summary_text || tool.description}
                        </p>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Tool Actions */}
          <div className="mb-12">
            <h2 className="text-2xl font-bold mb-6">도구별 액션</h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              {selectedToolsData?.map((tool, index) => (
                <Card key={tool.id}>
                  <CardContent className="p-6">
                    <div className="flex items-center gap-2 mb-4">
                      <div className="w-8 h-8 bg-transparent rounded-lg flex items-center justify-center text-foreground font-bold text-sm">
                        {tool.logo_url ? <img src={tool.logo_url} alt={tool.name} className="w-6 h-6 rounded" /> : tool.name.charAt(0)}
                      </div>
                      <span className="font-bold">{tool.name}</span>
                    </div>
                    <div className="space-y-2">
                      <Button asChild className="w-full bg-blue-500 hover:bg-blue-600">
                        <Link to={`/tools/${tool.id}`}>
                          <ExternalLink className="w-4 h-4 mr-2" />
                          자세히 보기
                        </Link>
                      </Button>
                      <Button asChild variant="outline" className="w-full">
                        <Link to="/presets">
                          <Zap className="w-4 h-4 mr-2" />
                          관련 프리셋 보기
                        </Link>
                      </Button>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          </div>

          {/* Search Modal (Re-used) */}
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
                          <Skeleton className="h-16 w-full" />
                          <Skeleton className="h-16 w-full" />
                        </div>
                      ) : allTools && allTools.length > 0 ? (
                        <div className="space-y-2">
                          {allTools.map((tool) => (
                            <div
                              key={tool.id}
                              className="flex items-center gap-3 p-3 border rounded-lg hover:bg-muted/50 cursor-pointer"
                              onClick={() => addTool(tool.id)}
                            >
                              <div className="w-10 h-10 bg-transparent rounded-lg flex items-center justify-center text-foreground font-bold">
                                {tool.logo_url ? <img src={tool.logo_url} alt={tool.name} className="w-8 h-8 rounded" /> : tool.name.charAt(0)}
                              </div>
                              <div className="flex-1">
                                <h3 className="font-medium">{tool.name}</h3>
                                <p className="text-sm text-muted-foreground">{tool.provider}</p>
                              </div>
                              <Plus className="w-4 h-4 text-muted-foreground" />
                            </div>
                          ))}
                        </div>
                      ) : (
                        <p className="text-center py-4 text-muted-foreground">검색 결과가 없습니다.</p>
                      )}
                    </div>
                  </div>
                </CardContent>
              </Card>
            </div>
          )}
        </div>
      </main>
    </div>
  );
};

export default ToolCompare;
