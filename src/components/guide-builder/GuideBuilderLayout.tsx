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
    CollisionDetection
} from '@dnd-kit/core';
import { arrayMove, sortableKeyboardCoordinates } from '@dnd-kit/sortable';
import { BuilderSidebar } from './BuilderSidebar';
import { BuilderCanvas } from './BuilderCanvas';
import { GuideOverview } from './GuideOverview';
import { Button } from '@/components/ui/button';
import { ChevronLeft, Eye, BookOpen, Save } from 'lucide-react';
import { Link } from 'react-router-dom';
import { GuidePreview } from './GuidePreview';
import { PromptManager } from './PromptManager';
import { PromptItem } from "@/components/guidebook/PromptPack";
import { GuideNavigator } from './GuideNavigator';
import { useGuideSubmit } from '@/hooks/useGuideSubmit';

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
    // NEW: Content Enhancement
    | 'example'
    | 'image'
    | 'copy';

export interface GuideBlock {
    id: string;
    type: BlockType;
    content: any;
    children?: GuideBlock[]; // For recursive nesting (e.g. Step > Action/Tips)
}

export interface GuideMetadata {
    title: string;
    summary: string;
    targetAudience: string;
    requirements: string;
    corePrinciples: string;
    categoryId: number;
    difficulty: string;
    duration: string;
    tags: string[];
    aiModelId?: number;
    submissionType?: 'new' | 'update';
    originalGuideId?: string | null;
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
    const [isPreviewMode, setIsPreviewMode] = useState(false);
    const [activeTab, setActiveTab] = useState<'curriculum' | 'prompts'>('curriculum');
    const [prompts, setPrompts] = useState<PromptItem[]>([]);

    const { submitGuide, isSubmitting } = useGuideSubmit();

    const [metadata, setMetadata] = useState<GuideMetadata>({
        title: '',
        summary: '',
        targetAudience: '',
        requirements: '',
        corePrinciples: '',
        categoryId: 1,
        aiModelId: undefined, // Will be set automatically in GuideOverview
        difficulty: 'Beginner',
        duration: '10 min',
        tags: [],
        submissionType: 'new',
        originalGuideId: null
    });

    const updateMetadata = (key: keyof GuideMetadata, value: any) => {
        setMetadata(prev => ({ ...prev, [key]: value }));
    };

    const sensors = useSensors(
        useSensor(PointerSensor),
        useSensor(KeyboardSensor, {
            coordinateGetter: sortableKeyboardCoordinates,
        })
    );
    // ... (drag handlers) ...


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

            // Get default content based on block type
            const getDefaultContent = (blockType: BlockType): any => {
                switch(blockType) {
                    case 'example':
                        return { title: '', description: '', exampleText: '', type: 'info' };
                    case 'image':
                        return { imageUrl: '', caption: '', alt: '', width: '100%' };
                    case 'copy':
                        return { title: '', text: '', language: 'bash', description: '' };
                    default:
                        return {};
                }
            };

            const newBlock: GuideBlock = {
                id: `block-${Date.now()}`,
                type,
                content: getDefaultContent(type),
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
        setBlocks(items =>
            items
                .filter(item => item.id !== id) // Top-level remove
                .map(item => ({                 // Nested remove
                    ...item,
                    children: item.children ? item.children.filter(child => child.id !== id) : undefined
                }))
        );
    };

    const updateBlockContent = (id: string, content: any) => {
        setBlocks(items => items.map(item => {
            // 1. Check if the item itself matches
            if (item.id === id) {
                return { ...item, content: { ...item.content, ...content } };
            }
            // 2. Check if any children match
            if (item.children) {
                return {
                    ...item,
                    children: item.children.map(child =>
                        child.id === id
                            ? { ...child, content: { ...child.content, ...content } }
                            : child
                    )
                };
            }
            return item;
        }));
    };

    if (isPreviewMode) {
        return <GuidePreview blocks={blocks} metadata={metadata} prompts={prompts} onExit={() => setIsPreviewMode(false)} />;
    }

