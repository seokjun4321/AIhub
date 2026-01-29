import { Collapsible, CollapsibleContent, CollapsibleTrigger } from "@/components/ui/collapsible";
import { HighlightBold } from "@/components/ui/highlight-bold";
import { Button } from "@/components/ui/button";
import { Checkbox } from "@/components/ui/checkbox";
import { ChevronDown, Link as LinkIcon } from "lucide-react";
import { PromptBlock } from "./PromptBlock";
import { WorkbookPanel } from "./WorkbookPanel";
import { useState, useEffect, useMemo } from "react";
import { useAuth } from "@/hooks/useAuth";
import { supabase } from "@/integrations/supabase/client";
import { useToast } from "@/hooks/use-toast";
import { GoalBanner, WhyThisMatters, ActionList, ExampleBlock, InputOutputBlock, TipsBlock, ChecklistBlock, CopyBlock, BranchBlock, ComparisonBlock, ImageDisplayBlock, ExampleDisplayBlock } from "./StepBlockComponents";
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';

interface StepBranch {
  id: string;
  content: {
    question?: string;
    optionA?: string;
    descriptionA?: string;
    optionB?: string;
    descriptionB?: string;
  };
}

interface StepExample {
  id: string;
  content: {
    title?: string;
    description?: string;
    exampleText: string;
    type?: 'success' | 'warning' | 'info';
  };
}

interface StepImage {
  id: string;
  content: {
    imageUrl: string;
    caption?: string;
    alt?: string;
    width?: string;
  };
}

interface StepCopyBlock {
  id: string;
  content: {
    title?: string;
    text: string;
    language?: string;
    description?: string;
  };
}

interface Step {
  id: number | string;
  step_order: number;
  title: string;
  summary: string | null;
  content: string | null;
  // New structured fields
  goal?: string | null;
  done_when?: string | null;
  why_matters?: string | null;
  tips?: string | null;
  checklist?: string | null;
  actions?: string | null; // Direct injection for Builder

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
  branches?: StepBranch[]; // New field for Preview
  // NEW: Content Enhancement Blocks
  examples?: StepExample[];
  images?: StepImage[];
  copyBlocks?: StepCopyBlock[];
}

export interface StepCardProps {
  step: Step;
  stepNumber: number;
  isOpen?: boolean;
  guideId: number;
  toolName?: string;
  toolUrl?: string;
}

// Simple markdown splitter (Fallback)
interface CopyBlockData {
  title: string;
  content: string;
}

interface ParsedSections extends Record<string, string | CopyBlockData[] | { src: string, alt: string }[] | any> {
  copyBlocks?: CopyBlockData[];
  images?: { src: string, alt: string }[];
}

