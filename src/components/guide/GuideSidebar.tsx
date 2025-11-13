import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Download, FileText, Copy } from "lucide-react";
import { ProgressRing } from "./ProgressRing";
import { StepTOC } from "./StepTOC";
import { RelatedGuideCard } from "./RelatedGuideCard";
import { useToast } from "@/hooks/use-toast";
import { useState, useEffect } from "react";
import { useAuth } from "@/hooks/useAuth";
import { supabase } from "@/integrations/supabase/client";

interface TOCItem {
  title: string;
  slug: string;
}

interface GuideSidebarProps {
  tocItems: TOCItem[];
  relatedGuides?: Array<{
    id: number;
    title: string;
    tool?: string;
    readTime?: number;
  }>;
  content?: string | null;
  guideId?: number;
  stepIds?: number[];
  totalSteps?: number; // 전체 스텝 개수
}

export function GuideSidebar({ tocItems, relatedGuides, content, guideId, stepIds, totalSteps }: GuideSidebarProps) {
  const { toast } = useToast();
  const { user } = useAuth();
  const [progress, setProgress] = useState(0);

  useEffect(() => {
    const calculateProgress = async () => {
      if (!guideId || !totalSteps || totalSteps === 0) {
        setProgress(0);
        return;
      }

      let completedCount = 0;

      // 파싱된 스텝(문자열 ID)의 진행률은 로컬 스토리지에서 확인
      tocItems.forEach((item) => {
        if (!item.stepId) {
          // 파싱된 스텝의 경우 slug에서 ID 추출
          // slug 형식: #step-{slug} 또는 #{slug}
          // StepCard에서 사용하는 ID 형식과 일치시켜야 함
          const stepIdFromSlug = item.slug.replace('#', '');
          // 사용자별로 구분하기 위해 user.id를 키에 포함
          const storageKey = user 
            ? `guide_progress_${guideId}_${stepIdFromSlug}_${user.id}`
            : `guide_progress_${guideId}_${stepIdFromSlug}`;
          if (localStorage.getItem(storageKey) === 'true') {
            completedCount++;
          }
        }
      });

      // DB 스텝 확인 (Supabase)
      if (user && stepIds && stepIds.length > 0) {
        const { data } = await supabase
          .from('guide_progress')
          .select('step_id, completed')
          .eq('user_id', user.id)
          .eq('guide_id', guideId)
          .in('step_id', stepIds);

        if (data) {
          completedCount += data.filter(p => p.completed).length;
        }
      }

      setProgress((completedCount / totalSteps) * 100);
    };

    calculateProgress();
    
    // 진행률 변경 이벤트 리스너
    const handleProgressChange = () => {
      calculateProgress();
    };
    
    window.addEventListener('stepProgressChanged', handleProgressChange);
    const interval = setInterval(calculateProgress, 1000);
    
    return () => {
      clearInterval(interval);
      window.removeEventListener('stepProgressChanged', handleProgressChange);
    };
  }, [user, guideId, stepIds, totalSteps, tocItems]);

  const handleCopyAllContent = () => {
    if (!content) return;
    navigator.clipboard.writeText(content);
    toast({
      title: "내용 복사됨",
      description: "가이드 내용이 클립보드에 복사되었습니다",
    });
  };

  return (
    <aside 
      className="w-full lg:w-80 flex-shrink-0 sticky-sidebar space-y-6"
    >
      {/* Progress */}
      {tocItems.length > 0 && (
        <Card className="p-6 text-center space-y-4 border-border/50">
          <h3 className="font-semibold text-sm text-muted-foreground uppercase tracking-wide">진행률</h3>
          <ProgressRing progress={progress} />
        </Card>
      )}

      {/* TOC */}
      {tocItems.length > 0 && (
        <Card className="p-4 border-border/50">
          <h3 className="font-semibold text-sm text-muted-foreground uppercase tracking-wide mb-4">목차</h3>
          <StepTOC items={tocItems} guideId={guideId} />
        </Card>
      )}


      {/* Related Guides */}
      {relatedGuides && relatedGuides.length > 0 && (
        <div className="space-y-3">
          <h3 className="font-semibold text-sm text-muted-foreground uppercase tracking-wide">관련 가이드</h3>
          {relatedGuides.map((guide) => (
            <RelatedGuideCard
              key={guide.id}
              id={guide.id}
              title={guide.title}
              tool={guide.tool}
              readTime={guide.readTime}
            />
          ))}
        </div>
      )}

    </aside>
  );
}

