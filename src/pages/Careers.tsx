import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { 
  Users, 
  Target, 
  Lightbulb, 
  Code, 
  TrendingUp, 
  Heart,
  Calendar,
  Award,
  MapPin,
  Clock,
  DollarSign,
  BookOpen,
  Coffee,
  Home,
  Zap,
  ArrowRight,
  CheckCircle
} from "lucide-react";
import { Link } from "react-router-dom";

const Careers = () => {
  const openPositions = [
    {
      title: "Frontend 개발자 (React/TypeScript)",
      type: "정규직",
      location: "서울 / 원격 근무 가능",
      experience: "신입 ~ 3년",
      department: "개발팀",
      description: "AIHub의 사용자 인터페이스를 개발하고 개선하는 역할을 담당합니다. React, TypeScript, Tailwind CSS를 활용하여 최고의 사용자 경험을 제공합니다.",
      requirements: [
        "React, TypeScript, JavaScript에 대한 깊은 이해",
        "Tailwind CSS 또는 유사한 CSS 프레임워크 경험",
        "반응형 웹 디자인 및 접근성에 대한 이해",
        "Git을 활용한 협업 경험",
        "사용자 중심의 개발 사고"
      ],
      responsibilities: [
        "AIHub 웹 애플리케이션 프론트엔드 개발",
        "사용자 인터페이스 개선 및 최적화",
        "성능 최적화 및 코드 품질 관리",
        "다른 개발자들과의 협업"
      ],
      benefits: [
        "경쟁력 있는 연봉",
        "원격 근무 지원",
        "개발 도구 및 교육 지원",
        "유연한 근무 시간"
      ]
    },
    {
      title: "AI/ML 엔지니어",
      type: "정규직",
      location: "서울 / 원격 근무 가능",
      experience: "신입 ~ 2년",
      department: "AI팀",
      description: "AI 추천 시스템과 머신러닝 모델을 개발하고 개선하는 역할을 담당합니다. 사용자에게 최적화된 AI 도구 추천을 제공합니다.",
      requirements: [
        "Python, TensorFlow/PyTorch 경험",
        "머신러닝 및 딥러닝 기초 지식",
        "데이터 분석 및 시각화 능력",
        "추천 시스템 개발 경험 (우대)",
        "클라우드 플랫폼 경험 (AWS, GCP 등)"
      ],
      responsibilities: [
        "AI 추천 알고리즘 개발 및 개선",
        "사용자 행동 데이터 분석",
        "머신러닝 모델 성능 최적화",
        "AI 도구 평가 및 분류 시스템 개발"
      ],
      benefits: [
        "경쟁력 있는 연봉",
        "AI 컨퍼런스 참가 지원",
        "최신 AI 도구 및 라이브러리 사용",
        "연구 및 실험 환경 제공"
      ]
    },
    {
      title: "마케팅 매니저",
      type: "정규직",
      location: "서울",
      experience: "신입 ~ 3년",
      department: "마케팅팀",
      description: "AIHub의 브랜드 인지도 향상과 사용자 확보를 위한 마케팅 전략을 수립하고 실행하는 역할을 담당합니다.",
      requirements: [
        "디지털 마케팅 경험",
        "소셜 미디어 마케팅 능력",
        "콘텐츠 마케팅 및 SEO 이해",
        "데이터 분석 및 성과 측정 능력",
        "창의적 사고와 커뮤니케이션 능력"
      ],
      responsibilities: [
        "종합 마케팅 전략 수립 및 실행",
        "소셜 미디어 채널 관리",
        "콘텐츠 마케팅 및 SEO 최적화",
        "사용자 확보 및 리텐션 전략 수립"
      ],
      benefits: [
        "경쟁력 있는 연봉",
        "마케팅 도구 및 플랫폼 사용",
        "창의적 프로젝트 자유도",
        "성과 기반 인센티브"
      ]
    }
  ];

  const benefits = [
    {
      icon: Heart,
      title: "건강 관리",
      description: "건강보험, 의료비 지원, 정기 건강검진"
    },
    {
      icon: Calendar,
      title: "유연한 근무",
      description: "원격 근무, 유연 근무 시간, 무제한 휴가"
    },
    {
      icon: BookOpen,
      title: "학습 지원",
      description: "교육비 지원, 도서 구매비, 컨퍼런스 참가 지원"
    },
    {
      icon: Coffee,
      title: "편의 시설",
      description: "커피 무제한, 간식 제공, 편안한 사무 환경"
    },
    {
      icon: Home,
      title: "재택 근무",
      description: "재택 근무 지원, IT 장비 제공, 통신비 지원"
    },
    {
      icon: Award,
      title: "성과 보상",
      description: "성과 기반 인센티브, 스톡옵션, 연봉 인상"
    }
  ];

  const culture = [
    {
      icon: Lightbulb,
      title: "혁신적 사고",
      description: "새로운 아이디어를 두려워하지 않고 실험을 장려합니다"
    },
    {
      icon: Users,
      title: "협력과 소통",
      description: "열린 소통과 팀워크를 통해 최고의 결과를 만들어갑니다"
    },
    {
      icon: TrendingUp,
      title: "지속적 성장",
      description: "개인과 회사의 지속적인 성장을 위해 노력합니다"
    },
    {
      icon: Target,
      title: "사용자 중심",
      description: "사용자의 니즈를 최우선으로 생각하고 제품을 개발합니다"
    }
  ];

  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      
      <main className="pt-24">
        <div className="container mx-auto px-6">
          {/* Hero Section */}
          <div className="text-center py-16">
            <Badge className="mb-4 bg-primary/10 text-primary hover:bg-primary/20">
              채용 정보
            </Badge>
            <h1 className="text-4xl md:text-6xl font-bold mb-6">
              AI 기술의 미래를 함께 <span className="bg-gradient-primary bg-clip-text text-transparent">만들어갈</span>
              <br />동료를 찾습니다
            </h1>
            <p className="text-xl text-muted-foreground max-w-3xl mx-auto mb-8">
              AIHub와 함께 AI 기술의 민주화를 이끌어갈 열정적인 동료들을 기다리고 있습니다. 
              여러분의 재능과 열정이 AIHub의 성장에 큰 도움이 될 것입니다.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Button asChild size="lg" className="bg-gradient-primary hover:opacity-90">
                <Link to="#positions">
                  채용 포지션 보기
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

          {/* Company Culture */}
          <div className="mb-16">
            <div className="text-center mb-12">
              <h2 className="text-3xl font-bold mb-4">AIHub 문화</h2>
              <p className="text-muted-foreground max-w-2xl mx-auto">
                AIHub가 추구하는 문화와 가치관을 통해 우리의 철학을 알아보세요.
              </p>
            </div>
            
            <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
              {culture.map((item, index) => {
                const Icon = item.icon;
                return (
                  <Card key={index} className="text-center hover:shadow-lg transition-shadow">
                    <CardContent className="p-6">
                      <Icon className="w-12 h-12 text-primary mx-auto mb-4" />
                      <h3 className="font-semibold mb-2">{item.title}</h3>
                      <p className="text-sm text-muted-foreground">
                        {item.description}
                      </p>
                    </CardContent>
                  </Card>
                );
              })}
            </div>
          </div>

          {/* Benefits */}
          <div className="mb-16">
            <div className="text-center mb-12">
              <h2 className="text-3xl font-bold mb-4">복리후생</h2>
              <p className="text-muted-foreground max-w-2xl mx-auto">
                AIHub에서 제공하는 다양한 복리후생을 통해 더 나은 업무 환경을 제공합니다.
              </p>
            </div>
            
            <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
              {benefits.map((benefit, index) => {
                const Icon = benefit.icon;
                return (
                  <Card key={index} className="hover:shadow-lg transition-shadow">
                    <CardContent className="p-6">
                      <div className="flex items-start gap-4">
                        <Icon className="w-8 h-8 text-primary mt-1 flex-shrink-0" />
                        <div>
                          <h3 className="font-semibold mb-2">{benefit.title}</h3>
                          <p className="text-sm text-muted-foreground">
                            {benefit.description}
                          </p>
                        </div>
                      </div>
                    </CardContent>
                  </Card>
                );
              })}
            </div>
          </div>

          {/* Open Positions */}
          <div id="positions" className="mb-16">
            <div className="text-center mb-12">
              <h2 className="text-3xl font-bold mb-4">채용 포지션</h2>
              <p className="text-muted-foreground max-w-2xl mx-auto">
                현재 AIHub에서 함께 일할 동료를 찾고 있습니다.
              </p>
            </div>
            
            <div className="space-y-8">
              {openPositions.map((position, index) => (
                <Card key={index} className="overflow-hidden hover:shadow-lg transition-shadow">
                  <CardHeader className="border-b border-border/50">
                    <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                      <div>
                        <CardTitle className="text-xl mb-2">{position.title}</CardTitle>
                        <div className="flex flex-wrap gap-2">
                          <Badge variant="secondary">{position.type}</Badge>
                          <Badge variant="outline">{position.department}</Badge>
                          <Badge variant="outline">{position.experience}</Badge>
                        </div>
                      </div>
                      <div className="flex items-center gap-2 text-sm text-muted-foreground">
                        <MapPin className="w-4 h-4" />
                        <span>{position.location}</span>
                      </div>
                    </div>
                  </CardHeader>
                  <CardContent className="p-6">
                    <div className="grid lg:grid-cols-3 gap-8">
                      <div className="lg:col-span-2">
                        <div className="mb-6">
                          <h4 className="font-semibold mb-3">포지션 소개</h4>
                          <p className="text-muted-foreground leading-relaxed">
                            {position.description}
                          </p>
                        </div>
                        
                        <div className="mb-6">
                          <h4 className="font-semibold mb-3">주요 업무</h4>
                          <ul className="space-y-2">
                            {position.responsibilities.map((responsibility, idx) => (
                              <li key={idx} className="flex items-start gap-2 text-sm text-muted-foreground">
                                <Target className="w-4 h-4 text-primary mt-0.5 flex-shrink-0" />
                                <span>{responsibility}</span>
                              </li>
                            ))}
                          </ul>
                        </div>
                        
                        <div>
                          <h4 className="font-semibold mb-3">자격 요건</h4>
                          <ul className="space-y-2">
                            {position.requirements.map((requirement, idx) => (
                              <li key={idx} className="flex items-start gap-2 text-sm text-muted-foreground">
                                <CheckCircle className="w-4 h-4 text-green-500 mt-0.5 flex-shrink-0" />
                                <span>{requirement}</span>
                              </li>
                            ))}
                          </ul>
                        </div>
                      </div>
                      
                      <div>
                        <div className="mb-6">
                          <h4 className="font-semibold mb-3">제공 혜택</h4>
                          <ul className="space-y-2">
                            {position.benefits.map((benefit, idx) => (
                              <li key={idx} className="flex items-start gap-2 text-sm text-muted-foreground">
                                <Award className="w-4 h-4 text-primary mt-0.5 flex-shrink-0" />
                                <span>{benefit}</span>
                              </li>
                            ))}
                          </ul>
                        </div>
                        
                        <Button className="w-full bg-gradient-primary hover:opacity-90">
                          지원하기
                          <ArrowRight className="ml-2 w-4 h-4" />
                        </Button>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          </div>

          {/* Application Process */}
          <div className="mb-16">
            <div className="text-center mb-12">
              <h2 className="text-3xl font-bold mb-4">지원 절차</h2>
              <p className="text-muted-foreground max-w-2xl mx-auto">
                AIHub에 지원하는 방법을 안내해드립니다.
              </p>
            </div>
            
            <div className="grid md:grid-cols-4 gap-6 max-w-4xl mx-auto">
              <div className="text-center">
                <div className="w-12 h-12 bg-primary rounded-full flex items-center justify-center mx-auto mb-4">
                  <span className="text-primary-foreground font-bold">1</span>
                </div>
                <h3 className="font-semibold mb-2">지원서 제출</h3>
                <p className="text-sm text-muted-foreground">
                  원하는 포지션에 지원서를 제출해주세요
                </p>
              </div>
              
              <div className="text-center">
                <div className="w-12 h-12 bg-primary rounded-full flex items-center justify-center mx-auto mb-4">
                  <span className="text-primary-foreground font-bold">2</span>
                </div>
                <h3 className="font-semibold mb-2">서류 검토</h3>
                <p className="text-sm text-muted-foreground">
                  제출된 서류를 검토하여 적합성을 평가합니다
                </p>
              </div>
              
              <div className="text-center">
                <div className="w-12 h-12 bg-primary rounded-full flex items-center justify-center mx-auto mb-4">
                  <span className="text-primary-foreground font-bold">3</span>
                </div>
                <h3 className="font-semibold mb-2">면접</h3>
                <p className="text-sm text-muted-foreground">
                  온라인 또는 오프라인 면접을 진행합니다
                </p>
              </div>
              
              <div className="text-center">
                <div className="w-12 h-12 bg-primary rounded-full flex items-center justify-center mx-auto mb-4">
                  <span className="text-primary-foreground font-bold">4</span>
                </div>
                <h3 className="font-semibold mb-2">최종 합격</h3>
                <p className="text-sm text-muted-foreground">
                  합격자에게 최종 발표 및 입사 안내를 드립니다
                </p>
              </div>
            </div>
          </div>

          {/* CTA Section */}
          <div className="text-center py-16 bg-gradient-to-r from-primary/5 to-primary/10 rounded-2xl mb-16">
            <h2 className="text-3xl font-bold mb-4">함께 성장할 동료를 찾고 있습니다</h2>
            <p className="text-muted-foreground max-w-2xl mx-auto mb-8">
              AIHub와 함께 AI 기술의 미래를 만들어가세요. 
              여러분의 재능과 열정이 AIHub의 성장에 큰 도움이 될 것입니다.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Button asChild size="lg" className="bg-gradient-primary hover:opacity-90">
                <Link to="/contact">
                  문의하기
                  <ArrowRight className="ml-2 w-4 h-4" />
                </Link>
              </Button>
              <Button asChild variant="outline" size="lg">
                <Link to="/team">
                  팀 소개 보기
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

export default Careers;