    return (
        <DndContext
            sensors={sensors}
            onDragStart={handleDragStart}
            onDragOver={handleDragOver}
            onDragEnd={handleDragEnd}
        >
            <div className="flex h-screen bg-slate-50 overflow-hidden">
                {/* Fixed Header */}
                <div className="fixed top-0 left-0 right-0 h-16 bg-white border-b border-slate-200 flex items-center justify-between px-6 z-50">
                    <div className="flex items-center gap-8">
                        <div className="flex items-center gap-2">
                            <div className="w-8 h-8 bg-emerald-100 rounded-lg flex items-center justify-center">
                                <BookOpen className="w-5 h-5 text-emerald-600" />
                            </div>
                            <h1 className="font-bold text-lg text-slate-800">Guide Builder</h1>
                        </div>

                        {/* TAB SWITCHER */}
                        <div className="flex bg-slate-100 p-1 rounded-lg">
                            <button
                                onClick={() => setActiveTab('curriculum')}
                                className={`px-4 py-1.5 rounded-md text-sm font-semibold transition-all ${activeTab === 'curriculum'
                                    ? 'bg-white text-emerald-700 shadow-sm'
                                    : 'text-slate-500 hover:text-slate-700'
                                    }`}
                            >
                                Curriculum
                            </button>
                            <button
                                onClick={() => setActiveTab('prompts')}
                                className={`px-4 py-1.5 rounded-md text-sm font-semibold transition-all ${activeTab === 'prompts'
                                    ? 'bg-white text-emerald-700 shadow-sm'
                                    : 'text-slate-500 hover:text-slate-700'
                                    }`}
                            >
                                Prompt Pack
                            </button>
                        </div>
                    </div>

                    <div className="flex items-center gap-3">
                        <Button
                            variant="ghost"
                            onClick={() => setIsPreviewMode(true)}
                            className="text-slate-600 hover:text-emerald-600"
                        >
                            <Eye className="w-4 h-4 mr-2" />
                            미리보기
                        </Button>
                        <Button
                            className="bg-emerald-600 hover:bg-emerald-700 text-white"
                            onClick={() => submitGuide(metadata, blocks, prompts)}
                            disabled={isSubmitting}
                        >
                            <Save className="w-4 h-4 mr-2" />
                            {isSubmitting ? '제출 중...' : '제출하기'}
                        </Button>
                    </div>
                </div>

                {/* Main Content Area */}
                <div className="pt-16 w-full h-full">
                    {activeTab === 'curriculum' ? (
                        <div className="flex h-full">
                            {/* Left Sidebar - Tools */}
                            <div className="w-80 bg-white border-r border-slate-200 h-full overflow-hidden flex-shrink-0">
                                <BuilderSidebar />
                            </div>

                            {/* Center - Canvas */}
                            <div className="flex-1 overflow-y-auto h-full relative bg-slate-50/50 p-8">
                                <div className="w-full max-w-3xl mx-auto pb-24">
                                    <GuideOverview metadata={metadata} onChange={updateMetadata} />
                                    <BuilderCanvas
                                        blocks={blocks}
                                        onRemove={removeBlock}
                                        onUpdate={updateBlockContent}
                                    />
                                </div>
                                {/* Navigator */}
                                <GuideNavigator blocks={blocks} />
                            </div>
                        </div>
                    ) : (
                        /* Prompt Manager Tab */
                        <div className="h-full overflow-y-auto bg-slate-50">
                            <PromptManager
                                prompts={prompts}
                                onChange={setPrompts}
                                blocks={blocks}
                            />
                        </div>
                    )}
                </div>

                {/* Drag Overlay */}
                <DragOverlay>
                    {activeId ? (
                        <div className="p-4 bg-white rounded-xl shadow-xl border-2 border-emerald-500 w-[300px] opacity-90 cursor-grabbing">
                            Scanning...
                        </div>
                    ) : null}
                </DragOverlay>
            </div>
        </DndContext>
    );
}
