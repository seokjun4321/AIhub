import React from 'react';
import { Check, Info, Lightbulb, AlertTriangle, Terminal, XCircle, CheckCircle2 } from "lucide-react";
import { cn } from "@/lib/utils";
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';

interface MarkdownProps {
    content: string;
}

const MarkdownContent = ({ content }: MarkdownProps) => (
    <div className="prose prose-sm max-w-none prose-p:my-1 prose-ul:my-1 prose-ol:my-1">
        <ReactMarkdown
            remarkPlugins={[remarkGfm]}
            components={{
                p: (props) => <p className="text-sm text-slate-600 leading-relaxed" {...props} />,
                strong: (props) => <strong className="font-semibold text-slate-900" {...props} />,
                li: (props) => <li className="text-sm text-slate-600" {...props} />,
            }}
        >
            {content}
        </ReactMarkdown>
    </div>
);

export const GoalBanner = ({ goal, doneWhen }: { goal?: string, doneWhen?: string }) => {
    if (!goal && !doneWhen) return null;
    return (
        <div className="flex flex-col md:flex-row gap-6 bg-slate-50 rounded-xl p-5 border border-slate-100 mb-8">
            {goal && (
                <div className="flex-1">
                    <div className="flex items-center gap-2 mb-2 text-emerald-600">
                        <div className="p-1 rounded bg-emerald-100">
                            <div className="w-2 h-2 rounded-full bg-emerald-600" />
                        </div>
                        <span className="font-bold text-xs uppercase tracking-wider">Goal</span>
                    </div>
                    <MarkdownContent content={goal} />
                </div>
            )}
            {doneWhen && (
                <div className="flex-1 md:border-l md:border-slate-200 md:pl-6">
                    <div className="flex items-center gap-2 mb-2 text-blue-600">
                        <div className="p-1 rounded bg-blue-100">
                            <Check className="w-3 h-3 text-blue-600" />
                        </div>
                        <span className="font-bold text-xs uppercase tracking-wider">Done When</span>
                    </div>
                    <MarkdownContent content={doneWhen} />
                </div>
            )}
        </div>
    );
};

export const WhyThisMatters = ({ content }: { content: string }) => {
    if (!content) return null;
    return (
        <div className="bg-amber-50/50 border border-amber-100 rounded-xl p-5 mb-8">
            <div className="flex items-center gap-2 mb-2 text-amber-700">
                <Lightbulb className="w-4 h-4" />
                <span className="font-bold text-sm">Why This Matters</span>
            </div>
            <MarkdownContent content={content} />
        </div>
    );
};

export const ActionList = ({ content }: { content: string }) => {
    if (!content) return null;

    // Force content to be rendered as numbered list if it looks like a list
    // Replace bullets with numbers for visual consistency if needed, 
    // or just rely on CSS counters for <li> elements regardless of ul/ol tag.
    // Let's use CSS counters to make all lists look like ordered steps.
    return (
        <div className="mb-8 border border-purple-100 bg-white rounded-xl overflow-hidden shadow-sm">
            <div className="bg-purple-50 px-5 py-3 border-b border-purple-100 flex items-center gap-2">
                <div className="bg-purple-100 text-purple-700 p-1 rounded-md">
                    <Check className="w-4 h-4" />
                </div>
                <h4 className="font-bold text-slate-800">Action & Content</h4>
            </div>
            <div className="p-6">
                <div className="space-y-4">
                    <ReactMarkdown
                        remarkPlugins={[remarkGfm]}
                        components={{
                            // Force both ul and ol to look like numbered steps
                            ul: (props) => <ul className="space-y-4 counter-reset-step" {...props} />,
                            ol: (props) => <ol className="space-y-4 counter-reset-step" {...props} />,
                            li: (props) => (
                                <li className="relative pl-10 text-sm text-slate-700 leading-relaxed group">
                                    {/* Number Badge */}
                                    <span className="absolute left-0 top-0 flex items-center justify-center w-6 h-6 text-xs font-bold text-purple-600 bg-purple-100 rounded-full ring-4 ring-white transition-colors">
                                        {/* We can't easily get index here without context, so we'll use CSS counter if possible? 
                                            Actually, pure CSS list-style works best or css counters. */}
                                    </span>
                                    {/* Using CSS counter for numbering 'step-counter' */}
                                    <style>{`
                                        ul.counter-reset-step, ol.counter-reset-step {
                                            counter-reset: step-counter;
                                            list-style: none;
                                            padding: 0;
                                        }
                                        .counter-reset-step li {
                                            counter-increment: step-counter;
                                        }
                                        .counter-reset-step li span::before {
                                            content: counter(step-counter);
                                        }
                                    `}</style>
                                    <div className="flex-1">
                                        {props.children}
                                    </div>
                                </li>
                            ),
                            p: (props) => <span {...props} />,
                        }}
                    >
                        {content}
                    </ReactMarkdown>
                </div>
            </div>
        </div>
    );
};

