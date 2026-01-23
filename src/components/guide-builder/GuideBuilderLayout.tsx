import { useState } from 'react';
import {
    DndContext,
    DragOverlay,
    closestCorners,
    KeyboardSensor,
    PointerSensor,
    useSensor,
    useSensors,
    DragStartEvent,
    DragEndEvent,
    DragOverEvent,
    defaultDropAnimationSideEffects,
    DropAnimation,
    pointerWithin,
    rectIntersection,
    getFirstCollision,
    CollisionDetection
} from '@dnd-kit/core';
import { arrayMove, sortableKeyboardCoordinates } from '@dnd-kit/sortable';
import { BuilderSidebar } from './BuilderSidebar';
import { BuilderCanvas } from './BuilderCanvas';
import { BuilderBlock } from './BuilderBlock';
import { GuideOverview } from './GuideOverview';
import Navbar from '@/components/ui/navbar';
import { Button } from '@/components/ui/button';
import { ChevronLeft } from 'lucide-react';
import { Link } from 'react-router-dom';

export type BlockType =
    // Basic
    | 'title'
    // Step Logic
    | 'step'
    | 'action'
    | 'tips'
    | 'warning'
    // Advanced
    | 'prompt'
    | 'branch'
    | 'checklist';

export interface GuideBlock {
    id: string;
    type: BlockType;
    content: any;
    children?: GuideBlock[]; // For recursive nesting (e.g. Step > Action/Tips)
}

const defaultDropAnimation: DropAnimation = {
    sideEffects: defaultDropAnimationSideEffects({
        styles: {
            active: {
                opacity: '0.5',
            },
        },
    }),
};

const customCollisionDetection: CollisionDetection = (args) => {
    // 1. First, check if pointer is strictly within a "Step Drop Zone"
    const pointerCollisions = pointerWithin(args);
    const dropZone = pointerCollisions.find((c) => c.data?.current?.isStepDropZone);

    if (dropZone) {
        return [dropZone];
    }

    // 2. If not over a drop zone, fall back to Closest Corners for smooth list sorting
    return closestCorners(args);
};

