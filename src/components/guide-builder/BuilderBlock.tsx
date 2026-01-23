import { useSortable } from '@dnd-kit/sortable';
import { useDroppable } from '@dnd-kit/core';
import { CSS } from '@dnd-kit/utilities';
import { GuideBlock } from './GuideBuilderLayout';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
import { GripVertical, Trash2, X, Lightbulb } from 'lucide-react';
import { cn } from '@/lib/utils';
import { Label } from '@/components/ui/label';

interface BuilderBlockProps {
    block: GuideBlock;
    onRemove: (id: string) => void;
    onUpdate: (id: string, content: any) => void;
}

export function BuilderBlock({ block, onRemove, onUpdate }: BuilderBlockProps) {
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
                            {block.type} BLOCK
                        </span>
                    </div>
                    <button
                        onClick={() => onRemove(block.id)}
                        className="text-slate-400 hover:text-red-500 transition-colors p-1 rounded hover:bg-red-50"
                    >
                        <Trash2 className="w-4 h-4" />
                    </button>
                </div>

                {/* Content Form based on Type */}
                <div className="space-y-4">
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
                                    1
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
                                    <Textarea
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
                                    <Textarea
                                        placeholder="이 단계가 완료되었다는 기준은 무엇인가요? (체크리스트)"
                                        className="min-h-[80px] border-none bg-transparent focus-visible:ring-0 resize-none text-sm p-0 placeholder:text-blue-700/30"
                                        value={block.content.doneWhen || ''}
                                        onChange={(e) => handleContentChange('doneWhen', e.target.value)}
                                    />
                                </div>
                            </div>

                            {/* 3. Why This Matters */}
                            <div className="bg-amber-50/50 border border-amber-100 rounded-xl p-4 space-y-2">
                                <div className="flex items-center gap-2 text-amber-600 font-bold text-xs uppercase tracking-wider">
                                    <Lightbulb className="w-4 h-4" />
                                    Why This Matters
                                </div>
                                <Textarea
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

                                                    {/* Child Input Area */}
                                                    <div className="w-full">
                                                        {(child.type === 'action' || child.type === 'tips' || child.type === 'warning') ? (
                                                            <Textarea
                                                                placeholder={`${child.type} 내용을 입력하세요...`}
                                                                className="border-0 bg-transparent p-0 focus-visible:ring-0 min-h-[40px] resize-none text-sm"
                                                            />
                                                        ) : (
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

                    {(block.type !== 'title' && block.type !== 'step' && block.type !== 'prompt') && (
                        <div className="text-center py-4 text-slate-400 italic bg-slate-50 rounded-lg border border-dashed border-slate-200">
                            {block.type} 블록 설정 폼은 준비 중입니다.
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
}
