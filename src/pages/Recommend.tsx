import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Link } from "react-router-dom";
import { ArrowRight, BrainCircuit, Code, Pencil, Palette } from "lucide-react";

// AI 추천 데이터를 담고 있는 배열입니다.
// 나중에는 이 데이터를 Supabase에서 불러올 수도 있습니다.
const recommendationData = [
  {
    category: "개발 (Development)",
    icon: <Code className="w-8 h-8 text-primary-foreground" />,
    gradient: "from-blue-500 to-cyan-500",
    scenarios: [
      {
        situation: "코딩하다 막혔을 때 🤯",
        summary: "복잡한 에러, 새로운 로직 구현... 전문가의 도움이 필요하다면?",
        aiName: "Gemini Advanced",
        reason: "뛰어난 논리력과 방대한 코드로 복잡한 문제 해결에 최적화!",
        guideLink: "/guides/2" // lovalbe.dev 가이드 ID (seed.js 기반)
      },
      {
        situation: "새 프로젝트를 시작할 때 🏗️",
        summary: "기술 스택 선정부터 전체 아키텍처 설계까지, 막막하다면?",
        aiName: "Claude 3 Opus",
        reason: "방대한 문서를 한 번에 이해하고, 체계적인 구조를 제안하는 데 탁월!",
        guideLink: "/guides/1" // ChatGPT 가이드 ID (임시)
      }
    ]
  },
  {
    category: "글쓰기 & 콘텐츠 제작 (Writing)",
    icon: <Pencil className="w-8 h-8 text-primary-foreground" />,
    gradient: "from-green-500 to-emerald-500",
    scenarios: [
      {
        situation: "블로그, 리포트 초안을 쓸 때 📝",
        summary: "글의 뼈대를 잡고, 자연스러운 문장으로 내용을 채우고 싶다면?",
        aiName: "ChatGPT-4o",
        reason: "창의적이고 완성도 높은 긴 글 생성에 강점을 보입니다!",
        guideLink: "/guides/1" // ChatGPT 가이드 ID (seed.js 기반)
      },
      {
        situation: "신뢰도 높은 정보 조사가 필요할 때 🔍",
        summary: "논문, 기사 등 정확한 출처 기반의 자료를 찾고 싶다면?",
        aiName: "Perplexity AI",
        reason: "실시간 웹 검색과 출처 제시로 정보의 신뢰도를 보장합니다!",
        guideLink: "/guides/1" // 임시 링크
      }
    ]
  },
    {
    category: "디자인 (Design)",
    icon: <Palette className="w-8 h-8 text-primary-foreground" />,
    gradient: "from-purple-500 to-pink-500",
    scenarios: [
      {
        situation: "예술적인 이미지를 만들고 싶을 때 🎨",
        summary: "프롬프트 입력만으로 고품질 이미지를 생성하고 싶다면?",
        aiName: "Midjourney",
        reason: "독보적인 퀄리티의 예술적이고 사실적인 이미지 생성!",
        guideLink: "/guides/1" // 임시 링크
      },
    ]
  },
];

const Recommend = () => {
  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      <main className="pt-24 pb-12">
        <div className="container mx-auto px-6">
          <div className="text-center mb-16">
            <h1 className="text-4xl md:text-5xl font-bold">AI 추천</h1>
            <p className="text-xl text-muted-foreground mt-4 max-w-2xl mx-auto">
              어떤 AI를 써야 할지 고민되시나요? <br />
              AIHub가 당신의 상황에 딱 맞는 AI와 가이드북을 추천해 드립니다.
            </p>
          </div>

          <div className="space-y-12">
            {recommendationData.map((categoryData) => (
              <section key={categoryData.category}>
                <div className="flex items-center gap-4 mb-6">
                  <div className={`p-3 rounded-xl bg-gradient-to-r ${categoryData.gradient} shadow-lg`}>
                    {categoryData.icon}
                  </div>
                  <h2 className="text-3xl font-bold">{categoryData.category}</h2>
                </div>
                <div className="grid md:grid-cols-2 gap-6">
                  {categoryData.scenarios.map((scenario) => (
                    <Card key={scenario.situation} className="h-full flex flex-col justify-between">
                      <CardHeader>
                        <CardTitle>{scenario.situation}</CardTitle>
                        <CardDescription>{scenario.summary}</CardDescription>
                      </CardHeader>
                      <CardContent>
                        <div className="bg-muted p-4 rounded-lg space-y-2 mb-4">
                           <div className="flex items-center gap-2">
                             <BrainCircuit className="w-5 h-5 text-primary"/>
                             <h4 className="font-semibold">추천 AI: {scenario.aiName}</h4>
                           </div>
                           <p className="text-sm text-muted-foreground">{scenario.reason}</p>
                        </div>
                        <Button asChild className="w-full group">
                          <Link to={scenario.guideLink}>
                            가이드북 보기
                            <ArrowRight className="ml-2 w-4 h-4 group-hover:translate-x-1 transition-transform" />
                          </Link>
                        </Button>
                      </CardContent>
                    </Card>
                  ))}
                </div>
              </section>
            ))}
          </div>
        </div>
      </main>
      <Footer />
    </div>
  );
};

export default Recommend;