import { useState } from 'react';
import { useSortable } from '@dnd-kit/sortable';
import { useDroppable } from '@dnd-kit/core';
import { CSS } from '@dnd-kit/utilities';
import { GuideBlock } from './GuideBuilderLayout';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
import { BulletPointTextarea } from '@/components/ui/bullet-point-textarea';
import { GripVertical, Trash2, X, Lightbulb, TerminalSquare, AlertTriangle, ChevronDown, ChevronUp } from 'lucide-react';
import { cn } from '@/lib/utils';
import { Label } from '@/components/ui/label';

interface BuilderBlockProps {
    block: GuideBlock;
    stepIndex?: number;
    onRemove: (id: string) => void;
    onUpdate: (id: string, content: any) => void;
}

export function BuilderBlock({ block, stepIndex, onRemove, onUpdate }: BuilderBlockProps) {
    const [isCollapsed, setIsCollapsed] = useState(false);

    const {
        attributes,
        listeners,
        setNodeRef,
        transform,
        transition,
        isDragging,
    } = useSortable({ id: block.id });

    // Separate droppable for the children area of a Step
    const { setNodeRef: setDroppableRef, isOver: isDroppableOver } = useDroppable({
        id: `${block.id}-dropzone`,
        data: {
            parentId: block.id,
            isStepDropZone: true,
        },
        disabled: block.type !== 'step',
    });

    const style = {
        transform: CSS.Transform.toString(transform),
        transition,
        opacity: isDragging ? 0.4 : 1,
    };

    const handleContentChange = (key: string, value: string) => {
        onUpdate(block.id, { [key]: value });
    };

    return (
        <div
            id={block.id}
            ref={setNodeRef}
            style={style}
            className={cn(
                "group relative bg-white border border-slate-200 rounded-2xl shadow-sm hover:shadow-md transition-shadow",
                isDragging && "ring-2 ring-emerald-500 shadow-xl z-50 bg-white"
            )}
        >
            {/* Drag Handle & Controls */}
            <div
                {...attributes}
                {...listeners}
                className="absolute -left-10 top-4 w-8 h-8 flex items-center justify-center text-slate-300 hover:text-slate-600 cursor-grab active:cursor-grabbing rounded-lg hover:bg-slate-100 transition-colors"
            >
                <GripVertical className="w-5 h-5" />
            </div>

            <div className="p-6">
                <div className="flex justify-between items-start mb-4">
                    <div className="flex items-center gap-2">
                        <span className="bg-slate-100 text-slate-500 text-xs font-bold px-2 py-1 rounded uppercase tracking-wider">
                            {block.type === 'step' ? `STEP ${stepIndex}` : `${block.type} BLOCK`}
                        </span>

                        {/* Tool Selector (Only for Step Blocks) */}
                        {block.type === 'step' && (
                            <select
                                className="h-6 text-xs bg-slate-50 border border-slate-200 rounded px-2 text-slate-600 focus:outline-none focus:ring-1 focus:ring-emerald-500"
                                value={block.content.tool || 'ChatGPT'}
                                onChange={(e) => handleContentChange('tool', e.target.value)}
                            >
                                <option value="ChatGPT">ChatGPT</option>
                                <option value="Claude">Claude</option>
                                <option value="Midjourney">Midjourney</option>
                                <option value="Gemini">Gemini</option>
                                <option value="Custom">직접 입력</option>
                            </select>
                        )}
                    </div>

                    <div className="flex items-center gap-1">
                        {/* Collapsible Toggle */}
                        <button
                            onClick={() => setIsCollapsed(!isCollapsed)}
                            className="text-slate-400 hover:text-slate-600 transition-colors p-1 rounded hover:bg-slate-100"
                        >
                            {isCollapsed ? <ChevronDown className="w-4 h-4" /> : <ChevronUp className="w-4 h-4" />}
                        </button>

                        <button
                            onClick={() => onRemove(block.id)}
                            className="text-slate-400 hover:text-red-500 transition-colors p-1 rounded hover:bg-red-50"
                        >
                            <Trash2 className="w-4 h-4" />
                        </button>
                    </div>
                </div>

                {/* Collapsible Content */}
                <div className={cn(
                    "space-y-4 transition-all duration-300 ease-in-out overflow-hidden",
                    isCollapsed ? "max-h-0 opacity-0" : "max-h-[2000px] opacity-100"
                )}>
                    {block.type === 'title' && (
                        <>
                            <div className="space-y-1">
                                <Label>가이드 제목</Label>
                                <Input
                                    placeholder="예: 초보자를 위한 미드저니 시작하기"
                                    className="text-lg font-bold"
                                    value={block.content.title || ''}
                                    onChange={(e) => handleContentChange('title', e.target.value)}
                                />
                            </div>
                            <div className="space-y-1">
                                <Label>한 줄 요약</Label>
                                <Textarea
                                    placeholder="이 가이드를 통해 무엇을 얻을 수 있는지 짧게 설명해주세요."
                                    value={block.content.summary || ''}
                                    onChange={(e) => handleContentChange('summary', e.target.value)}
                                />
                            </div>
                        </>
                    )}

                    {block.type === 'step' && (
                        <div className="space-y-6">
                            {/* 1. Header: Step Number & Title */}
                            <div className="flex items-center gap-4">
                                <div className="w-12 h-12 rounded-full bg-slate-100 border border-slate-200 flex items-center justify-center text-slate-500 font-bold text-xl shadow-sm">
                                    {stepIndex || 1}
                                </div>
                                <div className="flex-1">
                                    <Input
                                        placeholder="단계 제목 (예: 공식 사이트 접속 & 계정 생성)"
                                        className="text-lg font-bold border-none shadow-none focus-visible:ring-0 px-0 placeholder:text-slate-300"
                                        value={block.content.title || ''}
                                        onChange={(e) => handleContentChange('title', e.target.value)}
                                    />
                                    <div className="h-px bg-slate-100 w-full" />
                                </div>
                            </div>

                            {/* 2. Goal & Done When (2 Columns) */}
                            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                {/* GOAL */}
                                <div className="bg-emerald-50/50 border border-emerald-100 rounded-xl p-4 space-y-2">
                                    <div className="flex items-center gap-2 text-emerald-600 font-bold text-xs uppercase tracking-wider">
                                        <div className="w-2 h-2 rounded-full bg-emerald-500" />
                                        Goal
                                    </div>
                                    <BulletPointTextarea
                                        placeholder="이 단계의 핵심 목표를 입력하세요."
                                        className="min-h-[80px] border-none bg-transparent focus-visible:ring-0 resize-none text-sm p-0 placeholder:text-emerald-700/30"
                                        value={block.content.goal || ''}
                                        onChange={(e) => handleContentChange('goal', e.target.value)}
                                    />
                                </div>

                                {/* DONE WHEN */}
                                <div className="bg-blue-50/50 border border-blue-100 rounded-xl p-4 space-y-2">
                                    <div className="flex items-center gap-2 text-blue-600 font-bold text-xs uppercase tracking-wider">
                                        <div className="w-2 h-2 rounded-sm bg-blue-500" />
                                        Done When
                                    </div>
                                    <BulletPointTextarea
                                        placeholder="이 단계가 완료되었다는 기준은 무엇인가요? (체크리스트)"
                                        className="min-h-[80px] border-none bg-transparent focus-visible:ring-0 resize-none text-sm p-0 placeholder:text-blue-700/30"
                                        value={block.content.doneWhen || ''}
                                        onChange={(e) => handleContentChange('doneWhen', e.target.value)}
                                    />
                                </div>
                            </div>

                            {/* 3. Why This Matters */}
                            {/* WHY THIS MATTERS */}
                            <div className="bg-amber-50/50 border border-amber-100 rounded-xl p-4 space-y-2">
                                <div className="flex items-center gap-2 text-amber-600 font-bold text-xs uppercase tracking-wider">
                                    <Lightbulb className="w-4 h-4" />
                                    Why This Matters
                                </div>
                                <BulletPointTextarea
                                    placeholder="이 단계가 왜 중요한지 설명해주세요 (동기 부여)"
                                    className="min-h-[60px] border-none bg-transparent focus-visible:ring-0 resize-none text-sm p-0 placeholder:text-amber-700/30"
                                    value={block.content.whyMatters || ''}
                                    onChange={(e) => handleContentChange('whyMatters', e.target.value)}
                                />
                            </div>
                            {/* 4. Nested Children (Action & Content) */}
                            <div className="mt-2 pt-4 border-t border-slate-100">
                                <Label className="text-slate-400 text-xs uppercase tracking-wider font-bold mb-3 block">
                                    Action & Content
                                </Label>
                                <div
                                    ref={setDroppableRef}
                                    className={cn(
                                        "bg-slate-50/50 rounded-xl border-2 border-dashed border-slate-200 min-h-[120px] transition-all duration-200",
                                        isDroppableOver
                                            ? "bg-emerald-50 border-emerald-500 ring-4 ring-emerald-200 scale-[1.02] shadow-inner"
                                            : "hover:bg-slate-50 hover:border-emerald-300/50"
                                    )}
                                >
                                    {block.children && block.children.length > 0 ? (
                                        <div className="p-4 space-y-3">
                                            {block.children.map((child) => (
                                                <div key={child.id} className="bg-white border border-slate-200 rounded-lg p-4 shadow-sm group hover:border-emerald-200 transition-all">
                                                    <div className="flex justify-between items-start mb-2">
                                                        <span className="text-xs font-bold text-slate-500 uppercase flex items-center gap-2">
                                                            {child.type}
                                                        </span>
                                                        <Button variant="ghost" size="icon" className="h-6 w-6 -mt-1 -mr-1" onClick={() => onRemove(child.id)}>
                                                            <Trash2 className="w-3 h-3 text-slate-300 hover:text-red-500" />
                                                        </Button>
                                                    </div>

                                                    {/* Child Content Rendering */}
                                                    <div className="w-full">
                                                        {child.type === 'action' && (
                                                            <div className="space-y-2">
                                                                <div className="flex items-center gap-2 text-violet-600 font-bold text-xs uppercase tracking-wider mb-1">
                                                                    <TerminalSquare className="w-3 h-3" />
                                                                    Action & Content
                                                                </div>
                                                                <Textarea
                                                                    placeholder="구체적인 행동 지침을 입력하세요 (예: 1. 웹 브라우저 주소창에...)"
                                                                    className="border-violet-100 bg-violet-50/30 focus:bg-white min-h-[80px] text-sm resize-none"
                                                                    value={child.content?.text || ''}
                                                                    onChange={(e) => onUpdate(child.id, { ...child.content, text: e.target.value })}
                                                                />
                                                            </div>
                                                        )}

                                                        {child.type === 'tips' && (
                                                            <div className="space-y-2 bg-amber-50 rounded-lg p-3 border border-amber-100">
                                                                <div className="flex items-center gap-2 text-amber-700 font-bold text-xs uppercase tracking-wider">
                                                                    <Lightbulb className="w-3 h-3 text-amber-500 fill-amber-500" />
                                                                    자주하는 실수 & 팁
                                                                </div>
                                                                <Textarea
                                                                    placeholder="유용한 팁이나 주의할 점을 적어주세요."
                                                                    className="border-none bg-transparent focus-visible:ring-0 min-h-[60px] text-sm p-0 placeholder:text-amber-700/40"
                                                                    value={child.content?.text || ''}
                                                                    onChange={(e) => onUpdate(child.id, { ...child.content, text: e.target.value })}
                                                                />
                                                            </div>
                                                        )}

                                                        {child.type === 'warning' && (
                                                            <div className="space-y-2 bg-red-50 rounded-lg p-3 border border-red-100">
                                                                <div className="flex items-center gap-2 text-red-700 font-bold text-xs uppercase tracking-wider">
                                                                    <AlertTriangle className="w-3 h-3" />
                                                                    주의사항
                                                                </div>
                                                                <Textarea
                                                                    placeholder="사용자가 꼭 주의해야 할 사항을 적어주세요."
                                                                    className="border-none bg-transparent focus-visible:ring-0 min-h-[60px] text-sm p-0 placeholder:text-red-700/40"
                                                                    value={child.content?.text || ''}
                                                                    onChange={(e) => onUpdate(child.id, { ...child.content, text: e.target.value })}
                                                                />
                                                            </div>
                                                        )}

                                                        {child.type === 'prompt' && (
                                                            <div className="space-y-2 bg-slate-900 rounded-lg p-3 border border-slate-700">
                                                                <div className="flex items-center justify-between">
                                                                    <span className="text-slate-400 font-mono text-xs">AI PROMPT</span>
                                                                    <Button size="sm" variant="secondary" className="h-6 text-xs bg-slate-800 text-slate-300 border-none">
                                                                        Copy
                                                                    </Button>
                                                                </div>
                                                                <Textarea
                                                                    placeholder="/imagine prompt..."
                                                                    className="border-none bg-transparent focus-visible:ring-0 min-h-[80px] font-mono text-sm text-slate-100 p-0 placeholder:text-slate-600"
                                                                    value={child.content?.text || ''}
                                                                    onChange={(e) => onUpdate(child.id, { ...child.content, text: e.target.value })}
                                                                />
                                                            </div>
                                                        )}



                                                        {child.type === 'branch' && (
                                                            <div className="space-y-3 bg-purple-50 rounded-lg p-3 border border-purple-200">
                                                                <div className="flex items-center gap-2 text-purple-700 font-bold text-xs uppercase tracking-wider">
                                                                    <svg className="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 9l4-4 4 4m0 6l-4 4-4-4" />
                                                                    </svg>
                                                                    A/B 분기
                                                                </div>
                                                                <Input
                                                                    placeholder="분기 질문 (예: 어떤 AI 툴을 사용하실 건가요?)"
                                                                    className="border-purple-200 text-sm"
                                                                    value={child.content?.question || ''}
                                                                    onChange={(e) => onUpdate(child.id, { ...child.content, question: e.target.value })}
                                                                />
                                                                <div className="grid grid-cols-2 gap-2">
                                                                    <div className="space-y-1">
                                                                        <div className="flex items-center gap-1 text-blue-600 font-bold text-xs">
                                                                            <div className="w-4 h-4 rounded-full bg-blue-500 text-white flex items-center justify-center text-[10px] font-bold">A</div>
                                                                            옵션 A
                                                                        </div>
                                                                        <Textarea
                                                                            placeholder="예: ChatGPT 사용하기"
                                                                            className="border-blue-200 text-xs min-h-[60px]"
                                                                            value={child.content?.optionA || ''}
                                                                            onChange={(e) => onUpdate(child.id, { ...child.content, optionA: e.target.value })}
                                                                        />
                                                                    </div>
                                                                    <div className="space-y-1">
                                                                        <div className="flex items-center gap-1 text-emerald-600 font-bold text-xs">
                                                                            <div className="w-4 h-4 rounded-full bg-emerald-500 text-white flex items-center justify-center text-[10px] font-bold">B</div>
                                                                            옵션 B
                                                                        </div>
                                                                        <Textarea
                                                                            placeholder="예: Claude 사용하기"
                                                                            className="border-emerald-200 text-xs min-h-[60px]"
                                                                            value={child.content?.optionB || ''}
                                                                            onChange={(e) => onUpdate(child.id, { ...child.content, optionB: e.target.value })}
                                                                        />
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        )}

                                                        {/* Fallback for other types */}
                                                        {!['action', 'tips', 'warning', 'prompt', 'branch'].includes(child.type) && (
                                                            <div className="p-2 bg-slate-100 rounded text-xs text-slate-500 text-center">
                                                                {child.type} 설정 폼
                                                            </div>
                                                        )}
                                                    </div>
                                                </div>
                                            ))}
                                        </div>
                                    ) : (
                                        <div className="h-full min-h-[120px] flex flex-col items-center justify-center text-slate-400 gap-2">
                                            <div className="w-8 h-8 rounded-full bg-slate-100 flex items-center justify-center">
                                                <GripVertical className="w-4 h-4 text-slate-300" />
                                            </div>
                                            <span className="text-sm font-medium">여기에 Action, Tips 등의 블록을 넣으세요</span>
                                        </div>
                                    )}
                                </div>
                            </div>
                            {/* 5. Fixed Content (Common Mistakes & Checklist) */}
                            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mt-6">
                                {/* Common Mistakes & Tips */}
                                <div className="bg-amber-50/50 border border-amber-100 rounded-xl p-4 space-y-2">
                                    <div className="flex items-center gap-2 text-amber-600 font-bold text-xs uppercase tracking-wider">
                                        <Lightbulb className="w-4 h-4" />
                                        자주하는 실수 & 팁
                                    </div>
                                    <BulletPointTextarea
                                        placeholder="이 단계에서 자주 실수하는 부분이나 유용한 팁을 적어주세요."
                                        className="min-h-[80px] border-none bg-transparent focus-visible:ring-0 resize-none text-sm p-0 placeholder:text-amber-700/30"
                                        value={block.content.commonMistakes || ''}
                                        onChange={(e) => handleContentChange('commonMistakes', e.target.value)}
                                    />
                                </div>

                                {/* Mini Checklist */}
                                <div className="bg-slate-50/50 border border-slate-100 rounded-xl p-4 space-y-2">
                                    <div className="flex items-center gap-2 text-slate-600 font-bold text-xs uppercase tracking-wider">
                                        <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
                                        미니 체크리스트
                                    </div>
                                    <BulletPointTextarea
                                        placeholder="다음 단계로 넘어가기 전 꼭 확인해야 할 것들을 적어주세요."
                                        className="min-h-[80px] border-none bg-transparent focus-visible:ring-0 resize-none text-sm p-0 placeholder:text-slate-400"
                                        value={block.content.miniChecklist || ''}
                                        onChange={(e) => handleContentChange('miniChecklist', e.target.value)}
                                    />
                                </div>
                            </div>
                        </div>
                    )}

                    {block.type === 'prompt' && (
                        <div className="bg-slate-900 p-4 rounded-xl space-y-3">
                            <Label className="text-slate-400">AI 프롬프트 입력</Label>
                            <Textarea
                                className="bg-transparent border-slate-700 text-slate-100 font-mono focus:ring-emerald-500/50 min-h-[100px]"
                                placeholder="/imagine prompt: a futuristic city..."
                                value={block.content.prompt || ''}
                                onChange={(e) => handleContentChange('prompt', e.target.value)}
                            />
                        </div>
                    )}

                    {block.type === 'branch' && (
                        <div className="space-y-4">
                            <div className="space-y-2">
                                <Label className="text-purple-700 font-bold">분기 질문</Label>
                                <Input
                                    placeholder="예: 어떤 AI 툴을 사용하실 건가요?"
                                    className="border-purple-200 focus:border-purple-500"
                                    value={block.content.question || ''}
                                    onChange={(e) => handleContentChange('question', e.target.value)}
                                />
                            </div>
                            <div className="grid grid-cols-2 gap-4">
                                <div className="bg-blue-50 border border-blue-200 rounded-xl p-4 space-y-2">
                                    <div className="flex items-center gap-2 text-blue-700 font-bold text-sm">
                                        <div className="w-6 h-6 rounded-full bg-blue-500 text-white flex items-center justify-center text-xs font-bold">A</div>
                                        옵션 A
                                    </div>
                                    <Input
                                        placeholder="예: ChatGPT 사용하기"
                                        className="border-blue-200"
                                        value={block.content.optionA || ''}
                                        onChange={(e) => handleContentChange('optionA', e.target.value)}
                                    />
                                    <Textarea
                                        placeholder="이 옵션을 선택하면 어떻게 되는지 설명해주세요."
                                        className="border-blue-200 min-h-[80px]"
                                        value={block.content.descriptionA || ''}
                                        onChange={(e) => handleContentChange('descriptionA', e.target.value)}
                                    />
                                </div>
                                <div className="bg-emerald-50 border border-emerald-200 rounded-xl p-4 space-y-2">
                                    <div className="flex items-center gap-2 text-emerald-700 font-bold text-sm">
                                        <div className="w-6 h-6 rounded-full bg-emerald-500 text-white flex items-center justify-center text-xs font-bold">B</div>
                                        옵션 B
                                    </div>
                                    <Input
                                        placeholder="예: Claude 사용하기"
                                        className="border-emerald-200"
                                        value={block.content.optionB || ''}
                                        onChange={(e) => handleContentChange('optionB', e.target.value)}
                                    />
                                    <Textarea
                                        placeholder="이 옵션을 선택하면 어떻게 되는지 설명해주세요."
                                        className="border-emerald-200 min-h-[80px]"
                                        value={block.content.descriptionB || ''}
                                        onChange={(e) => handleContentChange('descriptionB', e.target.value)}
                                    />
                                </div>
                            </div>
                        </div>
                    )}

                    {(block.type !== 'title' && block.type !== 'step' && block.type !== 'prompt' && block.type !== 'branch') && (
                        <div className="text-center py-4 text-slate-400 italic bg-slate-50 rounded-lg border border-dashed border-slate-200">
                            {block.type} 블록 설정 폼은 준비 중입니다.
                        </div>
                    )}
                </div>
            </div>
        </div >
    );
}