export const ExampleBlock = ({ type, content }: { type: 'Input' | 'Output', content: string }) => {
    if (!content) return null;
    return (
        <div className="mb-8 rounded-xl bg-slate-900 overflow-hidden text-slate-200">
            <div className="px-5 py-2.5 bg-slate-950 flex items-center justify-between border-b border-slate-800">
                <div className="flex items-center gap-2 text-slate-400 text-xs font-semibold uppercase tracking-wider">
                    {type === 'Input' ? <Terminal className="w-3.5 h-3.5" /> : <div className="w-3.5 h-3.5 rounded-full border border-slate-500" />}
                    {type} Example
                </div>
            </div>
            <div className="p-5 font-mono text-sm leading-relaxed whitespace-pre-wrap">
                {content}
            </div>
        </div>
    );
};

// Helper for tool URLs
const getToolUrl = (name?: string, url?: string) => {
    if (url) return url;
    if (!name) return 'https://chat.openai.com'; // Default

    const lower = name.toLowerCase();
    if (lower.includes('chatgpt') || lower.includes('gpt')) return 'https://chat.openai.com';
    if (lower.includes('claude')) return 'https://claude.ai';
    if (lower.includes('gemini')) return 'https://gemini.google.com';
    if (lower.includes('midjourney')) return 'https://discord.com/invite/midjourney';
    if (lower.includes('notion')) return 'https://www.notion.so';
    if (lower.includes('wrtn') || lower.includes('뤼튼')) return 'https://wrtn.ai';

    return 'https://chat.openai.com'; // Fallback
};

