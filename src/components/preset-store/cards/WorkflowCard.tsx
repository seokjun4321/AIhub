import { WorkflowItem } from "@/data/mockData";
import { Clock, Layers, ArrowRight } from "lucide-react";
import { cn } from "@/lib/utils";

interface WorkflowCardProps {
    item: WorkflowItem;
}

const WorkflowCard = ({ item }: WorkflowCardProps) => {
    const getComplexityColor = (complexity: string) => {
        switch (complexity) {
            case "Simple": return "bg-emerald-100 text-emerald-700";
            case "Medium": return "bg-amber-100 text-amber-700";
            case "Complex": return "bg-rose-100 text-rose-700";
            default: return "bg-slate-100 text-slate-700";
        }
    };

    return (
        <div className="group bg-card rounded-xl border border-border shadow-sm hover:shadow-lg hover:-translate-y-0.5 transition-all duration-200 overflow-hidden cursor-pointer flex flex-col h-full">
            <div className="aspect-video bg-muted relative flex items-center justify-center">
                {/* Placeholder for flowchart preview */}
                <div className="text-muted-foreground opacity-50">Flowchart Preview</div>
            </div>

            <div className="flex gap-2 p-3 bg-muted/30 border-b border-border/50 text-xs">
                <span className={cn("px-2 py-1 rounded flex items-center gap-1 font-medium", getComplexityColor(item.complexity))}>
                    <Layers className="w-3 h-3" /> {item.complexity}
                </span>
                <span className="px-2 py-1 rounded flex items-center gap-1 bg-background border border-border/50 text-muted-foreground">
                    <Clock className="w-3 h-3" /> {item.duration}
                </span>
            </div>

            <div className="p-4 flex flex-col flex-1">
                <h3 className="font-semibold text-base mb-1 group-hover:text-primary transition-colors">{item.title}</h3>
                <p className="text-sm text-muted-foreground line-clamp-2 mb-3">
                    {item.description}
                </p>

                <div className="flex flex-wrap gap-2 mb-3 mt-auto">
                    {item.apps.map((app, idx) => (
                        <span key={idx} className="text-[11px] px-2 py-1 rounded bg-secondary text-secondary-foreground font-medium">
                            {app.name}
                        </span>
                    ))}
                </div>

                <div className="flex items-center justify-between pt-3 border-t border-border/50">
                    <span className="text-xs text-muted-foreground">{item.author}</span>
                    <div className="text-xs font-medium text-primary flex items-center group-hover:underline">
                        자세히 보기 <ArrowRight className="w-3 h-3 ml-1" />
                    </div>
                </div>
            </div>
        </div>
    );
};

export default WorkflowCard;
