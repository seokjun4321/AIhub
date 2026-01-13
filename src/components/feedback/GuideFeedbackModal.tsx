import { useEffect, useState, Fragment } from 'react';
import { Dialog, Transition } from '@headlessui/react';
import { X, Send, Loader2, AlertCircle, ChevronDown, ChevronUp, CheckCircle2 } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Textarea } from '@/components/ui/textarea';
import { cn } from '@/lib/utils';
import { useToast } from '@/hooks/use-toast';
import { supabase } from '@/integrations/supabase/client';

interface StepSummary {
    id: number;
    step_order: number;
    title: string;
}

interface GuideFeedbackModalProps {
    isOpen: boolean;
    onClose: () => void;
    guideId: string | number;
    guideTitle: string;
    steps?: StepSummary[];
}

export const GuideFeedbackModal = ({ isOpen, onClose, guideId, guideTitle, steps = [] }: GuideFeedbackModalProps) => {
    const [shouldShow, setShouldShow] = useState(false);

    // State for Accordion Logic
    const [expandedStepId, setExpandedStepId] = useState<number | null>(null);
    const [feedbackMap, setFeedbackMap] = useState<Record<number, string>>({}); // stepId -> reasonId

    const [message, setMessage] = useState('');
    const [isSubmitting, setIsSubmitting] = useState(false);
    const { toast } = useToast();

    const reasons = [
        { id: 'prompt_error', label: '🤖 프롬프트 결과 이상' },
        { id: 'tool_diff', label: '🛠️ 툴 사용법 다름' },
        { id: 'content_confusing', label: '📚 설명 이해 안됨' },
        { id: 'other', label: '💬 기타' },
    ];

    // Reset state when opening
    useEffect(() => {
        if (isOpen) {
            setShouldShow(true);
            setExpandedStepId(null);
            setFeedbackMap({});
            setMessage('');
        } else {
            setShouldShow(false);
        }
    }, [isOpen]);

    const handleClose = () => {
        setShouldShow(false);
        onClose();
    };

    const toggleStep = (id: number) => {
        setExpandedStepId(prev => (prev === id ? null : id));
    };

    const selectReason = (stepId: number, reasonId: string) => {
        setFeedbackMap(prev => {
            const newMap = { ...prev };
            // Toggle off if clicking same reason
            if (newMap[stepId] === reasonId) {
                delete newMap[stepId];
            } else {
                newMap[stepId] = reasonId;
            }
            return newMap;
        });
        // Auto-collapse after selection for better flow? 
        // Maybe better to stay open to let them confirm. Let's keep it open.
        // Or collapse to show "Done" state? Let's collapse.
        setExpandedStepId(null);
    };

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();

        const feedbackEntries = Object.entries(feedbackMap).map(([stepId, reason]) => ({
            stepId: Number(stepId),
            reason
        }));

        if (steps.length > 0 && feedbackEntries.length === 0) {
            toast({ title: "문제가 있는 단계를 선택하고 원인을 알려주세요", variant: "destructive" });
            return;
        }

        setIsSubmitting(true);

        try {
            const { data: { user } } = await supabase.auth.getUser();

            const insertPromises = feedbackEntries.map(({ stepId, reason }) => {
                return supabase.from('feedbacks').insert({
                    trigger: 'guidebook_complete',
                    entity_type: 'guidebook',
                    entity_id: String(guideId),
                    step_id: String(stepId),
                    category: reason,
                    message: message,
                    user_id: user?.id,
                    page_url: window.location.href,
                    metadata: {
                        userAgent: navigator.userAgent
                    }
                });
            });

            const results = await Promise.all(insertPromises);

            const errors = results.filter(r => r.error).map(r => r.error);
            if (errors.length > 0) {
                console.error("Feedback submission errors:", errors);
                throw new Error("Some feedback failed to send");
            }

            toast({
                title: "상세한 피드백 감사합니다!",
                description: "꼼꼼히 확인하고 수정하겠습니다.",
            });

            handleClose();

        } catch (error) {
            console.error("Feedback Error:", error);
            toast({
                title: "전송 실패",
                description: "잠시 후 다시 시도해주세요.",
                variant: "destructive"
            });
        } finally {
            setIsSubmitting(false);
        }
    };

    if (!shouldShow) return null;

    return (
        <Transition appear show={shouldShow} as={Fragment}>
            <Dialog as="div" className="relative z-50" onClose={handleClose}>
                <Transition.Child
                    as={Fragment}
                    enter="ease-out duration-300"
                    enterFrom="opacity-0"
                    enterTo="opacity-100"
                    leave="ease-in duration-200"
                    leaveFrom="opacity-100"
                    leaveTo="opacity-0"
                >
                    <div className="fixed inset-0 bg-black/25 backdrop-blur-sm" />
                </Transition.Child>

                <div className="fixed inset-0 overflow-y-auto">
                    <div className="flex min-h-full items-center justify-center p-4 text-center">
                        <Transition.Child
                            as={Fragment}
                            enter="ease-out duration-300"
                            enterFrom="opacity-0 scale-95 translate-y-4"
                            enterTo="opacity-100 scale-100 translate-y-0"
                            leave="ease-in duration-200"
                            leaveFrom="opacity-100 scale-100 translate-y-0"
                            leaveTo="opacity-0 scale-95 translate-y-4"
                        >
                            <Dialog.Panel className="w-full max-w-lg transform rounded-2xl bg-white p-6 text-left align-middle shadow-xl transition-all border border-slate-100 flex flex-col max-h-[85vh]">

                                {/* Header - Fixed */}
                                <div className="flex justify-between items-start mb-4 flex-shrink-0">
                                    <div className="pr-8">
                                        <Dialog.Title as="h3" className="text-lg font-bold text-slate-900 leading-snug flex items-center gap-2">
                                            <AlertCircle className="w-5 h-5 text-amber-500" />
                                            어디서 막히셨나요?
                                        </Dialog.Title>
                                        <p className="text-sm text-slate-500 mt-1">
                                            문제가 있는 단계들을 선택해 주세요.
                                        </p>
                                    </div>
                                    <button
                                        type="button"
                                        className="rounded-full p-1 hover:bg-slate-100 transition-colors -mr-2 -mt-2"
                                        onClick={handleClose}
                                    >
                                        <X className="w-5 h-5 text-slate-400" />
                                    </button>
                                </div>

                                <form onSubmit={handleSubmit} className="flex flex-col flex-1 min-h-0">

                                    {/* Scrollable Content Area */}
                                    <div className="flex-1 overflow-y-auto pr-1 custom-scrollbar space-y-6 pb-2">

                                        {/* 1. Accordion Step List */}
                                        {steps.length > 0 && (
                                            <div className="space-y-2">
                                                {steps.map((step) => {
                                                    const isExpanded = expandedStepId === step.id;
                                                    const selectedReasonId = feedbackMap[step.id];
                                                    const reasonLabel = reasons.find(r => r.id === selectedReasonId)?.label;

                                                    return (
                                                        <div key={step.id} className={cn(
                                                            "border rounded-xl transition-all overflow-hidden",
                                                            isExpanded ? "border-slate-300 shadow-sm bg-slate-50/50" :
                                                                selectedReasonId ? "border-slate-900 bg-slate-50" : "border-slate-100 hover:border-slate-200 bg-white"
                                                        )}>
                                                            {/* Step Header (Clickable) */}
                                                            <button
                                                                type="button"
                                                                onClick={() => toggleStep(step.id)}
                                                                className="w-full flex items-center justify-between p-3 text-left"
                                                            >
                                                                <div className="flex items-center gap-3 overflow-hidden">
                                                                    <span className={cn(
                                                                        "flex-shrink-0 w-6 h-6 rounded-full flex items-center justify-center text-xs font-bold transition-colors",
                                                                        selectedReasonId ? "bg-slate-900 text-white" : "bg-slate-100 text-slate-500"
                                                                    )}>
                                                                        {selectedReasonId ? <CheckCircle2 className="w-3.5 h-3.5" /> : step.step_order}
                                                                    </span>
                                                                    <div className="flex flex-col min-w-0">
                                                                        <span className={cn("text-sm truncate font-medium", selectedReasonId ? "text-slate-900" : "text-slate-600")}>
                                                                            Step {step.step_order}. {step.title}
                                                                        </span>
                                                                        {selectedReasonId && (
                                                                            <span className="text-xs font-bold text-amber-600 animate-in fade-in slide-in-from-left-1">
                                                                                {reasonLabel}
                                                                            </span>
                                                                        )}
                                                                    </div>
                                                                </div>
                                                                {isExpanded ? <ChevronUp className="w-4 h-4 text-slate-400" /> : <ChevronDown className="w-4 h-4 text-slate-400" />}
                                                            </button>

                                                            {/* Expanded Content (Reason Chips) */}
                                                            {isExpanded && (
                                                                <div className="p-3 pt-0 animate-in slide-in-from-top-1">
                                                                    <p className="text-xs font-semibold text-slate-500 mb-2 pl-1">어떤 문제였나요?</p>
                                                                    <div className="grid grid-cols-2 gap-2">
                                                                        {reasons.map((r) => (
                                                                            <button
                                                                                key={r.id}
                                                                                type="button"
                                                                                onClick={() => selectReason(step.id, r.id)}
                                                                                className={cn(
                                                                                    "px-3 py-2 rounded-lg text-xs font-medium transition-all text-left",
                                                                                    selectedReasonId === r.id
                                                                                        ? "bg-slate-800 text-white shadow-md transform scale-[1.02]"
                                                                                        : "bg-white border border-slate-200 text-slate-600 hover:border-slate-300 hover:bg-white"
                                                                                )}
                                                                            >
                                                                                {r.label}
                                                                            </button>
                                                                        ))}
                                                                    </div>
                                                                </div>
                                                            )}
                                                        </div>
                                                    );
                                                })}
                                            </div>
                                        )}

                                        {/* 2. Detail Message (Moved to bottom) */}
                                        <div className="space-y-2 pt-2 border-t border-slate-100">
                                            <label className="text-xs font-bold text-slate-500 uppercase tracking-wider block">
                                                추가 의견 (선택)
                                            </label>
                                            <Textarea
                                                value={message}
                                                onChange={(e) => setMessage(e.target.value)}
                                                placeholder="더 구체적인 내용이 있다면 적어주세요."
                                                className="min-h-[80px] resize-none text-sm bg-slate-50 border-slate-200 focus:bg-white"
                                            />
                                        </div>
                                    </div>

                                    {/* Footer Button - Fixed */}
                                    <div className="pt-4 mt-2 border-t border-slate-100 flex-shrink-0">
                                        <Button
                                            type="submit"
                                            disabled={isSubmitting || (steps.length > 0 && Object.keys(feedbackMap).length === 0)}
                                            className="w-full h-12 text-base font-semibold bg-slate-900 hover:bg-slate-800 text-white shadow-lg shadow-slate-900/10 transition-all rounded-xl"
                                        >
                                            {isSubmitting ? (
                                                <>
                                                    <Loader2 className="w-5 h-5 animate-spin mr-2" />
                                                    전송 중...
                                                </>
                                            ) : (
                                                <>
                                                    피드백 보내기 ({Object.keys(feedbackMap).length}건)
                                                    <Send className="w-4 h-4 ml-2" />
                                                </>
                                            )}
                                        </Button>
                                    </div>

                                </form>
                            </Dialog.Panel>
                        </Transition.Child>
                    </div>
                </div>
            </Dialog>
        </Transition>
    );
};
