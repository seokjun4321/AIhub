import { useState } from "react";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Label } from "@/components/ui/label";
import { 
  Mail, 
  Phone, 
  MapPin, 
  Clock, 
  Send, 
  MessageSquare, 
  Users, 
  ArrowRight,
  CheckCircle,
  AlertCircle
} from "lucide-react";
import { toast } from "sonner";

const Contact = () => {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    subject: "",
    message: ""
  });
  const [isSubmitting, setIsSubmitting] = useState(false);

  const contactInfo = [
    {
      icon: Mail,
      title: "이메일",
      value: "contact@aihub.com",
      description: "일반적인 문의사항"
    },
    {
      icon: Phone,
      title: "전화번호",
      value: "02-1234-5678",
      description: "긴급한 문의사항"
    },
    {
      icon: MapPin,
      title: "주소",
      value: "서울특별시 강남구 테헤란로 123",
      description: "AIHub 본사"
    },
    {
      icon: Clock,
      title: "운영시간",
      value: "월-금 09:00-18:00",
      description: "한국 시간 기준"
    }
  ];

  const faqItems = [
    {
      question: "AIHub는 어떤 서비스를 제공하나요?",
      answer: "AIHub는 사용자들이 최적의 AI 솔루션을 찾을 수 있도록 돕는 플랫폼입니다. AI 도구 추천, 가이드북, 커뮤니티 기능을 제공합니다."
    },
    {
      question: "회원가입은 무료인가요?",
      answer: "네, AIHub의 기본 서비스는 모두 무료로 이용하실 수 있습니다. 추가 프리미엄 기능은 유료로 제공될 예정입니다."
    },
    {
      question: "기술 지원은 어떻게 받을 수 있나요?",
      answer: "기술 지원은 이메일(contact@aihub.com) 또는 커뮤니티를 통해 받으실 수 있습니다. 빠른 응답을 위해 커뮤니티 이용을 권장합니다."
    },
    {
      question: "파트너십이나 협업에 관심이 있습니다.",
      answer: "파트너십 문의는 별도로 contact@aihub.com으로 연락주시면 담당자가 빠른 시일 내에 답변드리겠습니다."
    }
  ];

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);

    // 실제로는 여기서 API 호출을 하여 이메일을 전송합니다
    try {
      // 시뮬레이션을 위한 지연
      await new Promise(resolve => setTimeout(resolve, 2000));
      
      toast.success("문의가 성공적으로 전송되었습니다! 빠른 시일 내에 답변드리겠습니다.");
      setFormData({ name: "", email: "", subject: "", message: "" });
    } catch (error) {
      toast.error("문의 전송에 실패했습니다. 다시 시도해주세요.");
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };

  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      
      <main className="pt-24">
        <div className="container mx-auto px-6">
          {/* Hero Section */}
          <div className="text-center py-16">
            <Badge className="mb-4 bg-primary/10 text-primary hover:bg-primary/20">
              연락처
            </Badge>
            <h1 className="text-4xl md:text-6xl font-bold mb-6">
              언제든지 <span className="bg-gradient-primary bg-clip-text text-transparent">연락주세요</span>
            </h1>
            <p className="text-xl text-muted-foreground max-w-3xl mx-auto mb-8">
              AIHub에 대한 문의사항이나 제안사항이 있으시면 언제든지 연락주세요. 
              빠른 시일 내에 답변드리겠습니다.
            </p>
          </div>

          {/* Contact Info */}
          <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6 mb-16">
            {contactInfo.map((info, index) => {
              const Icon = info.icon;
              return (
                <Card key={index} className="text-center hover:shadow-lg transition-shadow">
                  <CardContent className="p-6">
                    <Icon className="w-8 h-8 text-primary mx-auto mb-4" />
                    <h3 className="font-semibold mb-2">{info.title}</h3>
                    <p className="text-primary font-medium mb-1">{info.value}</p>
                    <p className="text-sm text-muted-foreground">{info.description}</p>
                  </CardContent>
                </Card>
              );
            })}
          </div>

          {/* Contact Form & Info */}
          <div className="grid lg:grid-cols-2 gap-12 mb-16">
            {/* Contact Form */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <MessageSquare className="w-5 h-5 text-primary" />
                  문의하기
                </CardTitle>
              </CardHeader>
              <CardContent>
                <form onSubmit={handleSubmit} className="space-y-6">
                  <div className="grid md:grid-cols-2 gap-4">
                    <div className="space-y-2">
                      <Label htmlFor="name">이름 *</Label>
                      <Input
                        id="name"
                        name="name"
                        value={formData.name}
                        onChange={handleInputChange}
                        placeholder="홍길동"
                        required
                      />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="email">이메일 *</Label>
                      <Input
                        id="email"
                        name="email"
                        type="email"
                        value={formData.email}
                        onChange={handleInputChange}
                        placeholder="example@email.com"
                        required
                      />
                    </div>
                  </div>
                  
                  <div className="space-y-2">
                    <Label htmlFor="subject">제목 *</Label>
                    <Input
                      id="subject"
                      name="subject"
                      value={formData.subject}
                      onChange={handleInputChange}
                      placeholder="문의 제목을 입력해주세요"
                      required
                    />
                  </div>
                  
                  <div className="space-y-2">
                    <Label htmlFor="message">메시지 *</Label>
                    <Textarea
                      id="message"
                      name="message"
                      value={formData.message}
                      onChange={handleInputChange}
                      placeholder="문의사항을 자세히 작성해주세요..."
                      rows={6}
                      required
                    />
                  </div>
                  
                  <Button 
                    type="submit" 
                    className="w-full bg-gradient-primary hover:opacity-90"
                    disabled={isSubmitting}
                  >
                    {isSubmitting ? (
                      <>
                        <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin mr-2" />
                        전송 중...
                      </>
                    ) : (
                      <>
                        메시지 보내기
                        <Send className="ml-2 w-4 h-4" />
                      </>
                    )}
                  </Button>
                </form>
              </CardContent>
            </Card>

            {/* Additional Info */}
            <div className="space-y-6">
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Users className="w-5 h-5 text-primary" />
                    빠른 응답을 위한 팁
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    <div className="flex items-start gap-3">
                      <CheckCircle className="w-5 h-5 text-green-500 mt-0.5 flex-shrink-0" />
                      <div>
                        <h4 className="font-medium mb-1">구체적인 내용 작성</h4>
                        <p className="text-sm text-muted-foreground">
                          문의사항을 구체적으로 작성해주시면 더 정확한 답변을 드릴 수 있습니다.
                        </p>
                      </div>
                    </div>
                    <div className="flex items-start gap-3">
                      <CheckCircle className="w-5 h-5 text-green-500 mt-0.5 flex-shrink-0" />
                      <div>
                        <h4 className="font-medium mb-1">첨부 파일 포함</h4>
                        <p className="text-sm text-muted-foreground">
                          스크린샷이나 관련 파일이 있다면 이메일로 별도 첨부해주세요.
                        </p>
                      </div>
                    </div>
                    <div className="flex items-start gap-3">
                      <CheckCircle className="w-5 h-5 text-green-500 mt-0.5 flex-shrink-0" />
                      <div>
                        <h4 className="font-medium mb-1">응답 시간</h4>
                        <p className="text-sm text-muted-foreground">
                          일반적으로 24시간 이내에 답변드리며, 주말에는 다음 영업일에 답변드립니다.
                        </p>
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <AlertCircle className="w-5 h-5 text-primary" />
                    자주 묻는 질문
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    {faqItems.map((faq, index) => (
                      <div key={index} className="border-b border-border/50 pb-4 last:border-b-0">
                        <h4 className="font-medium mb-2">{faq.question}</h4>
                        <p className="text-sm text-muted-foreground">{faq.answer}</p>
                      </div>
                    ))}
                  </div>
                </CardContent>
              </Card>
            </div>
          </div>

          {/* Map Section */}
          <div className="mb-16">
            <div className="text-center mb-8">
              <h2 className="text-3xl font-bold mb-4">찾아오시는 길</h2>
              <p className="text-muted-foreground max-w-2xl mx-auto">
                AIHub 본사 위치와 오시는 방법을 안내해드립니다.
              </p>
            </div>
            
            <Card>
              <CardContent className="p-6">
                <div className="grid md:grid-cols-2 gap-8">
                  <div>
                    <h3 className="font-semibold mb-4">주소</h3>
                    <p className="text-muted-foreground mb-6">
                      서울특별시 강남구 테헤란로 123<br />
                      AIHub 빌딩 5층
                    </p>
                    
                    <h3 className="font-semibold mb-4">대중교통</h3>
                    <div className="space-y-2 text-sm text-muted-foreground">
                      <p><strong>지하철:</strong> 2호선 강남역 3번 출구에서 도보 5분</p>
                      <p><strong>버스:</strong> 강남역 정류장 하차 (간선 146, 360, 740)</p>
                      <p><strong>공항철도:</strong> 강남역에서 환승</p>
                    </div>
                  </div>
                  
                  <div className="bg-muted rounded-lg flex items-center justify-center h-64">
                    <div className="text-center text-muted-foreground">
                      <MapPin className="w-12 h-12 mx-auto mb-4" />
                      <p>지도가 여기에 표시됩니다</p>
                      <p className="text-sm">Google Maps 또는 Naver Maps 연동 예정</p>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>

          {/* CTA Section */}
          <div className="text-center py-16 bg-gradient-to-r from-primary/5 to-primary/10 rounded-2xl mb-16">
            <h2 className="text-3xl font-bold mb-4">더 많은 정보가 필요하신가요?</h2>
            <p className="text-muted-foreground max-w-2xl mx-auto mb-8">
              AIHub에 대한 더 자세한 정보를 원하시면 다른 페이지들도 확인해보세요.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Button asChild size="lg" className="bg-gradient-primary hover:opacity-90">
                <a href="/about">
                  회사 소개 보기
                  <ArrowRight className="ml-2 w-4 h-4" />
                </a>
              </Button>
              <Button asChild variant="outline" size="lg">
                <a href="/team">
                  팀 소개 보기
                </a>
              </Button>
            </div>
          </div>
        </div>
      </main>
      
      <Footer />
    </div>
  );
};

export default Contact;
