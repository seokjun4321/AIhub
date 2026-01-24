import React, { createContext, useContext, useState, ReactNode } from 'react';
import { sendMessageToN8n } from '@/lib/n8n';
import { useAuth } from '@/hooks/useAuth';

interface Message {
    type: 'user' | 'bot';
    text: string;
}

interface ChatbotContextType {
    isOpen: boolean;
    messages: Message[];
    isLoading: boolean;
    openChat: (initialMessage?: string) => void;
    closeChat: () => void;
    sendMessage: (text: string) => Promise<void>;
}

const ChatbotContext = createContext<ChatbotContextType | undefined>(undefined);

export const ChatbotProvider = ({ children }: { children: ReactNode }) => {
    const [isOpen, setIsOpen] = useState(false);
    const [messages, setMessages] = useState<Message[]>([]);
    const [isLoading, setIsLoading] = useState(false);
    const { user } = useAuth();

    const openChat = (initialMessage?: string) => {
        setIsOpen(true);
        if (initialMessage) {
            // Avoid duplicate initial messages if user clicks multiple times or if logic repeats
            // But for simple "run this prompt", we just send it.
            // We might want to clear messages if it's a fresh start, or keep history.
            // Let's decide to KEEP history for now, but if initialMessage is passed, we send it immediately.
            sendMessage(initialMessage);
        }
    };

    const closeChat = () => {
        setIsOpen(false);
    };

    const sendMessage = async (text: string) => {
        if (!text.trim() || isLoading) return;

        // Add user message
        setMessages((prev) => [...prev, { type: 'user', text }]);
        setIsLoading(true);

        try {
            const userId = user?.id || 'guest';
            const response = await sendMessageToN8n(userId, text);

            if (response && response.answer) {
                setMessages((prev) => [...prev, { type: 'bot', text: response.answer }]);
            } else {
                setMessages((prev) => [...prev, { type: 'bot', text: "죄송합니다. 답변 형식이 올바르지 않습니다." }]);
            }
        } catch (error) {
            console.error("Chatbot Error:", error);
            setMessages((prev) => [...prev, { type: 'bot', text: "죄송합니다. 연결에 실패했습니다. (잠시 후 다시 시도해주세요)" }]);
        } finally {
            setIsLoading(false);
        }
    };

    return (
        <ChatbotContext.Provider value={{ isOpen, messages, isLoading, openChat, closeChat, sendMessage }}>
            {children}
        </ChatbotContext.Provider>
    );
};

export const useChatbot = () => {
    const context = useContext(ChatbotContext);
    if (context === undefined) {
        throw new Error('useChatbot must be used within a ChatbotProvider');
    }
    return context;
};
