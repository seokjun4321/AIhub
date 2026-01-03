import { Collapsible, CollapsibleContent, CollapsibleTrigger } from "@/components/ui/collapsible";
import { Button } from "@/components/ui/button";
import { Checkbox } from "@/components/ui/checkbox";
import { ChevronDown, Link as LinkIcon } from "lucide-react";
import { PromptBlock } from "./PromptBlock";
import { WorkbookPanel } from "./WorkbookPanel";
import { useState, useEffect, useMemo } from "react";
import { useAuth } from "@/hooks/useAuth";
import { supabase } from "@/integrations/supabase/client";
import { useToast } from "@/hooks/use-toast";
import { GoalBanner, WhyThisMatters, ActionList, ExampleBlock, TipsBlock, ChecklistBlock, CopyBlock } from "./StepBlockComponents";
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';

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
}

interface StepCardProps {
  step: Step;
  stepNumber: number;
  isOpen?: boolean;
  guideId: number;
  toolName?: string;
  toolUrl?: string;
}

// Simple markdown splitter (Fallback)
const parseStepContent = (content: string | null) => {
  if (!content) return {};

  const sections: Record<string, string> = {};
  const lines = content.split(/\r?\n/);
  let currentKey = 'intro';
  let buffer: string[] = [];

  const flush = () => {
    if (buffer.length > 0) {
      if (sections[currentKey]) {
        sections[currentKey] += '\n' + buffer.join('\n').trim();
      } else {
        sections[currentKey] = buffer.join('\n').trim();
      }
    }
    buffer = [];
  };

  lines.forEach(line => {
    // 1. Strict Headers: ## Title
    const matchHash = line.match(/^\s*(#{2,6})\s+(.+)$/);
    // 2. Bold Headers: **Title** ... 
    // Capture: Group 1=**, Group 2=Title, Group 3=**, Group 4=remaining
    const matchBold = line.match(/^\s*(\*\*)\s*(.+?)\s*(\*\*)(.*)$/);

    if (matchHash || matchBold) {
      flush();

      let rawTitle = "";
      let remainingLine = "";

      if (matchHash) {
        rawTitle = matchHash[2].trim().toLowerCase();
      } else if (matchBold) {
        rawTitle = matchBold[2].trim().toLowerCase();
        remainingLine = matchBold[4].trim();
      }

      const t = rawTitle;

      if (t.includes('goal') || t.includes('목표') || t.includes('핵심')) currentKey = 'goal';
      else if (t.includes('done') || t.includes('완료')) currentKey = 'doneWhen';
      else if (t.includes('why') || t.includes('이유')) currentKey = 'why';
      else if (t.includes('action') || t.includes('할 일') || t.includes('할일') || t.includes('실행') || t.includes('따라하기')) currentKey = 'actions';
      else if (t.includes('(c)') || t.includes('복붙') || t.includes('copy') || t.includes('template') || t.includes('템플릿')) currentKey = 'copyPrompt';
      else if (t.includes('example') || t.includes('예시')) currentKey = 'example';
      else if (t.includes('input') || t.includes('입력')) currentKey = 'input_example';
      else if (t.includes('output') || t.includes('출력') || t.includes('결과')) currentKey = 'output_example';
      else if (t.includes('tip') || t.includes('팁') || t.includes('mistake') || t.includes('실수') || t.includes('주의')) currentKey = 'tips';
      else if (t.includes('check') || t.includes('체크')) currentKey = 'checklist';
      else currentKey = 'other';

      if (remainingLine) {
        const cleanContent = remainingLine.replace(/^[:→-]\s*/, '');
        if (cleanContent) buffer.push(cleanContent);
      }
    } else {
      buffer.push(line);
    }
  });
  flush();

  return sections;
};

export function StepCard({ step, stepNumber, isOpen = false, guideId, toolName, toolUrl }: StepCardProps) {
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
  // If we have 'other' content (unclassified), use that.
  // DO NOT fallback to step.content if we are using the structured layout, 
  // as step.content contains the raw full markdown which would cause duplication.
  const actions = parsedContent.actions || parsedContent.other || "";
  const copyPrompt = parsedContent.copyPrompt;

  // Also check for example blocks in parsed content
  const inputExample = parsedContent.input_example;
  const outputExample = parsedContent.output_example;
  const generalExample = parsedContent.example;

  // Handle content that doesn't fit the strict schema (fallback)
  // detailed check: if we have any structured columns OR parsed sections beyond intro
  console.log('RAW STEP CONTENT:', step.content);
  const hasStructuredContent = Boolean(
    goal || doneWhen || whyMatters || tips || checklist ||
    actions || inputExample || outputExample || generalExample ||
    step.goal || step.done_when || step.why_matters || step.tips || step.checklist || // Check DB fields directly
    Object.keys(parsedContent).length > 1
  );

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
            <div
              className="flex w-full items-center justify-between p-6 h-auto hover:bg-slate-50/50 rounded-none cursor-pointer text-left"
            >
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
                    {step.title.replace(/\*\*(.+?)\*\*/g, '$1').replace(/^Step\s+/i, '').replace(/^\d+\.\s*/, '')}
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

              {/* Intro content if any (often empty if everything is modularized) */}
              {parsedContent.intro && (
                <div className="mb-8 prose prose-sm max-w-none text-slate-600">
                  <ReactMarkdown remarkPlugins={[remarkGfm]}>{parsedContent.intro}</ReactMarkdown>
                </div>
              )}

              <WhyThisMatters content={whyMatters} />

              <ActionList content={actions} />

              <CopyBlock content={copyPrompt} toolName={toolName} toolUrl={toolUrl} />

              {inputExample && <ExampleBlock type="Input" content={inputExample} />}
              {outputExample && <ExampleBlock type="Output" content={outputExample} />}
              {generalExample && <ExampleBlock type="Input" content={generalExample} />}

              <TipsBlock content={tips} />
              <ChecklistBlock content={checklist} guideId={guideId} stepId={step.id} />


              {/* Prompts and Workbooks (Always rendered if exist) */}
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

