import { AgentItem } from "@/data/mockData";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogFooter } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Info, MessageSquare, AlertCircle, ExternalLink, Bot, User, Copy, Check } from "lucide-react";
import { cn } from "@/lib/utils";
import { ScrollArea } from "@/components/ui/scroll-area";
import { useState } from "react";

interface AgentModalProps {
    item: AgentItem;
    isOpen: boolean;
    onClose: () => void;
}

const AgentModal = ({ item, isOpen, onClose }: AgentModalProps) => {
    const [language, setLanguage] = useState<'ko' | 'en'>('ko');
    const [copied, setCopied] = useState(false);

    const handleCopy = () => {
        const currentInstructions = language === 'en' && item.instructions_en ? item.instructions_en : item.instructions;
        const promptText = currentInstructions.join('\n');
        navigator.clipboard.writeText(promptText);
        setCopied(true);
        setTimeout(() => setCopied(false), 2000);
    };

    const description = language === 'en' && item.description_en ? item.description_en : item.description;
    const instructions = language === 'en' && item.instructions_en ? item.instructions_en : item.instructions;
    const conversation = language === 'en' && item.exampleConversation_en ? item.exampleConversation_en : item.exampleConversation;

    return (
        <Dialog open={isOpen} onOpenChange={onClose}>
            <DialogContent className="max-w-3xl max-h-[85vh] h-full p-0 flex flex-col gap-0 overflow-hidden">
                {/* Header */}
                <div className="p-6 border-b border-border bg-card">
                    <div className="flex items-center justify-between mb-2">
                        <div className="flex items-center gap-3">
                            <Badge variant="outline" className={cn(
                                "border-2 font-bold",
                                item.platform === "GPT" && "border-green-500 text-green-600",
                                item.platform === "Claude" && "border-orange-500 text-orange-600",
                                item.platform === "Gemini" && "border-blue-500 text-blue-600",
                                item.platform === "Perplexity" && "border-cyan-500 text-cyan-600",
                            )}>
                                {item.platform}
                            </Badge>
                            <DialogTitle className="text-2xl font-bold">{item.title}</DialogTitle>
                        </div>
                        {/* Language Toggle */}
                        {(item.description_en || item.instructions_en) && (
                            <div className="flex bg-muted/50 p-1 rounded-lg border border-border">
                                <button
                                    onClick={() => setLanguage('ko')}
                                    className={cn(
                                        "px-3 py-1.5 text-xs font-semibold rounded-md transition-all",
                                        language === 'ko'
                                            ? "bg-white text-primary shadow-sm"
                                            : "text-muted-foreground hover:text-foreground"
                                    )}
                                >
                                    한국어
                                </button>
                                <button
                                    onClick={() => setLanguage('en')}
                                    className={cn(
                                        "px-3 py-1.5 text-xs font-semibold rounded-md transition-all",
                                        language === 'en'
                                            ? "bg-white text-primary shadow-sm"
                                            : "text-muted-foreground hover:text-foreground"
                                    )}
                                >
                                    English
                                </button>
                            </div>
                        )}
                    </div>
                    <DialogDescription className="text-base text-foreground/80">
                        {item.oneLiner}
                    </DialogDescription>
                </div>

                <div className="flex flex-1 overflow-hidden">
                    <Tabs defaultValue="overview" className="flex flex-1">
                        {/* Sidebar Tabs */}
                        <div className="w-44 bg-muted/30 border-r border-border min-h-full">
                            <TabsList className="flex flex-col w-full h-full justify-start p-2 bg-transparent gap-1">
                                <TabsTrigger value="overview" className="w-full justify-start gap-2 px-3 py-2 data-[state=active]:bg-primary/10 data-[state=active]:text-primary">
                                    <Info className="w-4 h-4" /> 개요
                                </TabsTrigger>
                                <TabsTrigger value="chat" className="w-full justify-start gap-2 px-3 py-2 data-[state=active]:bg-primary/10 data-[state=active]:text-primary">
                                    <MessageSquare className="w-4 h-4" /> 예시 대화
                                </TabsTrigger>
                                <TabsTrigger value="requirements" className="w-full justify-start gap-2 px-3 py-2 data-[state=active]:bg-primary/10 data-[state=active]:text-primary">
                                    <AlertCircle className="w-4 h-4" /> 요구사항
                                </TabsTrigger>
                            </TabsList>
                        </div>

                        {/* Content Area */}
                        <ScrollArea className="flex-1 p-6 h-full">
                            <TabsContent value="overview" className="mt-0 space-y-8">
                                <div>
                                    <h3 className="text-lg font-semibold mb-3">설명</h3>
                                    <p className="text-muted-foreground leading-relaxed">
                                        {description}
                                    </p>
                                    {item.capabilities && item.capabilities.length > 0 && (
                                        <div className="flex flex-wrap gap-2 mb-4">
                                            {item.capabilities.map((cap, i) => (
                                                <Badge key={i} variant="secondary" className="bg-indigo-50 text-indigo-700 hover:bg-indigo-100">
                                                    {cap}
                                                </Badge>
                                            ))}
                                        </div>
                                    )}
                                </div>

                                {/* Prompt Copy Section */}
                                <div>
                                    <div className="flex items-center justify-between mb-3">
                                        <h3 className="text-lg font-semibold">프롬프트 미리보기</h3>
                                        <Button
                                            size="sm"
                                            onClick={handleCopy}
                                            className={cn("gap-2 text-white", copied ? "bg-green-600 hover:bg-green-700" : "bg-slate-900 hover:bg-slate-800")}
                                        >
                                            {copied ? <Check className="w-4 h-4" /> : <Copy className="w-4 h-4" />}
                                            {copied ? "복사됨" : "프롬프트 복사"}
                                        </Button>
                                    </div>
                                    <div className="bg-slate-50 p-6 rounded-xl border border-slate-100 text-slate-800 font-mono text-sm leading-relaxed max-h-[300px] overflow-y-auto whitespace-pre-wrap">
                                        {instructions.join('\n\n')}
                                    </div>
                                </div>

                                <div className="bg-slate-50 p-5 rounded-xl border border-slate-100">
                                    <h3 className="font-semibold mb-3 flex items-center gap-2">
                                        <Bot className="w-4 h-4 text-primary" />
                                        시스템 지침 (System Instructions)
                                    </h3>
                                    <ul className="list-disc list-inside space-y-1 text-sm text-slate-700">
                                        {instructions.map((inst, idx) => (
                                            <li key={idx}>{inst}</li>
                                        ))}
                                    </ul>
                                </div>

                                <div>
                                    <h3 className="font-semibold mb-3">추천 질문 예시</h3>
                                    <div className="flex flex-wrap gap-2">
                                        {item.exampleQuestions.map((q, idx) => (
                                            <div key={idx} className="bg-secondary/50 px-3 py-1.5 rounded-lg text-sm text-secondary-foreground border border-secondary">
                                                "{q}"
                                            </div>
                                        ))}
                                    </div>
                                </div>
                            </TabsContent>

                            <TabsContent value="chat" className="mt-0">
                                <div className="space-y-4 max-w-2xl mx-auto py-4">
                                    {conversation.map((msg, idx) => (
                                        <div key={idx} className={cn("flex gap-3", msg.role === "user" ? "justify-end" : "justify-start")}>
                                            {msg.role === "assistant" && (
                                                <div className="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center shrink-0">
                                                    <Bot className="w-4 h-4 text-primary" />
                                                </div>
                                            )}
                                            <div className={cn(
                                                "max-w-[80%] p-4 rounded-2xl text-sm leading-relaxed",
                                                msg.role === "user"
                                                    ? "bg-primary text-primary-foreground rounded-tr-none"
                                                    : "bg-muted rounded-tl-none"
                                            )}>
                                                {msg.content}
                                            </div>
                                            {msg.role === "user" && (
                                                <div className="w-8 h-8 rounded-full bg-muted flex items-center justify-center shrink-0">
                                                    <User className="w-4 h-4 text-muted-foreground" />
                                                </div>
                                            )}
                                        </div>
                                    ))}
                                </div>
                            </TabsContent>

                            <TabsContent value="requirements" className="mt-0">
                                <h3 className="text-lg font-semibold mb-4">사용 전 필수 조건</h3>
                                <div className="space-y-2">
                                    {item.requirements.map((req, idx) => (
                                        <div key={idx} className="flex items-center gap-3 p-3 bg-red-50 text-red-900 rounded-lg border border-red-100">
                                            <AlertCircle className="w-5 h-5 text-red-500" />
                                            <span>{req}</span>
                                        </div>
                                    ))}
                                </div>
                            </TabsContent>
                        </ScrollArea>
                    </Tabs>
                </div>

                <DialogFooter className="p-4 border-t border-border bg-muted/20">
                    <Button
                        size="lg"
                        className="w-full gap-2"
                        onClick={() => window.open(item.url, '_blank')}
                    >
                        <ExternalLink className="w-4 h-4" />
                        {item.platform}에서 열기
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    );
};

export default AgentModal;
