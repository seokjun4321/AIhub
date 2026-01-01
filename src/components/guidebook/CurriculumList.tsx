
import {
    Accordion,
    AccordionContent,
    AccordionItem,
    AccordionTrigger,
} from "@/components/ui/accordion";
import { Checkbox } from "@/components/ui/checkbox";
import { PlayCircle, FileText, CheckCircle2 } from "lucide-react";


export interface Step {
    id: string | number;
    title: string;
    duration?: string;
    completed?: boolean;
}

export interface CurriculumListProps {
    steps: Step[];
}

export function CurriculumList({ steps }: CurriculumListProps) {
    // If no steps provided, show empty state or default
    if (!steps || steps.length === 0) {
        return (
            <div className="bg-white rounded-2xl border border-slate-100 p-8 text-center text-slate-500">
                등록된 강의 내용이 없습니다.
            </div>
        );
    }

    return (
        <div className="bg-white rounded-2xl border border-slate-100 shadow-sm overflow-hidden">
            <div className="p-6 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
                <div>
                    <h2 className="text-xl font-bold text-slate-900">상세 커리큘럼</h2>
                    <p className="text-sm text-slate-500 mt-1">총 {steps.length}개 강의</p>
                </div>
            </div>

            {/* For now, treating the whole guide as one chapter if mapping is flat */}
            <Accordion type="single" collapsible defaultValue="chapter-1" className="w-full">
                <AccordionItem value="chapter-1" className="border-b last:border-0 border-none">
                    <AccordionTrigger className="px-6 py-4 hover:bg-slate-50 transition-colors">
                        <div className="flex items-center gap-4 text-left">
                            <div className="flex items-center justify-center w-8 h-8 rounded-full bg-slate-100 text-slate-500 text-sm font-bold">
                                1
                            </div>
                            <div>
                                <h3 className="text-base font-semibold text-slate-900">가이드 시작하기</h3>
                                <span className="text-xs text-slate-500 font-normal mt-0.5 block">
                                    {steps.length} 강의
                                </span>
                            </div>
                        </div>
                    </AccordionTrigger>
                    <AccordionContent className="bg-slate-50/30">
                        <div className="flex flex-col">
                            {steps.map((step, index) => (
                                <div
                                    key={step.id}
                                    className="flex items-center justify-between px-6 py-3 hover:bg-slate-50 transition-colors border-t border-slate-100 first:border-0 pl-16 cursor-pointer"
                                    onClick={() => {
                                        const el = document.getElementById(`step-${step.id}`);
                                        if (el) el.scrollIntoView({ behavior: 'smooth' });
                                    }}
                                >
                                    <div className="flex items-center gap-3">
                                        <PlayCircle className="w-4 h-4 text-slate-400" />
                                        <span className="text-sm text-slate-700">{step.title}</span>
                                    </div>
                                    <div className="flex items-center gap-4">
                                        {step.duration && <span className="text-xs text-slate-400">{step.duration}</span>}
                                        <Checkbox id={`check-${step.id}`} className="data-[state=checked]:bg-green-500 data-[state=checked]:border-green-500" />
                                    </div>
                                </div>
                            ))}
                        </div>
                    </AccordionContent>
                </AccordionItem>
            </Accordion>
        </div>
    );
}
