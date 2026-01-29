import { useState } from 'react';
import { useSortable } from '@dnd-kit/sortable';
import { useDroppable } from '@dnd-kit/core';
import { CSS } from '@dnd-kit/utilities';
import { GuideBlock } from './GuideBuilderLayout';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
import { BulletPointTextarea } from '@/components/ui/bullet-point-textarea';
import { GripVertical, Trash2, X, Lightbulb, TerminalSquare, AlertTriangle, ChevronDown, ChevronUp, FileText, ImageIcon, Copy, Upload } from 'lucide-react';
import { cn } from '@/lib/utils';
import { Label } from '@/components/ui/label';
import { supabase } from '@/integrations/supabase/client';
import { useAuth } from '@/hooks/useAuth';
import { useToast } from '@/hooks/use-toast';

interface BuilderBlockProps {
    block: GuideBlock;
    stepIndex?: number;
    onRemove: (id: string) => void;
    onUpdate: (id: string, content: any) => void;
}

export function BuilderBlock({ block, stepIndex, onRemove, onUpdate }: BuilderBlockProps) {
    const [isCollapsed, setIsCollapsed] = useState(false);
    const [isUploading, setIsUploading] = useState(false);
    const { user } = useAuth();
    const { toast } = useToast();

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
        onUpdate(block.id, { ...block.content, [key]: value });
    };

    const handleImageUpload = async (e: React.ChangeEvent<HTMLInputElement>, childId?: string) => {
        const file = e.target.files?.[0];
        if (!file) return;

        // 파일 크기 체크 (10MB 제한)
        if (file.size > 10 * 1024 * 1024) {
            toast({
                title: "파일 크기 초과",
                description: "이미지는 10MB 이하여야 합니다.",
                variant: "destructive"
            });
            return;
        }

        // 이미지 파일 체크
        if (!file.type.startsWith('image/')) {
            toast({
                title: "잘못된 파일 형식",
                description: "이미지 파일만 업로드 가능합니다.",
                variant: "destructive"
            });
            return;
        }

        setIsUploading(true);

        try {
            const userId = user?.id || 'anonymous';
            const fileExt = file.name.split('.').pop();
            const fileName = `${userId}/${Date.now()}_${Math.random().toString(36).substring(7)}.${fileExt}`;

            const { data, error } = await supabase.storage
                .from('guide-images')
                .upload(fileName, file);

            if (error) throw error;

            const { data: { publicUrl } } = supabase.storage
                .from('guide-images')
                .getPublicUrl(data.path);

            // Update content
            if (childId) {
                // Child block update (for nested image blocks)
                onUpdate(childId, { imageUrl: publicUrl });
            } else {
                // Main block update
                handleContentChange('imageUrl', publicUrl);
            }

            toast({
                title: "업로드 완료!",
                description: "이미지가 성공적으로 업로드되었습니다."
            });
        } catch (error: any) {
            console.error('Upload error:', error);
            toast({
                title: "업로드 실패",
                description: error.message || "이미지 업로드 중 오류가 발생했습니다.",
                variant: "destructive"
            });
        } finally {
            setIsUploading(false);
        }
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
                                        "bg-slate-50/50 rounded-xl border-2 border-dashed border-slate-200 min-h-[120px] max-h-[600px] overflow-y-auto transition-all duration-200",
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
                                                                        <Input
                                                                            placeholder="예: ChatGPT 사용하기"
                                                                            className="border-blue-200 text-xs h-8"
                                                                            value={child.content?.optionA || ''}
                                                                            onChange={(e) => onUpdate(child.id, { ...child.content, optionA: e.target.value })}
                                                                        />
                                                                        <Textarea
                                                                            placeholder="설명 (선택)"
                                                                            className="border-blue-200 text-xs min-h-[60px] resize-none"
                                                                            value={child.content?.descriptionA || ''}
                                                                            onChange={(e) => onUpdate(child.id, { ...child.content, descriptionA: e.target.value })}
                                                                        />
                                                                    </div>
                                                                    <div className="space-y-1">
                                                                        <div className="flex items-center gap-1 text-emerald-600 font-bold text-xs">
                                                                            <div className="w-4 h-4 rounded-full bg-emerald-500 text-white flex items-center justify-center text-[10px] font-bold">B</div>
                                                                            옵션 B
                                                                        </div>
                                                                        <Input
                                                                            placeholder="예: Claude 사용하기"
                                                                            className="border-emerald-200 text-xs h-8"
                                                                            value={child.content?.optionB || ''}
                                                                            onChange={(e) => onUpdate(child.id, { ...child.content, optionB: e.target.value })}
                                                                        />
                                                                        <Textarea
                                                                            placeholder="설명 (선택)"
                                                                            className="border-emerald-200 text-xs min-h-[60px] resize-none"
                                                                            value={child.content?.descriptionB || ''}
                                                                            onChange={(e) => onUpdate(child.id, { ...child.content, descriptionB: e.target.value })}
                                                                        />
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        )}

                                                        {/* NEW: Example Block */}
                                                        {child.type === 'example' && (
                                                            <div className="space-y-4">
                                                                <div className="flex gap-2">
                                                                    <Button
                                                                        size="sm"
                                                                        variant={child.content?.type === 'success' ? 'default' : 'outline'}
                                                                        className={child.content?.type === 'success' ? 'bg-emerald-600' : ''}
                                                                        onClick={() => onUpdate(child.id, { ...child.content, type: 'success' })}
                                                                    >
                                                                        성공 사례
                                                                    </Button>
                                                                    <Button
                                                                        size="sm"
                                                                        variant={child.content?.type === 'info' ? 'default' : 'outline'}
                                                                        className={child.content?.type === 'info' ? 'bg-blue-600' : ''}
                                                                        onClick={() => onUpdate(child.id, { ...child.content, type: 'info' })}
                                                                    >
                                                                        정보
                                                                    </Button>
                                                                    <Button
                                                                        size="sm"
                                                                        variant={child.content?.type === 'warning' ? 'default' : 'outline'}
                                                                        className={child.content?.type === 'warning' ? 'bg-amber-600' : ''}
                                                                        onClick={() => onUpdate(child.id, { ...child.content, type: 'warning' })}
                                                                    >
                                                                        주의사항
                                                                    </Button>
                                                                </div>
                                                                <Input
                                                                    placeholder="예시 제목"
                                                                    className="text-sm"
                                                                    value={child.content?.title || ''}
                                                                    onChange={(e) => onUpdate(child.id, { ...child.content, title: e.target.value })}
                                                                />
                                                                <Textarea
                                                                    placeholder="간단한 설명"
                                                                    className="min-h-[60px] text-sm resize-none"
                                                                    value={child.content?.description || ''}
                                                                    onChange={(e) => onUpdate(child.id, { ...child.content, description: e.target.value })}
                                                                />
                                                                <div className="bg-blue-50 border border-blue-100 rounded-xl p-4 space-y-2">
                                                                    <div className="flex items-center gap-2 text-blue-600 font-bold text-xs uppercase tracking-wider">
                                                                        <FileText className="w-4 h-4" />
                                                                        예시 내용
                                                                    </div>
                                                                    <Textarea
                                                                        placeholder="실제 예시를 입력하세요 (마크다운 지원)"
                                                                        className="min-h-[120px] border-blue-200 bg-white text-sm"
                                                                        value={child.content?.exampleText || ''}
                                                                        onChange={(e) => onUpdate(child.id, { ...child.content, exampleText: e.target.value })}
                                                                    />
                                                                </div>
                                                            </div>
                                                        )}

                                                        {/* NEW: Image Block */}
                                                        {child.type === 'image' && (
                                                            <div className="space-y-4">
                                                                {/* 파일 업로드 */}
                                                                <div className="space-y-2">
                                                                    <Label className="text-sm text-indigo-700 font-bold">이미지 업로드</Label>
                                                                    <div className="flex items-center gap-2">
                                                                        <Input
                                                                            type="file"
                                                                            accept="image/*"
                                                                            onChange={(e) => handleImageUpload(e, child.id)}
                                                                            disabled={isUploading}
                                                                            className="text-sm"
                                                                        />
                                                                        {isUploading && (
                                                                            <span className="text-xs text-indigo-600 animate-pulse">업로드 중...</span>
                                                                        )}
                                                                    </div>
                                                                    <p className="text-xs text-slate-500">
                                                                        <Upload className="w-3 h-3 inline mr-1" />
                                                                        최대 10MB, JPG/PNG/GIF/WebP 지원
                                                                    </p>
                                                                </div>

                                                                {/* URL 직접 입력 */}
                                                                <div className="space-y-2">
                                                                    <Label className="text-sm text-slate-600">또는 URL 직접 입력</Label>
                                                                    <Input
                                                                        placeholder="https://example.com/image.png"
                                                                        className="text-sm"
                                                                        value={child.content?.imageUrl || ''}
                                                                        onChange={(e) => onUpdate(child.id, { ...child.content, imageUrl: e.target.value })}
                                                                    />
                                                                </div>

                                                                {child.content?.imageUrl && (
                                                                    <div className="bg-indigo-50 border border-indigo-100 rounded-xl p-4">
                                                                        <div className="flex items-center gap-2 text-indigo-600 font-bold text-xs uppercase tracking-wider mb-2">
                                                                            <ImageIcon className="w-4 h-4" />
                                                                            미리보기
                                                                        </div>
                                                                        <div className="bg-white rounded-lg overflow-hidden border border-indigo-100">
                                                                            <img
                                                                                src={child.content.imageUrl}
                                                                                alt="Preview"
                                                                                className="w-full h-auto max-h-[300px] object-contain"
                                                                                onError={(e) => {
                                                                                    e.currentTarget.src = 'data:image/svg+xml,%3Csvg xmlns="http://www.w3.org/2000/svg" width="400" height="200"%3E%3Crect fill="%23f1f5f9" width="400" height="200"/%3E%3Ctext x="50%25" y="50%25" dominant-baseline="middle" text-anchor="middle" fill="%2394a3b8"%3E이미지를 불러올 수 없습니다%3C/text%3E%3C/svg%3E';
                                                                                }}
                                                                            />
                                                                        </div>
                                                                    </div>
                                                                )}

                                                                <Input
                                                                    placeholder="캡션"
                                                                    className="text-sm"
                                                                    value={child.content?.caption || ''}
                                                                    onChange={(e) => onUpdate(child.id, { ...child.content, caption: e.target.value })}
                                                                />
                                                                <Input
                                                                    placeholder="대체 텍스트 (접근성)"
                                                                    className="text-sm"
                                                                    value={child.content?.alt || ''}
                                                                    onChange={(e) => onUpdate(child.id, { ...child.content, alt: e.target.value })}
                                                                />

                                                                <div className="space-y-1">
                                                                    <Label className="text-xs text-slate-600">표시 너비</Label>
                                                                    <div className="flex gap-2">
                                                                        <Button
                                                                            size="sm"
                                                                            variant="outline"
                                                                            onClick={() => onUpdate(child.id, { ...child.content, width: '100%' })}
                                                                        >
                                                                            전체
                                                                        </Button>
                                                                        <Button
                                                                            size="sm"
                                                                            variant="outline"
                                                                            onClick={() => onUpdate(child.id, { ...child.content, width: '600px' })}
                                                                        >
                                                                            중간
                                                                        </Button>
                                                                        <Button
                                                                            size="sm"
                                                                            variant="outline"
                                                                            onClick={() => onUpdate(child.id, { ...child.content, width: '400px' })}
                                                                        >
                                                                            작게
                                                                        </Button>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        )}

                                                        {/* NEW: Copy Block */}
                                                        {child.type === 'copy' && (
                                                            <div className="space-y-4">
                                                                <Input
                                                                    placeholder="블록 제목 (선택)"
                                                                    className="text-sm"
                                                                    value={child.content?.title || ''}
                                                                    onChange={(e) => onUpdate(child.id, { ...child.content, title: e.target.value })}
                                                                />

                                                                <div className="space-y-2">
                                                                    <Label className="text-xs text-slate-600">코드 언어</Label>
                                                                    <div className="flex flex-wrap gap-2">
                                                                        {['bash', 'python', 'javascript', 'json', 'sql', 'text'].map(lang => (
                                                                            <Button
                                                                                key={lang}
                                                                                size="sm"
                                                                                variant={child.content?.language === lang ? 'default' : 'outline'}
                                                                                className={child.content?.language === lang ? 'bg-slate-700' : ''}
                                                                                onClick={() => onUpdate(child.id, { ...child.content, language: lang })}
                                                                            >
                                                                                {lang}
                                                                            </Button>
                                                                        ))}
                                                                    </div>
                                                                </div>

                                                                <div className="bg-slate-900 rounded-xl p-4 space-y-2">
                                                                    <div className="flex items-center justify-between">
                                                                        <div className="flex items-center gap-2 text-slate-400 font-mono text-xs uppercase tracking-wider">
                                                                            <Copy className="w-3 h-3" />
                                                                            복사할 내용
                                                                        </div>
                                                                        <span className="text-slate-500 text-xs font-mono">
                                                                            {child.content?.language || 'text'}
                                                                        </span>
                                                                    </div>
                                                                    <Textarea
                                                                        placeholder="사용자가 복사할 텍스트나 코드를 입력하세요..."
                                                                        className="min-h-[120px] bg-slate-950 border-slate-700 text-slate-100 font-mono text-sm focus-visible:ring-slate-500"
                                                                        value={child.content?.text || ''}
                                                                        onChange={(e) => onUpdate(child.id, { ...child.content, text: e.target.value })}
                                                                    />
                                                                </div>

                                                                <Textarea
                                                                    placeholder="추가 설명 (선택)"
                                                                    className="min-h-[60px] text-sm resize-none"
                                                                    value={child.content?.description || ''}
                                                                    onChange={(e) => onUpdate(child.id, { ...child.content, description: e.target.value })}
                                                                />
                                                            </div>
                                                        )}

                                                        {/* Fallback for other types */}
                                                        {!['action', 'tips', 'warning', 'prompt', 'branch', 'example', 'image', 'copy'].includes(child.type) && (
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
