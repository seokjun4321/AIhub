import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Search } from "lucide-react";

const PresetHero = () => {
    return (
        <section className="pt-32 pb-20 text-center bg-background">
            <div className="container mx-auto px-6">
                <h1 className="text-4xl font-bold mb-4">필요한 AI 템플릿을 한 곳에서</h1>
                <p className="text-muted-foreground mb-8">
                    프롬프트, 자동화, 워크플로우, Gem까지 모두 판매·구매할 수 있어요.
                </p>

                <div className="max-w-2xl mx-auto relative mb-8">
                    <div className="relative">
                        <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground w-5 h-5" />
                        <Input
                            type="text"
                            placeholder="예: 스타트업 사업계획서 GPT"
                            className="w-full h-12 pl-12 pr-4 rounded-lg border-border/50 shadow-sm focus-visible:ring-primary/20"
                        />
                    </div>
                </div>

                <div className="flex justify-center gap-3">
                    <Button className="bg-primary hover:bg-primary/90 text-primary-foreground px-6">
                        카테고리 탐색
                    </Button>
                    <Button variant="outline" className="px-6">
                        내 템플릿 판매하기
                    </Button>
                </div>
            </div>
        </section>
    );
};

export default PresetHero;