export const CopyBlock = ({ content, toolName, toolUrl }: { content: string, toolName?: string, toolUrl?: string }) => {
    if (!content) return null;
    const [copied, setCopied] = React.useState(false);

    // Clean up content: Remove code block markers if present
    const cleanContent = content.replace(/^```\w*\n?/, '').replace(/\n?```$/, '').trim();

    const handleCopy = async () => {
        try {
            await navigator.clipboard.writeText(cleanContent);
            setCopied(true);
            setTimeout(() => setCopied(false), 2000);
        } catch (err) {
            console.error('Failed to copy:', err);
        }
    };

    const handleRun = () => {
        handleCopy();
        const url = getToolUrl(toolName, toolUrl);
        window.open(url, '_blank');
    };

    return (
        <div className="my-6 rounded-2xl border-2 border-emerald-200 bg-gradient-to-br from-emerald-50 to-teal-50 overflow-hidden shadow-sm">
            {/* Header */}
            <div className="bg-emerald-600 text-white px-6 py-4 flex items-center justify-between">
                <div className="flex items-center gap-3">
                    <div className="p-2 bg-white/20 rounded-lg">
                        <Terminal className="w-5 h-5" />
                    </div>
                    <div>
                        <h4 className="font-bold text-lg">복붙 블록</h4>
                        <p className="text-emerald-100 text-sm mt-0.5">템플릿을 복사해서 AI 도구에 바로 사용하세요</p>
                    </div>
                </div>
                <div className="flex gap-2">
                    {toolName && toolUrl && (
                        <button
                            onClick={handleRun}
                            className="flex items-center gap-1.5 px-4 py-2 text-sm font-semibold text-emerald-600 bg-white rounded-lg hover:bg-emerald-50 transition-all shadow-lg"
                        >
                            <Terminal className="w-4 h-4" />
                            실행
                        </button>
                    )}
                    <button
                        onClick={handleCopy}
                        className={`
                            flex items-center gap-2 px-6 py-2 text-sm font-semibold rounded-lg shadow-lg transition-all duration-200
                            ${copied
                                ? 'bg-white text-emerald-600 hover:bg-white'
                                : 'bg-emerald-700 hover:bg-emerald-800 text-white'
                            }
                        `}
                    >
                        {copied ? (
                            <>
                                <Check className="w-4 h-4" />
                                복사완료!
                            </>
                        ) : (
                            <>
                                <div className="w-4 h-4 relative">
                                    <div className="absolute inset-0 border-2 border-current rounded-sm" />
                                    <div className="absolute inset-0 border-2 border-current rounded-sm translate-x-0.5 -translate-y-0.5 bg-emerald-600" />
                                </div>
                                복사하기
                            </>
                        )}
                    </button>
                </div>
            </div>

            {/* Content */}
            <div className="p-6 bg-white">
                <pre className="bg-slate-900 text-slate-50 p-6 rounded-xl overflow-x-auto text-sm leading-relaxed font-mono whitespace-pre-wrap border-2 border-slate-700 shadow-inner">
                    <code>{cleanContent}</code>
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
};



export const TipsBlock = ({ content }: { content: string | null | undefined }) => {
    // Default tips if specific content is missing
    const displayContent = content || `
- (X) AI의 답변을 맹신하지 않기
- (V) 답변이 이상하면 프롬프트를 수정해서 다시 질문하기
- (V) 중요한 정보는 반드시 교차 검증하기
`;

    return (
        <div className="mb-6 rounded-xl border border-yellow-200 bg-[#FFFBE6] p-5">
            <div className="flex items-center gap-2 mb-3 text-orange-800">
                <AlertTriangle className="w-5 h-5 text-orange-600" />
                <h5 className="font-bold text-base">자주하는 실수 & 팁</h5>
            </div>
            <div className="pl-1">
                <ReactMarkdown
                    remarkPlugins={[remarkGfm]}
                    components={{
                        ul: (props) => <ul className="space-y-3" {...props} />,
                        li: ({ children, ...props }) => {
                            // Helper to detect specific markers in text children
                            const getIconAndText = (nodes: React.ReactNode): { icon: React.ReactNode, text: React.ReactNode } => {
                                const childrenArray = React.Children.toArray(nodes);
                                let icon = null;
                                let processedNodes = childrenArray;

                                if (childrenArray.length > 0 && typeof childrenArray[0] === 'string') {
                                    const firstStr = childrenArray[0] as string;
                                    if (firstStr.startsWith('(X)') || firstStr.startsWith('(x)')) {
                                        icon = <XCircle className="w-5 h-5 text-red-500 mt-0.5 flex-shrink-0" />;
                                        processedNodes = [firstStr.replace(/^\(x\)\s*/i, ''), ...childrenArray.slice(1)];
                                    } else if (firstStr.startsWith('(V)') || firstStr.startsWith('(v)')) {
                                        icon = <CheckCircle2 className="w-5 h-5 text-emerald-500 mt-0.5 flex-shrink-0" />;
                                        processedNodes = [firstStr.replace(/^\(v\)\s*/i, ''), ...childrenArray.slice(1)];
                                    }
                                }

                                // Default icon if no marker found
                                if (!icon) {
                                    icon = <span className="mt-2 w-1.5 h-1.5 rounded-full bg-orange-400 flex-shrink-0" />;
                                }

                                return { icon, text: processedNodes };
                            };

                            const { icon, text } = getIconAndText(children);

                            return (
                                <li className="flex gap-3 text-sm text-slate-800 items-start leading-relaxed">
                                    {icon}
                                    <span className="flex-1">{text}</span>
                                </li>
                            );
                        },
                        p: (props) => <span {...props} />,
                    }}
                >
                    {displayContent}
                </ReactMarkdown>
            </div>
        </div>
    );
};

export const ChecklistBlock = ({ content, guideId, stepId }: { content: string | null | undefined, guideId?: number, stepId?: number | string }) => {
    const [items, setItems] = React.useState<{ id: string; text: string; checked: boolean }[]>([]);

    // Default content if missing
    const effectiveContent = content || `
- [ ] 내용을 충분히 이해했나요?
- [ ] 프롬프트를 직접 실행해 보았나요?
- [ ] 결과물이 만족스러운지 확인했나요?
`;

    // Initial parse
    React.useEffect(() => {
        // Storage key for persistence
        const storageKey = (guideId && stepId) ? `checklist_${guideId}_${stepId}` : null;
        let savedState: Record<string, boolean> = {};

        if (storageKey) {
            try {
                const saved = localStorage.getItem(storageKey);
                if (saved) savedState = JSON.parse(saved);
            } catch (e) {
                console.error("Failed to load checklist state", e);
            }
        }

        const lines = effectiveContent.split(/\r?\n/);
        const parsedItems = lines
            .map((line, index) => {
                // Match "- [ ] text" or "- [x] text" or just "- text" with optional leading whitespace
                const match = line.match(/^\s*[-*]\s+(\[([ xX])\])?\s*(.*)$/);
                if (!match) return null;

                const isCheckedMarkdown = match[2]?.toLowerCase() === 'x';
                const text = match[3];
                const id = `item-${index}`;

                // Use saved state if available, otherwise markdown state
                const checked = storageKey && (id in savedState) ? savedState[id] : isCheckedMarkdown;

                return { id, text, checked };
            })
            .filter((item): item is { id: string; text: string; checked: boolean } => item !== null);

        setItems(parsedItems);
    }, [effectiveContent, guideId, stepId]);

    const toggleItem = (itemId: string) => {
        setItems(prev => {
            const newItems = prev.map(item =>
                item.id === itemId ? { ...item, checked: !item.checked } : item
            );

            // Save to local storage
            if (guideId && stepId) {
                const storageKey = `checklist_${guideId}_${stepId}`;
                const stateToSave = newItems.reduce((acc, item) => ({
                    ...acc,
                    [item.id]: item.checked
                }), {});
                localStorage.setItem(storageKey, JSON.stringify(stateToSave));
            }

            return newItems;
        });
    };

    return (
        <div className="mb-6 rounded-xl border border-emerald-200 bg-white p-5 shadow-sm">
            <div className="flex items-center gap-2 mb-3 text-emerald-700">
                <Check className="w-5 h-5" />
                <h5 className="font-bold text-base">미니 체크리스트</h5>
            </div>
            <div className="pl-1 space-y-3">
                {items.map((item) => (
                    <div key={item.id} className="flex items-start gap-3 text-sm text-slate-700 group">
                        <div
                            className={`mt-0.5 w-5 h-5 rounded border flex items-center justify-center flex-shrink-0 cursor-pointer transition-colors ${item.checked
                                ? 'bg-emerald-500 border-emerald-500 text-white'
                                : 'border-slate-300 bg-white group-hover:border-emerald-400'
                                }`}
                            onClick={() => toggleItem(item.id)}
                        >
                            {item.checked && <Check className="w-3.5 h-3.5" strokeWidth={3} />}
                        </div>
                        <span
                            className={`flex-1 leading-relaxed cursor-pointer select-none transition-colors ${item.checked ? 'text-slate-400' : 'text-slate-700'}`}
                            onClick={() => toggleItem(item.id)}
                        >
                            {item.text}
                        </span>
                    </div>
                ))}
            </div>
        </div>
    );
};

export const BranchBlock = ({ content }: { content: string | null | undefined }) => {
    if (!content) return null;

    // Parse content into options
    // Expected format: **Title**: Description
    const lines = content.split(/\r?\n/).filter(line => line.trim());
    const options: { title: string; desc: string[] }[] = [];

    let currentOption: { title: string; desc: string[] } | null = null;

    lines.forEach(line => {
        // Match **Title**: ... or just **Title**
        const titleMatch = line.match(/^\s*\*\*(.+?)\*\*[:\s]*(.*)$/);

        if (titleMatch) {
            if (currentOption) options.push(currentOption);
            currentOption = {
                title: titleMatch[1],
                desc: titleMatch[2] ? [titleMatch[2]] : []
            };
        } else if (currentOption) {
            currentOption.desc.push(line);
        }
    });
    if (currentOption) options.push(currentOption);

    // Fallback if no strict structure found, just render markdown
    if (options.length === 0) {
        return (
            <div className="mb-8 bg-blue-50/50 rounded-xl border border-blue-100 p-5">
                <div className="flex items-center gap-2 mb-3 text-blue-700">
                    <div className="p-1 rounded bg-blue-100">
                        <Info className="w-4 h-4" />
                    </div>
                    <h4 className="font-bold text-base">선택하세요 (분기)</h4>
                </div>
                <MarkdownContent content={content} />
            </div>
        );
    }

    return (
        <div className="mb-8">
            <div className="flex items-center gap-2 mb-4 text-slate-800 px-1">
                <div className="p-1 rounded bg-indigo-100 text-indigo-600">
                    <span className="text-xs font-bold px-1">Branch</span>
                </div>
                <h4 className="font-bold text-base">상황별 선택 가이드</h4>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {options.map((opt, idx) => (
                    <div key={idx} className="bg-white rounded-xl border border-slate-200 p-5 shadow-sm hover:shadow-md transition-shadow relative overflow-hidden group h-full">
                        <div className="absolute top-0 left-0 w-1 h-full bg-indigo-500" />
                        <h5 className="font-bold text-lg text-slate-900 mb-3">{opt.title}</h5>
                        <div className="text-sm text-slate-600 space-y-1">
                            <MarkdownContent content={opt.desc.join('\n')} />
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );
};
