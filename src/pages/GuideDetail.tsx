import { useParams, Link } from "react-router-dom";
import { useAuth } from "@/hooks/useAuth";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { StepCard } from "@/components/guide/StepCard";
import { Button } from "@/components/ui/button";
import { GuidebookHeader } from "@/components/guidebook/GuidebookHeader";
import { CurriculumList } from "@/components/guidebook/CurriculumList";
import { GuideOverviewCards } from "@/components/guidebook/GuideOverviewCards";
import { GuideTabs } from "@/components/guidebook/GuideTabs";
import { GuideProgressSidebar } from "@/components/guidebook/GuideProgressSidebar";
import { PromptPack } from "@/components/guidebook/PromptPack";
import { ThumbsUp, ThumbsDown } from "lucide-react";
import { useState, useEffect } from "react";
import { useToast } from "@/hooks/use-toast";
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import rehypeSlug from 'rehype-slug';
import rehypeAutolinkHeadings from 'rehype-autolink-headings';
import { Skeleton } from "@/components/ui/skeleton";
import { ChevronLeft, ChevronRight, CheckCircle2 } from "lucide-react";
import { GuideFeedbackModal } from "@/components/feedback/GuideFeedbackModal";
import confetti from 'canvas-confetti';

// 단일 가이드를 불러오는 함수 (관련 데이터 포함)
const fetchGuideById = async (id: string) => {
  const numericId = parseInt(id, 10);
  if (isNaN(numericId)) throw new Error("Invalid ID provided");
  const { data, error } = await supabase
    .from('guides')
    .select(`
      *,
      target_audience,
      ai_models(name, logo_url, website_url),
      categories(name),
      profiles(id, username, avatar_url)
    `)
    .eq('id', numericId)
    .single();
  if (error) throw new Error(error.message);
  return data as any;
};

// 가이드의 단계들을 불러오는 함수
const fetchGuideSteps = async (guideId: number) => {
  const { data, error } = await (supabase as any)
    .from('guide_steps')
    .select(`
      id,
      step_order,
      guide_id,
      title,
      summary,
      content,
      created_at,
      updated_at,
      goal,
      done_when,
      why_matters,
      tips,
      checklist,
      guide_prompts(id, label, text, provider),
      guide_workbook_fields(id, field_key, field_type, label, placeholder)
    `)
    .eq('guide_id', guideId)
    .order('step_order', { ascending: true });

  if (error) {
    console.error("fetchGuideSteps error:", error);
    throw new Error(error.message);
  }
  return (data || []) as Array<{
    id: number;
    step_order: number;
    title: string;
    summary: string | null;
    content: string | null;
    guide_prompts?: Array<{
      id: number;
      label: string;
      text: string;
      provider: string | null;
    }>;
    guide_workbook_fields?: Array<{
      id: number;
      field_key: string;
      field_type: string;
      label: string;
      placeholder: string | null;
    }>;
  }>;
};

// 가이드의 섹션들을 불러오는 함수
const fetchGuideSections = async (guideId: number) => {
  const { data, error } = await (supabase as any)
    .from('guide_sections')
    .select('*')
    .eq('guide_id', guideId)
    .order('section_order', { ascending: true });

  if (error) throw new Error(error.message);
  return (data || []) as Array<{
    id: number;
    section_type: string;
    section_order: number;
    title: string | null;
    content: string | null;
    data: any;
  }>;
};

// 관련 가이드 가져오기 (같은 카테고리 또는 같은 AI 모델)
const fetchRelatedGuides = async (guideId: number, categoryId: number | null, aiModelId: number) => {
  const queries = [];

  if (categoryId) {
    queries.push(
      supabase
        .from('guides')
        .select('id, title, estimated_time, ai_models(name)')
        .eq('category_id', categoryId)
        .neq('id', guideId)
        .limit(3)
    );
  }

  queries.push(
    supabase
      .from('guides')
      .select('id, title, estimated_time, ai_models(name)')
      .eq('ai_model_id', aiModelId)
      .neq('id', guideId)
      .limit(3)
  );

  const results = await Promise.all(queries);
  const allGuides = results.flatMap(result => result.data || []);

  // 중복 제거 및 최대 3개만 반환
  const uniqueGuides = Array.from(
    new Map(allGuides.map(guide => [guide.id, guide])).values()
  ).slice(0, 3);

  return uniqueGuides.map(guide => ({
    id: guide.id,
    title: guide.title,
    tool: (guide.ai_models as any)?.name,
    readTime: guide.estimated_time,
  }));
};

