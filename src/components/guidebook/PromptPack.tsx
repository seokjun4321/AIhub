import { Button } from "@/components/ui/button";
import { Copy, Check } from "lucide-react";
import { useState } from "react";
import { useToast } from "@/hooks/use-toast";

export interface PromptItem {
    id: string;
    title: string;
    description?: string;
    prompt: string;
}

interface PromptPackProps {
    prompts: PromptItem[];
}

export function PromptPack({ prompts }: PromptPackProps) {
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
        return <div className="text-center py-8 text-slate-500">등록된 프롬프트 팩이 없습니다.</div>;
    }

    return (
        <div className="space-y-4">
            {prompts.map((item) => (
                <div key={item.id} className="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm group">
                    <div className="flex justify-between items-start mb-4">
                        <div>
                            <h4 className="font-bold text-slate-900 mb-1">{item.title}</h4>
                            {item.description && (
                                <p className="text-sm text-slate-500">{item.description}</p>
                            )}
                        </div>
                        <Button
                            variant="outline"
                            size="sm"
                            className="gap-2 text-slate-600 hover:text-green-600 hover:border-green-200"
                            onClick={() => handleCopy(item.id, item.prompt)}
                        >
                            {copiedId === item.id ? (
                                <>
                                    <Check className="w-4 h-4" />
                                    복사됨
                                </>
                            ) : (
                                <>
                                    <Copy className="w-4 h-4" />
                                    복사하기
                                </>
                            )}
                        </Button>
                    </div>
                    <div className="bg-slate-50 p-4 rounded-xl border border-slate-100 text-sm text-slate-700 font-mono leading-relaxed whitespace-pre-wrap">
                        {item.prompt}
                    </div>
                </div>
            ))}
        </div>
    );
}
