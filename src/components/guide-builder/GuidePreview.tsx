
import { useState } from "react";
import { GuideBlock, GuideMetadata } from "./GuideBuilderLayout";
import { Button } from "@/components/ui/button";
import { ChevronLeft, ChevronRight, CheckCircle2, Eye, PenTool } from "lucide-react";
import { GuidebookHeader } from "@/components/guidebook/GuidebookHeader";
import { GuideOverviewCards } from "@/components/guidebook/GuideOverviewCards";
import { GuideProgressSidebar } from "@/components/guidebook/GuideProgressSidebar";
import { StepCard } from "@/components/guide/StepCard";
import { PromptPack } from "@/components/guidebook/PromptPack";
import Footer from "@/components/ui/footer";
import Navbar from "@/components/ui/navbar";
import { PromptItem } from "@/components/guidebook/PromptPack";

interface GuidePreviewProps {
    blocks: GuideBlock[];
    metadata: GuideMetadata;
    prompts: PromptItem[]; // New prop
    onExit: () => void;
}

export function GuidePreview({ blocks, metadata, prompts, onExit }: GuidePreviewProps) {
    const [activeStepIndex, setActiveStepIndex] = useState(0);
    const [completedStepIds, setCompletedStepIds] = useState<(string | number)[]>([]);
    const [activeTab, setActiveTab] = useState<'curriculum' | 'prompts'>('curriculum');

    // 1. Use Metadata for Info
    const title = metadata.title || "제목 없는 가이드";
    const summary = metadata.summary || "가이드 설명이 없습니다.";

    // 2. Extract Steps and Branches
    const steps = blocks.filter(b => b.type === 'step');
    // Collect branches from top-level AND from inside step children
    const topLevelBranches = blocks.filter(b => b.type === 'branch');
    const childBranches = steps.flatMap(step => step.children?.filter(c => c.type === 'branch') || []);
    const branches = [...topLevelBranches, ...childBranches];

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



        const childPrompts = block.children
            ?.filter(c => c.type === 'prompt')
            .map((c, idx) => ({
                id: idx + 1, // 1-based index for children
                label: `Additional Prompt ${idx + 1}`,
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
            tips: [block.content?.commonMistakes, tips].filter(Boolean).join('\n\n'),
            checklist: block.content?.miniChecklist || '',
            actions: actions, // This relies on our updated StepCard support
            guide_prompts: childPrompts, // Keep legacy child prompts if any
            guide_workbook_fields: []
        };
    });

    const currentStep = stepObjects[activeStepIndex];
    const totalSteps = stepObjects.length;

    // Navigation Handlers
    const handleNextStep = () => {
        if (activeStepIndex < totalSteps - 1) {
            setActiveStepIndex(prev => prev + 1);
            window.scrollTo({ top: 0, behavior: 'smooth' });
        } else {
            // If on last step, go to Prompt Pack
            setActiveTab('prompts');
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
    };

    const handlePrevStep = () => {
        if (activeStepIndex > 0) {
            setActiveStepIndex(prev => prev - 1);
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
    };

    const handleStepClick = (stepId: string | number) => {
        const index = stepObjects.findIndex(s => s.id === stepId);
        if (index >= 0) {
            setActiveTab('curriculum');
            setActiveStepIndex(index);
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
    };

    const handlePromptStepClick = (stepNumber: number) => {
        setActiveTab('curriculum');
        if (stepNumber >= 1 && stepNumber <= totalSteps) {
            setActiveStepIndex(stepNumber - 1);
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
                    category={`Category ${metadata.categoryId}` || "Uncategorized"}
                    tags={metadata.tags || ['Preview']}
                    duration={metadata.duration || "10 min"}
                    difficulty={metadata.difficulty || "Beginner"}
                />

                <div className="space-y-12">
                    {/* 2. Overview Cards */}
                    <section className="space-y-8">
                        <GuideOverviewCards
                            summary={summary}
                            recommendations={metadata.targetAudience ? metadata.targetAudience.split('\n').map(l => l.replace(/^[•-]\s*/, '').trim()).filter(Boolean) : []}
                            requirements={metadata.requirements ? metadata.requirements.split('\n').map(l => l.replace(/^[•-]\s*/, '').trim()).filter(Boolean) : []}
                            corePrinciples={metadata.corePrinciples ? metadata.corePrinciples.split('\n').map(l => l.replace(/^[•-]\s*/, '').trim()).filter(Boolean) : []}
                        />
                    </section>

                    {/* 3. Main View Switcher */}
                    <div className="border-b border-slate-200">
                        <div className="flex gap-8">
                            <button
                                onClick={() => setActiveTab('curriculum')}
                                className={`pb-4 px-2 font-bold text-sm transition-all relative ${activeTab === 'curriculum' ? 'text-emerald-600' : 'text-slate-500 hover:text-slate-800'}`}
                            >
                                <div className="flex items-center gap-2">
                                    <span className="w-5 h-5 flex items-center justify-center rounded bg-current/10">
                                        <svg className="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" /></svg>
                                    </span>
                                    Step-by-Step
                                </div>
                                {activeTab === 'curriculum' && <div className="absolute bottom-0 left-0 w-full h-0.5 bg-emerald-600 rounded-t-full" />}
                            </button>
                            <button
                                onClick={() => setActiveTab('prompts')}
                                className={`pb-4 px-2 font-bold text-sm transition-all relative ${activeTab === 'prompts' ? 'text-emerald-600' : 'text-slate-500 hover:text-slate-800'}`}
                            >
                                <div className="flex items-center gap-2">
                                    <span className="w-5 h-5 flex items-center justify-center rounded bg-current/10">
                                        <svg className="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z" /></svg>
                                    </span>
                                    Prompt Pack
                                </div>
                                {activeTab === 'prompts' && <div className="absolute bottom-0 left-0 w-full h-0.5 bg-emerald-600 rounded-t-full" />}
                            </button>
                        </div>
                    </div>

                    {/* 4. Content Area */}
                    <div className="min-h-[500px]">
                        {activeTab === 'curriculum' ? (
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

                                            {/* Branch Blocks */}
                                            {branches.length > 0 && (
                                                <div className="mt-8 space-y-6">
                                                    {branches.map((branch, idx) => (
                                                        <div key={branch.id} className="bg-purple-50 border border-purple-200 rounded-xl p-6 space-y-4">
                                                            <div className="flex items-center gap-2 text-purple-700 font-bold">
                                                                <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 9l4-4 4 4m0 6l-4 4-4-4" />
                                                                </svg>
                                                                A/B 분기 #{idx + 1}
                                                            </div>
                                                            <p className="text-lg font-medium text-slate-800">
                                                                {branch.content?.question || "분기 질문이 없습니다"}
                                                            </p>
                                                            <div className="grid grid-cols-2 gap-4">
                                                                <button className="bg-blue-100 hover:bg-blue-200 border-2 border-blue-300 rounded-xl p-4 text-left transition-colors">
                                                                    <div className="flex items-center gap-2 text-blue-700 font-bold mb-2">
                                                                        <div className="w-6 h-6 rounded-full bg-blue-500 text-white flex items-center justify-center text-xs font-bold">A</div>
                                                                        {branch.content?.optionA || "옵션 A"}
                                                                    </div>
                                                                    <p className="text-sm text-slate-600">
                                                                        {branch.content?.descriptionA || "설명 없음"}
                                                                    </p>
                                                                </button>
                                                                <button className="bg-emerald-100 hover:bg-emerald-200 border-2 border-emerald-300 rounded-xl p-4 text-left transition-colors">
                                                                    <div className="flex items-center gap-2 text-emerald-700 font-bold mb-2">
                                                                        <div className="w-6 h-6 rounded-full bg-emerald-500 text-white flex items-center justify-center text-xs font-bold">B</div>
                                                                        {branch.content?.optionB || "옵션 B"}
                                                                    </div>
                                                                    <p className="text-sm text-slate-600">
                                                                        {branch.content?.descriptionB || "설명 없음"}
                                                                    </p>
                                                                </button>
                                                            </div>
                                                        </div>
                                                    ))}
                                                </div>
                                            )}

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
                                                        className="gap-2 pr-2.5 bg-emerald-600 hover:bg-emerald-700 text-white shadow-md hover:shadow-lg transition-all"
                                                    >
                                                        {activeStepIndex === totalSteps - 1 ? (
                                                            <>
                                                                프롬프트 팩 보기
                                                                <CheckCircle2 className="w-4 h-4" />
                                                            </>
                                                        ) : (
                                                            <>
                                                                다음 Step
                                                                <ChevronRight className="w-4 h-4" />
                                                            </>
                                                        )}
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
                        ) : (
                            /* Prompt Pack View */
                            <div className="animate-in fade-in duration-300">
                                <PromptPack prompts={prompts} onStepClick={handlePromptStepClick} />
                            </div>
                        )}
                    </div>
                </div>
            </main>
        </div>
    );
}
