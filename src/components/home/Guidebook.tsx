import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Book, ArrowRight, Eye } from "lucide-react";
import { Link } from "react-router-dom";

const guides = [
    {
        level: "초급",
        title: "ChatGPT 완벽 활용 가이드",
        description: "효과적인 프롬프트 작성부터 고급 기능까지",
        points: ["효과적인 프롬프트 구조 작성법", "컨텍스트를 활용한 대화 전략"],
        views: "1.2K",
        color: "bg-green-100 text-green-700"
    },
    {
        level: "중급",
        title: "AI로 마케팅 콘텐츠 제작하기",
        description: "SNS, 블로그, 광고 문구를 AI로 자동화",
        points: ["매력적인 제목 생성 프롬프트", "타겟 고객별 맞춤 메시지"],
        views: "850",
        color: "bg-blue-100 text-blue-700"
    },
    {
        level: "고급",
        title: "개발자를 위한 AI 코딩 가이드",
        description: "GitHub Copilot과 ChatGPT로 생산성 향상",
        points: ["코드 리뷰 자동화 프롬프트", "버그 디버깅 효율화 방법"],
        views: "640",
        color: "bg-purple-100 text-purple-700"
    }
];

const Guidebook = () => {
    return (
        <section className="py-20">
            <div className="container mx-auto px-6">
                <div className="flex items-center justify-between mb-10">
                    <div>
                        <h2 className="text-3xl font-bold mb-2">가이드북</h2>
                        <p className="text-muted-foreground">실전에서 바로 사용할 수 있는 프롬프트와 활용법</p>
                    </div>
                    <Button variant="outline" asChild>
                        <Link to="/guidebook" className="flex items-center gap-2">
                            가이드 전체 보기
                            <ArrowRight className="w-4 h-4" />
                        </Link>
                    </Button>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
                    {guides.map((guide, index) => (
                        <Card key={index} className="hover:shadow-lg transition-all duration-300 hover:-translate-y-1 h-full flex flex-col">
                            <CardContent className="p-6 flex-1 flex flex-col">
                                <div className="flex justify-between items-start mb-4">
                                    <div className="w-10 h-10 rounded-lg bg-secondary flex items-center justify-center text-primary">
                                        <Book className="w-5 h-5" />
                                    </div>
                                    <Badge variant="secondary" className={guide.color}>
                                        {guide.level}
                                    </Badge>
                                </div>

                                <h3 className="text-xl font-bold mb-2">{guide.title}</h3>
                                <p className="text-muted-foreground text-sm mb-6">{guide.description}</p>

                                <div className="mt-auto">
                                    <div className="space-y-2 mb-6">
                                        {guide.points.map((point, i) => (
                                            <div key={i} className="flex items-center gap-2 text-sm text-muted-foreground">
                                                <div className="w-1 h-1 rounded-full bg-primary/50" />
                                                {point}
                                            </div>
                                        ))}
                                    </div>

                                    <div className="flex items-center text-xs text-muted-foreground pt-4 border-t">
                                        <Eye className="w-3 h-3 mr-1" />
                                        {guide.views}명이 읽었어요
                                    </div>
                                </div>
                            </CardContent>
                        </Card>
                    ))}
                </div>
            </div>
        </section>
    );
};

export default Guidebook;
