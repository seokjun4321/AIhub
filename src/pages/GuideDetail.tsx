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
import { ThumbsUp, ThumbsDown } from "lucide-react";
import { useState, useEffect } from "react";
import { useToast } from "@/hooks/use-toast";
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import rehypeSlug from 'rehype-slug';
import rehypeAutolinkHeadings from 'rehype-autolink-headings';
import { Skeleton } from "@/components/ui/skeleton";

// 단일 가이드를 불러오는 함수 (관련 데이터 포함)
const fetchGuideById = async (id: string) => {
  const numericId = parseInt(id, 10);
  if (isNaN(numericId)) throw new Error("Invalid ID provided");
  const { data, error } = await supabase
    .from('guides')
    .select(`
      *,
      ai_models(name, logo_url),
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
      *,
      guide_prompts(id, label, text, provider),
      guide_workbook_fields(id, field_key, field_type, label, placeholder)
    `)
    .eq('guide_id', guideId)
    .order('step_order', { ascending: true });

  if (error) throw new Error(error.message);
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
  const [activeStepId, setActiveStepId] = useState<string | number | null>(null);
  const [completedStepIds, setCompletedStepIds] = useState<(string | number)[]>([]);

  const { data: guide, isLoading, error } = useQuery({
    queryKey: ['guide', id],
    queryFn: () => fetchGuideById(id!),
    enabled: !!id,
  });

  const { data: steps } = useQuery({
    queryKey: ['guideSteps', guide?.id],
    queryFn: () => fetchGuideSteps(guide.id),
    enabled: !!guide,
  });

  const { data: sections } = useQuery({
    queryKey: ['guideSections', guide?.id],
    queryFn: () => fetchGuideSections(guide.id),
    enabled: !!guide,
  });

  const { data: relatedGuides } = useQuery({
    queryKey: ['relatedGuides', guide?.id, guide?.category_id, guide?.ai_model_id],
    queryFn: () => fetchRelatedGuides(guide.id, guide.category_id, guide.ai_model_id),
    enabled: !!guide,
  });

  // DB에서 가져온 스텝이 있으면 사용, 없으면 마크다운에서 파싱
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

  // Initial Progress Load
  useEffect(() => {
    const loadProgress = async () => {
      let completed: (string | number)[] = [];

      // 1. DB Steps (if user logged in)
      if (user && guide?.id) {
        try {
          const { data } = await supabase
            .from('guide_progress')
            .select('step_id')
            .eq('guide_id', guide.id)
            .eq('completed', true);

          if (data) {
            completed = [...completed, ...data.map(d => d.step_id)];
          }
        } catch (err) {
          console.error("Failed to load progress", err);
        }
      }

      // 2. LocalStorage Checks (For Parsed Steps OR Guest Users)
      stepsArray.forEach(step => {
        const isDbStep = typeof step.id === 'number';

        // Check LocalStorage if:
        // A) It is a Parsed Step (String ID) - ALWAYS LocalStorage (even if logged in)
        // B) User is Guest (User null) - ALL Steps are LocalStorage
        if (!isDbStep || !user) {
          const storageKey = user
            ? `guide_progress_${guide?.id}_${step.id}_${user.id}`
            : `guide_progress_${guide?.id}_${step.id}`;

          if (localStorage.getItem(storageKey) === 'true') {
            // Avoid duplicates if guest
            if (!completed.includes(step.id)) {
              completed.push(step.id);
            }
          }
        }
      });

      setCompletedStepIds(completed);
    };

    if (guide?.id && stepsArray.length > 0) {
      loadProgress();
    }
  }, [guide?.id, stepsArray, user]);

  // Listen for progress updates
  useEffect(() => {
    const handleProgressChange = (e: CustomEvent) => {
      const { guideId: eventGuideId, stepId, completed } = e.detail;
      if (Number(eventGuideId) !== Number(guide?.id)) return;

      setCompletedStepIds(prev => {
        if (completed) {
          return prev.includes(stepId) ? prev : [...prev, stepId];
        } else {
          return prev.filter(id => id !== stepId);
        }
      });
    };

    window.addEventListener('stepProgressChanged', handleProgressChange as EventListener);
    return () => {
      window.removeEventListener('stepProgressChanged', handleProgressChange as EventListener);
    };
  }, [guide?.id]);

  // Scroll Observation
  useEffect(() => {
    if (!hasSteps) return;

    const observerOptions = {
      root: null,
      rootMargin: '-10% 0px -60% 0px', // When the element is near the top
      threshold: 0
    };

    const observerCallback = (entries: IntersectionObserverEntry[]) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          const stepIdStr = entry.target.id.replace('step-', '');
          // Try to find matching ID in our steps
          const matchingStep = stepsArray.find(s => s.id.toString() == stepIdStr);
          const foundId = matchingStep ? matchingStep.id : stepIdStr;

          setActiveStepId(foundId);

          // Completion logic: mark all previous steps as complete -> REMOVED. Only manual check.
          /*
          const currentIndex = stepsArray.findIndex(s => s.id === foundId);
          if (currentIndex >= 0) {
            const prevSteps = stepsArray.slice(0, currentIndex + 1).map(s => s.id);
            setCompletedStepIds(prevSteps);
          }
          */
        }
      });
    };

    const observer = new IntersectionObserver(observerCallback, observerOptions);

    stepsArray.forEach(step => {
      const element = document.getElementById(`step-${step.id}`);
      if (element) observer.observe(element);
    });

    return () => observer.disconnect();
  }, [hasSteps, stepsArray]);

  const handleStepClick = (stepId: string | number) => {
    setActiveStepId(stepId);
    const element = document.getElementById(`step-${stepId}`);
    if (element) {
      element.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  };

  const handleFeedback = (positive: boolean) => {
    setFeedbackGiven(true);
    toast({
      title: positive ? "피드백 감사합니다!" : "개선하겠습니다",
      description: "의견을 주셔서 감사합니다",
    });
  };

  if (isLoading) {
    return (
      <div className="min-h-screen bg-background">
        <Navbar />
        <div className="container px-4 md:px-6 py-12">
          <Skeleton className="h-12 w-3/4 mb-6" />
          <Skeleton className="h-6 w-1/2 mb-12" />
          <div className="grid gap-8 lg:grid-cols-[1fr,400px]">
            <Skeleton className="h-96" />
            <Skeleton className="h-96" />
          </div>
        </div>
        <Footer />
      </div>
    );
  }

  if (error) return <div>에러가 발생했습니다: {error.message}</div>;
  if (!guide) return <div>가이드를 찾을 수 없습니다.</div>;

  // Process Sections for Tabs
  const usageScenarios = sections?.filter(s => s.section_type === 'usage_scenario').flatMap(s => s.data) || [];
  const promptPacks = sections?.filter(s => s.section_type === 'prompt_pack').flatMap(s => s.data) || [];
  const qualityChecklist = sections?.filter(s => s.section_type === 'quality_checklist').flatMap(s => s.data) || [];
  const commonMistakes = sections?.filter(s => s.section_type === 'common_mistakes').flatMap(s => s.data) || [];
  const beforeAfter = sections?.filter(s => s.section_type === 'before_after').flatMap(s => s.data) || [];

  // Calculate progress for Header and Sidebar
  const totalSteps = navSteps.length;
  const completedCount = completedStepIds.length;
  const progressPercentage = totalSteps > 0 ? Math.round((completedCount / totalSteps) * 100) : 0;

  return (
    <div className="min-h-screen bg-background">
      <Navbar />

      <main className="container max-w-7xl mx-auto py-12 px-4">
        {/* Breadcrumb styled navigation */}
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
          progress={progressPercentage}
          category={(guide.categories as any)?.name}
          toolName={(guide.ai_models as any)?.name}
          logoUrl={(guide.ai_models as any)?.logo_url}
          duration={guide.estimated_time}
          difficulty={guide.difficulty || "초급"}
        />

        <div className="space-y-12">
          {/* 2. Overview Cards only */}
          <section className="space-y-8">
            <GuideOverviewCards
              summary={guide.one_line_summary}
              recommendations={guide.target_audience ? [guide.target_audience, "AI 활용법이 궁금한 분"] : ["누구나"]}
              requirements={guide.requirements && Array.isArray(guide.requirements) ? guide.requirements : ["ChatGPT 계정"]}
              corePrinciples={guide.core_principles && Array.isArray(guide.core_principles) ? guide.core_principles : ["AI는 조수, 판단은 본인"]}
            />
          </section>

          {/* 3. Guide Tabs (Scenarios, Prompts, etc.) */}
          <section>
            <GuideTabs
              scenarios={usageScenarios}
              prompts={promptPacks}
              checklist={qualityChecklist}
              mistakes={commonMistakes}
              comparisons={beforeAfter}
            />
          </section>

          {/* 4. Curriculum (Step-by-step) */}
          <section>
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 items-start">
              <div className="lg:col-span-2 space-y-8">
                {/* Steps Detail - Main Content */}
                {hasSteps ? (
                  <div className="space-y-8">
                    {stepsArray.map((step, index) => (
                      <div id={`step-${step.id}`} key={step.id || index} className="scroll-mt-24">
                        <StepCard
                          step={{
                            ...step,
                            id: step.id,
                            guide_prompts: step.guide_prompts || [],
                            guide_workbook_fields: step.guide_workbook_fields || [],
                          }}
                          stepNumber={index + 1}
                          guideId={guide.id}
                          isOpen={true}
                        />
                      </div>
                    ))}
                  </div>
                ) : (
                  <div className="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm">
                    <h3 className="font-bold text-lg mb-4">가이드 내용</h3>
                    <div className="prose prose-sm max-w-none">
                      <ReactMarkdown
                        remarkPlugins={[remarkGfm]}
                        rehypePlugins={[rehypeSlug, [rehypeAutolinkHeadings, { behavior: 'wrap' }]]}
                      >
                        {guide.content || ''}
                      </ReactMarkdown>
                    </div>
                  </div>
                )}

                {/* Feedback */}
                <section className="rounded-2xl border bg-card p-6">
                  <h3 className="font-semibold mb-4">이 가이드가 도움이 되었나요?</h3>
                  {!feedbackGiven ? (
                    <div className="flex gap-3">
                      <Button
                        variant="outline"
                        onClick={() => handleFeedback(true)}
                        className="border-accent/50 hover:bg-accent/10"
                      >
                        <ThumbsUp className="mr-2 h-4 w-4" />
                        네, 매우 도움이 되었습니다
                      </Button>
                      <Button
                        variant="outline"
                        onClick={() => handleFeedback(false)}
                        className="border-border/50"
                      >
                        <ThumbsDown className="mr-2 h-4 w-4" />
                        개선이 필요합니다
                      </Button>
                    </div>
                  ) : (
                    <div className="text-accent font-medium">피드백 감사합니다! 🙏</div>
                  )}
                </section>
              </div>

              <div className="hidden lg:block space-y-6 sticky top-24">
                {hasSteps && navSteps.length > 0 && (
                  <GuideProgressSidebar
                    steps={navSteps}
                    activeStepId={activeStepId}
                    completedStepIds={completedStepIds}
                    onStepClick={handleStepClick}
                  />
                )}

                {!hasSteps && (
                  <div className="bg-indigo-50 p-6 rounded-2xl border border-indigo-100">
                    <h3 className="font-bold text-indigo-900 mb-2">🎓 수강 팁</h3>
                    <p className="text-sm text-indigo-700">
                      가이드 내용을 천천히 읽고 실습해보세요.
                    </p>
                  </div>
                )}
              </div>
            </div>
          </section>
        </div>
      </main>
      <Footer />
    </div>
  );
};

export default GuideDetail;