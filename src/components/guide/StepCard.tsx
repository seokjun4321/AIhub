import { Collapsible, CollapsibleContent, CollapsibleTrigger } from "@/components/ui/collapsible";
import { Button } from "@/components/ui/button";
import { Checkbox } from "@/components/ui/checkbox";
import { ChevronDown, Link as LinkIcon } from "lucide-react";
import { PromptBlock } from "./PromptBlock";
import { WorkbookPanel } from "./WorkbookPanel";
import { useState, useEffect } from "react";
import { useAuth } from "@/hooks/useAuth";
import { supabase } from "@/integrations/supabase/client";
import { useToast } from "@/hooks/use-toast";
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';

interface Step {
  id: number | string;
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
}

interface StepCardProps {
  step: Step;
  stepNumber: number;
  isOpen?: boolean;
  guideId: number;
}

export function StepCard({ step, stepNumber, isOpen = false, guideId }: StepCardProps) {
  const [open, setOpen] = useState(isOpen);
  const [completed, setCompleted] = useState(false);
  const { user } = useAuth();
  const { toast } = useToast();

  useEffect(() => {
    if (typeof step.id === 'number') {
      // DB 스텝인 경우 Supabase에서 진행률 확인
      if (user) {
        supabase
          .from('guide_progress')
          .select('completed')
          .eq('user_id', user.id)
          .eq('step_id', step.id)
          .single()
          .then(({ data }) => {
            if (data) {
              setCompleted(data.completed);
            }
          });
      }
    } else {
      // 파싱된 스텝(문자열 ID)은 로컬 스토리지에서 확인
      // 사용자별로 구분하기 위해 user.id를 키에 포함
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

    // DB 스텝인 경우 Supabase에 저장
    if (typeof step.id === 'number') {
      if (!user) {
        toast({
          title: "로그인이 필요합니다",
          description: "진행률을 저장하려면 로그인해주세요",
        });
        setCompleted(!newCompleted); // 롤백
        return;
      }

      const { error } = await supabase
        .from('guide_progress')
        .upsert({
          user_id: user.id,
          guide_id: guideId,
          step_id: step.id,
          completed: newCompleted,
          completed_at: newCompleted ? new Date().toISOString() : null,
        }, {
          onConflict: 'user_id,step_id'
        });

      if (error) {
        toast({
          title: "오류 발생",
          description: error.message,
          variant: "destructive",
        });
        setCompleted(!newCompleted); // 롤백
        return;
      }
      
      // 진행률 업데이트를 위해 이벤트 발생
      window.dispatchEvent(new CustomEvent('stepProgressChanged', { 
        detail: { guideId, stepId: step.id, completed: newCompleted } 
      }));
    } else {
      // 파싱된 스텝(문자열 ID)은 로컬 스토리지에 저장
      // 사용자별로 구분하기 위해 user.id를 키에 포함
      const storageKey = user 
        ? `guide_progress_${guideId}_${step.id}_${user.id}`
        : `guide_progress_${guideId}_${step.id}`;
      if (newCompleted) {
        localStorage.setItem(storageKey, 'true');
      } else {
        localStorage.removeItem(storageKey);
      }
      
      // 진행률 업데이트를 위해 이벤트 발생
      window.dispatchEvent(new CustomEvent('stepProgressChanged', { 
        detail: { guideId, stepId: step.id, completed: newCompleted } 
      }));
    }

    toast({
      title: newCompleted ? "완료되었습니다! 🎉" : "완료 취소됨",
    });
  };

  const handleCopyLink = () => {
    const url = `${window.location.pathname}#step-${step.id}`;
    navigator.clipboard.writeText(window.location.origin + url);
    toast({
      title: "링크 복사됨",
      description: "이 단계의 링크가 클립보드에 복사되었습니다",
    });
  };

  return (
    <div id={`step-${step.id}`} className="scroll-mt-24">
      <Collapsible open={open} onOpenChange={setOpen} className="group">
        <div className="rounded-xl border bg-card shadow-sm hover:shadow-md transition-all overflow-hidden">
          <CollapsibleTrigger asChild>
            <Button
              variant="ghost"
              className="w-full justify-between p-5 h-auto hover:bg-muted/30 rounded-xl"
            >
              <div className="flex items-center gap-4 text-left flex-1 min-w-0">
                <div className="flex items-center gap-3 flex-shrink-0">
                  <Checkbox
                    checked={completed}
                    onCheckedChange={handleToggleComplete}
                    onClick={(e) => e.stopPropagation()}
                    className="h-5 w-5 data-[state=checked]:bg-foreground data-[state=checked]:border-foreground data-[state=checked]:text-background"
                  />
                  <div className="flex h-10 w-10 items-center justify-center rounded-full bg-accent text-accent-foreground font-bold text-sm shadow-sm">
                    {stepNumber}
                  </div>
                </div>
                <div className="flex-1 min-w-0 overflow-hidden">
                  <h3 className="font-semibold text-base text-foreground truncate">
                    {step.title.replace(/\*\*(.+?)\*\*/g, '$1').replace(/^Step\s+/i, '').replace(/^\d+\.\s*/, '')}
                  </h3>
                  {step.summary && !open && (
                    <p className="text-sm text-muted-foreground mt-1 truncate">{step.summary}</p>
                  )}
                </div>
              </div>
              <div className="flex items-center gap-2 ml-4 flex-shrink-0">
                <Button
                  variant="ghost"
                  size="icon"
                  onClick={(e) => {
                    e.preventDefault();
                    e.stopPropagation();
                    handleCopyLink();
                  }}
                  onMouseDown={(e) => {
                    e.preventDefault();
                    e.stopPropagation();
                  }}
                  className="h-8 w-8 text-muted-foreground hover:text-foreground hover:bg-muted/50"
                >
                  <LinkIcon className="h-4 w-4" />
                </Button>
                <ChevronDown className={`h-5 w-5 text-muted-foreground transition-transform duration-200 ${open ? "rotate-180" : ""}`} />
              </div>
            </Button>
          </CollapsibleTrigger>

          <CollapsibleContent className="px-5 pb-6 space-y-6 animate-accordion-down">
            <div className="border-t border-border/50 pt-6">
              {step.content && (
                <div className="prose prose-sm max-w-none text-foreground/90 mb-6
                  prose-p:text-foreground/90 prose-p:leading-relaxed prose-p:mb-4
                  prose-headings:text-foreground prose-headings:font-semibold prose-headings:mb-3 prose-headings:mt-4
                  prose-strong:text-foreground prose-strong:font-bold
                  prose-ul:space-y-2 prose-ul:my-4 prose-ul:ml-4
                  prose-ol:space-y-2 prose-ol:my-4 prose-ol:ml-4
                  prose-li:text-foreground/90 prose-li:leading-relaxed
                  prose-code:text-accent prose-code:bg-muted prose-code:px-1.5 prose-code:py-0.5 prose-code:rounded prose-code:text-xs
                  prose-blockquote:border-l-accent prose-blockquote:border-l-4 prose-blockquote:pl-4 prose-blockquote:italic prose-blockquote:text-muted-foreground">
                  <ReactMarkdown 
                    remarkPlugins={[remarkGfm]}
                    components={{
                      strong: ({node, ...props}) => <strong className="font-bold text-foreground" {...props} />,
                      a: ({node, ...props}) => <a className="text-foreground font-medium underline hover:opacity-80" {...props} />
                    }}
                  >
                    {step.content}
                  </ReactMarkdown>
                </div>
              )}

              {step.guide_prompts && step.guide_prompts.length > 0 && (
                <div className="space-y-4 mt-6">
                  <h4 className="font-semibold text-sm text-muted-foreground uppercase tracking-wide mb-3">프롬프트</h4>
                  {step.guide_prompts.map((prompt) => (
                    <PromptBlock key={prompt.id} prompt={prompt} />
                  ))}
                </div>
              )}

              {step.guide_workbook_fields && step.guide_workbook_fields.length > 0 && (
                <div className="mt-6">
                  <WorkbookPanel 
                    fields={step.guide_workbook_fields} 
                    stepId={step.id}
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

