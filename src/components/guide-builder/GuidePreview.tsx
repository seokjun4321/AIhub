
import { useState } from "react";
import { GuideBlock, GuideMetadata } from "./GuideBuilderLayout";
import { Button } from "@/components/ui/button";
import { ChevronLeft, ChevronRight, CheckCircle2, Eye, PenTool } from "lucide-react";
import { GuidebookHeader } from "@/components/guidebook/GuidebookHeader";
import { GuideOverviewCards } from "@/components/guidebook/GuideOverviewCards";
import { GuideProgressSidebar } from "@/components/guidebook/GuideProgressSidebar";
import { StepCard } from "@/components/guide/StepCard";
import Footer from "@/components/ui/footer";
import Navbar from "@/components/ui/navbar";

interface GuidePreviewProps {
    blocks: GuideBlock[];
    metadata: GuideMetadata;
    onExit: () => void;
}

export function GuidePreview({ blocks, metadata, onExit }: GuidePreviewProps) {
    const [activeStepIndex, setActiveStepIndex] = useState(0);
    const [completedStepIds, setCompletedStepIds] = useState<(string | number)[]>([]);

    // 1. Use Metadata for Info
    const title = metadata.title || "제목 없는 가이드";
    const summary = metadata.summary || "가이드 설명이 없습니다.";

    // 2. Extract Steps
    const steps = blocks.filter(b => b.type === 'step');

    // 3. Transform GuideBlock -> Step Object expected by StepCard
    const stepObjects = steps.map((block, index) => {
        // Collect children contents
        const actions = block.children
            ?.filter(c => c.type === 'action')
            .map(c => c.content?.text || '')
            .join('\n\n') || '';

        const tips = block.children
            ?.filter(c => c.type === 'tips')
            .map(c => c.content?.text || '')
            .join('\n\n') || '';

        const checklist = block.children
            ?.filter(c => c.type === 'checklist')
            .map(c => c.content?.text || '')
            .join('\n') || '';

        const prompts = block.children
            ?.filter(c => c.type === 'prompt')
            .map((c, idx) => ({
                id: idx,
                label: `Prompt ${idx + 1}`,
                text: c.content?.text || '',
                provider: 'AI'
            })) || [];

        return {
            id: block.id,
            step_order: index + 1,
            title: block.content?.title || `Step ${index + 1}`,
            summary: null,
            content: null, // We provide structured fields instead
            goal: block.content?.goal,
            done_when: block.content?.doneWhen,
            why_matters: block.content?.whyMatters,
            tips: tips,
            checklist: checklist,
            actions: actions, // This relies on our updated StepCard support
            guide_prompts: prompts,
            guide_workbook_fields: []
        };
    });

    const currentStep = stepObjects[activeStepIndex];
    const totalSteps = stepObjects.length;

    // Navigation Handlers
    const handleNextStep = () => {
        if (activeStepIndex < totalSteps - 1) setActiveStepIndex(prev => prev + 1);
        window.scrollTo({ top: 0, behavior: 'smooth' });
    };

    const handlePrevStep = () => {
        if (activeStepIndex > 0) setActiveStepIndex(prev => prev - 1);
        window.scrollTo({ top: 0, behavior: 'smooth' });
    };

    const handleStepClick = (stepId: string | number) => {
        const index = stepObjects.findIndex(s => s.id === stepId);
        if (index >= 0) {
            setActiveStepIndex(index);
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
    };

    return (
        <div className="min-h-screen bg-slate-50">
            {/* Minimal Header for Preview Mode */}
            <header className="fixed top-0 w-full z-50 bg-slate-900 border-b border-slate-800 text-white shadow-lg">
                <div className="container mx-auto px-6 h-16 flex items-center justify-between">
                    <div className="flex items-center gap-4">
                        <span className="bg-emerald-500 text-white text-xs font-bold px-2 py-1 rounded">PREVIEW MODE</span>
                        <h1 className="font-bold text-lg truncate max-w-md">{title}</h1>
                    </div>
                    <div className="flex items-center gap-4">
                        <span className="text-slate-400 text-sm hidden md:inline-block">이 화면은 사용자에게 보여지는 실제 모습입니다</span>
                        <Button
                            onClick={onExit}
                            variant="secondary"
                            className="bg-white text-slate-900 hover:bg-slate-100"
                        >
                            <PenTool className="w-4 h-4 mr-2" />
                            편집기로 돌아가기
                        </Button>
                    </div>
                </div>
            </header>

            <main className="container max-w-7xl mx-auto py-12 px-4 mt-16 text-left">
                {/* 1. Header */}
                <GuidebookHeader
                    title={title}
                    description={summary}
                    progress={0}
                    category="Uncategorized"
                    tags={['Preview']}
                    duration="10 min"
                    difficulty="Beginner"
                />

                <div className="space-y-12">
                    {/* 2. Overview Cards */}
                    <section className="space-y-8">
                        <GuideOverviewCards
                            summary={summary}
                            recommendations={[metadata.targetAudience]}
                            requirements={[metadata.requirements]}
                            corePrinciples={[metadata.corePrinciples]}
                        />
                    </section>

                    {/* 3. Content Area */}
                    <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 items-start">
                        {/* Sidebar (Desktop: Left) */}
                        <div className="hidden lg:block space-y-6 sticky top-24 lg:col-span-1">
                            <GuideProgressSidebar
                                steps={stepObjects.map(s => ({ id: s.id, title: s.title }))}
                                activeStepId={currentStep?.id}
                                completedStepIds={completedStepIds}
                                onStepClick={handleStepClick}
                            />
                        </div>

                        {/* Main Content (Right) */}
                        <div className="lg:col-span-2 space-y-8">
                            {/* Focus Mode: Render only active step */}
                            {currentStep ? (
                                <div className="animate-in fade-in slide-in-from-bottom-4 duration-500 text-left">
                                    <StepCard
                                        key={currentStep.id}
                                        step={currentStep}
                                        stepNumber={activeStepIndex + 1}
                                        guideId={0} // Mock ID
                                        isOpen={true}
                                        toolName="Preview Tool"
                                    />

                                    {/* Navigation Footer */}
                                    <div className="mt-8 flex items-center justify-between">
                                        <Button
                                            variant="outline"
                                            onClick={handlePrevStep}
                                            disabled={activeStepIndex === 0}
                                            className="gap-2 pl-2.5 text-slate-600 hover:text-slate-900"
                                        >
                                            <ChevronLeft className="w-4 h-4" />
                                            이전 Step
                                        </Button>

                                        <div className="flex items-center gap-4">
                                            <div className="text-sm font-medium text-slate-400">
                                                {activeStepIndex + 1} / {totalSteps}
                                            </div>

                                            <Button
                                                onClick={handleNextStep}
                                                disabled={activeStepIndex === totalSteps - 1}
                                                className="gap-2 pr-2.5 bg-emerald-600 hover:bg-emerald-700 text-white shadow-md hover:shadow-lg transition-all"
                                            >
                                                다음 Step
                                                <ChevronRight className="w-4 h-4" />
                                            </Button>
                                        </div>
                                    </div>
                                </div>
                            ) : (
                                <div className="p-12 text-center border-2 border-dashed border-slate-200 rounded-2xl bg-slate-50 text-slate-400">
                                    등록된 Step이 없습니다. 편집기에서 Step을 추가해주세요.
                                </div>
                            )}
                        </div>
                    </div>
                </div>
            </main>
        </div>
    );
}
