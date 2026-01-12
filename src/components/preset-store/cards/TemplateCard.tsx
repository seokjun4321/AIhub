import { TemplateItem } from "@/data/mockData";
import { cn } from "@/lib/utils";

interface TemplateCardProps {
    item: TemplateItem;
}

const TemplateCard = ({ item }: TemplateCardProps) => {
    return (
        <div className="group bg-card rounded-xl border border-border shadow-sm hover:shadow-lg transition-all duration-200 overflow-hidden cursor-pointer flex flex-col h-full">
            <div className="aspect-[4/3] bg-muted relative overflow-hidden">
                <img
                    src={item.imageUrl}
                    alt={item.title}
                    className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105"
                />
                <div className="absolute top-0 left-0 w-full h-full bg-black/5 opacity-0 group-hover:opacity-10 transition-opacity" />
            </div>

            <div className="p-4 flex flex-col flex-1">
                <div className="flex justify-between items-start mb-2">
                    <h3 className="font-semibold text-base leading-tight flex-1 mr-2 group-hover:text-primary transition-colors line-clamp-1">
                        {item.title}
                    </h3>
                </div>

                <div className="flex items-center justify-between mb-2">
                    <span className="text-xs text-muted-foreground">{item.category}</span>
                    <span className={cn(
                        "text-xs px-2 py-0.5 rounded-full font-semibold",
                        item.price === 0 ? "bg-emerald-100 text-emerald-700" : "bg-primary text-primary-foreground"
                    )}>
                        {item.price === 0 ? "무료" : `₩${item.price.toLocaleString()}`}
                    </span>
                </div>

                <div className="flex flex-wrap gap-2 mb-3">
                    {item.includes.map((inc, idx) => (
                        <span key={idx} className="text-[11px] px-1.5 py-0.5 bg-muted text-muted-foreground rounded hover:bg-muted/80">
                            {inc}
                        </span>
                    ))}
                </div>

                <div className="mt-auto pt-2 border-t border-border/50">
                    <span className="text-xs text-muted-foreground">{item.author}</span>
                </div>
            </div>
        </div>
    );
};

export default TemplateCard;
