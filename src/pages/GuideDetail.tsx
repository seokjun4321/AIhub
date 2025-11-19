import { useParams, Link } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { GuideHeader } from "@/components/guide/GuideHeader";
import { GuideHero } from "@/components/guide/GuideHero";
import { GuideSidebar } from "@/components/guide/GuideSidebar";
import { StepCard } from "@/components/guide/StepCard";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { ThumbsUp, ThumbsDown, ArrowRight, ChevronDown } from "lucide-react";
import { useState } from "react";
import { useToast } from "@/hooks/use-toast";
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import rehypeSlug from 'rehype-slug';
import rehypeAutolinkHeadings from 'rehype-autolink-headings';
import { Skeleton } from "@/components/ui/skeleton";
import { Collapsible, CollapsibleContent, CollapsibleTrigger } from "@/components/ui/collapsible";

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
      // 이전 스텝이 있으면 저장
      if (currentStep) {
        steps.push(currentStep);
      }
      
      // 새 스텝 시작 - 마크다운 볼드 제거
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
      // 현재 스텝의 내용 추가
      currentStep.content += line + '\n';
      
      // 첫 번째 문단을 summary로 사용 (헤딩 다음 첫 문단)
      if (!currentStep.summary && line.trim() && !line.trim().startsWith('#')) {
        const firstParagraph = line.trim().replace(/[#*`\[\]]/g, '').substring(0, 100);
        if (firstParagraph.length > 0) {
          currentStep.summary = firstParagraph + (firstParagraph.length >= 100 ? '...' : '');
        }
      }
    }
  }
  
  // 마지막 스텝 저장
  if (currentStep) {
    steps.push(currentStep);
  }
  
  return steps;
}

