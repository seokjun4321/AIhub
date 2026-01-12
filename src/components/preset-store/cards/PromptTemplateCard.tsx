import { PromptTemplate } from "@/data/mockData";
import { Copy, Check } from "lucide-react";
import { useState } from "react";
// Assuming toast is available via existing hook or we use simple alert for now if toast not found easily.
// Plan said "Use existing src/components/ui/sonner.tsx or toaster.tsx".
// I'll check imports later, for now I'll use a placeholder or basic copy logic.
import { cn } from "@/lib/utils";
import { Button } from "@/components/ui/button";
// import { useToast } from "@/components/ui/use-toast"; // Uncomment if available

interface PromptTemplateCardProps {
    item: PromptTemplate;
}

const PromptTemplateCard = ({ item }: PromptTemplateCardProps) => {
    const [copied, setCopied] = useState(false);
    // const { toast } = useToast();

    const handleCopy = (e: React.MouseEvent) => {
        e.stopPropagation();
        navigator.clipboard.writeText(item.title + " - " + item.description); // Mock copy content
        setCopied(true);

        // toast({
        //   title: "프롬프트가 복사되었습니다",
        //   duration: 3000,
        // });

        setTimeout(() => setCopied(false), 2000);
    };

    const getBadgeColor = (color: string) => {
        switch (color) {
            case "green": return "bg-emerald-100 text-emerald-700";
            case "yellow": return "bg-amber-100 text-amber-700";
            case "red": return "bg-rose-100 text-rose-700";
            case "blue": return "bg-blue-100 text-blue-700";
            default: return "bg-slate-100 text-slate-700";
        }
    };

    return (
        <div className="group bg-card rounded-xl border border-border shadow-sm hover:shadow-lg transition-all duration-200 p-5 flex flex-col h-full cursor-pointer relative">
            <div className="flex justify-between items-start mb-4">
                <div className="flex gap-2">
                    {item.badges.map((badge, idx) => (
                        <span key={idx} className={cn("text-xs px-2 py-1 rounded-full font-medium", getBadgeColor(badge.color))}>
                            {badge.text}
                        </span>
                    ))}
                </div>
                <Button
                    size="icon"
                    variant="ghost"
                    className="h-8 w-8 -mr-2 -mt-2 text-muted-foreground hover:text-foreground"
                    onClick={handleCopy}
                    title="프롬프트 복사"
                >
                    {copied ? <Check className="w-4 h-4 text-green-600" /> : <Copy className="w-4 h-4" />}
                </Button>
            </div>

            <h3 className="font-bold text-lg leading-tight mb-2 group-hover:text-primary transition-colors">
                {item.title}
            </h3>
            <p className="text-sm text-muted-foreground line-clamp-3 mb-4 flex-1">
                {item.description}
            </p>

            <div className="flex flex-wrap gap-2 mb-4">
                {item.tags.slice(0, 3).map((tag, idx) => (
                    <span key={idx} className="text-xs px-2 py-1 rounded-full bg-secondary text-secondary-foreground">
                        {tag}
                    </span>
                ))}
            </div>

            <div className="flex items-center justify-between pt-3 border-t border-border/50 mt-auto">
                <span className="text-xs text-muted-foreground">{item.author}</span>
                <span className="text-xs text-muted-foreground">{item.date}</span>
            </div>
        </div>
    );
};

export default PromptTemplateCard;
