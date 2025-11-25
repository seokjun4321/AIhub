import { Card } from "@/components/ui/card";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { Star } from "lucide-react";

const creators = [
    {
        name: "비즈니스팀",
        rating: 4.9,
        sales: "1250개 판매",
        tags: ["프롬프트", "자동화"],
        description: "사업계획서 자동 생성 프롬프트 세트",
        avatar: "B"
    },
    {
        name: "크리에이티브스튜디오",
        rating: 4.8,
        sales: "980개 판매",
        tags: ["디자인", "프롬프트"],
        description: "Midjourney 캐릭터 프롬프트 팩",
        avatar: "C"
    },
    {
        name: "오토메이션랩",
        rating: 4.9,
        sales: "850개 판매",
        tags: ["자동화", "워크플로우"],
        description: "n8n 이메일 자동분류 워크플로우",
        avatar: "A"
    }
];

const CreatorGrid = () => {
    return (
        <section className="py-12 bg-secondary/10">
            <div className="container mx-auto px-6">
                <div className="text-center mb-8">
                    <h2 className="text-xl font-bold mb-1">인기 크리에이터</h2>
                    <p className="text-sm text-muted-foreground">검증된 크리에이터의 템플릿을 만나보세요</p>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                    {creators.map((creator, index) => (
                        <Card key={index} className="p-6 flex items-start gap-4 hover:shadow-md transition-all cursor-pointer">
                            <Avatar className="w-12 h-12">
                                <AvatarImage src={`https://api.dicebear.com/7.x/avataaars/svg?seed=${creator.name}`} />
                                <AvatarFallback>{creator.avatar}</AvatarFallback>
                            </Avatar>
                            <div className="flex-1">
                                <div className="flex justify-between items-start mb-1">
                                    <h3 className="font-bold text-sm">{creator.name}</h3>
                                </div>
                                <div className="flex items-center gap-2 text-xs text-muted-foreground mb-3">
                                    <div className="flex items-center gap-0.5">
                                        <Star className="w-3 h-3 text-yellow-400 fill-yellow-400" />
                                        <span className="font-medium text-foreground">{creator.rating}</span>
                                    </div>
                                    <span>•</span>
                                    <span>{creator.sales}</span>
                                </div>
                                <div className="flex gap-1 mb-3">
                                    {creator.tags.map((tag) => (
                                        <Badge key={tag} variant="secondary" className="text-[10px] px-1.5 h-5 font-normal">
                                            {tag}
                                        </Badge>
                                    ))}
                                </div>
                                <div className="text-xs text-muted-foreground pt-3 border-t">
                                    <span className="block text-[10px] mb-0.5">대표 상품</span>
                                    <span className="font-medium text-foreground line-clamp-1">{creator.description}</span>
                                </div>
                            </div>
                        </Card>
                    ))}
                </div>
            </div>
        </section>
    );
};

export default CreatorGrid;
