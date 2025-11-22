import { Button } from "@/components/ui/button";
import { Copy, Check } from "lucide-react";
import { useState } from "react";
import { useToast } from "@/hooks/use-toast";

interface PromptHeroProps {
  completedChapters: number;
  totalChapters: number;
}

export const PromptHero = ({ completedChapters, totalChapters }: PromptHeroProps) => {
  const progress = (completedChapters / totalChapters) * 100;
  const [copied, setCopied] = useState(false);
  const { toast } = useToast();

  const handleShareCode = async () => {
    const codeStructure = `I'm working on a Prompt Engineering Guidebook page for AIHub (Korean web app). Here are the relevant files:

📄 Main Page:
- src/pages/PromptEngineering.tsx

🧩 Components:
- src/components/PromptHero.tsx
- src/components/ChapterNav.tsx
- src/components/ChapterSection.tsx
- src/components/ExamplePromptBlock.tsx
- src/components/PracticeCard.tsx
- src/components/TipsCard.tsx
- src/components/PersonaCard.tsx
- src/components/MasterPromptBuilder.tsx
- src/components/NavLink.tsx

🎨 Design System:
- src/index.css (semantic tokens, HSL colors)
- tailwind.config.ts (theme configuration)

🔧 UI Components (shadcn/ui):
- src/components/ui/button.tsx
- src/components/ui/card.tsx
- src/components/ui/textarea.tsx
- src/components/ui/badge.tsx
- src/components/ui/progress.tsx
- src/components/ui/accordion.tsx
- src/components/ui/tabs.tsx

📝 Context:
This is a course-style page teaching prompt engineering fundamentals with:
- 10 chapters (0-9) covering RCTFP, ROSES, Few-shot, Chain-of-Thought, etc.
- Interactive practice components for each chapter
- Master Prompt Builder at the bottom

Please help me with: [describe your request here]`;

    try {
      await navigator.clipboard.writeText(codeStructure);
      setCopied(true);
      toast({
        title: "코드 구조가 복사되었습니다",
        description: "AI 도구에 붙여넣기하여 사용하세요",
      });
      setTimeout(() => setCopied(false), 2000);
    } catch (err) {
      toast({
        title: "복사 실패",
        description: "다시 시도해주세요",
        variant: "destructive",
      });
    }
  };

  return (
    <div className="relative overflow-hidden bg-gradient-to-br from-primary to-[hsl(237_91%_65%)] text-primary-foreground py-16 px-6 rounded-2xl shadow-lg">
      <div className="max-w-4xl mx-auto relative z-10">
        <h1 className="text-4xl md:text-5xl font-bold mb-4">
          프롬프트 엔지니어링 입문
        </h1>
        <p className="text-lg md:text-xl mb-8 opacity-95 leading-relaxed">
          AI를 잘 쓰는 사람과 못 쓰는 사람의 차이는 결국 프롬프트 설계 능력입니다. 
          이 코스는 AIHub의 모든 가이드북을 보기 전에 먼저 완주하는 0번 트랙입니다.
        </p>
        
        <div className="flex flex-col sm:flex-row gap-4 mb-8">
          <Button 
            size="lg" 
            className="bg-white text-primary hover:bg-white/90 font-semibold shadow-md"
          >
            학습 시작하기
          </Button>
          <Button 
            size="lg" 
            variant="outline" 
            className="bg-transparent border-2 border-white text-white hover:bg-white/10"
          >
            요약만 보기
          </Button>
          <Button 
            size="lg" 
            variant="outline" 
            className="bg-transparent border-2 border-white text-white hover:bg-white/10"
            onClick={handleShareCode}
          >
            {copied ? <Check className="mr-2 h-5 w-5" /> : <Copy className="mr-2 h-5 w-5" />}
            {copied ? "복사됨!" : "코드 구조 공유"}
          </Button>
        </div>

        <div className="bg-white/10 backdrop-blur-sm rounded-lg p-4">
          <div className="flex justify-between items-center mb-2">
            <span className="text-sm font-medium">진행도</span>
            <span className="text-sm font-semibold">{completedChapters} / {totalChapters} 챕터 완료</span>
          </div>
          <div className="w-full bg-white/20 rounded-full h-3 overflow-hidden">
            <div 
              className="bg-white h-full rounded-full transition-all duration-500 ease-out shadow-sm"
              style={{ width: `${progress}%` }}
            />
          </div>
        </div>
      </div>
      
      {/* Decorative elements */}
      <div className="absolute top-0 right-0 w-64 h-64 bg-white/5 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2" />
      <div className="absolute bottom-0 left-0 w-96 h-96 bg-white/5 rounded-full blur-3xl translate-y-1/2 -translate-x-1/2" />
    </div>
  );
};