// 마크다운 볼드 문법 제거 헬퍼 함수
function removeMarkdownBold(text: string): string {
  return text.replace(/\*\*(.+?)\*\*/g, '$1');
}

// 마크다운 콘텐츠를 스텝으로 파싱하는 함수
function parseMarkdownToSteps(content: string | null): Array<{
  id: string;
  step_order: number;
  title: string;
  summary: string | null;
  content: string;
}> {
  if (!content) return [];

  const lines = content.split(/\r?\n/);
  const steps: Array<{
    id: string;
    step_order: number;
    title: string;
    summary: string | null;
    content: string;
  }> = [];

  let currentStep: {
    id: string;
    step_order: number;
    title: string;
    summary: string | null;
    content: string;
  } | null = null;

  let stepOrder = 1;

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    // ## 헤딩을 찾음 (## 또는 ### 등)
    const headingMatch = /^(##+)[\s]+(.+)$/.exec(line.trim());

    if (headingMatch) {
      if (currentStep) {
        steps.push(currentStep);
      }
      const rawTitle = headingMatch[2].trim();
      const title = removeMarkdownBold(rawTitle);
      const slug = title
        .toLowerCase()
        .replace(/[^a-z0-9가-힣\s-]/g, '')
        .replace(/\s+/g, '-')
        .replace(/-+/g, '-');

      currentStep = {
        id: `step-${slug}`,
        step_order: stepOrder++,
        title: title,
        summary: null,
        content: line + '\n', // 헤딩 포함
      };
    } else if (currentStep) {
      currentStep.content += line + '\n';
      if (!currentStep.summary && line.trim() && !line.trim().startsWith('#')) {
        const firstParagraph = line.trim().replace(/[#*`\[\]]/g, '').substring(0, 100);
        if (firstParagraph.length > 0) {
          currentStep.summary = firstParagraph + (firstParagraph.length >= 100 ? '...' : '');
        }
      }
    }
  }

  if (currentStep) {
    steps.push(currentStep);
  }

  return steps;
}

const GuideDetail = () => {
  const { id } = useParams<{ id: string }>();
  const { user } = useAuth();
  const [feedbackGiven, setFeedbackGiven] = useState(false);
  const { toast } = useToast();

  // Navigation State
  const [activeStepIndex, setActiveStepIndex] = useState(0); // Focus Mode Index
  const [completedStepIds, setCompletedStepIds] = useState<(string | number)[]>([]);
  const [activeTab, setActiveTab] = useState<'curriculum' | 'prompts'>('curriculum');
  const [isFeedbackModalOpen, setIsFeedbackModalOpen] = useState(false);
  const [successState, setSuccessState] = useState(false);

  // Queries
  const { data: guide, isLoading: isGuideLoading, error: guideError } = useQuery({
    queryKey: ['guide', id],
    queryFn: () => fetchGuideById(id || ''),
    enabled: !!id
  });

  const { data: steps, isLoading: isStepsLoading, error: stepsError } = useQuery({
    queryKey: ['guide_steps', guide?.id],
    queryFn: () => fetchGuideSteps(guide.id),
    enabled: !!guide?.id
  });

  const { data: sections, isLoading: isSectionsLoading } = useQuery({
    queryKey: ['guide_sections', guide?.id],
    queryFn: () => fetchGuideSections(guide.id),
    enabled: !!guide?.id
  });

  const isLoading = isGuideLoading || isStepsLoading || isSectionsLoading;
  const error = guideError || stepsError;
  const dbSteps = Array.isArray(steps) ? steps : [];
  const parsedSteps = dbSteps.length === 0 && guide?.content
    ? parseMarkdownToSteps(guide.content)
    : [];
  const stepsArray = dbSteps.length > 0 ? dbSteps : parsedSteps;
  const hasSteps = stepsArray.length > 0;

  // Navigation Items
  const navSteps = stepsArray.map(s => ({
    id: s.id,
    title: s.title
  }));

  // Helper function for consistent scroll behavior
  const scrollToContent = () => {
    setTimeout(() => {
      const contentElement = document.querySelector('.lg\\:col-span-2');
      if (contentElement) {
        const top = contentElement.getBoundingClientRect().top + window.pageYOffset - 100; // 100px offset for navbar
        window.scrollTo({ top, behavior: 'smooth' });
      }
    }, 50); // Small delay to ensure DOM is updated
  };

  // Handlers
  const handleStepClick = (stepId: string | number) => {
    const index = stepsArray.findIndex(s => s.id === stepId);
    if (index >= 0) {
      setActiveStepIndex(index);
      scrollToContent();
    }
  };

  const handleNextStep = () => {
    if (activeStepIndex < stepsArray.length - 1) {
      setActiveStepIndex(prev => prev + 1);
      scrollToContent();
    }
  };

  const handlePrevStep = () => {
    if (activeStepIndex > 0) {
      setActiveStepIndex(prev => prev - 1);
      scrollToContent();
    }
  };

  const handleSuccess = () => {
    setSuccessState(true);
    confetti({
      particleCount: 100,
      spread: 70,
      origin: { y: 0.6 }
    });
    toast({
      title: "축하합니다! 가이드를 완료하셨어요! 🎉",
      description: "멋진 결과물을 만드셨길 바랍니다.",
      duration: 4000,
    });
    // Frequency Capping: Save that they completed this guide so we don't ask again immediately
    if (guide?.id) {
      localStorage.setItem(`feedback_guide_${guide.id}_completed`, 'true');
    }
  };

  const handleFailure = () => {
    setIsFeedbackModalOpen(true);
  };

  const handlePromptStepClick = (stepNumber: number) => {
    setActiveTab('curriculum');
    // stepNumber is 1-based, activeStepIndex is 0-based
    const targetIndex = stepNumber - 1;
    if (targetIndex >= 0 && targetIndex < stepsArray.length) {
      setActiveStepIndex(targetIndex);
      scrollToContent();
    }
  };

  // Sync activeStepIndex to activeStepId for Sidebar
  const activeStepId = hasSteps ? stepsArray[activeStepIndex]?.id : null;

  // Initial Progress Load (remains same)
  useEffect(() => {
    // ... (keep existing logic)
    const loadProgress = async () => {
      let completed: (string | number)[] = [];
      if (user && guide?.id) {
        try {
          const { data } = await (supabase as any)
            .from('guide_progress')
            .select('step_id')
            .eq('guide_id', guide.id)
            .eq('completed', true);
          if (data) completed = [...completed, ...data.map(d => d.step_id)];
        } catch (err) { console.error(err); }
      }
      stepsArray.forEach(step => {
        const isDbStep = typeof step.id === 'number';
        if (!isDbStep || !user) {
          const storageKey = user ? `guide_progress_${guide?.id}_${step.id}_${user.id}` : `guide_progress_${guide?.id}_${step.id}`;
          if (localStorage.getItem(storageKey) === 'true' && !completed.includes(step.id)) completed.push(step.id);
        }
      });
      setCompletedStepIds(completed);
    };
    if (guide?.id && stepsArray.length > 0) loadProgress();
  }, [guide?.id, stepsArray, user]);

  // Listen for progress updates (remains same)
  useEffect(() => {
    const handleProgressChange = (e: CustomEvent) => {
      const { guideId: eventGuideId, stepId, completed } = e.detail;
      if (Number(eventGuideId) !== Number(guide?.id)) return;
      setCompletedStepIds(prev => completed ? (prev.includes(stepId) ? prev : [...prev, stepId]) : prev.filter(id => id !== stepId));
    };
    window.addEventListener('stepProgressChanged', handleProgressChange as EventListener);
    return () => window.removeEventListener('stepProgressChanged', handleProgressChange as EventListener);
  }, [guide?.id]);


  // Loading & Error States (remains same)
  if (isLoading) return <div className="min-h-screen bg-background"><Navbar /><div className="container px-4 md:px-6 py-12"><Skeleton className="h-12 w-3/4 mb-6" /><Skeleton className="h-6 w-1/2 mb-12" /><div className="grid gap-8 lg:grid-cols-[1fr,400px]"><Skeleton className="h-96" /><Skeleton className="h-96" /></div></div><Footer /></div>;
  if (error) return <div>에러가 발생했습니다: {error.message}</div>;
  if (!guide) return <div>가이드를 찾을 수 없습니다.</div>;

  // Load prompts from guide_sections table where section_type is 'prompt_pack'
  const promptPacks = sections
    ?.filter(s => s.section_type === 'prompt_pack')
    .flatMap((s, sectionIndex) => {
      const data = s.data;
      // data is a JSONB array of objects with {label, text} structure
      if (Array.isArray(data)) {
        return data.map((item: any, index: number) => ({
          id: item.id || `prompt-${sectionIndex}-${index}`,
          title: item.title || item.label, // Support both new and old format
          prompt: item.prompt || item.text, // Support both new and old format
          description: item.description,
          tags: item.tags,
          relatedStep: item.relatedStep,
          failurePatterns: item.failurePatterns
        }));
      }
      return [];
    }) || [];
  const totalSteps = navSteps.length;
  const completedCount = completedStepIds.length;
  const progressPercentage = totalSteps > 0 ? Math.round((completedCount / totalSteps) * 100) : 0;

  // Current Active Step Data
  const currentStep = hasSteps ? stepsArray[activeStepIndex] : null;

  console.log('Guide Data:', guide);
  console.log('Sections Data:', sections);

  // Process sections for Overview Cards
  const summarySection = sections?.find((s: any) => s.section_type === 'summary');
  const targetAudienceSection = sections?.find((s: any) => s.section_type === 'target_audience');
  const preparationSection = sections?.find((s: any) => s.section_type === 'preparation');
  const corePrinciplesSection = sections?.find((s: any) => s.section_type === 'core_principles');

  const summaryContent = summarySection?.content || guide?.one_line_summary;
  const recommendations = targetAudienceSection?.data || [];
  const requirements = preparationSection?.data || (guide?.requirements && Array.isArray(guide.requirements) ? guide.requirements : ["ChatGPT 계정"]);

  const rawCorePrinciples = corePrinciplesSection?.data || [];
  const corePrinciples = Array.isArray(rawCorePrinciples)
    ? rawCorePrinciples.map((item: any) => typeof item === 'string' ? item : `${item.title}: ${item.description}`)
    : [];

  return (
    <div className="min-h-screen bg-slate-50">
      <Navbar />

      <main className="container max-w-7xl mx-auto py-12 px-4">
        {/* Breadcrumb */}
        <div className="flex items-center gap-2 text-sm text-slate-500 mb-6">
          <Link to="/" className="hover:text-slate-900 cursor-pointer">홈</Link>
          <span>/</span>
          <Link to="/guidebook" className="hover:text-slate-900 cursor-pointer">가이드북</Link>
          <span>/</span>
          <span className="text-slate-900 font-medium">{guide.title}</span>
        </div>

        {/* 1. Header */}
        <GuidebookHeader
          title={guide.title}
          description={guide.description}
          progress={Math.round(progressPercentage)}
          category={guide.categories?.name}
          tags={id === '14' ? ['ChatGPT', 'Kling AI', 'Hailuo AI'] : [guide.ai_models?.name]}
          duration={guide.estimated_time}
          difficulty={guide.difficulty}
        />

        <div className="space-y-12">
          {/* 2. Overview Cards */}
          <section className="space-y-8">
            <GuideOverviewCards
              summary={summaryContent}
              recommendations={recommendations}
              requirements={requirements}
              corePrinciples={corePrinciples}
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
          <section className="min-h-[500px]">
            {activeTab === 'curriculum' ? (
              <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 items-start">

                {/* Modified Layout: Sidebar LEFT, Content RIGHT */}

                {/* Sidebar (Desktop: Left) */}
                <div className="hidden lg:block space-y-6 sticky top-24 lg:col-span-1">
                  {hasSteps && navSteps.length > 0 && (
                    <GuideProgressSidebar
                      steps={navSteps}
                      activeStepId={activeStepId}
                      completedStepIds={completedStepIds}
                      onStepClick={handleStepClick}
                    />
                  )}
                </div>

                {/* Main Content (Right) */}
                <div className="lg:col-span-2 space-y-8">
                  {/* Focus Mode: Render only active step */}
                  {currentStep ? (
                    <div className="animate-in fade-in slide-in-from-bottom-4 duration-500">
                      <StepCard
                        key={currentStep.id} // Key forces re-render on step change
                        step={{
                          ...currentStep,
                          id: currentStep.id,
                          guide_prompts: (currentStep as any).guide_prompts || [],
                          guide_workbook_fields: (currentStep as any).guide_workbook_fields || [],
                        }}
                        stepNumber={activeStepIndex + 1}
                        guideId={guide.id}
                        isOpen={true} // Always open in focus mode
                        toolName={(guide.ai_models as any)?.name}
                        toolUrl={(guide.ai_models as any)?.website_url}
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
                            variant={completedStepIds.includes(currentStep.id) ? "secondary" : "outline"}
                            onClick={async () => {
                              const step = currentStep;
                              const isCompleted = completedStepIds.includes(step.id);
                              const newCompleted = !isCompleted;

                              if (typeof step.id === 'number') {
                                if (!user) {
                                  toast({ title: "로그인이 필요합니다", description: "진행률을 저장하려면 로그인해주세요" });
                                  return;
                                }
                                const { error } = await (supabase as any)
                                  .from('guide_progress')
                                  .upsert({
                                    user_id: user.id,
                                    guide_id: guide.id,
                                    step_id: step.id,
                                    completed: newCompleted,
                                    completed_at: newCompleted ? new Date().toISOString() : null,
                                  }, { onConflict: 'user_id,step_id' });

                                if (error) {
                                  toast({ title: "오류 발생", description: error.message, variant: "destructive" });
                                  return;
                                }
                              } else {
                                const storageKey = user
                                  ? `guide_progress_${guide.id}_${step.id}_${user.id}`
                                  : `guide_progress_${guide.id}_${step.id}`;
                                if (newCompleted) localStorage.setItem(storageKey, 'true');
                                else localStorage.removeItem(storageKey);
                              }

                              window.dispatchEvent(new CustomEvent('stepProgressChanged', {
                                detail: { guideId: guide.id, stepId: step.id, completed: newCompleted }
                              }));

                              if (newCompleted) {
                                toast({ title: "완료되었습니다! 🎉" });
                                // Optional: Auto-advance could be added here if desired, but user didn't explicitly ask for auto-advance on complete.
                              }
                            }}
                            className={`gap-2 ${completedStepIds.includes(currentStep.id) ? 'bg-emerald-100 text-emerald-700 hover:bg-emerald-200 border-emerald-200' : 'text-slate-500 hover:text-slate-900'}`}
                          >
                            <CheckCircle2 className={`w-4 h-4 ${completedStepIds.includes(currentStep.id) ? 'fill-emerald-600 text-white' : ''}`} />
                            {completedStepIds.includes(currentStep.id) ? '완료됨' : '완료 표시'}
                          </Button>

                          <Button
                            onClick={handleNextStep}
                            disabled={activeStepIndex === stepsArray.length - 1}
                            className="gap-2 pr-2.5 bg-emerald-600 hover:bg-emerald-700 text-white shadow-md hover:shadow-lg transition-all"
                          >
                            다음 Step
                            <ChevronRight className="w-4 h-4" />
                          </Button>
                        </div>
                      </div>
                    </div>
                  ) : (
                    <div className="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm">
                      {/* Fallback for no steps (Markdown only) */}
                      <h3 className="font-bold text-lg mb-4">가이드 내용</h3>
                      <div className="prose prose-sm max-w-none">
                        <ReactMarkdown remarkPlugins={[remarkGfm]} rehypePlugins={[rehypeSlug, [rehypeAutolinkHeadings, { behavior: 'wrap' }]]}>
                          {guide.content || ''}
                        </ReactMarkdown>
                      </div>
                    </div>
                  )}

                  {/* Feedback Section (Only show on last step?) */}
                  {activeStepIndex === stepsArray.length - 1 && (
                    <section className="rounded-3xl border border-slate-200 bg-white p-8 mt-16 animate-in fade-in duration-700 text-center shadow-sm">
                      <div className="mb-6">
                        <h3 className="text-xl font-bold text-slate-900 mb-2">가이드를 모두 완료하셨나요?</h3>
                        <p className="text-slate-500">여러분의 경험이 궁금합니다. 결과를 알려주세요!</p>
                      </div>

                      {!successState ? (
                        <div className="flex flex-col sm:flex-row justify-center gap-4">
                          <Button
                            onClick={handleSuccess}
                            className="h-12 px-8 text-base bg-emerald-600 hover:bg-emerald-700 text-white shadow-lg shadow-emerald-200 transition-all hover:scale-105"
                          >
                            🎉 네, 성공했어요!
                          </Button>
                          <Button
                            variant="outline"
                            onClick={handleFailure}
                            className="h-12 px-8 text-base border-slate-200 hover:bg-slate-50 text-slate-600 hover:text-slate-900 transition-all"
                          >
                            🤔 잘 안 되거나 막혔어요
                          </Button>
                        </div>
                      ) : (
                        <div className="flex items-center justify-center gap-2 text-emerald-600 font-bold text-lg animate-in zoom-in duration-300">
                          <CheckCircle2 className="w-6 h-6" />
                          <span>완료되었습니다! 수고하셨어요 👏</span>
                        </div>
                      )}

                      <GuideFeedbackModal
                        isOpen={isFeedbackModalOpen}
                        onClose={() => setIsFeedbackModalOpen(false)}
                        guideId={guide.id}
                        guideTitle={guide.title}
                        steps={stepsArray.map(s => ({ id: s.id, step_order: s.step_order, title: s.title }))}
                      />
                    </section>
                  )}
                </div>

              </div>
            ) : (
              /* Prompt Pack View */
              <div className="animate-in fade-in duration-300">
                <PromptPack prompts={promptPacks} onStepClick={handlePromptStepClick} />
              </div>
            )}
          </section>
        </div>
      </main>
      <Footer />
    </div>
  );
};

export default GuideDetail;