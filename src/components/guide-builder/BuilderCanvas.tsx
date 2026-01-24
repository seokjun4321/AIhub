import { useDroppable } from '@dnd-kit/core';
import { SortableContext, verticalListSortingStrategy } from '@dnd-kit/sortable';
import { GuideBlock } from './GuideBuilderLayout';
import { BuilderBlock } from './BuilderBlock';
import { cn } from '@/lib/utils';

interface BuilderCanvasProps {
    blocks: GuideBlock[];
    onRemove: (id: string) => void;
    onUpdate: (id: string, content: any) => void;
}

export function BuilderCanvas({ blocks, onRemove, onUpdate }: BuilderCanvasProps) {
    const { setNodeRef, isOver } = useDroppable({
        id: 'canvas-droppable',
    });

    return (
        <div
            ref={setNodeRef}
            className={cn(
                "min-h-[800px] w-full rounded-3xl transition-colors border-2 border-dashed",
                isOver ? "bg-emerald-50/50 border-emerald-300" : "bg-transparent border-transparent",
                blocks.length === 0 && !isOver && "border-slate-200"
            )}
        >
            {blocks.length === 0 ? (
                <div className="h-full flex flex-col items-center justify-center text-center p-12 text-slate-400 min-h-[600px]">
                    <div className="w-20 h-20 rounded-full bg-slate-100 flex items-center justify-center mb-6">
                        <svg className="w-8 h-8 text-slate-300" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M12 6v6m0 0v6m0-6h6m-6 0H6" /></svg>
                    </div>
                    <h3 className="text-lg font-bold text-slate-600 mb-2">가이드북 작성을 시작해볼까요?</h3>
                    <p className="max-w-xs mx-auto">오른쪽 도구 상자에서 원하는 블록을 드래그하여 이곳에 놓아보세요.</p>
                </div>
            ) : (
                <div className="space-y-6">
                    <SortableContext
                        items={blocks.map(b => b.id)}
                        strategy={verticalListSortingStrategy}
                    >
                        {blocks.map((block, index) => {
                            // Calculate step number (count step blocks from start to current position)
                            let stepIndex = 0;
                            if (block.type === 'step') {
                                stepIndex = blocks.slice(0, index + 1).filter(b => b.type === 'step').length;
                            }
                            return (
                                <BuilderBlock
                                    key={block.id}
                                    block={block}
                                    stepIndex={stepIndex}
                                    onRemove={onRemove}
                                    onUpdate={onUpdate}
                                />
                            );
                        })}
                    </SortableContext>
                </div>
            )}
        </div>
    );
}
