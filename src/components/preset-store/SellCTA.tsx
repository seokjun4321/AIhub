import { Button } from "@/components/ui/button";
import { Upload } from "lucide-react";

const SellCTA = () => {
    return (
        <section className="py-20">
            <div className="container mx-auto px-6">
                <div className="bg-background border rounded-2xl p-12 text-center max-w-4xl mx-auto shadow-sm">
                    <h2 className="text-2xl font-bold mb-4">당신도 템플릿을 판매해보세요</h2>
                    <p className="text-muted-foreground mb-8">
                        직접 만든 프롬프트, 워크플로우, Gem을 다른 창작자들과 공유하고 수익을 창출하세요
                    </p>

                    <div className="flex justify-center gap-3">
                        <Button className="bg-gray-800 hover:bg-gray-900 text-white gap-2">
                            <Upload className="w-4 h-4" />
                            템플릿 업로드하기
                        </Button>
                        <Button variant="outline">
                            판매 가이드 보기
                        </Button>
                    </div>

                    <p className="text-xs text-muted-foreground mt-6">
                        AIHub는 판매 수익의 20%를 플랫폼 운영비로 사용합니다
                    </p>
                </div>
            </div>
        </section>
    );
};

export default SellCTA;
