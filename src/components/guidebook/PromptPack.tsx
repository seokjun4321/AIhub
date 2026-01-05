import { Button } from "@/components/ui/button";
import { Copy, Check, Tag } from "lucide-react";
import { useState } from "react";
import { useToast } from "@/hooks/use-toast";

export interface PromptItem {
    id: string;
    title: string;
    description?: string; // Used for "When to use"
    prompt: string;
    tags?: string[];
    relatedStep?: number[];
    failurePatterns?: string; // New field for "Failure Patterns & Fixes"
}

interface PromptPackProps {
    prompts: PromptItem[];
    onStepClick?: (stepNumber: number) => void;
}

export function PromptPack({ prompts, onStepClick }: PromptPackProps) {
    const { toast } = useToast();
    const [copiedId, setCopiedId] = useState<string | null>(null);

    const handleCopy = (id: string, text: string) => {
        navigator.clipboard.writeText(text);
        setCopiedId(id);
        toast({
            description: "프롬프트가 복사되었습니다.",
            duration: 2000,
        });
        setTimeout(() => setCopiedId(null), 2000);
    };

    if (!prompts || prompts.length === 0) {
        return (
            <div className="text-center py-16 bg-slate-50 rounded-3xl border border-slate-100 border-dashed">
                <p className="text-slate-400 font-medium">등록된 프롬프트 팩이 없습니다.</p>
            </div>
        );
    }

    return (
        <div className="grid grid-cols-1 gap-8">
            {prompts.map((item) => (
                <div key={item.id} className="bg-white p-8 rounded-3xl border border-slate-200 shadow-sm hover:shadow-md transition-all group flex flex-col">
                    <div className="flex flex-col md:flex-row justify-between items-start gap-6 mb-6">
                        <div className="space-y-4 flex-1">
                            {/* Header & Tags */}
                            <div className="space-y-2">
                                <div className="flex flex-wrap items-center gap-2">
                                    <span className="inline-flex items-center justify-center w-8 h-8 rounded-full bg-slate-100 text-slate-600 font-bold text-sm">
                                        #{item.id?.replace('prompt-', '') || 'N/A'}
                                    </span>
                                    {item.tags?.map((tag, idx) => (
                                        <span key={idx} className="inline-flex items-center px-2.5 py-1 rounded-md bg-emerald-50 text-emerald-700 text-xs font-semibold">
                                            {tag}
                                        </span>
                                    ))}
                                </div>
                                <h4 className="text-xl font-bold text-slate-900">{item.title}</h4>
                            </div>

                            {/* When to use (Description) */}
                            {item.description && (
                                <div className="text-slate-600 leading-relaxed text-sm bg-slate-50 p-4 rounded-xl border border-slate-100">
                                    <strong className="block text-slate-800 mb-2 font-semibold">💡 언제 쓰나요?</strong>
                                    <div className="whitespace-pre-line pl-1">{item.description}</div>
                                </div>
                            )}
                        </div>

                        {/* Copy Button */}
                        <Button
                            variant="outline"
                            className="flex-shrink-0 gap-2 text-slate-600 hover:text-emerald-600 hover:border-emerald-200 hover:bg-emerald-50 h-10"
                            onClick={() => handleCopy(item.id, item.prompt)}
                        >
                            {copiedId === item.id ? (
                                <>
                                    <Check className="w-4 h-4" />
                                    <span className="text-xs font-medium">복사됨</span>
                                </>
                            ) : (
                                <>
                                    <Copy className="w-4 h-4" />
                                    <span className="text-xs font-medium">복사하기</span>
                                </>
                            )}
                        </Button>
                    </div>

                    {/* Prompt Box */}
                    <div className="relative mb-6">
                        <div className="absolute top-3 right-3 px-2 py-0.5 rounded bg-white/80 backdrop-blur border border-slate-100 text-[10px] font-mono text-slate-400 pointer-events-none uppercase tracking-wider">
                            Prompt
                        </div>
                        <div className="bg-slate-900 text-slate-50 p-6 rounded-2xl border border-slate-800 text-sm font-mono leading-relaxed whitespace-pre-wrap shadow-inner selection:bg-emerald-500/30">
                            {item.prompt}
                        </div>
                    </div>

                    {/* Failure Patterns */}
                    {item.failurePatterns && (
                        <div className="text-sm bg-red-50/50 p-5 rounded-2xl border border-red-100 mb-6">
                            <strong className="block text-red-800 mb-3 font-semibold flex items-center gap-2">
                                🚫 실패 패턴 & ✅ 수정 가이드
                            </strong>
                            <div className="whitespace-pre-line text-slate-700 leading-relaxed pl-1">
                                {item.failurePatterns}
                            </div>
                        </div>
                    )}

                    {/* Related Steps (Moved to Bottom) */}
                    {item.relatedStep && item.relatedStep.length > 0 && (
                        <div className="mt-auto pt-6 border-t border-slate-100 flex items-center gap-3">
                            <span className="text-sm font-semibold text-slate-500">관련 Step:</span>
                            <div className="flex flex-wrap gap-2">
                                {item.relatedStep.map(step => (
                                    <button
                                        key={step}
                                        onClick={() => onStepClick?.(step)}
                                        className="h-8 pl-3 pr-4 rounded-full bg-slate-100 hover:bg-emerald-100 text-slate-600 hover:text-emerald-700 text-xs font-bold transition-colors flex items-center gap-1.5 group/btn"
                                    >
                                        <span className="w-5 h-5 rounded-full bg-white flex items-center justify-center text-[10px] group-hover/btn:bg-white/80">
                                            {step}
                                        </span>
                                        이동
                                    </button>
                                ))}
                            </div>
                        </div>
                    )}
                </div>
            ))}
        </div>
    );
}
