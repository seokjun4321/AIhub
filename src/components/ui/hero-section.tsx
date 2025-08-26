import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Brain, Search, BookOpen, Users, ArrowRight, Sparkles } from "lucide-react";

const HeroSection = () => {
  return (
    <section className="relative min-h-screen bg-gradient-secondary overflow-hidden">
      {/* Background Elements */}
      <div className="absolute inset-0 bg-gradient-to-br from-primary/10 via-transparent to-accent/10" />
      <div className="absolute top-1/4 left-1/4 w-96 h-96 bg-primary/20 rounded-full blur-3xl" />
      <div className="absolute bottom-1/4 right-1/4 w-96 h-96 bg-accent/20 rounded-full blur-3xl" />
      
      <div className="relative container mx-auto px-6 py-20">
        <div className="text-center space-y-8 max-w-4xl mx-auto">
          {/* Logo & Title */}
          <div className="flex items-center justify-center gap-3 mb-6">
            <div className="p-3 bg-gradient-primary rounded-2xl shadow-primary">
              <Brain className="w-8 h-8 text-primary-foreground" />
            </div>
            <h1 className="text-4xl md:text-6xl font-bold bg-gradient-primary bg-clip-text text-transparent">
              AIHub
            </h1>
          </div>
          
          {/* Main Headline */}
          <h2 className="text-3xl md:text-5xl font-bold text-foreground leading-tight">
            당신의 문제에 딱 맞는
            <br />
            <span className="bg-gradient-primary bg-clip-text text-transparent">
              AI 솔루션을 찾아드립니다
            </span>
          </h2>
          
          {/* Subtitle */}
          <p className="text-xl text-muted-foreground max-w-2xl mx-auto leading-relaxed">
            AI가 넘쳐나는 시대, 무엇을 써야 할지 모르겠다면? 
            실제 사용자들이 검증한 AI 추천과 활용법을 한곳에서 만나보세요.
          </p>
          
          {/* CTA Buttons */}
          <div className="flex flex-col sm:flex-row gap-4 justify-center items-center mt-8">
            <Button size="lg" className="bg-gradient-primary hover:opacity-90 shadow-primary group">
              AI 추천받기
              <ArrowRight className="ml-2 w-5 h-5 group-hover:translate-x-1 transition-transform" />
            </Button>
            <Button variant="outline" size="lg" className="border-2 hover:bg-accent/10">
              가이드북 둘러보기
            </Button>
          </div>
          
          {/* Stats */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-6 mt-16">
            <Card className="bg-card/80 backdrop-blur-sm border-0 shadow-glass">
              <CardContent className="p-6 text-center">
                <div className="text-2xl font-bold text-primary mb-2">50+</div>
                <div className="text-sm text-muted-foreground">AI 도구</div>
              </CardContent>
            </Card>
            <Card className="bg-card/80 backdrop-blur-sm border-0 shadow-glass">
              <CardContent className="p-6 text-center">
                <div className="text-2xl font-bold text-primary mb-2">100+</div>
                <div className="text-sm text-muted-foreground">활용 가이드</div>
              </CardContent>
            </Card>
            <Card className="bg-card/80 backdrop-blur-sm border-0 shadow-glass">
              <CardContent className="p-6 text-center">
                <div className="text-2xl font-bold text-primary mb-2">1,000+</div>
                <div className="text-sm text-muted-foreground">커뮤니티 멤버</div>
              </CardContent>
            </Card>
            <Card className="bg-card/80 backdrop-blur-sm border-0 shadow-glass">
              <CardContent className="p-6 text-center">
                <div className="text-2xl font-bold text-primary mb-2">24/7</div>
                <div className="text-sm text-muted-foreground">실시간 지원</div>
              </CardContent>
            </Card>
          </div>
          
          {/* Feature Highlights */}
          <div className="grid md:grid-cols-3 gap-8 mt-20">
            <div className="flex flex-col items-center text-center space-y-4">
              <div className="p-4 bg-gradient-primary rounded-2xl shadow-primary">
                <Search className="w-8 h-8 text-primary-foreground" />
              </div>
              <h3 className="text-xl font-semibold">맞춤형 AI 추천</h3>
              <p className="text-muted-foreground">상황과 목표를 알려주시면 최적의 AI 도구를 추천해드립니다</p>
            </div>
            
            <div className="flex flex-col items-center text-center space-y-4">
              <div className="p-4 bg-gradient-primary rounded-2xl shadow-primary">
                <BookOpen className="w-8 h-8 text-primary-foreground" />
              </div>
              <h3 className="text-xl font-semibold">실용적 가이드북</h3>
              <p className="text-muted-foreground">단계별 활용법부터 프롬프트 작성까지 모든 것을 알려드립니다</p>
            </div>
            
            <div className="flex flex-col items-center text-center space-y-4">
              <div className="p-4 bg-gradient-primary rounded-2xl shadow-primary">
                <Users className="w-8 h-8 text-primary-foreground" />
              </div>
              <h3 className="text-xl font-semibold">커뮤니티 지식공유</h3>
              <p className="text-muted-foreground">실제 사용자들의 경험과 팁을 공유하고 배워보세요</p>
            </div>
          </div>
        </div>
      </div>
      
      {/* Floating Elements */}
      <div className="absolute top-20 left-10 opacity-20">
        <Sparkles className="w-6 h-6 text-primary animate-pulse" />
      </div>
      <div className="absolute top-40 right-20 opacity-30">
        <Brain className="w-8 h-8 text-accent animate-pulse delay-500" />
      </div>
      <div className="absolute bottom-20 left-20 opacity-25">
        <Search className="w-7 h-7 text-primary animate-pulse delay-1000" />
      </div>
    </section>
  );
};

export default HeroSection;