import { useState } from 'react';
import { Copy, Check, BookOpen } from 'lucide-react';
import { Button } from '@/components/ui/button';

interface CopyBlockProps {
    title?: string;
    content: string;
    language?: string;
    description?: string;
}

export function CopyBlock({ title, content, language = 'text', description }: CopyBlockProps) {
    const [copied, setCopied] = useState(false);

    const handleCopy = async () => {
        try {
            await navigator.clipboard.writeText(content);
            setCopied(true);
            setTimeout(() => setCopied(false), 2000);
        } catch (err) {
            console.error('Failed to copy:', err);
        }
    };

    return (
        <div className="my-6 rounded-2xl border-2 border-emerald-200 bg-gradient-to-br from-emerald-50 to-teal-50 overflow-hidden shadow-sm">
            {/* Header */}
            <div className="bg-emerald-600 text-white px-6 py-4 flex items-center justify-between">
                <div className="flex items-center gap-3">
                    <div className="p-2 bg-white/20 rounded-lg">
                        <BookOpen className="w-5 h-5" />
                    </div>
                    <div>
                        <h4 className="font-bold text-lg">
                            {title || '복붙 블록'}
                        </h4>
                        {description && (
                            <p className="text-emerald-100 text-sm mt-0.5">{description}</p>
                        )}
                    </div>
                </div>
                <Button
                    onClick={handleCopy}
                    className={`
            ${copied
                            ? 'bg-white text-emerald-600 hover:bg-white'
                            : 'bg-emerald-700 hover:bg-emerald-800 text-white'
                        }
            transition-all duration-200 font-semibold px-6 py-2 rounded-lg shadow-lg
          `}
                >
                    {copied ? (
                        <>
                            <Check className="w-4 h-4 mr-2" />
                            복사완료!
                        </>
                    ) : (
                        <>
                            <Copy className="w-4 h-4 mr-2" />
                            복사하기
                        </>
                    )}
                </Button>
            </div>

            {/* Content */}
            <div className="p-6 bg-white">
                <pre className="bg-slate-900 text-slate-50 p-6 rounded-xl overflow-x-auto text-sm leading-relaxed font-mono whitespace-pre-wrap border-2 border-slate-700 shadow-inner">
                    <code className={`language-${language}`}>{content}</code>
                </pre>
            </div>

            {/* Footer Tip */}
            <div className="bg-emerald-50 px-6 py-3 border-t border-emerald-200">
                <p className="text-sm text-emerald-800 flex items-center gap-2">
                    <span className="text-emerald-600">💡</span>
                    <span className="font-medium">이 템플릿을 ChatGPT, Kling AI, Hailuo AI 등에 바로 붙여넣으세요!</span>
                </p>
            </div>
        </div>
    );
}
