import { Button } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Brain, Github, Twitter, Mail, ArrowRight, Users, Target, Lightbulb, Code, TrendingUp, Phone, MapPin } from "lucide-react";

const Footer = () => {
  const footerLinks = {
    product: [
      { name: "AI 추천", href: "/recommend" },
      { name: "가이드북", href: "/guides" },
      { name: "커뮤니티", href: "/community" },
      { name: "AI 도구", href: "/tools" },
    ],
    company: [
      { name: "소개", href: "/about" },
      { name: "팀", href: "/team" },
      { name: "채용", href: "/careers" },
      { name: "연락처", href: "/contact" },
    ],
    support: [
      { name: "도움말", href: "/help" },
      { name: "FAQ", href: "/faq" },
      { name: "피드백", href: "/feedback" },
      { name: "문의하기", href: "/contact" },
    ],
    legal: [
      { name: "이용약관", href: "/terms" },
      { name: "개인정보처리방침", href: "/privacy" },
      { name: "쿠키 정책", href: "/cookies" },
    ],
  };



  return (
    <footer className="bg-card border-t border-border/50">
      <div className="container mx-auto px-6">
        {/* Newsletter Section */}
        <div className="py-12 border-b border-border/50">
          <div className="max-w-2xl mx-auto text-center">
            <h3 className="text-2xl font-bold mb-4">
              AIHub 뉴스레터
            </h3>
            <p className="text-muted-foreground mb-6">
              최신 AI 트렌드와 활용법을 주 1회 이메일로 받아보세요
            </p>
            <div className="flex flex-col sm:flex-row gap-3 max-w-md mx-auto">
              <input
                type="email"
                placeholder="이메일 주소를 입력하세요"
                className="flex-1 px-4 py-3 rounded-lg border border-border bg-background focus:outline-none focus:ring-2 focus:ring-primary/50"
              />
              <Button className="bg-gradient-primary hover:opacity-90 px-6">
                구독하기
                <ArrowRight className="ml-2 w-4 h-4" />
              </Button>
            </div>
          </div>
        </div>

        {/* Main Footer Content */}
        <div className="py-12">
          <div className="grid lg:grid-cols-5 gap-8">
            {/* Brand Section */}
            <div className="lg:col-span-2">
              <div className="flex items-center gap-2 mb-4">
                <div className="p-2 bg-gradient-primary rounded-lg shadow-primary">
                  <Brain className="w-6 h-6 text-primary-foreground" />
                </div>
                <span className="text-2xl font-bold bg-gradient-primary bg-clip-text text-transparent">
                  AIHub
                </span>
              </div>
              <p className="text-muted-foreground mb-6 max-w-md">
                당신의 문제에 딱 맞는 AI 솔루션을 찾아드립니다. 
                실제 사용자들이 검증한 AI 추천과 활용법을 한곳에서 만나보세요.
              </p>
              
              {/* Social Links */}
              <div className="flex gap-3">
                <Button variant="outline" size="icon" className="hover:bg-primary/10">
                  <Github className="w-4 h-4" />
                </Button>
                <Button variant="outline" size="icon" className="hover:bg-primary/10">
                  <Twitter className="w-4 h-4" />
                </Button>
                <Button variant="outline" size="icon" className="hover:bg-primary/10">
                  <Mail className="w-4 h-4" />
                </Button>
              </div>
            </div>

            {/* Links Sections */}
            <div>
              <h4 className="font-semibold mb-4">제품</h4>
              <ul className="space-y-3">
                {footerLinks.product.map((link) => (
                  <li key={link.name}>
                    <a
                      href={link.href}
                      className="text-muted-foreground hover:text-primary transition-colors"
                    >
                      {link.name}
                    </a>
                  </li>
                ))}
              </ul>
            </div>

            <div>
              <h4 className="font-semibold mb-4">회사</h4>
              <ul className="space-y-3">
                {footerLinks.company.map((link) => (
                  <li key={link.name}>
                    <a
                      href={link.href}
                      className="text-muted-foreground hover:text-primary transition-colors"
                    >
                      {link.name}
                    </a>
                  </li>
                ))}
              </ul>
            </div>

            <div>
              <h4 className="font-semibold mb-4">지원</h4>
              <ul className="space-y-3">
                {footerLinks.support.map((link) => (
                  <li key={link.name}>
                    <a
                      href={link.href}
                      className="text-muted-foreground hover:text-primary transition-colors"
                    >
                      {link.name}
                    </a>
                  </li>
                ))}
              </ul>
            </div>
          </div>
        </div>



        {/* Bottom Section */}
        <Separator className="opacity-50" />
        <div className="py-6 flex flex-col md:flex-row justify-between items-center gap-4">
          <div className="text-sm text-muted-foreground">
            © 2024 AIHub. All rights reserved.
          </div>
          
          <div className="flex gap-6">
            {footerLinks.legal.map((link) => (
              <a
                key={link.name}
                href={link.href}
                className="text-sm text-muted-foreground hover:text-primary transition-colors"
              >
                {link.name}
              </a>
            ))}
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;