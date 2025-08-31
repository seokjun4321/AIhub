import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { 
  Target, 
  Users, 
  TrendingUp, 
  Lightbulb, 
  Award, 
  Globe, 
  Zap, 
  Heart,
  Calendar,
  CheckCircle,
  ArrowRight
} from "lucide-react";
import { Link } from "react-router-dom";

const About = () => {
  const values = [
    {
      icon: Target,
      title: "명확한 목표",
      description: "사용자의 문제에 딱 맞는 AI 솔루션을 정확하게 추천합니다",
      color: "text-blue-600"
    },
    {
      icon: Users,
      title: "커뮤니티 중심",
      description: "실제 사용자들의 경험과 지식을 공유하는 활발한 커뮤니티",
      color: "text-green-600"
    },
    {
      icon: TrendingUp,
      title: "지속적 성장",
      description: "AI 기술의 발전과 함께 지속적으로 업데이트되는 플랫폼",
      color: "text-purple-600"
    },
    {
      icon: Lightbulb,
      title: "혁신적 사고",
      description: "새로운 아이디어와 창의적 솔루션으로 AI 생태계를 선도합니다",
      color: "text-orange-600"
    }
  ];

  const timeline = [
    {
      year: "2025",
      month: "10월",
      title: "AIHub 베타 서비스 출시",
      description: "AI 추천 시스템과 커뮤니티 기능을 포함한 베타 버전 출시"
    },
    {
      year: "2025",
      month: "8월",
      title: "팀 구성 및 개발 시작",
      description: "성균관대학교와 연세대학교 학생들이 모여 AIHub 개발 시작"
    },
    {
      year: "2025",
      month: "7월",
      title: "아이디어 구상",
      description: "AI 도구 선택의 어려움을 해결하는 플랫폼 아이디어 구상"
    }
  ];

  const stats = [
    { number: "100+", label: "AI 도구", icon: Zap },
    { number: "50+", label: "가이드", icon: Award },
    { number: "1000+", label: "사용자", icon: Users },
    { number: "24/7", label: "지원", icon: Heart }
  ];

  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      
      {/* Hero Section */}
      <main className="pt-24">
        <div className="container mx-auto px-6">
          {/* Hero */}
          <div className="text-center py-16">
            <Badge className="mb-4 bg-primary/10 text-primary hover:bg-primary/20">
              AIHub 소개
            </Badge>
            <h1 className="text-4xl md:text-6xl font-bold mb-6">
              AI 기술의 <span className="bg-gradient-primary bg-clip-text text-transparent">민주화</span>를 위한
              <br />첫 번째 걸음
            </h1>
            <p className="text-xl text-muted-foreground max-w-3xl mx-auto mb-8">
              AIHub는 혁신적인 AI 기술을 통해 사용자들이 최적의 AI 솔루션을 찾을 수 있도록 돕는 플랫폼입니다. 
              실제 사용자들의 경험을 바탕으로 검증된 AI 도구들을 추천하고, 
              커뮤니티를 통해 지식을 공유하며 함께 성장하는 생태계를 만들어갑니다.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Button asChild size="lg" className="bg-gradient-primary hover:opacity-90">
                <Link to="/team">
                  팀 소개 보기
                  <ArrowRight className="ml-2 w-4 h-4" />
                </Link>
              </Button>
              <Button asChild variant="outline" size="lg">
                <Link to="/contact">
                  문의하기
                </Link>
              </Button>
            </div>
          </div>

          {/* Stats Section */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-6 mb-16">
            {stats.map((stat, index) => {
              const Icon = stat.icon;
              return (
                <div key={index} className="text-center p-6 rounded-lg border border-border/50">
                  <Icon className="w-8 h-8 text-primary mx-auto mb-3" />
                  <div className="text-2xl font-bold mb-1">{stat.number}</div>
                  <div className="text-sm text-muted-foreground">{stat.label}</div>
                </div>
              );
            })}
          </div>

          {/* Mission & Vision */}
          <div className="grid md:grid-cols-2 gap-8 mb-16">
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Target className="w-5 h-5 text-primary" />
                  우리의 미션
                </CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-muted-foreground">
                  복잡하고 어려운 AI 도구 선택 과정을 단순화하여, 
                  누구나 쉽게 자신에게 맞는 AI 솔루션을 찾을 수 있도록 돕습니다. 
                  실제 사용자들의 경험과 리뷰를 바탕으로 신뢰할 수 있는 추천을 제공하여, 
                  AI 기술의 접근성을 높이고 활용도를 극대화합니다.
                </p>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Globe className="w-5 h-5 text-primary" />
                  우리의 비전
                </CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-muted-foreground">
                  AI 기술의 민주화를 통해 모든 사람이 AI의 혜택을 누릴 수 있는 세상을 만듭니다. 
                  사용자 중심의 플랫폼으로 성장하여, AI 생태계의 핵심 허브가 되고, 
                  지속적인 혁신을 통해 AI 기술 발전에 기여합니다.
                </p>
              </CardContent>
            </Card>
          </div>

          {/* Core Values */}
          <div className="mb-16">
            <div className="text-center mb-12">
              <h2 className="text-3xl font-bold mb-4">핵심 가치</h2>
              <p className="text-muted-foreground max-w-2xl mx-auto">
                AIHub가 추구하는 핵심 가치들을 통해 우리의 철학과 방향성을 제시합니다.
              </p>
            </div>
            
            <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
              {values.map((value, index) => {
                const Icon = value.icon;
                return (
                  <Card key={index} className="text-center hover:shadow-lg transition-shadow">
                    <CardContent className="p-6">
                      <Icon className={`w-12 h-12 mx-auto mb-4 ${value.color}`} />
                      <h3 className="font-semibold mb-2">{value.title}</h3>
                      <p className="text-sm text-muted-foreground">
                        {value.description}
                      </p>
                    </CardContent>
                  </Card>
                );
              })}
            </div>
          </div>

          {/* Timeline */}
          <div className="mb-16">
            <div className="text-center mb-12">
              <h2 className="text-3xl font-bold mb-4">연혁</h2>
              <p className="text-muted-foreground max-w-2xl mx-auto">
                AIHub의 성장 과정을 함께 살펴보세요.
              </p>
            </div>
            
            <div className="max-w-4xl mx-auto">
              {timeline.map((item, index) => (
                <div key={index} className="flex items-start gap-6 mb-8">
                  <div className="flex-shrink-0">
                    <div className="w-12 h-12 bg-primary rounded-full flex items-center justify-center">
                      <Calendar className="w-6 h-6 text-primary-foreground" />
                    </div>
                  </div>
                  <div className="flex-1">
                    <div className="flex items-center gap-2 mb-2">
                      <span className="font-bold text-lg">{item.year}</span>
                      <span className="text-muted-foreground">{item.month}</span>
                    </div>
                    <h3 className="font-semibold mb-2">{item.title}</h3>
                    <p className="text-muted-foreground">{item.description}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* CTA Section */}
          <div className="text-center py-16 bg-gradient-to-r from-primary/5 to-primary/10 rounded-2xl mb-16">
            <h2 className="text-3xl font-bold mb-4">함께 성장해요</h2>
            <p className="text-muted-foreground max-w-2xl mx-auto mb-8">
              AIHub와 함께 AI 기술의 미래를 만들어가세요. 
              여러분의 경험과 지식이 다른 사용자들에게 큰 도움이 됩니다.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Button asChild size="lg" className="bg-gradient-primary hover:opacity-90">
                <Link to="/community">
                  커뮤니티 참여하기
                </Link>
              </Button>
              <Button asChild variant="outline" size="lg">
                <Link to="/careers">
                  채용 정보 보기
                </Link>
              </Button>
            </div>
          </div>
        </div>
      </main>
      
      <Footer />
    </div>
  );
};

export default About;
