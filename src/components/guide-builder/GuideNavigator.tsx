import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";
import { GuideBlock } from "./GuideBuilderLayout";
import { ArrowUp, Hash } from "lucide-react";

interface GuideNavigatorProps {
    blocks: GuideBlock[];
}

export function GuideNavigator({ blocks }: GuideNavigatorProps) {
    const steps = blocks.filter(b => b.type === 'step');

    const scrollToBlock = (id: string) => {
        const element = document.getElementById(`block-${id}`); // We assume blocks will have IDs
        // Actually, our BuilderBlock uses `id` directly. Let's fix that assumption later or ensure blocks have DOM IDs.
        // For dnd-kit sortables, we might not have set explicit IDs on the DOM elements easily accessible for scrolling unless we did it in BuilderBlock.
        // Let's modify BuilderBlock to ensure it has an ID we can target if it doesn't already.
        // Wait, dnd-kit usually handles refs.
        // Let's assume we can target them by some attribute or we add an ID to the wrapper.

        // Strategy: Modify BuilderBlock to accept an `id` prop for the DOM element, 
        // OR rely on the fact that we can just find the element by some data attribute.
        // Let's try to find by data-id attribute which dnd-kit might use, or just custom id.

        // Actually, let's just use the block.id.
        const el = document.getElementById(id) || document.getElementById(`block-${id}`);
        if (el) {
            el.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
    };

    const scrollToTop = () => {
        const container = document.querySelector('.overflow-y-auto'); // Target the scrollable container
        if (container) {
            container.scrollTo({ top: 0, behavior: 'smooth' });
        }
    };

    if (steps.length === 0) return null;

    return (
        <div className="fixed right-8 top-24 flex flex-col gap-2 z-40 bg-white/90 backdrop-blur border border-slate-200 p-2 rounded-xl shadow-lg border-opacity-60 transition-all hover:bg-white">
            <div className="text-xs font-bold text-slate-400 px-2 py-1 uppercase tracking-wider mb-1 flex items-center justify-between">
                <span>Navigator</span>
                <span className="bg-slate-100 text-slate-500 px-1.5 rounded-full text-[10px]">{steps.length}</span>
            </div>

            <div className="max-h-[300px] overflow-y-auto space-y-1 custom-scrollbar pr-1">
                {steps.map((step, index) => (
                    <button
                        key={step.id}
                        onClick={() => scrollToBlock(step.id)}
                        className="w-full text-left px-3 py-2 rounded-lg hover:bg-emerald-50 text-slate-600 hover:text-emerald-700 text-sm transition-colors flex items-center gap-2 group truncate max-w-[200px]"
                        title={step.content?.title || `Step ${index + 1}`}
                    >
                        <span className="w-5 h-5 flex items-center justify-center bg-slate-100 group-hover:bg-emerald-100 rounded text-xs font-bold text-slate-500 group-hover:text-emerald-600 transition-colors flex-shrink-0">
                            {index + 1}
                        </span>
                        <span className="truncate flex-1">
                            {step.content?.title || `Step ${index + 1}`}
                        </span>
                    </button>
                ))}
            </div>

            <div className="h-px bg-slate-100 my-1" />

            <Button
                variant="ghost"
                size="sm"
                onClick={scrollToTop}
                className="text-xs text-slate-400 hover:text-slate-700"
            >
                <ArrowUp className="w-3 h-3 mr-1" />
                Top
            </Button>
        </div>
    );
}
