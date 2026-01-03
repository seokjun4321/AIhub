import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Sparkles, BookOpen, Users, ArrowRight } from "lucide-react";
import { Link } from "react-router-dom";

const features = [
    {
        icon: Sparkles,
        title: "도구 추천",
        description: "당신의 문제에 딱 맞는 AI 도구를 추천해드립니다.",
        link: "/guides",
        color: "text-green-500",
        bg: "bg-green-500/10"
    },
    {
        icon: BookOpen,
        title: "가이드북",
        description: "단계별 가이드와 프롬프트 예시를 제공합니다.",
        link: "/guidebook",
        color: "text-blue-500",
        bg: "bg-blue-500/10"
    },
    {
        icon: Users,
        title: "커뮤니티",
        description: "다른 사용자들과 질문을 공유하고 해결책을 찾으세요.",
        link: "/community",
        color: "text-orange-500",
        bg: "bg-orange-500/10"
    }
];

const CoreFeatures = () => {
    return (
        <section className="py-20 bg-secondary/30">
            <div className="container mx-auto px-6">
                <div className="text-center mb-16">
                    <h2 className="text-3xl font-bold mb-4">AIHub의 핵심 기능</h2>
                    <p className="text-muted-foreground">AI 활용을 위한 모든 것을 한 곳에서</p>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
                    {features.map((feature, index) => (
                        <Card key={index} className="border-none shadow-lg hover:shadow-xl transition-all duration-300 hover:-translate-y-1">
                            <CardHeader>
                                <div className={`w-12 h-12 rounded-xl ${feature.bg} ${feature.color} flex items-center justify-center mb-4`}>
                                    <feature.icon className="w-6 h-6" />
                                </div>
                                <CardTitle className="text-xl mb-2">{feature.title}</CardTitle>
                                <CardDescription className="text-base">{feature.description}</CardDescription>
                            </CardHeader>
                            <CardContent>
                                <Button variant="ghost" className="group p-0 h-auto hover:bg-transparent" asChild>
                                    <Link to={feature.link} className="flex items-center gap-2 text-sm font-medium">
                                        자세히 보기
                                        <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
                                    </Link>
                                </Button>
                            </CardContent>
                        </Card>
                    ))}
                </div>
            </div>
        </section>
    );
};

export default CoreFeatures;
