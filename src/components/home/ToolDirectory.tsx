import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { ArrowRight, Type, Image, Code, Search, Video, Music, MessageSquare, Briefcase } from "lucide-react";
import { Link } from "react-router-dom";

const categories = [
    { icon: Type, name: "텍스트 생성", count: "45개 +", color: "text-blue-500", bg: "bg-blue-500/10" },
    { icon: Image, name: "이미지 생성", count: "30개 +", color: "text-purple-500", bg: "bg-purple-500/10" },
    { icon: Code, name: "코드 작성", count: "25개 +", color: "text-green-500", bg: "bg-green-500/10" },
    { icon: Search, name: "검색", count: "15개 +", color: "text-orange-500", bg: "bg-orange-500/10" },
    { icon: Video, name: "동영상 편집", count: "20개 +", color: "text-red-500", bg: "bg-red-500/10" },
    { icon: Music, name: "음성/음악", count: "18개 +", color: "text-pink-500", bg: "bg-pink-500/10" },
    { icon: MessageSquare, name: "챗봇", count: "35개 +", color: "text-cyan-500", bg: "bg-cyan-500/10" },
    { icon: Briefcase, name: "생산성", count: "50개 +", color: "text-yellow-500", bg: "bg-yellow-500/10" },
];

const ToolDirectory = () => {
    return (
        <section className="py-20">
            <div className="container mx-auto px-6">
                <div className="flex items-center justify-between mb-10">
                    <div>
                        <h2 className="text-3xl font-bold mb-2">AI 도구 디렉토리</h2>
                        <p className="text-muted-foreground">카테고리별로 정리된 140+ AI 도구</p>
                    </div>
                    <Button variant="outline" asChild>
                        <Link to="/tools" className="flex items-center gap-2">
                            모든 도구 보기
                            <ArrowRight className="w-4 h-4" />
                        </Link>
                    </Button>
                </div>

                <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                    {categories.map((category, index) => (
                        <Card key={index} className="p-4 hover:shadow-md transition-all cursor-pointer group border hover:border-primary/20">
                            <div className="flex items-center gap-4">
                                <div className={`w-10 h-10 rounded-lg ${category.bg} ${category.color} flex items-center justify-center group-hover:scale-110 transition-transform`}>
                                    <category.icon className="w-5 h-5" />
                                </div>
                                <div>
                                    <h3 className="font-medium text-sm">{category.name}</h3>
                                    <p className="text-xs text-muted-foreground">{category.count}</p>
                                </div>
                            </div>
                        </Card>
                    ))}
                </div>
            </div>
        </section>
    );
};

export default ToolDirectory;
