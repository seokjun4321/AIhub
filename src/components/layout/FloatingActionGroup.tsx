import { useState } from 'react';
import { GlobalChatbot } from '../chat/GlobalChatbot';
import { useChatbot } from '@/contexts/ChatbotContext';
import { MessageCircle } from 'lucide-react';
import ScrollToTop from '../ui/ScrollToTop';
import { GlobalFeedbackWidget } from '../feedback/GlobalFeedbackWidget';

export const FloatingActionGroup = () => {
    const { openChat, isOpen } = useChatbot();
    const [isHovered, setIsHovered] = useState(false);

    return (
        <div className="fixed bottom-6 right-6 z-50 flex flex-col items-end gap-4 pointer-events-none">
            {/* 3. Feedback Widget (Top) */}
            <div className="pointer-events-auto">
                <GlobalFeedbackWidget className="flex flex-col items-end gap-2" />
            </div>

            {/* 2. Scroll To Top (Middle) */}
            <div className="pointer-events-auto">
                <ScrollToTop className="rounded-full bg-white text-slate-600 shadow-lg hover:bg-slate-50 border border-slate-200 w-14 h-14 flex items-center justify-center transition-all" />
            </div>

            {/* 1. Global Chatbot Trigger (Bottom) */}
            <div className="pointer-events-auto relative">
                {/* Label on Hover */}
                <div className={`
                    absolute right-full mr-3 top-1/2 -translate-y-1/2 
                    bg-slate-900 text-white text-xs font-bold py-1.5 px-3 rounded-lg shadow-lg 
                    transition-all duration-300 origin-right whitespace-nowrap
                    ${isHovered ? "opacity-100 scale-100 translate-x-0" : "opacity-0 scale-90 translate-x-4 pointer-events-none"}
                `}>
                    AI에게 물어보기
                </div>

                <button
                    onClick={() => openChat()}
                    onMouseEnter={() => setIsHovered(true)}
                    onMouseLeave={() => setIsHovered(false)}
                    className={`
                        group relative flex items-center justify-center w-14 h-14 rounded-full shadow-[0_8px_30px_rgb(0,0,0,0.12)] 
                        hover:shadow-[0_8px_30px_rgb(0,0,0,0.2)] hover:scale-110 active:scale-95 transition-all duration-300 
                        ${isOpen ? 'bg-slate-800 rotate-90' : 'bg-white'}
                    `}
                >
                    {isOpen ? (
                        <svg className="w-6 h-6 text-white transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    ) : (
                        <>
                            <div className="absolute inset-0 rounded-full bg-[#3B82F6] opacity-90 group-hover:opacity-100 transition-opacity" />
                            <MessageCircle className="w-7 h-7 text-white relative z-10" strokeWidth={2} />
                        </>
                    )}
                </button>
            </div>

            {/* Render the Modal (portal-like behavior handled by fixed positioning in component) */}
            <GlobalChatbot />
        </div>
    );
};