const parseStepContent = (content: string | null): ParsedSections => {
  if (!content) return {};

  const sections: ParsedSections = {};
  const lines = content.split(/\r?\n/);
  let currentKey = 'intro';
  let buffer: string[] = [];

  // Image extraction
  let images: { src: string, alt: string }[] = [];

  // For multi-block support
  let copyBlocks: CopyBlockData[] = [];
  let currentCopyBlockTitle = "Copy Block";

  const flush = () => {
    if (buffer.length > 0) {
      const text = buffer.join('\n').trim();

      if (currentKey === 'copyPrompt') {
        // Add to array instead of overwriting
        copyBlocks.push({
          title: currentCopyBlockTitle,
          content: text
        });
        // Also keep legacy field for backward compatibility if it's the first one
        if (!sections['copyPrompt']) {
          sections['copyPrompt'] = text;
        }
      } else {
        if (sections[currentKey]) {
          // If string, append. If array/object, ignore for now (simplified)
          if (typeof sections[currentKey] === 'string') {
            sections[currentKey] += '\n' + text;
          }
        } else {
          sections[currentKey] = text;
        }
      }
    }
    buffer = [];
  };

  lines.forEach(line => {
    // 1. Check for Image Markdown: ![alt](src)
    // We only extract standalone image lines. Inline images might be tricky, assuming block for now.
    const imageMatch = line.match(/^\s*!\[(.*?)\]\((.*?)\)\s*$/);
    if (imageMatch) {
      // It's an image line!
      flush(); // Flush content before this image
      images.push({
        alt: imageMatch[1],
        src: imageMatch[2]
      });
      return; // Skip adding this line to buffer
    }

    // Only match markdown headers: #### Title
    const matchHash = line.match(/^\s*(#{2,6})\s+(.+)$/);

    if (matchHash) {
      flush();

      const rawTitle = matchHash[2].trim();
      const lowerTitle = rawTitle.toLowerCase(); // Case-insensitive matching
      const t = lowerTitle;

      // Extract marker patterns like (A), (B), (C), (D), (E) from the title
      const markerMatch = t.match(/\(([a-e])\)/i);
      const marker = markerMatch ? markerMatch[1].toLowerCase() : null;
      console.log('[PARSER] rawTitle:', rawTitle, '| marker:', marker);

      if (t.includes('cmp') || t.includes('비교') || t.includes('comparison')) currentKey = 'comparison';
      else if (marker === 'b' || t.includes('action') || t.includes('할 일') || t.includes('할일') || t.includes('실행') || t.includes('따라하기')) currentKey = 'actions';
      else if (marker === 'c' || t.includes('복붙') || t.includes('copy') || t.includes('template') || t.includes('템플릿')) {
        currentKey = 'copyPrompt';
        // Use the raw title (without marker if possible, or just raw) as the block title
        // e.g. "#### (C) 과학 분야 예시" -> "과학 분야 예시"
        currentCopyBlockTitle = rawTitle.replace(/^\([a-e]\)\s*/i, '').trim() || "Copy Block";
      }
      else if (marker === 'e' || t.includes('분기') || t.includes('branch') || t.includes('선택')) currentKey = 'branch';
      else if (marker === 'd' || t.includes('example') || t.includes('예시')) currentKey = 'example';
      else if (marker === 'a' || t.includes('goal') || t.includes('목표') || t.includes('핵심')) currentKey = 'goal';
      else if (t.includes('done') || t.includes('완료')) currentKey = 'doneWhen';
      else if (t.includes('why') || t.includes('이유')) currentKey = 'why';
      else if (t.includes('input') || t.includes('입력')) currentKey = 'input_example';
      else if (t.includes('output') || t.includes('출력') || t.includes('결과')) currentKey = 'output_example';
      else if (t.includes('tip') || t.includes('팁') || t.includes('mistake') || t.includes('실수') || t.includes('주의')) currentKey = 'tips';
      else if (t.includes('check') || t.includes('체크')) currentKey = 'checklist';
      else currentKey = 'other';
    } else {
      buffer.push(line);
    }
  });
  flush();

  // Attach collected copy blocks
  if (copyBlocks.length > 0) {
    sections['copyBlocks'] = copyBlocks;
  }

  // Attach collected images
  if (images.length > 0) {
    sections['images'] = images;
  }

  // Post-process: Split 'example' section into 'input', 'process', and 'output' parts
  if (sections.example && typeof sections.example === 'string' && !sections.input_example && !sections.output_example) {
    const exampleText = sections.example;

    // Regex to match sections
    // Input: starts with **...입력... or **...Input..., captures until next block
    const inputMatch = exampleText.match(/\*\*[^*]*(?:입력|Input)[^*]*\*\*\s*:?\s*([^]*?)(?=\*\*[^*]*(?:과정|Process|출력|Output|반환|결과|Result|Response)[^*]*\*\*|\s*$)/i);

    // Process: starts with **...과정... or **...Process..., captures until next block
    const processMatch = exampleText.match(/\*\*[^*]*(?:과정|Process)[^*]*\*\*\s*:?\s*([^]*?)(?=\*\*[^*]*(?:출력|Output|반환|결과|Result|Response)[^*]*\*\*|\s*$)/i);

    // Output: starts with **...출력... or **...Output... or **...반환..., captures until end
    const outputMatch = exampleText.match(/\*\*[^*]*(?:출력|Output|반환|결과|Result|Response)[^*]*\*\*\s*:?\s*([^]*?)$/i);

    if (inputMatch) {
      sections.input_example = inputMatch[1].trim();
      console.log('[PARSER] Extracted input_example');
    }

    if (processMatch) {
      sections.process_example = processMatch[1].trim();
      console.log('[PARSER] Extracted process_example');
    }

    if (outputMatch) {
      sections.output_example = outputMatch[1].trim();
      console.log('[PARSER] Extracted output_example');
    }
  }

  return sections;
};

export function StepCard({ step, stepNumber, isOpen = false, guideId, toolName, toolUrl }: StepCardProps) {
  // ... (existing hooks and state) ...
  const [open, setOpen] = useState(isOpen);
  const [completed, setCompleted] = useState(false);
  const { user } = useAuth();
  const { toast } = useToast();

  const parsedContent = useMemo(() => parseStepContent(step.content), [step.content]);

  // Prioritize structured columns, fallback to parsed markdown
  const goal = step.goal || parsedContent.goal;
  const doneWhen = step.done_when || parsedContent.doneWhen;
  const whyMatters = step.why_matters || parsedContent.why;
  const tips = step.tips || parsedContent.tips;
  const checklist = step.checklist || parsedContent.checklist;

  // If we have specific action items, use them. 
  const actions = step.actions || parsedContent.actions || parsedContent.other || "";
  const copyPrompt = step.guide_prompts?.[0]?.text || parsedContent.copyPrompt;
  const branch = parsedContent.branch;

  // Also check for example blocks in parsed content
  const inputExample = parsedContent.input_example;
  const processExample = parsedContent.process_example;
  const outputExample = parsedContent.output_example;
  const generalExample = parsedContent.example;

  // ... (useEffect hooks) ...
  useEffect(() => {
    setOpen(isOpen);
  }, [isOpen]);

  useEffect(() => {
    if (typeof step.id === 'number') {
      if (user) {
        (supabase as any)
          .from('guide_progress')
          .select('completed')
          .eq('user_id', user.id)
          .eq('step_id', step.id)
          .single()
          .then(({ data }: any) => {
            if (data) setCompleted(data.completed);
          });
      }
    } else {
      const storageKey = user
        ? `guide_progress_${guideId}_${step.id}_${user.id}`
        : `guide_progress_${guideId}_${step.id}`;
      const stored = localStorage.getItem(storageKey);
      setCompleted(stored === 'true');
    }
  }, [user, step.id, guideId]);

  const handleToggleComplete = async () => {
    // ... (existing implementation) ...
    const newCompleted = !completed;
    setCompleted(newCompleted);

    if (typeof step.id === 'number') {
      if (!user) {
        toast({ title: "로그인이 필요합니다", description: "진행률을 저장하려면 로그인해주세요" });
        setCompleted(!newCompleted);
        return;
      }

      const { error } = await (supabase as any)
        .from('guide_progress')
        .upsert({
          user_id: user.id,
          guide_id: guideId,
          step_id: step.id,
          completed: newCompleted,
          completed_at: newCompleted ? new Date().toISOString() : null,
        }, { onConflict: 'user_id,step_id' });

      if (error) {
        toast({ title: "오류 발생", description: error.message, variant: "destructive" });
        setCompleted(!newCompleted);
        return;
      }
    } else {
      const storageKey = user
        ? `guide_progress_${guideId}_${step.id}_${user.id}`
        : `guide_progress_${guideId}_${step.id}`;
      if (newCompleted) localStorage.setItem(storageKey, 'true');
      else localStorage.removeItem(storageKey);
    }

    window.dispatchEvent(new CustomEvent('stepProgressChanged', {
      detail: { guideId, stepId: step.id, completed: newCompleted }
    }));

    toast({ title: newCompleted ? "완료되었습니다! 🎉" : "완료 취소됨" });
  };

  const handleCopyLink = () => {
    const url = `${window.location.pathname}#step-${step.id}`;
    navigator.clipboard.writeText(window.location.origin + url);
    toast({ title: "링크 복사됨", description: "이 단계의 링크가 클립보드에 복사되었습니다" });
  };

  return (
    <div id={`step-${step.id}`} className="scroll-mt-24">
      <Collapsible open={open} onOpenChange={setOpen} className="group">
        <div className={`rounded-2xl border transition-all duration-300 overflow-hidden ${open ? 'bg-white border-slate-200 shadow-lg' : 'bg-white border-slate-100 shadow-sm hover:shadow-md'}`}>
          <CollapsibleTrigger asChild>
            <div className="flex w-full items-center justify-between p-6 h-auto hover:bg-slate-50/50 rounded-none cursor-pointer text-left">
              <div className="flex items-center gap-5 text-left flex-1 min-w-0">
                <div className="flex items-center gap-4 flex-shrink-0">
                  <div className="relative">
                    <Checkbox
                      checked={completed}
                      onCheckedChange={handleToggleComplete}
                      onClick={(e) => e.stopPropagation()}
                      className="absolute -top-1 -right-1 z-10 bg-white shadow-sm h-5 w-5 data-[state=checked]:bg-emerald-600 data-[state=checked]:border-none text-white rounded-full"
                    />
                    <div className={`flex h-12 w-12 items-center justify-center rounded-2xl font-bold text-lg shadow-inner transition-colors ${completed ? 'bg-emerald-100 text-emerald-700' : 'bg-slate-100 text-slate-500'}`}>
                      {stepNumber}
                    </div>
                  </div>
                </div>
                <div className="flex-1 min-w-0">
                  <h3 className={`font-bold text-lg transition-colors ${completed ? 'text-slate-500 line-through decoration-slate-300 decoration-2' : 'text-slate-900'}`}>
                    <HighlightBold text={step.title.replace(/^Step\s+/i, '').replace(/^\d+\.\s*/, '')} />
                  </h3>
                  {step.summary && !open && (
                    <p className="text-sm text-slate-500 mt-1 truncate">{step.summary}</p>
                  )}
                </div>
              </div>
              <div className="flex items-center gap-2 ml-4 flex-shrink-0">
                <ChevronDown className={`h-5 w-5 text-slate-400 transition-transform duration-300 ${open ? "rotate-180" : ""}`} />
              </div>
            </div>
          </CollapsibleTrigger>

          <CollapsibleContent className="animate-accordion-down">
            <div className="px-6 pb-8 pt-2">
              <div className="w-full h-px bg-slate-100 mb-8" />

              <GoalBanner goal={goal} doneWhen={doneWhen} />

              {parsedContent.intro && (
                <div className="mb-8 prose prose-sm max-w-none text-slate-600">
                  <ReactMarkdown remarkPlugins={[remarkGfm]}>{parsedContent.intro}</ReactMarkdown>
                </div>
              )}

              <WhyThisMatters content={whyMatters} />
              <ComparisonBlock content={parsedContent.comparison} />
              <ActionList content={actions} />

              {parsedContent.images && parsedContent.images.length > 0 && (
                parsedContent.images.map((img, idx) => (
                  <ImageDisplayBlock key={idx} src={img.src} alt={img.alt} />
                ))
              )}

              {parsedContent.copyBlocks && parsedContent.copyBlocks.length > 0 ? (
                parsedContent.copyBlocks.map((block, index) => (
                  <CopyBlock
                    key={index}
                    content={block.content}
                    toolName={toolName}
                    toolUrl={toolUrl}
                    title={block.title}
                  />
                ))
              ) : (
                <CopyBlock content={copyPrompt} toolName={toolName} toolUrl={toolUrl} />
              )}

              <BranchBlock content={branch} />

              {/* Structured Branches from Builder (Preview) */}
              {step.branches && step.branches.length > 0 && (
                <div className="space-y-6 mb-8 mt-8 border-t border-slate-100 pt-8">
                  {step.branches.map((branch, idx) => (
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
                          <p className="text-sm text-slate-600 whitespace-pre-wrap">
                            {branch.content?.descriptionA || "설명 없음"}
                          </p>
                        </button>
                        <button className="bg-emerald-100 hover:bg-emerald-200 border-2 border-emerald-300 rounded-xl p-4 text-left transition-colors">
                          <div className="flex items-center gap-2 text-emerald-700 font-bold mb-2">
                            <div className="w-6 h-6 rounded-full bg-emerald-500 text-white flex items-center justify-center text-xs font-bold">B</div>
                            {branch.content?.optionB || "옵션 B"}
                          </div>
                          <p className="text-sm text-slate-600 whitespace-pre-wrap">
                            {branch.content?.descriptionB || "설명 없음"}
                          </p>
                        </button>
                      </div>
                    </div>
                  ))}
                </div>
              )}

              {/* NEW: Example Blocks */}
              {step.examples && step.examples.length > 0 && step.examples.map((example) => (
                <ExampleDisplayBlock
                  key={example.id}
                  title={example.content?.title}
                  description={example.content?.description}
                  exampleText={example.content?.exampleText || ''}
                  type={example.content?.type}
                />
              ))}

              {/* NEW: Image Blocks */}
              {step.images && step.images.length > 0 && step.images.map((image) => (
                <ImageDisplayBlock
                  key={image.id}
                  src={image.content?.imageUrl}
                  alt={image.content?.alt}
                  caption={image.content?.caption}
                  width={image.content?.width}
                />
              ))}

              {/* NEW: Copy Blocks (from builder children) */}
              {step.copyBlocks && step.copyBlocks.length > 0 && step.copyBlocks.map((copyBlock) => (
                <CopyBlock
                  key={copyBlock.id}
                  content={copyBlock.content?.text || ''}
                  title={copyBlock.content?.title}
                  toolName={toolName}
                  toolUrl={toolUrl}
                />
              ))}

              {(inputExample || outputExample) ? (
                <InputOutputBlock inputContent={inputExample} processContent={processExample} outputContent={outputExample} />
              ) : (
                <>
                  {inputExample && <ExampleBlock type="Input" content={inputExample} />}
                  {processExample && <ExampleBlock type="Process" content={processExample} />}
                  {outputExample && <ExampleBlock type="Output" content={outputExample} />}
                  {generalExample && <ExampleBlock type="Example" content={generalExample} />}
                </>
              )}

              <TipsBlock content={tips} />
              <ChecklistBlock content={checklist} guideId={guideId} stepId={step.id} />


              {step.guide_prompts && step.guide_prompts.length > 0 && (
                <div className="space-y-4 mt-8 bg-indigo-50/50 p-6 rounded-2xl border border-indigo-100">
                  <h4 className="font-bold text-indigo-900 mb-4 flex items-center gap-2">
                    <span className="w-2 h-2 rounded-full bg-indigo-500"></span>
                    Prompt Pack
                  </h4>
                  {step.guide_prompts.map((prompt) => (
                    <PromptBlock
                      key={prompt.id}
                      prompt={prompt}
                      fallbackToolName={toolName}
                      fallbackToolUrl={toolUrl}
                    />
                  ))}
                </div>
              )}

              {step.guide_workbook_fields && step.guide_workbook_fields.length > 0 && (
                <div className="mt-8">
                  <WorkbookPanel
                    fields={step.guide_workbook_fields}
                    stepId={typeof step.id === 'string' ? (parseInt(step.id) || 0) : step.id}
                    guideId={guideId}
                  />
                </div>
              )}
            </div>
          </CollapsibleContent>
        </div>
      </Collapsible>
    </div>
  );
}