export default function GuideBuilderLayout() {
    const [blocks, setBlocks] = useState<GuideBlock[]>([]);
    const [activeId, setActiveId] = useState<string | null>(null);
    const [activeType, setActiveType] = useState<BlockType | null>(null);

    const sensors = useSensors(
        useSensor(PointerSensor),
        useSensor(KeyboardSensor, {
            coordinateGetter: sortableKeyboardCoordinates,
        })
    );

    const handleDragStart = (event: DragStartEvent) => {
        const { active } = event;
        setActiveId(active.id as string);

        // If dragging from sidebar, active.data.current.type identifies the type
        if (active.data.current?.sortable?.index === undefined && active.data.current?.type) {
            setActiveType(active.data.current.type);
        }
        // If sorting existing item
        else {
            const block = blocks.find((b) => b.id === active.id);
            if (block) setActiveType(block.type);
        }
    };

    const handleDragOver = (event: DragOverEvent) => {
        // Optional: Add visual cues here if needed during drag
    };

    const handleDragEnd = (event: DragEndEvent) => {
        const { active, over } = event;
        setActiveId(null);
        setActiveType(null);

        if (!over) return;

        const isNestedDrop = over.data.current?.isStepDropZone || (over.id as string).endsWith('-dropzone');

        // 1. Drop from Sidebar (New Item)
        if (active.data.current?.type && !blocks.find(b => b.id === active.id)) {
            const type = active.data.current.type as BlockType;
            const newBlock: GuideBlock = {
                id: `block-${Date.now()}`,
                type,
                content: {},
            };

            if (over.id === 'canvas-droppable') {
                setBlocks((items) => [...items, newBlock]);
            } else if (isNestedDrop) {
                // Determine Parent ID (Prefer data, fallback to string parsing)
                const parentId = over.data.current?.parentId || (over.id as string).replace('-dropzone', '');

                setBlocks(items => items.map(item => {
                    if (item.id === parentId) {
                        return {
                            ...item,
                            children: [...(item.children || []), newBlock]
                        };
                    }
                    return item;
                }));
            } else {
                // Insert after specific item
                const overIndex = blocks.findIndex((b) => b.id === over.id);
                if (overIndex !== -1) {
                    const newItems = [...blocks];
                    newItems.splice(overIndex + 1, 0, newBlock);
                    setBlocks(newItems);
                } else {
                    setBlocks((items) => [...items, newBlock]);
                }
            }
        }
        // 2. Reorder or Nest Existing Items
        else {
            if (isNestedDrop) {
                // Move existing item INTO a step
                const parentId = over.data.current?.parentId || (over.id as string).replace('-dropzone', '');
                const movedBlock = blocks.find(b => b.id === active.id);

                if (movedBlock) {
                    setBlocks(items => {
                        // 1. Remove from main list
                        const filtered = items.filter(b => b.id !== active.id);
                        // 2. Add to parent's children
                        return filtered.map(item => {
                            if (item.id === parentId) {
                                return {
                                    ...item,
                                    children: [...(item.children || []), movedBlock]
                                };
                            }
                            return item;
                        });
                    });
                }
            } else if (active.id !== over.id) {
                // Standard Reorder
                setBlocks((items) => {
                    const oldIndex = items.findIndex((b) => b.id === active.id);
                    const newIndex = items.findIndex((b) => b.id === over.id);
                    return arrayMove(items, oldIndex, newIndex);
                });
            }
        }
    };

    const removeBlock = (id: string) => {
        setBlocks(items => items.filter(item => item.id !== id));
    };

    const updateBlockContent = (id: string, content: any) => {
        setBlocks(items => items.map(item =>
            item.id === id ? { ...item, content: { ...item.content, ...content } } : item
        ));
    };

    return (
        <div className="min-h-screen bg-slate-50 flex flex-col">
            {/* Header */}
            <header className="h-16 bg-white border-b border-slate-200 flex items-center justify-between px-6 fixed top-0 w-full z-50">
                <div className="flex items-center gap-4">
                    <Link to="/guidebook" className="text-slate-500 hover:text-slate-900 transition-colors">
                        <ChevronLeft className="w-5 h-5" />
                    </Link>
                    <h1 className="font-bold text-lg text-slate-900">새 가이드북 만들기</h1>
                    <div className="h-4 w-px bg-slate-200 mx-2" />
                    <span className="text-sm text-slate-500">초안 작성 중...</span>
                </div>
                <div className="flex items-center gap-3">
                    <Button variant="outline" className="text-slate-600">미리보기</Button>
                    <Button className="bg-emerald-600 hover:bg-emerald-700 text-white">게시하기</Button>
                </div>
            </header>

            {/* Main Editor Area */}
            <div className="flex-1 pt-16 flex min-h-screen">
                <DndContext
                    sensors={sensors}
                    collisionDetection={customCollisionDetection}
                    onDragStart={handleDragStart}
                    onDragOver={handleDragOver}
                    onDragEnd={handleDragEnd}
                >
                    {/* Left: Canvas */}
                    <main className="flex-1 bg-slate-50/50 p-8 flex justify-center">
                        <div className="w-full max-w-3xl pb-24">
                            <GuideOverview />
                            <BuilderCanvas
                                blocks={blocks}
                                onRemove={removeBlock}
                                onUpdate={updateBlockContent}
                            />
                        </div>
                    </main>

                    {/* Right: Sidebar */}
                    <div className="w-80 relative">
                        <aside className="bg-white border-l border-slate-200 flex flex-col z-40 shadow-xl shadow-slate-200/50 sticky top-16 h-[calc(100vh-4rem)]">
                            <BuilderSidebar />
                        </aside>
                    </div>

                    {/* Drag Overlay (Visual Follower) */}
                    <DragOverlay dropAnimation={defaultDropAnimation}>
                        {activeType ? (
                            <div className="w-64 p-4 bg-white rounded-xl shadow-2xl border-2 border-emerald-500 opacity-90 cursor-grabbing pointer-events-none">
                                <span className="font-bold text-slate-900 capitalize">{activeType} Block</span>
                            </div>
                        ) : null}
                    </DragOverlay>
                </DndContext>
            </div>
        </div>
    );
}
