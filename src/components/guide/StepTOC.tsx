import { Check } from "lucide-react";
import { useState, useEffect } from "react";
import { useAuth } from "@/hooks/useAuth";
import { supabase } from "@/integrations/supabase/client";

interface TOCItem {
  title: string;
  slug: string;
  stepId?: number; // step ID 추가
}

interface StepTOCProps {
  items: TOCItem[];
  activeSlug?: string;
  guideId?: number;
}

export function StepTOC({ items, activeSlug, guideId }: StepTOCProps) {
  const { user } = useAuth();
  const [completedSteps, setCompletedSteps] = useState<Set<number>>(new Set());

  useEffect(() => {
    const fetchCompletedSteps = async () => {
      if (!user || !guideId) {
        setCompletedSteps(new Set());
        return;
      }

      const stepIds = items
        .map(item => item.stepId)
        .filter((id): id is number => id !== undefined);

      if (stepIds.length === 0) {
        setCompletedSteps(new Set());
        return;
      }

      const { data } = await supabase
        .from('guide_progress')
        .select('step_id')
        .eq('user_id', user.id)
        .eq('guide_id', guideId)
        .in('step_id', stepIds)
        .eq('completed', true);

      if (data) {
        setCompletedSteps(new Set(data.map(p => p.step_id)));
      }
    };

    fetchCompletedSteps();
    const interval = setInterval(fetchCompletedSteps, 2000);
    return () => clearInterval(interval);
  }, [user, guideId, items]);

  const scrollToSection = (slug: string) => {
    // slug가 #으로 시작하면 제거
    const id = slug.startsWith('#') ? slug.slice(1) : slug;
    const element = document.getElementById(id) || document.querySelector(slug);
    if (element) {
      const headerOffset = 200; // Navbar + GuideHeader 높이
      const elementPosition = element.getBoundingClientRect().top;
      const offsetPosition = elementPosition + window.pageYOffset - headerOffset;
      
      window.scrollTo({
        top: offsetPosition,
        behavior: "smooth"
      });
    }
  };

  return (
    <nav className="space-y-1">
      {items.map((item, index) => {
        const isActive = activeSlug === item.slug;
        const isCompleted = item.stepId ? completedSteps.has(item.stepId) : false;

        return (
          <button
            key={item.slug}
            onClick={() => scrollToSection(item.slug)}
            className={`
              w-full flex items-start gap-3 p-3 rounded-xl text-left transition-all
              ${isActive 
                ? "bg-accent/10 text-accent font-medium" 
                : "hover:bg-muted/50 text-muted-foreground hover:text-foreground"
              }
            `}
          >
            <div className={`
              flex h-6 w-6 items-center justify-center rounded-lg text-xs font-bold shrink-0
              ${isCompleted 
                ? "bg-accent text-accent-foreground" 
                : isActive
                ? "bg-gradient-to-br from-primary to-accent text-primary-foreground"
                : "bg-muted text-muted-foreground"
              }
            `}>
              {isCompleted ? <Check className="h-4 w-4" /> : index + 1}
            </div>
            <span className="text-sm leading-tight">{item.title}</span>
          </button>
        );
      })}
    </nav>
  );
}

