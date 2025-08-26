import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { ArrowRight, Sparkles, Zap, Users } from "lucide-react";

const CTASection = () => {
  return (
    <section className="py-20 bg-gradient-to-br from-primary/5 via-background to-accent/5">
      <div className="container mx-auto px-6">
        {/* Main CTA */}
        <div className="relative">
          {/* Background Elements */}
          <div className="absolute inset-0 bg-gradient-primary opacity-10 rounded-3xl blur-3xl" />
          
          <Card className="relative overflow-hidden border-0 shadow-2xl bg-gradient-to-br from-card/90 to-card/70 backdrop-blur-sm">
            <CardContent className="p-12 md:p-16 text-center">
              {/* Floating Icons */}
              <div className="absolute top-8 left-8 opacity-20">
                <Sparkles className="w-8 h-8 text-primary animate-pulse" />
              </div>
              <div className="absolute top-8 right-8 opacity-20">
                <Zap className="w-8 h-8 text-accent animate-pulse delay-500" />
              </div>
              <div className="absolute bottom-8 left-1/2 transform -translate-x-1/2 opacity-20">
                <Users className="w-8 h-8 text-primary animate-pulse delay-1000" />
              </div>
              
              <div className="relative z-10 max-w-3xl mx-auto">
                <h2 className="text-3xl md:text-5xl font-bold mb-6">
                  지금 바로 시작하세요!
                  <br />
                  <span className="bg-gradient-primary bg-clip-text text-transparent">
                    AI로 더 스마트하게
                  </span>
                </h2>
                
                <p className="text-xl text-muted-foreground mb-8 leading-relaxed">
                  수많은 AI 도구 중에서 헤매지 마세요. 
                  <br className="hidden md:block" />
                  AIHub와 함께 당신에게 딱 맞는 AI를 찾아보세요.
                </p>
                
                <div className="flex flex-col sm:flex-row gap-4 justify-center items-center">
                  <Button size="lg" className="bg-gradient-primary hover:opacity-90 shadow-primary text-lg px-8 py-6 group">
                    무료로 시작하기
                    <ArrowRight className="ml-2 w-5 h-5 group-hover:translate-x-1 transition-transform" />
                  </Button>
                  <Button variant="outline" size="lg" className="border-2 text-lg px-8 py-6">
                    데모 보기
                  </Button>
                </div>
                
                <div className="mt-8 text-sm text-muted-foreground">
                  ✅ 무료 가입 &nbsp;&nbsp; ✅ 신용카드 불필요 &nbsp;&nbsp; ✅ 즉시 사용 가능
                </div>
              </div>
            </CardContent>
          </Card>
        </div>
        
        {/* Secondary CTAs */}
        <div className="grid md:grid-cols-3 gap-6 mt-12">
          <Card className="group hover:shadow-lg transition-all duration-300 cursor-pointer">
            <CardContent className="p-8 text-center">
              <div className="w-16 h-16 bg-gradient-to-r from-blue-500 to-cyan-500 rounded-2xl mx-auto mb-4 flex items-center justify-center group-hover:scale-110 transition-transform">
                <Sparkles className="w-8 h-8 text-white" />
              </div>
              <h3 className="text-xl font-semibold mb-2 group-hover:text-primary transition-colors">
                AI 추천받기
              </h3>
              <p className="text-muted-foreground mb-4">
                상황을 알려주시면 맞춤형 AI를 추천해드려요
              </p>
              <Button variant="outline" size="sm" className="group-hover:border-primary/50">
                추천받기
              </Button>
            </CardContent>
          </Card>
          
          <Card className="group hover:shadow-lg transition-all duration-300 cursor-pointer">
            <CardContent className="p-8 text-center">
              <div className="w-16 h-16 bg-gradient-to-r from-green-500 to-emerald-500 rounded-2xl mx-auto mb-4 flex items-center justify-center group-hover:scale-110 transition-transform">
                <Users className="w-8 h-8 text-white" />
              </div>
              <h3 className="text-xl font-semibold mb-2 group-hover:text-primary transition-colors">
                커뮤니티 참여
              </h3>
              <p className="text-muted-foreground mb-4">
                다른 사용자들과 경험을 나누고 배워보세요
              </p>
              <Button variant="outline" size="sm" className="group-hover:border-primary/50">
                참여하기
              </Button>
            </CardContent>
          </Card>
          
          <Card className="group hover:shadow-lg transition-all duration-300 cursor-pointer">
            <CardContent className="p-8 text-center">
              <div className="w-16 h-16 bg-gradient-to-r from-purple-500 to-pink-500 rounded-2xl mx-auto mb-4 flex items-center justify-center group-hover:scale-110 transition-transform">
                <Zap className="w-8 h-8 text-white" />
              </div>
              <h3 className="text-xl font-semibold mb-2 group-hover:text-primary transition-colors">
                가이드 탐색
              </h3>
              <p className="text-muted-foreground mb-4">
                검증된 AI 활용법을 단계별로 배워보세요
              </p>
              <Button variant="outline" size="sm" className="group-hover:border-primary/50">
                탐색하기
              </Button>
            </CardContent>
          </Card>
        </div>
      </div>
    </section>
  );
};

export default CTASection;