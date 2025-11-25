import { Card } from "@/components/ui/card";
import { FileText, Sparkles, Workflow, Table, Image, User } from "lucide-react";

const categories = [
    { icon: FileText, name: "프롬프트 템플릿" },
    { icon: Sparkles, name: "Gem / GPT / Artifact" },
    { icon: Workflow, name: "자동화 워크플로우" },
    { icon: Table, name: "Notion / Sheets 템플릿" },
    { icon: Image, name: "AI 생성 디자인" },
    { icon: User, name: "크리에이터 서비스" },
];

const PresetCategories = () => {
    return (
        <section className="py-12">
            <div className="container mx-auto px-6">
                <div className="text-center mb-8">
                    <h2 className="text-xl font-bold mb-1">카테고리</h2>
                    <p className="text-sm text-muted-foreground">원하는 AI 리소스를 찾아보세요</p>
                </div>

                <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4">
                    {categories.map((category, index) => (
                        <Card key={index} className="p-6 flex flex-col items-center justify-center gap-3 hover:shadow-md transition-all cursor-pointer hover:border-primary/30 group">
                            <category.icon className="w-6 h-6 text-muted-foreground group-hover:text-primary transition-colors" />
                            <span className="text-xs font-medium text-center">{category.name}</span>
                        </Card>
                    ))}
                </div>
            </div>
        </section>
    );
};

export default PresetCategories;
