import { useRef, useEffect, useState } from 'react';
import { useChatbot } from '@/contexts/ChatbotContext';
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import '../../styles/newHome.css'; // Reusing existing styles for now, or we can move them

export const GlobalChatbot = () => {
    const { isOpen, messages, isLoading, closeChat, sendMessage } = useChatbot();
    const [inputValue, setInputValue] = useState('');
    const inputRef = useRef<HTMLInputElement>(null);
    const messagesEndRef = useRef<HTMLDivElement>(null);

    // Auto-scroll to bottom
    useEffect(() => {
        messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
    }, [messages, isLoading, isOpen]);

    // Focus input on open
    useEffect(() => {
        if (isOpen && inputRef.current) {
            inputRef.current.focus();
        }
    }, [isOpen]);

    const handleSend = () => {
        if (!inputValue.trim()) return;
        sendMessage(inputValue);
        setInputValue('');
    };

    const handleKeyDown = (e: React.KeyboardEvent) => {
        if (e.key === 'Enter' && !e.nativeEvent.isComposing) {
            e.preventDefault();
            handleSend();
        }
    };

    if (!isOpen) return null;

    return (
        <div
            className="fixed inset-0 z-[100] flex items-center justify-center bg-black/50 backdrop-blur-sm animate-in fade-in duration-200 pointer-events-auto"
            onClick={(e) => e.target === e.currentTarget && closeChat()}
        >
            <div className="w-[90%] max-w-[500px] h-[600px] max-h-[90%] bg-white rounded-2xl shadow-2xl flex flex-col overflow-hidden animate-in zoom-in-95 duration-200">
                {/* Header */}
                <div className="p-4 border-b flex justify-between items-center bg-slate-50">
                    <div className="flex items-center gap-2">
                        <div className="w-8 h-8 rounded-full bg-gradient-to-tr from-emerald-400 to-blue-500 flex items-center justify-center text-white font-bold">
                            AI
                        </div>
                        <h3 className="font-bold text-lg text-slate-800">AI 어시스턴트</h3>
                    </div>
                    <button
                        onClick={closeChat}
                        className="p-2 hover:bg-slate-200 rounded-full transition-colors text-slate-500"
                    >
                        <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>

                {/* Body */}
                <div className="flex-1 overflow-y-auto p-4 space-y-4 bg-slate-50/50">
                    {messages.length === 0 && (
                        <div className="text-center py-8 text-slate-500">
                            <p>무엇을 도와드릴까요?</p>
                            <p className="text-sm mt-2">필요한 AI 도구나 가이드북을 찾아드립니다.</p>
                        </div>
                    )}

                    {messages.map((msg, idx) => (
                        <div key={idx} className={`flex ${msg.type === 'user' ? 'justify-end' : 'justify-start'}`}>
                            <div className={`
                                max-w-[80%] rounded-2xl px-4 py-2.5 text-sm leading-relaxed
                                ${msg.type === 'user'
                                    ? 'bg-blue-600 text-white rounded-tr-none'
                                    : 'bg-white border shadow-sm text-slate-700 rounded-tl-none'
                                }
                            `}>
                                <ReactMarkdown
                                    remarkPlugins={[remarkGfm]}
                                    components={{
                                        p: ({ children }) => <p className="mb-1 last:mb-0 leading-relaxed">{children}</p>,
                                        a: ({ href, children }) => <a href={href} target="_blank" rel="noopener noreferrer" className="text-blue-500 hover:underline">{children}</a>,
                                        ul: ({ children }) => <ul className="list-disc ml-4 mb-2">{children}</ul>,
                                        ol: ({ children }) => <ol className="list-decimal ml-4 mb-2">{children}</ol>,
                                        li: ({ children }) => <li className="mb-0.5">{children}</li>,
                                        strong: ({ children }) => <span className="font-bold text-slate-900">{children}</span>,
                                        em: ({ children }) => <em className="italic">{children}</em>,
                                        blockquote: ({ children }) => <blockquote className="border-l-4 border-slate-300 pl-4 py-1 my-2 bg-slate-50 italic">{children}</blockquote>,
                                        code: ({ children }) => <code className="bg-slate-100 rounded px-1 py-0.5 text-xs font-mono text-red-500">{children}</code>,
                                        pre: ({ children }) => <pre className="bg-slate-100 rounded p-2 text-xs overflow-x-auto my-2">{children}</pre>
                                    }}
                                >
                                    {msg.text
                                        // 1. Escape ampersands to prevent issues
                                        .replace(/&/g, '&amp;')
                                        // 2. Clean up ALL backslashes
                                        .replace(/\\/g, '')
                                        // 3. Normalize spaces around bold tags
                                        .replace(/\*\*\s+/g, '**')
                                        .replace(/\s+\*\*/g, '**')
                                        // 4. Robust Fix: Move bold markers INSIDE brackets
                                        // **[Text]** -> [**Text**]
                                        .replace(/\*\*\[([^\]]*?)\]\*\*/g, '[**$1**]')
                                        // 5. NEW: Convert [**Text**] into Link -> [**Text**](/guides?search=Text)
                                        .replace(/\[\*\*([^\]]*?)\*\*\]/g, (match, title) => {
                                            // Unescape HTML entities for the URL parameter (e.g. &amp; -> &)
                                            const searchTitle = title.replace(/&amp;/g, '&');
                                            return `[**${title}**](/guides?search=${encodeURIComponent(searchTitle)})`;
                                        })
                                    }
                                </ReactMarkdown>
                            </div>
                        </div>
                    ))}

                    {isLoading && (
                        <div className="flex justify-start">
                            <div className="bg-white border shadow-sm rounded-2xl rounded-tl-none px-4 py-3">
                                <div className="flex gap-1.5">
                                    <span className="w-2 h-2 rounded-full bg-slate-400 animate-bounce" style={{ animationDelay: '0ms' }} />
                                    <span className="w-2 h-2 rounded-full bg-slate-400 animate-bounce" style={{ animationDelay: '150ms' }} />
                                    <span className="w-2 h-2 rounded-full bg-slate-400 animate-bounce" style={{ animationDelay: '300ms' }} />
                                </div>
                            </div>
                        </div>
                    )}
                    <div ref={messagesEndRef} />
                </div>

                {/* Input */}
                <div className="p-4 bg-white border-t">
                    <div className="flex gap-2">
                        <input
                            ref={inputRef}
                            type="text"
                            value={inputValue}
                            onChange={(e) => setInputValue(e.target.value)}
                            onKeyDown={handleKeyDown}
                            placeholder="메시지를 입력하세요..."
                            className="flex-1 px-4 py-2.5 bg-slate-100 border-transparent focus:bg-white focus:border-blue-500 rounded-xl outline-none transition-all placeholder:text-slate-400"
                            disabled={isLoading}
                        />
                        <button
                            onClick={handleSend}
                            disabled={isLoading || !inputValue.trim()}
                            className="px-4 py-2 bg-blue-600 text-white rounded-xl hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors font-medium flex items-center justify-center min-w-[3rem]"
                        >
                            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8" />
                            </svg>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    );
};
