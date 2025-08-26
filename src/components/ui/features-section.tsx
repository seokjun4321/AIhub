import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { 
  Brain, 
  BookOpen, 
  Users, 
  Search, 
  ArrowRight, 
  Star,
  TrendingUp,
  MessageSquare,
  Lightbulb,
  Target,
  Zap
} from "lucide-react";

const FeaturesSection = () => {
  const mainFeatures = [
    {
      id: "recommend",
      title: "맞춤형 AI 추천",
      description: "상황과 목표를 입력하시면 최적의 AI 도구를 추천해드립니다",
      icon: Target,
      items: [
        "업무 상황별 AI 도구 매칭",
        "목표 달성을 위한 최적 솔루션",
        "실시간 AI 트렌드 반영"
      ],
      color: "from-purple-500 to-pink-500"
    },
    {
      id: "guides",
      title: "실용적 가이드북",
      description: "A부터 Z까지 체계적으로 정리된 AI 활용 가이드를 제공합니다",
      icon: BookOpen,
      items: [
        "단계별 활용법 가이드",
        "효과적인 프롬프트 작성법",
        "실제 사용 사례와 팁"
      ],
      color: "from-blue-500 to-cyan-500"
    },
    {
      id: "community",
      title: "지식 공유 커뮤니티",
      description: "실제 사용자들의 경험과 노하우를 공유하고 배우세요",
      icon: Users,
      items: [
        "Q&A 질문 답변",
        "성공 사례 공유",
        "전문가 검증 정보"
      ],
      color: "from-green-500 to-emerald-500"
    },
    {
      id: "tools",
      title: "AI 도구 디렉토리",
      description: "카테고리별로 정리된 검증된 AI 도구들을 찾아보세요",
      icon: Search,
      items: [
        "50+ 검증된 AI 도구",
        "카테고리별 분류",
        "사용자 리뷰와 평점"
      ],
      color: "from-orange-500 to-red-500"
    }
  ];

  const quickAccess = [
    { title: "글쓰기 AI", icon: BookOpen, count: "15개 도구" },
    { title: "이미지 생성", icon: Lightbulb, count: "12개 도구" },
    { title: "코딩 도우미", icon: Brain, count: "20개 도구" },
    { title: "데이터 분석", icon: TrendingUp, count: "8개 도구" },
  ];

  return (
    <section className="py-20 bg-background">
      <div className="container mx-auto px-6">
        {/* Section Header */}
        <div className="text-center mb-16">
          <Badge variant="outline" className="mb-4 border-primary/30 text-primary">
            핵심 기능
          </Badge>
          <h2 className="text-3xl md:text-4xl font-bold mb-4">
            AIHub가 제공하는
            <span className="bg-gradient-primary bg-clip-text text-transparent"> 특별한 경험</span>
          </h2>
          <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
            단순한 AI 정보 나열이 아닌, 실제 문제 해결을 위한 맞춤형 솔루션을 제공합니다
          </p>
        </div>

        {/* Main Features Grid */}
        <div className="grid lg:grid-cols-2 gap-8 mb-16">
          {mainFeatures.map((feature, index) => {
            const Icon = feature.icon;
            return (
              <Card key={feature.id} className="group hover:shadow-primary/10 hover:shadow-2xl transition-all duration-300 overflow-hidden">
                <CardHeader className="pb-4">
                  <div className="flex items-start gap-4">
                    <div className={`p-3 rounded-xl bg-gradient-to-r ${feature.color} shadow-lg`}>
                      <Icon className="w-6 h-6 text-white" />
                    </div>
                    <div className="flex-1">
                      <CardTitle className="text-xl mb-2 group-hover:text-primary transition-colors">
                        {feature.title}
                      </CardTitle>
                      <p className="text-muted-foreground">{feature.description}</p>
                    </div>
                  </div>
                </CardHeader>
                <CardContent>
                  <ul className="space-y-3 mb-6">
                    {feature.items.map((item, itemIndex) => (
                      <li key={itemIndex} className="flex items-center gap-3">
                        <div className="w-2 h-2 bg-primary rounded-full flex-shrink-0" />
                        <span className="text-sm text-foreground">{item}</span>
                      </li>
                    ))}
                  </ul>
                  <Button variant="outline" className="w-full group-hover:border-primary/50 transition-colors">
                    자세히 보기
                    <ArrowRight className="ml-2 w-4 h-4 group-hover:translate-x-1 transition-transform" />
                  </Button>
                </CardContent>
              </Card>
            );
          })}
        </div>

        {/* Quick Access */}
        <div className="bg-gradient-to-r from-accent/10 via-primary/5 to-accent/10 rounded-2xl p-8">
          <div className="text-center mb-8">
            <h3 className="text-2xl font-bold mb-2">빠른 접근</h3>
            <p className="text-muted-foreground">인기 카테고리별 AI 도구를 바로 찾아보세요</p>
          </div>
          
          <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-4">
            {quickAccess.map((item, index) => {
              const Icon = item.icon;
              return (
                <Card key={index} className="group cursor-pointer hover:shadow-lg transition-all duration-300 bg-card/80 backdrop-blur-sm border-0">
                  <CardContent className="p-6 text-center">
                    <div className="mb-4 mx-auto w-12 h-12 bg-gradient-primary rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform">
                      <Icon className="w-6 h-6 text-primary-foreground" />
                    </div>
                    <h4 className="font-semibold mb-1 group-hover:text-primary transition-colors">
                      {item.title}
                    </h4>
                    <p className="text-sm text-muted-foreground">{item.count}</p>
                  </CardContent>
                </Card>
              );
            })}
          </div>
          
          <div className="text-center mt-8">
            <Button className="bg-gradient-primary hover:opacity-90 shadow-primary">
              <Zap className="mr-2 w-4 h-4" />
              모든 카테고리 보기
            </Button>
          </div>
        </div>

        {/* Community Highlight */}
        <div className="mt-16 grid md:grid-cols-2 gap-8 items-center">
          <div>
            <Badge variant="outline" className="mb-4 border-green-500/30 text-green-600">
              실시간 커뮤니티
            </Badge>
            <h3 className="text-2xl font-bold mb-4">
              같은 고민을 하는 사람들과
              <br />
              <span className="text-green-600">함께 성장하세요</span>
            </h3>
            <p className="text-muted-foreground mb-6">
              혼자 고민하지 마세요. AIHub 커뮤니티에서 다른 사용자들과 
              경험을 나누고, 전문가들의 조언을 받아보세요.
            </p>
            <div className="flex gap-4">
              <Button variant="outline">
                <MessageSquare className="mr-2 w-4 h-4" />
                질문하기
              </Button>
              <Button>
                커뮤니티 참여하기
              </Button>
            </div>
          </div>
          
          <div className="grid grid-cols-2 gap-4">
            <Card className="bg-gradient-to-br from-green-50 to-emerald-50 border-green-200">
              <CardContent className="p-6 text-center">
                <Star className="w-8 h-8 text-green-600 mx-auto mb-2" />
                <div className="text-2xl font-bold text-green-700">4.8</div>
                <div className="text-sm text-green-600">만족도</div>
              </CardContent>
            </Card>
            <Card className="bg-gradient-to-br from-blue-50 to-cyan-50 border-blue-200">
              <CardContent className="p-6 text-center">
                <MessageSquare className="w-8 h-8 text-blue-600 mx-auto mb-2" />
                <div className="text-2xl font-bold text-blue-700">1.2k</div>
                <div className="text-sm text-blue-600">답변완료</div>
              </CardContent>
            </Card>
            <Card className="bg-gradient-to-br from-purple-50 to-pink-50 border-purple-200">
              <CardContent className="p-6 text-center">
                <Users className="w-8 h-8 text-purple-600 mx-auto mb-2" />
                <div className="text-2xl font-bold text-purple-700">500+</div>
                <div className="text-sm text-purple-600">활성 멤버</div>
              </CardContent>
            </Card>
            <Card className="bg-gradient-to-br from-orange-50 to-red-50 border-orange-200">
              <CardContent className="p-6 text-center">
                <TrendingUp className="w-8 h-8 text-orange-600 mx-auto mb-2" />
                <div className="text-2xl font-bold text-orange-700">95%</div>
                <div className="text-sm text-orange-600">해결률</div>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </section>
  );
};

export default FeaturesSection;