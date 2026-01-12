import { DesignItem } from "@/data/mockData";
import { useState } from "react";
// import { cn } from "@/lib/utils";

interface DesignCardProps {
    item: DesignItem;
}

const DesignCard = ({ item }: DesignCardProps) => {
    const [isHovered, setIsHovered] = useState(false);

    return (
        <div
            className="group bg-card rounded-xl border border-border shadow-sm hover:shadow-lg transition-all duration-200 overflow-hidden cursor-pointer flex flex-col h-full"
            onMouseEnter={() => setIsHovered(true)}
            onMouseLeave={() => setIsHovered(false)}
        >
            <div className="aspect-square bg-muted relative overflow-hidden">
                {/* Before Image (Always visible, behind) */}
                <img
                    src={item.beforeImage}
                    alt="Before"
                    className="w-full h-full object-cover absolute top-0 left-0"
                />

                {/* After Image (Visible on hover with transition) */}
                <img
                    src={item.afterImage}
                    alt="After"
                    className={`w-full h-full object-cover absolute top-0 left-0 transition-opacity duration-300 ease-in-out ${isHovered ? "opacity-100" : "opacity-0"}`}
                />

                <div className="absolute top-2 left-2 bg-black/60 backdrop-blur-sm text-white px-2 py-0.5 rounded text-[10px] font-medium z-10 pointer-events-none">
                    {isHovered ? "After" : "Before"}
                </div>
            </div>

            <div className="p-3">
                <h3 className="font-medium text-sm mb-2 truncate group-hover:text-primary transition-colors">
                    {item.title}
                </h3>
                <div className="flex flex-wrap gap-1">
                    {item.tags.slice(0, 2).map((tag, idx) => (
                        <span key={idx} className="text-[10px] px-1.5 py-0.5 rounded-full bg-secondary text-secondary-foreground">
                            {tag}
                        </span>
                    ))}
                </div>
            </div>
        </div>
    );
};

export default DesignCard;
