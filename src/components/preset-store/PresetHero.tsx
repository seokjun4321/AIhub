import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Search } from "lucide-react";
import { Link } from "react-router-dom";

interface PresetHeroProps {
    searchQuery: string;
    onSearchChange: (value: string) => void;
}

const PresetHero = ({ searchQuery, onSearchChange }: PresetHeroProps) => {
    const scrollToCategories = () => {
        const categorySection = document.getElementById('category-section');
        if (categorySection) {
            categorySection.scrollIntoView({ behavior: 'smooth' });
        }
    };

    return (
        <section className="pt-32 pb-12 px-4 text-center w-full max-w-4xl mx-auto">
            <h1 className="text-[36px] md:text-[48px] font-bold text-foreground mb-4">
                필요한 AI 템플릿을 한 곳에서
            </h1>
            <p className="text-[18px] text-muted-foreground mb-8">
                프롬프트, 자동화, 워크플로우, Gem까지 모두 판매·구매할 수 있어요.
            </p>

            <div className="w-full mx-auto relative mb-6">
                <div className="relative">
                    <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-muted-foreground w-5 h-5" />
                    <Input
                        type="text"
                        placeholder="예: 스타트업 사업계획서 GPT"
                        className="w-full h-14 pl-12 pr-4 rounded-full border-border bg-card text-base shadow-sm focus-visible:ring-1 focus-visible:ring-primary focus-visible:border-primary transition-all"
                        value={searchQuery}
                        onChange={(e) => onSearchChange(e.target.value)}
                    />
                </div>
            </div>

            <div className="flex justify-center gap-3">
                <Button
                    size="lg"
                    className="rounded-full px-8 bg-primary hover:bg-primary/90 text-primary-foreground"
                    onClick={scrollToCategories}
                >
                    카테고리 탐색
                </Button>
                <Link to="/sell-preset">
                    <Button
                        size="lg"
                        variant="outline"
                        className="rounded-full px-8 border-border text-foreground hover:bg-accent hover:text-accent-foreground"
                    >
                        내 템플릿 판매하기
                    </Button>
                </Link>
            </div>
        </section>
    );
};

export default PresetHero;
