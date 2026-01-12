import { CATEGORIES } from "@/data/mockData";
import { cn } from "@/lib/utils";

interface CategorySelectorProps {
    selectedCategory: string | null;
    onSelectCategory: (id: string) => void;
}

const CategorySelector = ({ selectedCategory, onSelectCategory }: CategorySelectorProps) => {
    return (
        <section id="category-section" className="py-16 w-full bg-secondary/30">
            <div className="max-w-5xl mx-auto px-4">
                <div className="text-center mb-10">
                    <h2 className="text-2xl font-bold mb-2">카테고리</h2>
                    <p className="text-muted-foreground">원하는 AI 템플릿을 찾아보세요</p>
                </div>

                <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4">
                    {CATEGORIES.map((category) => {
                        const isSelected = selectedCategory === category.id;
                        return (
                            <button
                                key={category.id}
                                onClick={() => onSelectCategory(isSelected ? "" : category.id)}
                                className={cn(
                                    "flex flex-col items-center justify-center p-6 rounded-xl border transition-all duration-200 h-full w-full",
                                    "bg-card hover:shadow-md hover:border-primary/50",
                                    isSelected
                                        ? "bg-primary/10 border-primary text-primary"
                                        : "border-border text-foreground hover:text-foreground"
                                )}
                            >
                                <category.icon
                                    className={cn(
                                        "w-8 h-8 mb-3 transition-colors",
                                        isSelected ? "text-primary" : "text-muted-foreground group-hover:text-primary"
                                    )}
                                />
                                <span className={cn(
                                    "text-sm font-medium text-center leading-tight",
                                    isSelected ? "text-primary" : "text-foreground"
                                )}>
                                    {category.name}
                                </span>
                            </button>
                        );
                    })}
                </div>
            </div>
        </section>
    );
};

export default CategorySelector;
