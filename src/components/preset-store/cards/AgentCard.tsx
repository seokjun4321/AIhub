import { AgentItem } from "@/data/mockData";
import { ExternalLink } from "lucide-react";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

interface AgentCardProps {
    item: AgentItem;
}

const AgentCard = ({ item }: AgentCardProps) => {
    const getPlatformStyle = (platform: string) => {
        switch (platform) {
            case "GPT": return "bg-emerald-100 text-emerald-700";
            case "Claude": return "bg-orange-100 text-orange-700";
            case "Gemini": return "bg-blue-100 text-blue-700";
            case "Perplexity": return "bg-purple-100 text-purple-700";
            default: return "bg-slate-100 text-slate-700";
        }
    };

    return (
        <div className="group bg-card rounded-xl border border-border shadow-sm hover:shadow-lg transition-all duration-200 p-5 flex flex-col h-full cursor-pointer">
            <div className="flex justify-between items-start mb-3">
                <span className={cn("text-xs px-3 py-1 rounded-full font-medium", getPlatformStyle(item.platform))}>
                    {item.platform}
                </span>
            </div>

            <h3 className="font-bold text-lg mb-2 group-hover:text-primary transition-colors">{item.title}</h3>
            <p className="text-sm text-muted-foreground line-clamp-3 mb-4 flex-1">
                {item.description}
            </p>

            {item.exampleQuestions.length > 0 && (
                <div className="mb-5 bg-muted/30 p-3 rounded-lg">
                    <p className="text-xs font-medium text-muted-foreground mb-2">예시 질문</p>
                    <ul className="space-y-2">
                        {item.exampleQuestions.slice(0, 3).map((q, idx) => (
                            <li key={idx} className="flex items-start text-[13px] text-foreground/80 leading-snug">
                                <span className="mr-2 opacity-50">•</span>
                                {q}
                            </li>
                        ))}
                    </ul>
                </div>
            )}

            <Button
                className="w-full mt-auto"
                onClick={(e) => {
                    e.stopPropagation();
                    window.open(item.url, '_blank');
                }}
            >
                열기 <ExternalLink className="w-4 h-4 ml-2" />
            </Button>
        </div>
    );
};

export default AgentCard;
