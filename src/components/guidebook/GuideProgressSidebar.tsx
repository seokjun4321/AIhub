import { Progress } from "@/components/ui/progress";
import { HighlightBold } from "@/components/ui/highlight-bold";
import { CheckCircle2, Circle, PlayCircle } from "lucide-react";
import { cn } from "@/lib/utils";

export interface NavigationStep {
    id: string | number;
    title: string;
}

interface GuideProgressSidebarProps {
    steps: NavigationStep[];
    activeStepId: string | number | null;
    completedStepIds?: (string | number)[];
    onStepClick: (id: string | number) => void;
}

export function GuideProgressSidebar({
    steps,
    activeStepId,
    completedStepIds = [],
    onStepClick
}: GuideProgressSidebarProps) {

    // Calculate progress
    const totalSteps = steps.length;
    // If we have distinct "completed" logic, use that. 
    // For now, let's assume if you've scrolled past it or it's in the list, it's "done" or "in progress".
    // A simple heuristic: index of active step + 1 if sequential?
    // Let's stick to simple "completedStepIds" length for now.
    const completedCount = completedStepIds.length;
    const progressPercentage = totalSteps > 0 ? Math.round((completedCount / totalSteps) * 100) : 0;

    return (
        <div className="sticky top-24 bg-white p-6 rounded-2xl border border-slate-100 shadow-sm transition-all">
            <div className="mb-6">
                <div className="flex justify-between items-end mb-2">
                    <h3 className="font-bold text-slate-900">학습 진도율</h3>
                    <span className="text-xl font-bold text-green-600">{progressPercentage}%</span>
                </div>
                <Progress value={progressPercentage} className="h-2 bg-slate-100" indicatorClassName="bg-green-500" />
                <p className="text-xs text-slate-400 mt-2 text-right">
                    {completedCount} / {totalSteps} 단계 완료
                </p>
            </div>

            <div className="space-y-1">
                <h4 className="text-xs font-bold text-slate-400 uppercase tracking-wider mb-3">목차</h4>
                <nav className="flex flex-col space-y-1">
                    {steps.map((step, index) => {
                        const isActive = activeStepId === step.id;
                        const isCompleted = completedStepIds.includes(step.id);

                        return (
                            <button
                                key={step.id}
                                onClick={() => onStepClick(step.id)}
                                className={cn(
                                    "flex items-start gap-3 w-full text-left p-2 rounded-lg transition-all text-sm group",
                                    isActive
                                        ? "bg-green-50 text-green-700 font-medium"
                                        : "text-slate-600 hover:bg-slate-50"
                                )}
                            >
                                <div className={cn(
                                    "mt-0.5 shrink-0 w-5 h-5 flex items-center justify-center rounded-full text-[10px] font-bold border transition-colors",
                                    isActive ? "border-green-600 bg-green-600 text-white" :
                                        isCompleted ? "border-green-500 bg-green-100 text-green-700" :
                                            "border-slate-200 bg-white text-slate-400 group-hover:border-slate-300 group-hover:text-slate-500"
                                )}>
                                    {isActive && <PlayCircle className="w-3 h-3 text-white absolute" style={{ opacity: 0 }} />}
                                    {/* Using simple numbers now as requested */}
                                    {String(index + 1).padStart(2, '0')}
                                </div>
                                <span className={cn(
                                    "line-clamp-2",
                                    isCompleted && !isActive && "text-slate-400"
                                )}>
                                    <HighlightBold text={step.title.replace(/^Step\s+\d+[\.\:]?\s*/i, '').replace(/^\d+[\.\)]\s*/, '')} />
                                </span>
                            </button>
                        );
                    })}
                </nav>
            </div>
        </div>
    );
}
