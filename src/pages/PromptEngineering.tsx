import { useState, useEffect } from "react";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Link } from "react-router-dom";
import { Progress } from "@/components/ui/progress";
import { CheckCircle2, Circle } from "lucide-react";
import { useAuth } from "@/hooks/useAuth";
import { supabase } from "@/integrations/supabase/client";
import { useToast } from "@/hooks/use-toast";
import { useQuery, useQueryClient } from "@tanstack/react-query";

// 프롬프트 엔지니어링 챕터 목록
const chapters = [
  { id: 0, title: "왜 프롬프트 엔지니어링이 먼저인가" },
  { id: 1, title: "마인드셋" },
  { id: 2, title: "RCTFP 구조" },
  { id: 3, title: "ROSES 프레임워크" },
  { id: 4, title: "Few-shot & Chain-of-Thought" },
  { id: 5, title: "출력 포맷 통제" },
  { id: 6, title: "페르소나 & 컨텍스트" },
  { id: 7, title: "모듈형 프롬프트 시스템" },
  { id: 8, title: "AIHub 프레임워크" },
  { id: 9, title: "마스터 프롬프트 워크숍" },
];

// Supabase에서 진행도 가져오기
const fetchPromptEngineeringProgress = async (userId: string) => {
  const { data, error } = await (supabase as any)
    .from('prompt_engineering_progress')
    .select('chapter_id, completed')
    .eq('user_id', userId)
    .eq('completed', true);
  
  if (error) {
    console.error('Failed to load progress from database', error);
    return new Set<number>();
  }
  
  return new Set((data || []).map((item: any) => item.chapter_id));
};

