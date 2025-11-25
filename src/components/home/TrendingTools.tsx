import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { TrendingUp, ArrowUpRight } from "lucide-react";

const trendingTools = [
    {
        name: "ChatGPT",
        category: "텍스트 생성",
        growth: "+25%",
        description: "강력한 대화형 AI로 다양한 작업을 처리합니다.",
        icon: "https://upload.wikimedia.org/wikipedia/commons/0/04/ChatGPT_logo.svg"
    },
    {
        name: "Midjourney",
        category: "이미지 생성",
        growth: "+18%",
        description: "텍스트로 예술적인 이미지를 생성합니다.",
        icon: "https://upload.wikimedia.org/wikipedia/commons/e/ed/Midjourney_Emblem.png"
    },
    {
        name: "GitHub Copilot",
        category: "코드 작성",
        growth: "+22%",
        description: "AI가 코드 작성을 도와줍니다.",
        icon: "https://upload.wikimedia.org/wikipedia/commons/2/29/GitHub_Copilot_logo.svg"
    },
    {
        name: "Perplexity AI",
        category: "검색",
        growth: "+30%",
        description: "AI 기반 검색 엔진으로 정확한 답변을 제공합니다.",
        icon: "https://upload.wikimedia.org/wikipedia/commons/1/1d/Perplexity_AI_logo.svg"
    }
];

const TrendingTools = () => {
    return (
        <section className="py-12 bg-secondary/20">
            <div className="container mx-auto px-6">
                <div className="flex items-center gap-2 mb-8">
                    <TrendingUp className="w-6 h-6 text-green-500" />
                    <h2 className="text-2xl font-bold">트렌딩 도구</h2>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    {trendingTools.map((tool, index) => (
                        <Card key={index} className="hover:shadow-lg transition-all duration-300 cursor-pointer group">
                            <CardContent className="p-6">
                                <div className="flex items-start justify-between mb-4">
                                    <div className="flex items-center gap-4">
                                        <div className="w-12 h-12 bg-white rounded-xl shadow-sm flex items-center justify-center p-2">
                                            {/* 실제 아이콘 대신 텍스트나 기본 아이콘 사용 가능, 여기서는 외부 이미지 사용 */}
                                            <img src={tool.icon} alt={tool.name} className="w-full h-full object-contain" onError={(e) => {
                                                (e.target as HTMLImageElement).src = "https://via.placeholder.com/48?text=" + tool.name[0];
                                            }} />
                                        </div>
                                        <div>
                                            <h3 className="font-bold text-lg group-hover:text-primary transition-colors">{tool.name}</h3>
                                            <Badge variant="secondary" className="mt-1 font-normal text-xs">
                                                {tool.category}
                                            </Badge>
                                        </div>
                                    </div>
                                    <Badge className="bg-green-100 text-green-700 hover:bg-green-200 border-none flex items-center gap-1">
                                        <ArrowUpRight className="w-3 h-3" />
                                        {tool.growth}
                                    </Badge>
                                </div>
                                <p className="text-muted-foreground text-sm">{tool.description}</p>
                            </CardContent>
                        </Card>
                    ))}
                </div>
            </div>
        </section>
    );
};

export default TrendingTools;