// 목차 생성 (단계가 있으면 단계 기반, 없으면 Markdown 기반)
function buildTOC(steps: any[], content: string | null): Array<{ title: string; slug: string; stepId?: number }> {
  // 단계가 있으면 단계 기반 목차 - 마크다운 볼드 제거
  if (steps && steps.length > 0) {
    return steps.map((step) => {
      // slug 생성: 숫자 ID면 #step-{id}, 문자열 ID면 #{id} (이미 step- 포함)
      const slug = typeof step.id === 'number' 
        ? `#step-${step.id}` 
        : `#${step.id}`;
      return {
        title: removeMarkdownBold(step.title),
        slug: slug,
        stepId: typeof step.id === 'number' ? step.id : undefined,
      };
    });
  }
  
  // 단계가 없으면 기존 content에서 Markdown 헤딩 추출
  if (!content) return [];
  
  const lines = content.split(/\r?\n/);
  const items: Array<{ title: string; slug: string }> = [];
  const slugify = (text: string) =>
    '#' + text
      .trim()
      .toLowerCase()
      .replace(/[^a-z0-9가-힣\s-]/g, '')
      .replace(/\s+/g, '-')
      .replace(/-+/g, '-');
  for (const line of lines) {
    const match = /^(##+)[\s]+(.+)$/.exec(line.trim());
    if (match) {
      const rawTitle = match[2].trim();
      const title = removeMarkdownBold(rawTitle);
      items.push({ title, slug: slugify(title) });
    }
  }
  return items;
}

const GuideDetail = () => {
  const { id } = useParams<{ id: string }>();
  const [feedbackGiven, setFeedbackGiven] = useState(false);
  const [openSections, setOpenSections] = useState<Record<number, boolean>>({});
  const { toast } = useToast();

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

  const handleStartGuide = () => {
    if (steps && Array.isArray(steps) && steps.length > 0) {
      // 단계가 있으면 첫 번째 단계로 스크롤
      const firstStep = document.getElementById(`step-${steps[0].id}`);
      if (firstStep) {
        firstStep.scrollIntoView({ behavior: "smooth", block: "start" });
      }
    } else {
      // 단계가 없으면 기존 방식 (Markdown 헤딩)
      const tocItems = buildTOC([], guide?.content || '');
      if (tocItems.length > 0) {
        const firstItem = document.querySelector(tocItems[0].slug);
        if (firstItem) {
          firstItem.scrollIntoView({ behavior: "smooth", block: "start" });
        }
      }
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

  // DB에서 가져온 스텝이 있으면 사용, 없으면 마크다운에서 파싱
  const dbSteps = Array.isArray(steps) ? steps : [];
  const parsedSteps = dbSteps.length === 0 && guide.content 
    ? parseMarkdownToSteps(guide.content) 
    : [];
  
  // DB 스텝과 파싱된 스텝 중 하나 사용
  const stepsArray = dbSteps.length > 0 ? dbSteps : parsedSteps;
  const tocItems = buildTOC(stepsArray, guide.content);
  const breadcrumbs = [
    "가이드북",
    (guide.categories as any)?.name || "카테고리",
    guide.title
  ].filter(Boolean);

  // 단계가 있는 경우와 없는 경우를 구분하여 렌더링
  const hasSteps = stepsArray.length > 0;

  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      <div className="pt-16">
        <GuideHero 
          title={guide.title}
          description={guide.description}
          category={(guide.categories as any)?.name}
          toolName={(guide.ai_models as any)?.name}
          toolLogoUrl={(guide.ai_models as any)?.logo_url}
          estimatedTime={guide.estimated_time}
          updatedAt={guide.updated_at}
          content={guide.content}
          author={guide.profiles}
          onStartGuide={handleStartGuide}
        />
          </div>

      <main className="pt-6 pb-12 relative">
        <div className="flex flex-col lg:flex-row gap-6 items-start mx-auto px-4 md:px-6 max-w-7xl">
          {/* Main Content */}
          <div className="flex-1 space-y-8 min-w-0">
            {/* Sections (한 줄 요약, Persona, 핵심 기능 등) */}
            {sections && sections.length > 0 && (
              <section className="space-y-4">
                {sections.map((section, index) => {
                  // 섹션의 요약 텍스트 생성 (content의 첫 100자)
                  const summary = section.content 
                    ? section.content.replace(/[#*`\[\]]/g, '').substring(0, 100) + (section.content.length > 100 ? '...' : '')
                    : null;
                  
                  const isOpen = openSections[section.id] ?? (index === 0);
                  
                  return (
                    <Collapsible 
                      key={section.id} 
                      open={isOpen} 
                      onOpenChange={(open) => setOpenSections(prev => ({ ...prev, [section.id]: open }))} 
                      className="group"
                    >
                      <div className="rounded-xl border bg-card shadow-sm hover:shadow-md transition-all overflow-hidden">
                        <CollapsibleTrigger asChild>
                          <Button
                            variant="ghost"
                            className="w-full justify-between p-5 h-auto hover:bg-muted/30 rounded-xl"
                          >
                            <div className="flex items-center gap-4 text-left flex-1 min-w-0">
                              <div className="flex-1 min-w-0 overflow-hidden">
                                <h3 className="font-semibold text-base text-foreground">
                                  {section.title || `섹션 ${index + 1}`}
                                </h3>
                                {summary && !section.title && (
                                  <p className="text-sm text-muted-foreground mt-1 truncate">{summary}</p>
                                )}
                              </div>
                            </div>
                            <ChevronDown className={`h-5 w-5 text-muted-foreground transition-transform duration-200 ml-4 flex-shrink-0 ${isOpen ? "rotate-180" : ""}`} />
                          </Button>
                        </CollapsibleTrigger>

                        <CollapsibleContent className="px-5 pb-6 space-y-6 animate-accordion-down">
                          <div className="border-t border-border/50 pt-6">
                            {section.content && (
                              <div className="prose prose-sm max-w-none prose-headings:scroll-mt-24 
                                prose-p:text-foreground/90 prose-p:leading-relaxed prose-p:mb-4
                                prose-headings:text-foreground prose-headings:font-bold prose-headings:mb-4 prose-headings:mt-6
                                prose-strong:text-foreground prose-strong:font-bold
                                prose-ul:space-y-2 prose-ul:my-4 
                                prose-ol:space-y-2 prose-ol:my-4 
                                prose-li:text-foreground/90 prose-li:leading-relaxed
                                prose-code:text-accent prose-code:bg-muted prose-code:px-1.5 prose-code:py-0.5 prose-code:rounded
                                prose-blockquote:border-l-accent prose-blockquote:border-l-4 prose-blockquote:pl-4 prose-blockquote:italic
                                prose-a:text-foreground prose-a:font-medium prose-a:underline hover:prose-a:opacity-80 mb-6">
                                <ReactMarkdown 
                                  remarkPlugins={[remarkGfm]}
                                  rehypePlugins={[rehypeSlug, [rehypeAutolinkHeadings, { behavior: 'wrap' }]]}
                                  components={{
                                    strong: ({node, ...props}) => <strong className="font-bold text-foreground" {...props} />,
                                    a: ({node, ...props}) => <a className="text-foreground font-medium underline hover:opacity-80" {...props} />
                                  }}
                                >
                                  {section.content}
                                </ReactMarkdown>
                              </div>
                            )}
                            {section.data && (
                              <div className="mt-6">
                                {section.section_type === 'persona' && (
                                  <div className="overflow-x-auto">
                                    <table className="w-full border-collapse">
                                      <thead>
                                        <tr className="border-b">
                                          <th className="text-left p-3 font-semibold">Persona</th>
                                          <th className="text-left p-3 font-semibold">상황 / 문제</th>
                                          <th className="text-left p-3 font-semibold">목표</th>
                                        </tr>
                                      </thead>
                                      <tbody>
                                        {Array.isArray(section.data) && section.data.map((item: any, idx: number) => (
                                          <tr key={idx} className="border-b">
                                            <td className="p-3">{item.persona}</td>
                                            <td className="p-3">{item.situation}</td>
                                            <td className="p-3">{item.goal}</td>
                                          </tr>
                                        ))}
                                      </tbody>
                                    </table>
                                  </div>
                                )}
                                {section.section_type === 'features' && (
                                  <div className="space-y-4">
                                    {Array.isArray(section.data) && section.data.map((item: any, idx: number) => (
                                      <div key={idx} className="border-l-4 border-accent pl-4 py-2">
                                        <h4 className="font-semibold mb-1">{item.name}</h4>
                                        <p className="text-sm text-muted-foreground mb-1">{item.description}</p>
                                        {item.example && (
                                          <p className="text-xs text-muted-foreground italic">{item.example}</p>
                                        )}
                                      </div>
                                    ))}
                                  </div>
                                )}
                                {section.section_type === 'pros_cons' && section.data && Array.isArray(section.data) && (
                                  <div className="overflow-x-auto mt-4">
                                    <table className="w-full border-collapse border">
                                      <thead>
                                        <tr className="border-b bg-muted/50">
                                          <th className="text-left p-3 font-semibold border-r">비교 항목</th>
                                          <th className="text-left p-3 font-semibold border-r">주요 역할</th>
                                          <th className="text-left p-3 font-semibold border-r">강점</th>
                                          <th className="text-left p-3 font-semibold border-r">약점</th>
                                          <th className="text-left p-3 font-semibold">추천 사용자</th>
                                        </tr>
                                      </thead>
                                      <tbody>
                                        {section.data.map((item: any, idx: number) => (
                                          <tr key={idx} className="border-b">
                                            <td className="p-3 font-medium border-r">{item.tool}</td>
                                            <td className="p-3 border-r">{item.role}</td>
                                            <td className="p-3 border-r">{item.strength}</td>
                                            <td className="p-3 border-r">{item.weakness}</td>
                                            <td className="p-3">{item.recommended_for}</td>
                                          </tr>
                                        ))}
                                      </tbody>
                                    </table>
                                  </div>
                                )}
                              </div>
                            )}
                          </div>
                        </CollapsibleContent>
                      </div>
                    </Collapsible>
                  );
                })}
              </section>
            )}
            {/* Steps 또는 Content */}
            {hasSteps ? (
              <section className="space-y-4">
                {stepsArray.map((step, index) => (
                  <StepCard 
                    key={step.id || `parsed-step-${index}`} 
                    step={{
                      ...step,
                      // 파싱된 스텝의 원래 ID 유지 (문자열), DB 스텝은 숫자 ID 유지
                      id: step.id,
                      guide_prompts: step.guide_prompts || [],
                      guide_workbook_fields: step.guide_workbook_fields || [],
                    }} 
                    stepNumber={index + 1}
                    isOpen={false}
                    guideId={guide.id}
                  />
                ))}
              </section>
            ) : (
              <section className="rounded-2xl border bg-card shadow-sm overflow-hidden">
                <div className="px-6 md:px-10 py-8">
                  <article className="prose prose-sm max-w-none prose-headings:scroll-mt-24 
                    prose-p:text-foreground/90 prose-p:leading-relaxed prose-p:mb-4
                    prose-headings:text-foreground prose-headings:font-bold prose-headings:mb-4 prose-headings:mt-6
                    prose-strong:text-foreground prose-strong:font-bold
                    prose-ul:space-y-2 prose-ul:my-4 
                    prose-ol:space-y-2 prose-ol:my-4 
                    prose-li:text-foreground/90 prose-li:leading-relaxed
                    prose-code:text-accent prose-code:bg-muted prose-code:px-1.5 prose-code:py-0.5 prose-code:rounded
                    prose-blockquote:border-l-accent prose-blockquote:border-l-4 prose-blockquote:pl-4 prose-blockquote:italic
                    prose-a:text-blue-600 prose-a:dark:text-blue-400 prose-a:font-medium prose-a:underline hover:prose-a:text-blue-800 dark:hover:prose-a:text-blue-300">
                    <ReactMarkdown 
                      remarkPlugins={[remarkGfm]}
                      rehypePlugins={[rehypeSlug, [rehypeAutolinkHeadings, { behavior: 'wrap' }]]}
                      components={{
                        strong: ({node, ...props}) => <strong className="font-bold text-foreground" {...props} />,
                        a: ({node, ...props}) => <a className="text-blue-600 dark:text-blue-400 font-medium underline hover:text-blue-800 dark:hover:text-blue-300" {...props} />
                      }}
                    >
                      {guide.content || ''}
                    </ReactMarkdown>
                  </article>
                </div>
              </section>
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

          {/* Sidebar */}
          <GuideSidebar 
            tocItems={tocItems}
            relatedGuides={relatedGuides}
            content={guide.content}
            guideId={guide.id}
            stepIds={stepsArray.filter(s => typeof s.id === 'number').map(s => s.id as number)}
            totalSteps={stepsArray.length}
          />
        </div>
      </main>

      <Footer />
    </div>
  );
};

export default GuideDetail;