const PromptEngineering = () => {
  const { user } = useAuth();
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const [selectedChapter, setSelectedChapter] = useState(0);

  // 진행도 가져오기
  const { data: completedChapters = new Set<number>(), refetch } = useQuery({
    queryKey: ['promptEngineeringProgress', user?.id],
    queryFn: () => fetchPromptEngineeringProgress(user!.id),
    enabled: !!user,
  });

  // 진행도 변경 이벤트 리스너
  useEffect(() => {
    const handleProgressChange = () => {
      if (user) {
        refetch();
      }
    };
    
    window.addEventListener('promptEngineeringProgressChanged', handleProgressChange);
    return () => {
      window.removeEventListener('promptEngineeringProgressChanged', handleProgressChange);
    };
  }, [user, refetch]);

  const toggleChapterComplete = async (chapterId: number) => {
    if (!user) {
      toast({
        title: "로그인이 필요합니다",
        description: "진행도를 저장하려면 로그인해주세요",
      });
      return;
    }

    const isCompleted = completedChapters.has(chapterId);
    const newCompleted = !isCompleted;

    // Supabase에 저장
    const { error } = await (supabase as any)
      .from('prompt_engineering_progress')
      .upsert({
        user_id: user.id,
        chapter_id: chapterId,
        completed: newCompleted,
        completed_at: newCompleted ? new Date().toISOString() : null,
      }, {
        onConflict: 'user_id,chapter_id'
      });

    if (error) {
      toast({
        title: "오류 발생",
        description: error.message,
        variant: "destructive",
      });
      return;
    }

    // 진행도 업데이트
    queryClient.invalidateQueries({ queryKey: ['promptEngineeringProgress', user.id] });
    
    // 진행도 변경 이벤트 발생
    window.dispatchEvent(new CustomEvent('promptEngineeringProgressChanged'));

    toast({
      title: newCompleted ? "완료되었습니다! 🎉" : "완료 취소됨",
    });
  };

  const completedCount = completedChapters.size;
  const progress = (completedCount / chapters.length) * 100;

  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      <main className="pt-24 pb-12">
        <div className="container mx-auto px-6">
          {/* 히어로 섹션 */}
          <div className="mb-12">
            <Card className="bg-gradient-to-br from-blue-600 via-blue-500 to-purple-600 border-0 shadow-2xl overflow-hidden">
              <CardContent className="p-6 md:p-10 text-white">
                <div className="max-w-4xl mx-auto">
                  <h1 className="text-3xl md:text-4xl font-bold mb-3">
                    프롬프트 엔지니어링 입문
                  </h1>
                  <p className="text-base md:text-lg text-blue-50 mb-6 leading-relaxed">
                    AI를 잘 쓰는 사람과 못 쓰는 사람의 차이는 결국 프롬프트 설계 능력입니다. 
                    이 코스는 AIHub의 모든 가이드북을 보기 전에 먼저 완주하는 0번 트랙입니다.
                  </p>
                  
                  <div className="bg-white/10 backdrop-blur-sm rounded-lg p-4">
                    <div className="flex items-center justify-between mb-2">
                      <span className="text-sm font-medium text-blue-50">진행도</span>
                      <span className="text-sm font-medium text-blue-50">{completedCount}/{chapters.length} 챕터 완료</span>
                    </div>
                    <Progress value={progress} className="h-2" />
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>

          {/* 학습 목차 및 콘텐츠 */}
          <div className="grid lg:grid-cols-[300px,1fr] gap-8">
            {/* 사이드바 - 학습 목차 */}
            <div className="space-y-2">
              <h2 className="text-xl font-bold mb-4">학습 목차</h2>
              <div className="space-y-1">
                {chapters.map((chapter) => {
                  const isCompleted = completedChapters.has(chapter.id);
                  return (
                    <button
                      key={chapter.id}
                      onClick={() => setSelectedChapter(chapter.id)}
                      className={`w-full text-left px-4 py-3 rounded-lg transition-colors ${
                        selectedChapter === chapter.id
                          ? "bg-primary text-primary-foreground"
                          : "hover:bg-muted"
                      }`}
                    >
                      <div className="flex items-center gap-2">
                        <button
                          onClick={(e) => {
                            e.stopPropagation();
                            toggleChapterComplete(chapter.id);
                          }}
                          className="hover:opacity-70 transition-opacity"
                        >
                          {isCompleted ? (
                            <CheckCircle2 className="w-4 h-4 text-green-500" />
                          ) : (
                            <Circle className="w-4 h-4" />
                          )}
                        </button>
                        <span className="text-sm">{chapter.id}. {chapter.title}</span>
                      </div>
                    </button>
                  );
                })}
              </div>
            </div>

            {/* 메인 콘텐츠 영역 */}
            <div className="space-y-6">
              <Card>
                <CardContent className="p-6">
                  <div className="flex items-center gap-4 mb-6">
                    <div className="w-12 h-12 rounded-full bg-primary text-primary-foreground flex items-center justify-center text-xl font-bold">
                      {selectedChapter}
                    </div>
                    <div>
                      <h2 className="text-2xl font-bold">{chapters[selectedChapter].title}</h2>
                      <p className="text-muted-foreground text-sm mt-1">
                        AI를 효과적으로 사용하기 위한 필수 기초
                      </p>
                    </div>
                  </div>

                  <div className="prose max-w-none">
                    <p className="text-foreground/90 leading-relaxed">
                      ChatGPT, Claude, Gemini 같은 AI 도구들이 등장하면서 누구나 AI를 쓸 수 있게 되었습니다. 
                      하지만 같은 AI를 사용해도 결과물의 품질은 천차만별입니다. 그 차이를 만드는 것은 바로 프롬프트 설계 능력입니다.
                    </p>
                    
                    <p className="text-foreground/90 leading-relaxed mt-4">
                      이 코스에서는 프롬프트 엔지니어링의 기초부터 고급 기법까지 단계별로 학습할 수 있습니다. 
                      각 챕터를 완료하면 다음 챕터로 진행할 수 있으며, 실습을 통해 바로 적용해볼 수 있습니다.
                    </p>

                    {/* 챕터별 콘텐츠는 여기에 추가 */}
                    {selectedChapter === 0 && (
                      <div className="mt-6 space-y-4">
                        <h3 className="text-xl font-semibold">좋은 프롬프트 예시</h3>
                        <div className="bg-muted p-4 rounded-lg">
                          <p className="text-sm font-medium mb-2">나쁜 예:</p>
                          <p className="text-sm text-muted-foreground mb-4">"마케팅 글 써줘"</p>
                          <p className="text-sm font-medium mb-2">좋은 예:</p>
                          <ul className="text-sm text-muted-foreground space-y-1 list-disc list-inside">
                            <li>당신은 B2B SaaS 마케팅 전문가입니다.</li>
                            <li>스타트업 창업자를 대상으로, 우리 제품(AI 기반 고객 분석 도구)의 가치를 설명하는 블로그 글을 작성해주세요.</li>
                            <li>출력 형식: 제목 (50자 이내, SEO 최적화) + 도입부 (문제 제기, 2-3문단) + 본문 (솔루션 제시, 5-6문단) + 결론 (CTA 포함, 2문단)</li>
                          </ul>
                        </div>
                      </div>
                    )}
                  </div>
                </CardContent>
              </Card>
            </div>
          </div>
        </div>
      </main>
      <Footer />
    </div>
  );
};

export default PromptEngineering;


