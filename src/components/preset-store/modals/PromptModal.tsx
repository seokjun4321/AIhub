import { PromptTemplate } from "@/data/mockData";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Copy, Check, FileText, FlaskConical, BookOpen, Lightbulb } from "lucide-react";
import { useState } from "react";
import { cn } from "@/lib/utils";
import { Textarea } from "@/components/ui/textarea";

interface PromptModalProps {
    item: PromptTemplate;
    isOpen: boolean;
    onClose: () => void;
}

const PromptModal = ({ item, isOpen, onClose }: PromptModalProps) => {
    const [variables, setVariables] = useState<Record<string, string>>({});
    const [copied, setCopied] = useState(false);

    const handleVariableChange = (name: string, value: string) => {
        setVariables(prev => ({ ...prev, [name]: value }));
    };

    const fillExample = () => {
        const exampleVars: Record<string, string> = {};
        item.variables.forEach(v => {
            exampleVars[v.name] = v.example;
        });
        setVariables(exampleVars);
    };

    const getCompletedPrompt = () => {
        let prompt = item.prompt;
        item.variables.forEach(v => {
            const value = variables[v.name] || `{${v.name}}`;
            prompt = prompt.replace(new RegExp(`{${v.name}}`, 'g'), value);
        });
        return prompt;
    };

    const handleCopy = () => {
        navigator.clipboard.writeText(getCompletedPrompt());
        setCopied(true);
        setTimeout(() => setCopied(false), 2000);
    };

    return (
        <Dialog open={isOpen} onOpenChange={onClose}>
            <DialogContent className="max-w-7xl h-[750px] max-h-[90vh] p-0 flex flex-col gap-0 overflow-hidden">
                {/* Header */}
                <div className="p-6 border-b border-border bg-card">
                    <div className="flex items-center gap-3 mb-2">
                        <Badge variant={item.difficulty === 'Beginner' ? 'secondary' : 'default'} className={cn(
                            item.difficulty === "Beginner" && "bg-emerald-100 text-emerald-800 hover:bg-emerald-200",
                            item.difficulty === "Intermediate" && "bg-amber-100 text-amber-800 hover:bg-amber-200",
                            item.difficulty === "Advanced" && "bg-rose-100 text-rose-800 hover:bg-rose-200"
                        )}>
                            {item.badges[0].text}
                        </Badge>
                        <div className="flex gap-1">
                            {item.tags.map((tag, i) => (
                                <Badge key={i} variant="outline" className="text-muted-foreground">{tag}</Badge>
                            ))}
                        </div>
                    </div>
                    <DialogTitle className="text-2xl font-bold mb-2">{item.title}</DialogTitle>
                    <DialogDescription className="text-base text-foreground/80 mb-4">
                        {item.oneLiner}
                    </DialogDescription>
                    <div className="flex items-center gap-2">
                        <span className="text-sm text-muted-foreground">호환:</span>
                        {item.compatibleTools.map((tool, i) => (
                            <Badge key={i} variant="secondary" className="bg-slate-100">
                                {tool}
                            </Badge>
                        ))}
                    </div>
                </div>

                <div className="flex flex-1 overflow-hidden">
                    <Tabs defaultValue="overview" className="flex flex-1">
                        {/* Sidebar Tabs */}
                        <div className="w-48 bg-muted/30 border-r border-border min-h-full">
                            <TabsList className="flex flex-col w-full h-full justify-start p-2 bg-transparent gap-1">
                                <TabsTrigger value="overview" className="w-full justify-start gap-2 px-3 py-2 data-[state=active]:bg-primary/10 data-[state=active]:text-primary">
                                    <FileText className="w-4 h-4" /> 개요
                                </TabsTrigger>
                                <TabsTrigger value="example" className="w-full justify-start gap-2 px-3 py-2 data-[state=active]:bg-primary/10 data-[state=active]:text-primary">
                                    <FlaskConical className="w-4 h-4" /> 예시 결과
                                </TabsTrigger>
                                <TabsTrigger value="tips" className="w-full justify-start gap-2 px-3 py-2 data-[state=active]:bg-primary/10 data-[state=active]:text-primary">
                                    <BookOpen className="w-4 h-4" /> 사용 팁
                                </TabsTrigger>
                            </TabsList>
                        </div>

                        {/* Content Area */}
                        <ScrollArea className="flex-1 p-6 h-full">
                            <TabsContent value="overview" className="mt-0 h-full">
                                <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 h-full">
                                    {/* Left: Input Variables */}
                                    <div className="flex flex-col h-full">
                                        <div className="flex items-center justify-between mb-4 shrink-0">
                                            <h3 className="text-lg font-semibold">변수 입력</h3>
                                            <Button variant="outline" size="sm" onClick={fillExample}>
                                                예시 채우기
                                            </Button>
                                        </div>
                                        <div className="grid gap-4 overflow-y-auto pr-2">
                                            {item.variables.map((v) => (
                                                <div key={v.name} className="space-y-1.5">
                                                    <Label className="text-sm font-medium flex items-center gap-2">
                                                        {v.name}
                                                        <span className="text-xs text-muted-foreground font-normal">({v.placeholder})</span>
                                                    </Label>
                                                    <Input
                                                        value={variables[v.name] || ""}
                                                        onChange={(e) => handleVariableChange(v.name, e.target.value)}
                                                        placeholder={v.example}
                                                        className="bg-muted/20"
                                                    />
                                                </div>
                                            ))}
                                        </div>
                                    </div>

                                    {/* Right: Prompt Preview */}
                                    <div className="flex flex-col h-full border-l border-slate-100 pl-8 -ml-8 lg:ml-0 lg:pl-0 lg:border-l-0">
                                        <div className="flex items-center justify-between mb-4 shrink-0">
                                            <h3 className="text-lg font-semibold">프롬프트 미리보기</h3>
                                            <Button size="sm" onClick={handleCopy} className={cn("gap-2", copied ? "bg-green-600 hover:bg-green-700" : "")}>
                                                {copied ? <Check className="w-4 h-4" /> : <Copy className="w-4 h-4" />}
                                                {copied ? "복사됨" : "프롬프트 복사"}
                                            </Button>
                                        </div>
                                        <div className="relative flex-1">
                                            <Textarea
                                                readOnly
                                                value={getCompletedPrompt()}
                                                className="h-full min-h-[400px] font-mono text-sm bg-muted/30 resize-none p-6 leading-relaxed rounded-xl border-slate-200"
                                            />
                                        </div>
                                    </div>
                                </div>
                            </TabsContent>

                            <TabsContent value="example" className="mt-0 space-y-6">
                                <div>
                                    <h3 className="text-lg font-semibold mb-3">입력 값</h3>
                                    <div className="bg-muted/30 p-4 rounded-lg border border-border whitespace-pre-wrap font-mono text-sm">
                                        {item.exampleIO.input}
                                    </div>
                                </div>
                                <div>
                                    <h3 className="text-lg font-semibold mb-3">생성 결과</h3>
                                    <div className="bg-primary/5 p-6 rounded-lg border border-primary/20 whitespace-pre-wrap leading-relaxed shadow-sm">
                                        {item.exampleIO.output}
                                    </div>
                                </div>
                            </TabsContent>

                            <TabsContent value="tips" className="mt-0">
                                <h3 className="text-lg font-semibold mb-4">💡 효과적인 사용 팁</h3>
                                <div className="grid gap-3">
                                    {item.tips.map((tip, idx) => (
                                        <div key={idx} className="flex gap-3 p-4 bg-amber-50 rounded-lg border border-amber-100 text-amber-900">
                                            <Lightbulb className="w-5 h-5 flex-shrink-0 text-amber-600 mt-0.5" />
                                            <p className="leading-relaxed">{tip}</p>
                                        </div>
                                    ))}
                                </div>
                            </TabsContent>
                        </ScrollArea>
                    </Tabs>
                </div>
            </DialogContent>
        </Dialog>
    );
};

export default PromptModal;
