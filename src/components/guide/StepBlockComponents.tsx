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

    return (
        <div className="mb-8 border border-purple-100 bg-white rounded-xl overflow-hidden shadow-sm">
            <div className="bg-purple-50 px-5 py-3 border-b border-purple-100 flex items-center gap-2">
                <div className="bg-purple-100 text-purple-700 p-1 rounded-md">
                    <Check className="w-4 h-4" />
                </div>
                <h4 className="font-bold text-slate-800">Action & Content</h4>
            </div>
            <div className="p-6">
                <div className="space-y-4 action-list-content">
                    {/* Scoped CSS for nested list hierarchy */}
                    <style>{`
                        /* Base Counters (Level 1) */
                        ul.counter-reset-step, ol.counter-reset-step {
                            counter-reset: step-counter;
                            list-style: none; /* Hide default for Level 1 */
                            padding: 0;
                        }
                        
                        /* Level 1 List Items */
                        .action-list-content > ul > li, 
                        .action-list-content > ol > li {
                            counter-increment: step-counter;
                            padding-left: 2.5rem; /* Matches pl-10 */
                        }
                        
                        .action-list-content > ul > li > .step-badge::before, 
                        .action-list-content > ol > li > .step-badge::before {
                            content: counter(step-counter);
                        }

                        /* Level 2+ Nested Lists (Bullets) */
                        .action-list-content li ul, 
                        .action-list-content li ol {
                            list-style: disc; /* Force bullets */
                            padding-left: 1.5rem;
                            margin-top: 0.5rem;
                            margin-bottom: 0.5rem;
                        }

                        /* Nested List Items */
                        .action-list-content li li {
                            padding-left: 0 !important; /* Override React component's pl-10 */
                            display: list-item;
                        }

                        /* Hide Badge for Nested Items */
                        .action-list-content li li .step-badge {
                            display: none;
                        }
                    `}</style>
                    <ReactMarkdown
                        remarkPlugins={[remarkGfm]}
                        components={{
                            // Force both ul and ol to look like numbered steps
                            ul: (props) => <ul className="space-y-4 counter-reset-step" {...props} />,
                            ol: (props) => <ol className="space-y-4 counter-reset-step" {...props} />,
                            li: (props) => (
                                <li className="relative pl-10 text-sm text-slate-700 leading-relaxed group">
                                    {/* Number Badge */}
                                    <span className="step-badge absolute left-0 top-0 flex items-center justify-center w-6 h-6 text-xs font-bold text-purple-600 bg-purple-100 rounded-full ring-4 ring-white transition-colors z-10">
                                        {/* CSS Content handles number */}
                                    </span>
                                    {/* Optional Connector Line for main steps (visual flair, optional) - skipping for now to reduce clutter */}

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

// New Input/Output Block with side-by-side layout
// New Input/Output Block with side-by-side layout
export const InputOutputBlock = ({ inputContent, processContent, outputContent }: { inputContent?: string, processContent?: string, outputContent?: string }) => {
    if (!inputContent && !processContent && !outputContent) return null;

    // Helper to clean quotes and backticks
    const cleanQuotes = (text: string) => {
        return text
            .replace(/^["'`]+|["'`]+$/g, '') // Remove leading/trailing quotes
            .replace(/^```\w*\n?/, '').replace(/\n?```$/, '') // Remove code block markers
            .trim();
    };

    // If only one is provided, show the old single block style
    if ((!inputContent && !processContent) || (!inputContent && !outputContent) || (!processContent && !outputContent && !inputContent)) {
        // Fallback logic if we just have one block can be complex with 3 items. 
        // But usually we have at least Input+Output or Input+Process+Output.
        // If we strictly have just one, render simple block.
        const content = cleanQuotes(inputContent || processContent || outputContent || '');
        const type = inputContent ? 'Input' : (processContent ? 'Process' : 'Output');
        return (
            <div className="mb-8 rounded-xl bg-slate-900 overflow-hidden text-slate-200">
                <div className="px-5 py-2.5 bg-slate-950 flex items-center justify-between border-b border-slate-800">
                    <div className="flex items-center gap-2 text-slate-400 text-xs font-semibold uppercase tracking-wider">
                        {type === 'Input' ? <Terminal className="w-3.5 h-3.5" /> :
                            type === 'Process' ? <div className="w-3.5 h-3.5 rounded-full border border-purple-500 bg-purple-500/20" /> :
                                <div className="w-3.5 h-3.5 rounded-full border border-emerald-500 bg-emerald-500/20" />}
                        {type} Example
                    </div>
                </div>
                <div className="p-5 font-mono text-sm leading-relaxed whitespace-pre-wrap">
                    {content}
                </div>
            </div>
        );
    }

    const cleanedInput = inputContent ? cleanQuotes(inputContent) : '';
    const cleanedProcess = processContent ? cleanQuotes(processContent) : '';
    const cleanedOutput = outputContent ? cleanQuotes(outputContent) : '';

    const hasProcess = !!cleanedProcess;

    // Layout configuration
    // If we have Process, use 3 columns on LG. If not, 2 columns.
    const gridCols = hasProcess ? "grid-cols-1 lg:grid-cols-3" : "grid-cols-1 lg:grid-cols-2";

    return (
        <div className="mb-8">
            <div className="flex items-center gap-2 mb-3 text-slate-700">
                <Terminal className="w-4 h-4" />
                <h4 className="font-bold text-sm uppercase tracking-wide">Example</h4>
            </div>
            <div className={`grid ${gridCols} gap-4 relative`}>
                {/* Input Block */}
                {cleanedInput && (
                    <div className="rounded-xl bg-slate-900 overflow-hidden text-slate-200 shadow-lg border border-slate-700 flex flex-col h-full">
                        <div className="px-5 py-3 bg-gradient-to-r from-blue-900 to-indigo-900 border-b border-slate-700 flex-shrink-0">
                            <div className="flex items-center gap-2 text-white">
                                <div className="p-1.5 bg-white/20 rounded-md">
                                    <Terminal className="w-4 h-4" />
                                </div>
                                <span className="font-bold text-sm uppercase tracking-wider">Input</span>
                            </div>
                        </div>
                        <div className="p-6 font-mono text-sm leading-relaxed whitespace-pre-wrap bg-slate-900 flex-1">
                            {cleanedInput}
                        </div>
                    </div>
                )}

                {/* Arrow 1: Input -> Next (Process or Output) */}
                <div className={`hidden lg:flex absolute top-1/2 -translate-y-1/2 z-10 ${hasProcess ? 'left-[33%]' : 'left-1/2'} -translate-x-1/2`}>
                    <div className="bg-white rounded-full p-2 shadow-xl border-4 border-slate-100">
                        <svg className="w-5 h-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M9 5l7 7-7 7" />
                        </svg>
                    </div>
                </div>

                {/* Process Block (Optional) */}
                {cleanedProcess && (
                    <>
                        <div className="rounded-xl bg-slate-900 overflow-hidden text-slate-200 shadow-lg border border-slate-700 flex flex-col h-full">
                            <div className="px-5 py-3 bg-gradient-to-r from-violet-900 to-purple-900 border-b border-slate-700 flex-shrink-0">
                                <div className="flex items-center gap-2 text-white">
                                    <div className="p-1.5 bg-white/20 rounded-md">
                                        <div className="w-4 h-4 flex items-center justify-center font-bold text-xs">P</div>
                                    </div>
                                    <span className="font-bold text-sm uppercase tracking-wider">Process</span>
                                </div>
                            </div>
                            <div className="p-6 font-mono text-sm leading-relaxed whitespace-pre-wrap bg-slate-900 flex-1">
                                {cleanedProcess}
                            </div>
                        </div>

                        {/* Arrow 2: Process -> Output */}
                        <div className="hidden lg:flex absolute left-[66%] top-1/2 -translate-x-1/2 -translate-y-1/2 z-10">
                            <div className="bg-white rounded-full p-2 shadow-xl border-4 border-slate-100">
                                <svg className="w-5 h-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M9 5l7 7-7 7" />
                                </svg>
                            </div>
                        </div>
                    </>
                )}

                {/* Output Block */}
                {cleanedOutput && (
                    <div className="rounded-xl bg-slate-900 overflow-hidden text-slate-200 shadow-lg border border-slate-700 flex flex-col h-full">
                        <div className="px-5 py-3 bg-gradient-to-r from-emerald-900 to-teal-900 border-b border-slate-700 flex-shrink-0">
                            <div className="flex items-center gap-2 text-white">
                                <div className="p-1.5 bg-white/20 rounded-md">
                                    <CheckCircle2 className="w-4 h-4" />
                                </div>
                                <span className="font-bold text-sm uppercase tracking-wider">Output</span>
                            </div>
                        </div>
                        <div className="p-6 font-mono text-sm leading-relaxed whitespace-pre-wrap bg-slate-900 flex-1">
                            {cleanedOutput}
                        </div>
                    </div>
                )}
            </div>
        </div>
    );
};

export const BranchBlock = ({ content }: { content: string | null | undefined }) => {
    // If content is empty or explicitly says "None" (in Korean or English), don't render
    if (!content ||
        content.includes('없음 (이 단계는 분기 없음)') ||
        content.trim() === '없음' ||
        content.toLowerCase().includes('none (no branch)')) {
        return null;
    }

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
                <div className="prose prose-sm max-w-none prose-p:my-1 prose-ul:my-1 prose-ol:my-1">
                    <ReactMarkdown
                        remarkPlugins={[remarkGfm]}
                        components={{
                            p: (props) => <p className="text-sm text-slate-700 leading-relaxed" {...props} />,
                            strong: (props) => <strong className="font-semibold text-blue-900" {...props} />,
                            li: (props) => <li className="text-sm text-slate-700" {...props} />,
                        }}
                    >
                        {content}
                    </ReactMarkdown>
                </div>
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
                            <div className="prose prose-sm max-w-none">
                                <ReactMarkdown
                                    remarkPlugins={[remarkGfm]}
                                    components={{
                                        p: (props) => <p className="text-sm text-slate-600 leading-relaxed" {...props} />,
                                    }}
                                >
                                    {opt.desc.join('\n')}
                                </ReactMarkdown>
                            </div>
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );
};

// Keep ExampleBlock for backward compatibility
export const ExampleBlock = ({ type, content }: { type: 'Input' | 'Process' | 'Output' | 'Example', content: string }) => {
    if (!content) return null;

    // Helper: Determine icon and color based on type or specific title
    const getIconAndStyle = (type: string, title: string = '') => {
        const lowerTitle = title.toLowerCase();
        let icon = <Terminal className="w-3.5 h-3.5" />;
        let style = "bg-slate-950 border-slate-800";
        // Gradient headers based on content
        if (lowerTitle.includes('input') || lowerTitle.includes('입력') || type === 'Input') {
            return { icon: <Terminal className="w-3.5 h-3.5" />, headerBg: "bg-gradient-to-r from-blue-900 to-indigo-900", borderColor: "border-slate-700" };
        }
        if (lowerTitle.includes('process') || lowerTitle.includes('과정') || type === 'Process') {
            return { icon: <div className="w-3.5 h-3.5 flex items-center justify-center font-bold text-[10px]">P</div>, headerBg: "bg-gradient-to-r from-violet-900 to-purple-900", borderColor: "border-slate-700" };
        }
        if (lowerTitle.includes('output') || lowerTitle.includes('출력') || lowerTitle.includes('result') || type === 'Output') {
            return { icon: <CheckCircle2 className="w-3.5 h-3.5" />, headerBg: "bg-gradient-to-r from-emerald-900 to-teal-900", borderColor: "border-slate-700" };
        }
        // Default generic
        return { icon: <div className="w-3.5 h-3.5 rounded-full border border-slate-500 bg-slate-500/20" />, headerBg: "bg-slate-950", borderColor: "border-slate-800" };
    };


    // If type is 'Example', try to parse multiple sections for grid layout
    if (type === 'Example') {
        const lines = content.split(/\r?\n/).filter(line => line.trim());
        const sections: { title: string; body: string[] }[] = [];
        let currentSection: { title: string; body: string[] } | null = null;
        let parsingStarted = false;

        lines.forEach(line => {
            // Match **Title**: or **Title** (at start of line)
            const titleMatch = line.match(/^\s*\*\*(.+?)\*\*[:\s]*(.*)$/);

            if (titleMatch) {
                // Save previous section
                if (currentSection) sections.push(currentSection);

                // Start new section
                currentSection = {
                    title: titleMatch[1],
                    body: titleMatch[2] ? [titleMatch[2]] : []
                };
                parsingStarted = true;
            } else if (currentSection) {
                currentSection.body.push(line);
            } else if (!parsingStarted) {
                // Content before any header (intro text)
                // We can either ignore it or put it in a "Intro" section. 
                // For now let's assume valid structure starts with **Title**.
                // Or treat as single block if no structure found at all.
            }
        });
        if (currentSection) sections.push(currentSection);

        // Render Grid if we found multiple sections (or at least one valid section structure)
        if (sections.length > 0) {

            // Analyze sections to determine grid layout
            const nonFullWidthCount = sections.filter(sec => {
                const lowerTitle = sec.title.toLowerCase();
                return !(lowerTitle.includes('scenario') ||
                    lowerTitle.includes('시나리오') ||
                    lowerTitle.includes('basic prompt') ||
                    lowerTitle.includes('기본 프롬프트'));
            }).length;

            // Use 3 columns if we have exactly 3 regular items (e.g., Step 7: Step 1, 2, 3), otherwise 2 columns
            const useThreeCols = nonFullWidthCount === 3;
            const gridClass = useThreeCols ? "grid-cols-1 lg:grid-cols-3" : "grid-cols-1 lg:grid-cols-2";

            return (
                <div className="mb-8">
                    {/* Optional: Generic 'Example' header above the grid if strictly needed, 
                         but Step 6 usually has its own header implies context. 
                         Let's add a small header if it's a grid to denote "Examples" */}
                    <div className="flex items-center gap-2 mb-3 text-slate-700">
                        <Terminal className="w-4 h-4" />
                        <h4 className="font-bold text-sm uppercase tracking-wide">Examples</h4>
                    </div>

                    <div className={`grid ${gridClass} gap-4`}>
                        {sections.map((sec, idx) => {
                            const { icon, headerBg, borderColor } = getIconAndStyle('Example', sec.title);

                            // Check if this section should span full width
                            const lowerTitle = sec.title.toLowerCase();
                            const isFullWidth = lowerTitle.includes('scenario') ||
                                lowerTitle.includes('시나리오') ||
                                lowerTitle.includes('basic prompt') ||
                                lowerTitle.includes('기본 프롬프트');

                            // Determine colspan based on grid total columns
                            const totalCols = useThreeCols ? 3 : 2;
                            const colSpanClass = isFullWidth
                                ? (totalCols === 3 ? "lg:col-span-3" : "lg:col-span-2")
                                : "lg:col-span-1";

                            return (
                                <div key={idx} className={`rounded-xl bg-slate-900 overflow-hidden text-slate-200 shadow-lg border ${borderColor} flex flex-col h-full ${colSpanClass}`}>
                                    <div className={`px-5 py-3 ${headerBg} border-b ${borderColor} flex-shrink-0`}>
                                        <div className="flex items-center gap-2 text-white">
                                            <div className="p-1.5 bg-white/20 rounded-md">
                                                {icon}
                                            </div>
                                            <span className="font-bold text-sm uppercase tracking-wider truncate">{sec.title}</span>
                                        </div>
                                    </div>
                                    <div className="p-5 font-mono text-sm leading-relaxed whitespace-pre-wrap bg-slate-900 flex-1">
                                        <ReactMarkdown
                                            remarkPlugins={[remarkGfm]}
                                            components={{
                                                // Unifying all text to white (slate-200) as requested
                                                p: ({ node, ...props }) => <p className="text-slate-200 font-normal mb-1" {...props} />,
                                                li: ({ node, ...props }) => <li className="text-slate-200 font-normal" {...props} />,
                                                code: ({ node, ...props }) => <span className="font-mono text-slate-200 font-normal" {...props} />,
                                                pre: ({ node, ...props }) => {
                                                    // Remove ref to avoid type error
                                                    const { ref, ...rest } = props as any;
                                                    return <div className="my-2 bg-slate-950/50 p-3 rounded-lg border border-slate-800" {...rest} />;
                                                },
                                            }}
                                        >
                                            {sec.body.join('\n')}
                                        </ReactMarkdown>
                                    </div>
                                </div>
                            );
                        })}
                    </div>
                </div>
            );
        }
    }

    // Fallback: Default Single Block Rendering (for Input/Process/Output or unstructured Example)
    const { icon, headerBg, borderColor } = getIconAndStyle(type);

    return (
        <div className={`mb-8 rounded-xl bg-slate-900 overflow-hidden text-slate-200 border ${borderColor}`}>
            <div className={`px-5 py-2.5 ${headerBg} flex items-center justify-between border-b ${borderColor}`}>
                <div className="flex items-center gap-2 text-slate-200 text-xs font-semibold uppercase tracking-wider">
                    {icon}
                    {type === 'Example' ? 'Example' : `${type} Example`}
                </div>
            </div>
            <div className="p-5 font-mono text-sm leading-relaxed whitespace-pre-wrap">
                {type === 'Example' ? (
                    <ReactMarkdown
                        remarkPlugins={[remarkGfm]}
                        components={{
                            // GitHub Alerts support
                            blockquote: ({ node, children, ...props }) => {
                                // Extract text content to detect alert type
                                const textContent = node.children
                                    .map((child: any) => {
                                        if (child.type === 'paragraph' && child.children) {
                                            return child.children.map((c: any) => c.value || '').join('');
                                        }
                                        return '';
                                    })
                                    .join('');

                                // Check for GitHub Alert patterns
                                const alertMatch = textContent.match(/^\[!(WARNING|TIP|NOTE|IMPORTANT|CAUTION)\]/);

                                if (alertMatch) {
                                    const alertType = alertMatch[1];

                                    // Style configurations for different alert types
                                    const alertStyles = {
                                        WARNING: {
                                            bg: 'bg-red-900/30',
                                            border: 'border-red-700/50',
                                            icon: <AlertTriangle className="w-4 h-4 text-red-400" />,
                                            titleColor: 'text-red-400',
                                            textColor: 'text-red-200'
                                        },
                                        TIP: {
                                            bg: 'bg-emerald-900/30',
                                            border: 'border-emerald-700/50',
                                            icon: <Lightbulb className="w-4 h-4 text-emerald-400" />,
                                            titleColor: 'text-emerald-400',
                                            textColor: 'text-emerald-200'
                                        },
                                        NOTE: {
                                            bg: 'bg-blue-900/30',
                                            border: 'border-blue-700/50',
                                            icon: <Info className="w-4 h-4 text-blue-400" />,
                                            titleColor: 'text-blue-400',
                                            textColor: 'text-blue-200'
                                        },
                                        IMPORTANT: {
                                            bg: 'bg-purple-900/30',
                                            border: 'border-purple-700/50',
                                            icon: <div className="w-4 h-4 rounded-full bg-purple-400" />,
                                            titleColor: 'text-purple-400',
                                            textColor: 'text-purple-200'
                                        },
                                        CAUTION: {
                                            bg: 'bg-amber-900/30',
                                            border: 'border-amber-700/50',
                                            icon: <AlertTriangle className="w-4 h-4 text-amber-400" />,
                                            titleColor: 'text-amber-400',
                                            textColor: 'text-amber-200'
                                        }
                                    };

                                    const style = alertStyles[alertType as keyof typeof alertStyles];

                                    return (
                                        <div className={`rounded-lg border ${style.border} ${style.bg} p-4 my-3 not-prose`}>
                                            <div className="flex gap-3">
                                                <div className="flex-shrink-0 mt-0.5">{style.icon}</div>
                                                <div className="flex-1 font-sans">
                                                    <ReactMarkdown
                                                        remarkPlugins={[remarkGfm]}
                                                        components={{
                                                            p: ({ children, ...props }) => {
                                                                // Remove the [!TYPE] from first paragraph
                                                                const childText = typeof children === 'string' ? children : '';
                                                                const cleanedText = childText.replace(/^\[!\w+\]\s*/, '');
                                                                return <p className={`${style.textColor} text-sm leading-relaxed mb-1 last:mb-0`} {...props}>{cleanedText || children}</p>;
                                                            },
                                                            strong: ({ node, ...props }) => <strong className={`${style.titleColor} font-bold`} {...props} />,
                                                        }}
                                                    >
                                                        {textContent.replace(/^\[!\w+\]\s*/, '')}
                                                    </ReactMarkdown>
                                                </div>
                                            </div>
                                        </div>
                                    );
                                }

                                // Default blockquote (no alert detected)
                                return <blockquote className="border-l-4 border-slate-700 pl-4 my-2 italic text-slate-400" {...props}>{children}</blockquote>;
                            },
                            strong: ({ node, ...props }) => <span className="font-bold text-white block mt-4 first:mt-0 mb-2 text-base border-b border-slate-700 pb-1" {...props} />,
                            p: ({ node, ...props }) => <p className="mb-2 last:mb-0" {...props} />,
                            ul: ({ node, ...props }) => <ul className="list-disc pl-5 mb-2 space-y-1" {...props} />,
                            ol: ({ node, ...props }) => <ol className="list-decimal pl-5 mb-2 space-y-1" {...props} />,
                            code: ({ node, ...props }) => <code className="bg-slate-800 px-1 py-0.5 rounded text-emerald-300 font-normal" {...props} />,
                            pre: ({ node, ...props }) => {
                                const { ref, ...rest } = props as any;
                                return <div className="my-2 bg-slate-950/50 p-3 rounded-lg border border-slate-800" {...rest} />;
                            },
                        }}
                    >
                        {content}
                    </ReactMarkdown>
                ) : (
                    content
                )}
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

    // 1. Try to extract footer strictly OUTSIDE the last code block
    const lastFenceIndex = content.lastIndexOf('```');
    const firstFenceIndex = content.indexOf('```');

    let mainContent = content;
    let footerText = '';

    if (firstFenceIndex !== -1 && lastFenceIndex !== -1 && firstFenceIndex !== lastFenceIndex) {
        // We have fences. Split by the last closing fence.
        const rawCodePart = content.substring(0, lastFenceIndex);
        const rawFooterPart = content.substring(lastFenceIndex + 3);

        mainContent = rawCodePart.replace(/^```(?:\w*\n)?/, '').trim();
        footerText = rawFooterPart.trim();
    } else {
        // No valid fences, treat all as content
        mainContent = content.trim();
    }

    // 2. If no footer found outside, look INSIDE mainContent (for legacy inner pattern)
    // This handles cases where the user wrote the footer INSIDE the fences.
    if (!footerText) {
        // Regex to find "**이 템플릿을...**" (or generic bold footer)
        const legacyFooterRegex = /(\*\*이 템플릿을.+?(\*\*|$))/s;
        const match = mainContent.match(legacyFooterRegex);

        if (match) {
            footerText = match[1].replace(/\*\*/g, '').trim();
            mainContent = mainContent.replace(match[0], '').trim();
        }
    }

    const handleCopy = async () => {
        try {
            await navigator.clipboard.writeText(mainContent);
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
        <div className="mb-8 group">
            <div className="relative rounded-xl border border-slate-200 bg-slate-50 overflow-hidden transition-all hover:border-slate-300 hover:shadow-sm">
                {/* Header */}
                <div className="flex items-center justify-between px-5 py-3 border-b border-slate-200/60 bg-slate-100/50">
                    <div className="flex items-center gap-2">
                        <div className="p-1 rounded bg-white border border-slate-200 shadow-sm">
                            <Terminal className="w-3 h-3 text-slate-500" />
                        </div>
                        <span className="font-semibold text-sm text-slate-700">Copy Block</span>
                    </div>
                    <div className="flex items-center gap-2">
                        <button
                            onClick={handleRun}
                            className="flex items-center gap-1.5 px-2.5 py-1.5 text-xs font-bold text-white bg-gradient-to-r from-blue-600 to-indigo-600 rounded-md hover:opacity-90 transition-opacity shadow-sm"
                        >
                            <Terminal className="w-3.5 h-3.5" />
                            <span>Run</span>
                        </button>
                        <button
                            onClick={handleCopy}
                            className="flex items-center gap-1.5 px-2.5 py-1.5 text-xs font-medium text-slate-600 bg-white border border-slate-200 rounded-md hover:bg-slate-50 hover:text-slate-900 transition-colors shadow-sm"
                        >
                            {copied ? (
                                <>
                                    <Check className="w-3.5 h-3.5 text-emerald-500" />
                                    <span className="text-emerald-600">Copied</span>
                                </>
                            ) : (
                                <>
                                    <div className="w-3.5 h-3.5 relative">
                                        <div className="absolute inset-0 border-2 border-slate-400 rounded-sm" />
                                        <div className="absolute inset-0 border-2 border-slate-400 rounded-sm translate-x-0.5 -translate-y-0.5 bg-white" />
                                    </div>
                                    <span>Copy</span>
                                </>
                            )}
                        </button>
                    </div>
                </div>

                {/* Content */}
                <div className="p-5 text-sm text-slate-700 leading-snug font-sans">
                    <ReactMarkdown
                        remarkPlugins={[remarkGfm]}
                        components={{
                            code: ({ node, ...props }) => <span className="font-mono text-slate-800 bg-slate-200/60 px-1 py-0.5 rounded text-[13px]" {...props} />,
                            pre: ({ node, ...props }) => {
                                const { ref, ...rest } = props as any;
                                return <div className="not-prose" {...rest} />;
                            },
                            p: ({ node, ...props }) => <div className="mb-1 last:mb-0" {...props} />,
                            ul: ({ node, ...props }) => <ul className="list-disc pl-5 space-y-0.5 my-1" {...props} />,
                            ol: ({ node, ...props }) => <ol className="list-decimal pl-5 space-y-0.5 my-1" {...props} />,
                        }}
                    >
                        {mainContent}
                    </ReactMarkdown>
                </div>

            </div>

            {/* Footer (if exists) - Moved outside */}
            {footerText && (
                <div className="mt-2.5 flex items-start gap-1.5 px-1 text-xs text-slate-500 font-medium whitespace-pre-wrap">
                    <Info className="w-3.5 h-3.5 flex-shrink-0 mt-0.5 text-slate-400" />
                    <span>{footerText}</span>
                </div>
            )}
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


