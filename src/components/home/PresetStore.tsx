import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { ArrowRight, Download, Star } from "lucide-react";
import { Link } from "react-router-dom";

const presets = [
    {
        tag: "비즈니스",
        price: "무료",
        title: "블로그 포스팅 워크플로우",
        description: "주제 선정부터 SEO 최적화까지 자동화",
        rating: "4.8",
        downloads: "1.5K",
        isFree: true
    },
    {
        tag: "마케팅",
        price: "무료",
        title: "소셜미디어 콘텐츠 생성기",
        description: "여러 플랫폼용 콘텐츠를 한 번에 생성",
        rating: "4.6",
        downloads: "1.2K",
        isFree: true
    },
    {
        tag: "개발",
        price: "무료",
        title: "코드 리뷰 자동화",
        description: "Pull Request 자동 리뷰 및 개선 제안",
        rating: "4.9",
        downloads: "890",
        isFree: true
    },
    {
        tag: "고객 서비스",
        price: "무료",
        title: "고객 응대 챗봇 템플릿",
        description: "FAQ 자동 응답 및 티켓 분류",
        rating: "4.7",
        downloads: "750",
        isFree: true
    }
];

const PresetStore = () => {
    return (
        <section className="py-20 bg-secondary/20">
            <div className="container mx-auto px-6">
                <div className="flex items-center justify-between mb-10">
                    <div>
                        <h2 className="text-3xl font-bold mb-2">프리셋 스토어</h2>
                        <p className="text-muted-foreground">검증된 AI 워크플로우를 바로 활용하세요</p>
                    </div>
                    <Button variant="outline" asChild>
                        <Link to="/presets" className="flex items-center gap-2">
                            프리셋 전체 보기
                            <ArrowRight className="w-4 h-4" />
                        </Link>
                    </Button>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    {presets.map((preset, index) => (
                        <Card key={index} className="hover:shadow-lg transition-all duration-300">
                            <CardContent className="p-6">
                                <div className="flex justify-between items-start mb-4">
                                    <Badge variant="outline" className="rounded-md">
                                        {preset.tag}
                                    </Badge>
                                    <span className={`text-sm font-bold ${preset.isFree ? 'text-green-600' : 'text-primary'}`}>
                                        {preset.price}
                                    </span>
                                </div>

                                <h3 className="font-bold mb-2 line-clamp-1">{preset.title}</h3>
                                <p className="text-muted-foreground text-sm mb-4 line-clamp-2 h-10">{preset.description}</p>

                                <div className="flex items-center gap-1 text-sm font-medium mb-6">
                                    <Star className="w-4 h-4 text-yellow-400 fill-yellow-400" />
                                    <span>{preset.rating}</span>
                                    <span className="text-muted-foreground font-normal ml-1">({preset.downloads})</span>
                                </div>

                                <Button variant="outline" className="w-full gap-2 hover:bg-primary hover:text-primary-foreground transition-colors">
                                    <Download className="w-4 h-4" />
                                    다운로드
                                </Button>
                            </CardContent>
                        </Card>
                    ))}
                </div>
            </div>
        </section>
    );
};

export default PresetStore;
