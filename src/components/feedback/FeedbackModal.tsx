import React, { Fragment, useState } from 'react';
import { Dialog, Transition } from '@headlessui/react';
import { X, MessageSquare, Bug, Lightbulb, HelpCircle, Send, Loader2 } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Textarea } from '@/components/ui/textarea';
import { Input } from '@/components/ui/input';
import { cn } from '@/lib/utils';
import { useToast } from '@/hooks/use-toast';

import { supabase } from '@/integrations/supabase/client';

export type FeedbackTrigger = 'global_widget' | 'guidebook_complete' | 'preset_copy';
export type FeedbackCategory = 'bug' | 'feature' | 'other' | 'content';

interface FeedbackModalProps {
    isOpen: boolean;
    onClose: () => void;
    trigger: FeedbackTrigger;
    initialCategory?: FeedbackCategory;
    title?: string;
    placeholder?: string;
    defaultValues?: {
        entityType?: string;
        entityId?: string;
    };
}

export const FeedbackModal = ({
    isOpen,
    onClose,
    trigger,
    initialCategory = 'feature',
    title = "소중한 의견을 들려주세요",
    placeholder = "어떤 점이 좋거나 불편하셨나요? 자유롭게 적어주세요.",
    defaultValues
}: FeedbackModalProps) => {
    const [rating, setRating] = useState<number>(0);
    const [category, setCategory] = useState<FeedbackCategory>(initialCategory);
    const [message, setMessage] = useState('');
    const [email, setEmail] = useState('');
    const [isSubmitting, setIsSubmitting] = useState(false);
    const { toast } = useToast();

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!message.trim()) {
            toast({ title: "내용을 입력해주세요", variant: "destructive" });
            return;
        }

        setIsSubmitting(true);

        try {
            const { data: { user } } = await supabase.auth.getUser();

            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            const { error } = await supabase.from('feedbacks' as any).insert({
                trigger, // 'global_widget' etc
                entity_type: defaultValues?.entityType,
                entity_id: defaultValues?.entityId,
                category,
                rating: rating > 0 ? rating : null,
                message,
                email: email || null,
                user_id: user?.id,
                page_url: window.location.href,
                metadata: {
                    userAgent: navigator.userAgent
                }
            });

            if (error) throw error;

            toast({
                title: "소중한 의견 감사합니다! 💌",
                description: "남겨주신 의견을 바탕으로 더 좋은 서비스를 만들겠습니다.",
            });

            onClose();
            resetForm();

        } catch (error: unknown) {
            console.error("Feedback submission error:", error);
            toast({
                title: "전송 실패",
                description: "일시적인 오류가 발생했습니다. 잠시 후 다시 시도해주세요.",
                variant: "destructive"
            });
        } finally {
            setIsSubmitting(false);
        }
    };

    const resetForm = () => {
        setRating(0);
        setCategory(initialCategory);
        setMessage('');
        setEmail('');
    };

    const categories: { id: FeedbackCategory; label: string; icon: React.ReactNode }[] = [
        { id: 'bug', label: '버그 신고', icon: <Bug className="w-3.5 h-3.5" /> },
        { id: 'feature', label: '기능 제안', icon: <Lightbulb className="w-3.5 h-3.5 text-yellow-500" /> },
        { id: 'content', label: '콘텐츠 개선', icon: <MessageSquare className="w-3.5 h-3.5" /> },
        { id: 'other', label: '기타', icon: <HelpCircle className="w-3.5 h-3.5" /> },
    ];

    return (
        <Transition appear show={isOpen} as={Fragment}>
            <Dialog as="div" className="relative z-50" onClose={onClose}>
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
                            <Dialog.Panel className="w-full max-w-md transform overflow-hidden rounded-2xl bg-white p-6 text-left align-middle shadow-xl transition-all border border-slate-100">

                                {/* Header */}
                                <div className="flex justify-between items-start mb-6">
                                    <Dialog.Title as="h3" className="text-lg font-bold text-slate-900 leading-snug">
                                        {title}
                                    </Dialog.Title>
                                    <button
                                        type="button"
                                        className="rounded-full p-1 hover:bg-slate-100 transition-colors"
                                        onClick={onClose}
                                    >
                                        <X className="w-5 h-5 text-slate-400" />
                                    </button>
                                </div>

                                <form onSubmit={handleSubmit} className="space-y-6">

                                    {/* Rating (Optional for Global) */}
                                    <div className="flex justify-center gap-2">
                                        {[1, 2, 3, 4, 5].map((star) => (
                                            <button
                                                key={star}
                                                type="button"
                                                onClick={() => setRating(star)}
                                                className={cn(
                                                    "w-10 h-10 rounded-full flex items-center justify-center text-2xl transition-all hover:scale-110",
                                                    rating === star ? "grayscale-0 scale-125" : "grayscale opacity-30 hover:opacity-100 hover:scale-110"
                                                )}
                                            >
                                                {star === 1 ? '😡' : star === 2 ? '🙁' : star === 3 ? '😐' : star === 4 ? '🙂' : '😍'}
                                            </button>
                                        ))}
                                    </div>

                                    {/* Category Chips */}
                                    <div className="space-y-2">
                                        <label className="text-xs font-bold text-slate-500 uppercase tracking-wider">유형 선택</label>
                                        <div className="flex flex-wrap gap-2">
                                            {categories.map((cat) => (
                                                <button
                                                    key={cat.id}
                                                    type="button"
                                                    onClick={() => setCategory(cat.id)}
                                                    className={cn(
                                                        "flex items-center gap-1.5 px-3 py-1.5 rounded-full text-sm font-medium transition-all border",
                                                        category === cat.id
                                                            ? "bg-slate-900 text-white border-slate-900 shadow-md transform scale-105"
                                                            : "bg-white text-slate-600 border-slate-200 hover:border-slate-300 hover:bg-slate-50"
                                                    )}
                                                >
                                                    {cat.icon}
                                                    {cat.label}
                                                </button>
                                            ))}
                                        </div>
                                    </div>

                                    {/* Message Input */}
                                    <div className="space-y-2">
                                        <Textarea
                                            value={message}
                                            onChange={(e) => setMessage(e.target.value)}
                                            placeholder={placeholder}
                                            className="min-h-[120px] resize-none text-base p-4 focus:ring-emerald-500/20 focus:border-emerald-500"
                                        />
                                    </div>

                                    {/* Email Input (Optional) */}
                                    <div className="space-y-2">
                                        <div className="flex items-center justify-between">
                                            <label className="text-xs font-bold text-slate-500 uppercase tracking-wider">답변 받을 이메일 (선택)</label>
                                        </div>
                                        <Input
                                            type="email"
                                            value={email}
                                            onChange={(e) => setEmail(e.target.value)}
                                            placeholder="example@email.com"
                                            className="h-10 text-sm bg-slate-50 border-slate-200 focus:bg-white transition-all"
                                        />
                                    </div>

                                    {/* Submit Button */}
                                    <Button
                                        type="submit"
                                        disabled={isSubmitting || !message.trim()}
                                        className="w-full h-12 text-base font-semibold bg-emerald-600 hover:bg-emerald-700 text-white shadow-lg shadow-emerald-600/20 hover:shadow-emerald-600/30 transition-all rounded-xl"
                                    >
                                        {isSubmitting ? (
                                            <>
                                                <Loader2 className="w-5 h-5 animate-spin mr-2" />
                                                보내는 중...
                                            </>
                                        ) : (
                                            <>
                                                의견 보내기
                                                <Send className="w-4 h-4 ml-2" />
                                            </>
                                        )}
                                    </Button>

                                </form>
                            </Dialog.Panel>
                        </Transition.Child>
                    </div>
                </div>
            </Dialog>
        </Transition>
    );
};
