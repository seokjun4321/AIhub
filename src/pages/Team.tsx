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
  Phone, 
  Mail, 
  MapPin,
  Calendar,
  Award,
  Github,
  Linkedin,
  ExternalLink,
  ArrowRight
} from "lucide-react";
import { Link } from "react-router-dom";

const Team = () => {
  const teamMembers = [
    {
      name: "김석준",
      role: "Co-Founder & CTO",
      education: "성균관대학교 소프트웨어학과 22학번",
      birth: "2003년생",
      phone: "010-4104-2133",
      email: "seokjun4321@gmail.com",
      image: "/kim-seokjun.jpg",
      skills: ["Full-Stack Development", "AI/ML", "Product Strategy", "React", "TypeScript", "Node.js"],
      description: "기술적 구현과 혁신적인 아이디어를 결합하여 AIHub의 핵심 제품을 개발합니다. 사용자 경험을 최우선으로 생각하며, 최신 기술 트렌드를 반영한 솔루션을 제공합니다.",
      responsibilities: [
        "전체 기술 아키텍처 설계 및 개발",
        "AI 추천 시스템 알고리즘 구현",
        "프론트엔드 및 백엔드 개발",
        "제품 전략 및 로드맵 수립"
      ],
      social: {
        github: "https://github.com/seokjun4321",
        linkedin: "#",
        portfolio: "#"
      }
    },
    {
      name: "박민욱",
      role: "Co-Founder & CEO",
      education: "연세대학교 물리학과 22학번",
      birth: "2003년생",
      phone: "010-5175-5079",
      email: "markmp0618@gmail.com",
      image: "/placeholder.svg",
      skills: ["Business Strategy", "Market Research", "Marketing", "Data Analysis", "User Research", "Growth Hacking"],
      description: "시장 분석과 전략적 비전을 통해 AIHub의 성장 방향을 이끌어갑니다. 사용자 니즈를 깊이 이해하고, 비즈니스 모델을 지속적으로 개선합니다.",
      responsibilities: [
        "전체 비즈니스 전략 수립 및 실행",
        "시장 조사 및 경쟁사 분석",
        "마케팅 전략 및 브랜딩",
        "사용자 리서치 및 제품 기획"
      ],
      social: {
        github: "#",
        linkedin: "#",
        portfolio: "#"
      }
    }
  ];

  const teamStats = [
    { number: "2", label: "창업자", icon: Users },
    { number: "3+", label: "개월 경험", icon: Calendar },
    { number: "100%", label: "열정", icon: Award },
    { number: "24/7", label: "커뮤니케이션", icon: Phone }
  ];

  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      
      <main className="pt-24">
        <div className="container mx-auto px-6">
          {/* Hero Section */}
          <div className="text-center py-16">
            <Badge className="mb-4 bg-primary/10 text-primary hover:bg-primary/20">
              팀 소개
            </Badge>
            <h1 className="text-4xl md:text-6xl font-bold mb-6">
              AIHub를 만드는 <span className="bg-gradient-primary bg-clip-text text-transparent">젊은 창업자들</span>
            </h1>
            <p className="text-xl text-muted-foreground max-w-3xl mx-auto mb-8">
              성균관대학교와 연세대학교 학생들이 모여 AI 기술의 민주화를 위해 노력하고 있습니다. 
              각자의 전문 분야에서 최고의 역량을 발휘하여 AIHub의 비전을 실현해갑니다.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Button asChild size="lg" className="bg-gradient-primary hover:opacity-90">
                <Link to="/contact">
                  문의하기
                  <ArrowRight className="ml-2 w-4 h-4" />
                </Link>
              </Button>
              <Button asChild variant="outline" size="lg">
                <Link to="/careers">
                  채용 정보 보기
                </Link>
              </Button>
            </div>
          </div>

          {/* Team Stats */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-6 mb-16">
            {teamStats.map((stat, index) => {
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

          {/* Team Members */}
          <div className="mb-16">
            <div className="text-center mb-12">
              <h2 className="text-3xl font-bold mb-4">팀 멤버</h2>
              <p className="text-muted-foreground max-w-2xl mx-auto">
                각자의 전문 분야에서 최고의 역량을 발휘하는 AIHub 팀을 소개합니다.
              </p>
            </div>
            
            <div className="space-y-12">
              {teamMembers.map((member, index) => (
                <Card key={index} className="overflow-hidden">
                  <CardContent className="p-8">
                    <div className="grid md:grid-cols-3 gap-8">
                      {/* Profile Image & Basic Info */}
                      <div className="text-center md:text-left">
                        <div className="relative inline-block mb-6">
                          <img
                            src={member.image}
                            alt={member.name}
                                                         className="w-32 h-32 rounded-full object-cover object-top border-4 border-primary/20"
                          />
                          <Badge className="absolute -bottom-2 -right-2 bg-primary text-primary-foreground">
                            {member.role.split(' ')[0]}
                          </Badge>
                        </div>
                        
                        <h3 className="text-2xl font-bold mb-2">{member.name}</h3>
                        <p className="text-primary font-medium mb-1">{member.role}</p>
                        
                        {/* Contact Info */}
                        <div className="space-y-2 text-sm">
                          <div className="flex items-center gap-2 justify-center md:justify-start">
                            <Code className="w-4 h-4 text-muted-foreground" />
                            <span className="text-muted-foreground">{member.education}</span>
                          </div>
                          <div className="flex items-center gap-2 justify-center md:justify-start">
                            <Calendar className="w-4 h-4 text-muted-foreground" />
                            <span className="text-muted-foreground">{member.birth}</span>
                          </div>
                          <div className="flex items-center gap-2 justify-center md:justify-start">
                            <Phone className="w-4 h-4 text-muted-foreground" />
                            <span className="text-muted-foreground">{member.phone}</span>
                          </div>
                          <div className="flex items-center gap-2 justify-center md:justify-start">
                            <Mail className="w-4 h-4 text-muted-foreground" />
                            <span className="text-muted-foreground">{member.email}</span>
                          </div>
                        </div>
                        
                        {/* Social Links */}
                        <div className="flex gap-3 mt-6 justify-center md:justify-start">
                          <Button variant="outline" size="icon" asChild>
                            <a href={member.social.github} target="_blank" rel="noopener noreferrer">
                              <Github className="w-4 h-4" />
                            </a>
                          </Button>
                          <Button variant="outline" size="icon" asChild>
                            <a href={member.social.linkedin} target="_blank" rel="noopener noreferrer">
                              <Linkedin className="w-4 h-4" />
                            </a>
                          </Button>
                          <Button variant="outline" size="icon" asChild>
                            <a href={member.social.portfolio} target="_blank" rel="noopener noreferrer">
                              <ExternalLink className="w-4 h-4" />
                            </a>
                          </Button>
                        </div>
                      </div>
                      
                      {/* Description & Skills */}
                      <div className="md:col-span-2">
                        <div className="mb-6">
                          <h4 className="font-semibold mb-3">소개</h4>
                          <p className="text-muted-foreground leading-relaxed">
                            {member.description}
                          </p>
                        </div>
                        
                        <div className="mb-6">
                          <h4 className="font-semibold mb-3">주요 책임</h4>
                          <ul className="space-y-2">
                            {member.responsibilities.map((responsibility, idx) => (
                              <li key={idx} className="flex items-start gap-2 text-sm text-muted-foreground">
                                <Target className="w-4 h-4 text-primary mt-0.5 flex-shrink-0" />
                                <span>{responsibility}</span>
                              </li>
                            ))}
                          </ul>
                        </div>
                        
                        <div>
                          <h4 className="font-semibold mb-3">전문 분야</h4>
                          <div className="flex flex-wrap gap-2">
                            {member.skills.map((skill, skillIndex) => (
                              <Badge key={skillIndex} variant="secondary">
                                {skill}
                              </Badge>
                            ))}
                          </div>
                        </div>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          </div>

          {/* Team Culture */}
          <div className="mb-16">
            <div className="text-center mb-12">
              <h2 className="text-3xl font-bold mb-4">팀 문화</h2>
              <p className="text-muted-foreground max-w-2xl mx-auto">
                AIHub가 추구하는 팀 문화와 가치관을 소개합니다.
              </p>
            </div>
            
            <div className="grid md:grid-cols-3 gap-6">
              <Card className="text-center">
                <CardContent className="p-6">
                  <Lightbulb className="w-12 h-12 text-primary mx-auto mb-4" />
                  <h3 className="font-semibold mb-2">혁신적 사고</h3>
                  <p className="text-sm text-muted-foreground">
                    새로운 아이디어를 두려워하지 않고, 창의적인 솔루션을 찾아갑니다.
                  </p>
                </CardContent>
              </Card>
              
              <Card className="text-center">
                <CardContent className="p-6">
                  <Users className="w-12 h-12 text-primary mx-auto mb-4" />
                  <h3 className="font-semibold mb-2">협력과 소통</h3>
                  <p className="text-sm text-muted-foreground">
                    서로의 의견을 존중하고, 열린 소통을 통해 최고의 결과를 만들어갑니다.
                  </p>
                </CardContent>
              </Card>
              
              <Card className="text-center">
                <CardContent className="p-6">
                  <TrendingUp className="w-12 h-12 text-primary mx-auto mb-4" />
                  <h3 className="font-semibold mb-2">지속적 학습</h3>
                  <p className="text-sm text-muted-foreground">
                    새로운 기술과 트렌드를 배우며, 끊임없이 성장해나갑니다.
                  </p>
                </CardContent>
              </Card>
            </div>
          </div>

          {/* CTA Section */}
          <div className="text-center py-16 bg-gradient-to-r from-primary/5 to-primary/10 rounded-2xl mb-16">
            <h2 className="text-3xl font-bold mb-4">함께 일할 동료를 찾고 있습니다</h2>
            <p className="text-muted-foreground max-w-2xl mx-auto mb-8">
              AI 기술의 미래를 함께 만들어갈 열정적인 동료들을 기다리고 있습니다. 
              여러분의 재능과 열정이 AIHub의 성장에 큰 도움이 될 것입니다.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Button asChild size="lg" className="bg-gradient-primary hover:opacity-90">
                <Link to="/careers">
                  채용 정보 보기
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
        </div>
      </main>
      
      <Footer />
    </div>
  );
};

export default Team;
