import { useState } from 'react';
import { MessageSquarePlus } from 'lucide-react';
import { FeedbackModal } from './FeedbackModal';
import { cn } from '@/lib/utils';

export const GlobalFeedbackWidget = () => {
    const [isOpen, setIsOpen] = useState(false);
    const [isHovered, setIsHovered] = useState(false);

    return (
        <>
            <div
                className="fixed bottom-6 right-6 z-40 flex flex-col items-end gap-2"
                onMouseEnter={() => setIsHovered(true)}
                onMouseLeave={() => setIsHovered(false)}
            >
                {/* Tooltip Label */}
                <div className={cn(
                    "bg-slate-900 text-white text-xs font-bold py-1.5 px-3 rounded-lg shadow-lg mb-1 transition-all duration-300 origin-right whitespace-nowrap",
                    isHovered ? "opacity-100 scale-100 translate-x-0" : "opacity-0 scale-90 translate-x-4 pointer-events-none"
                )}>
                    피드백 보내기
                </div>

                {/* Floating Button */}
                <button
                    onClick={() => setIsOpen(true)}
                    className="group relative flex items-center justify-center w-14 h-14 rounded-full bg-white border border-slate-200 shadow-[0_8px_30px_rgb(0,0,0,0.12)] hover:shadow-[0_8px_30px_rgb(0,0,0,0.2)] hover:scale-110 active:scale-95 transition-all duration-300 ring-4 ring-transparent hover:ring-slate-100"
                    aria-label="Give Feedback"
                >
                    <div className="absolute inset-0 rounded-full bg-gradient-to-tr from-emerald-50 to-blue-50 opacity-0 group-hover:opacity-100 transition-opacity duration-500" />
                    <MessageSquarePlus className="w-6 h-6 text-slate-600 group-hover:text-emerald-600 transition-colors relative z-10" strokeWidth={2} />
                </button>
            </div>

            <FeedbackModal
                isOpen={isOpen}
                onClose={() => setIsOpen(false)}
                trigger="global_widget"
                title="무엇을 도와드릴까요?"
                placeholder="사이트 이용 중 불편한 점이나 바라는 점이 있다면 자유롭게 말씀해주세요."
            />
        </>
    );
};
