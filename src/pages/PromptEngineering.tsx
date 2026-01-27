import { useState, useEffect } from "react";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { GuidebookHeader } from "@/components/guidebook/GuidebookHeader";
import { GuideOverviewCards } from "@/components/guidebook/GuideOverviewCards";
import { GuideProgressSidebar } from "@/components/guidebook/GuideProgressSidebar";
import { ExamplePromptBlock } from "@/components/ExamplePromptBlock";
import { PracticeCard } from "@/components/PracticeCard";
import { TipsCard } from "@/components/TipsCard";
import { PersonaCard } from "@/components/PersonaCard";
import { MasterPromptBuilder } from "@/components/MasterPromptBuilder";
import { useAuth } from "@/hooks/useAuth";
import { supabase } from "@/integrations/supabase/client";
import { useToast } from "@/hooks/use-toast";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { Button } from "@/components/ui/button";
import { ChevronLeft, ChevronRight, CheckCircle2 } from "lucide-react";
import { Link } from "react-router-dom";
import { cn } from "@/lib/utils";
import confetti from 'canvas-confetti';

const TOTAL_CHAPTERS = 10;

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
  const [activeStepIndex, setActiveStepIndex] = useState(0);
  const [selectedPersona, setSelectedPersona] = useState(0);

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

    // 완료 축하 효과
    if (newCompleted) {
      toast({
        title: "완료되었습니다! 🎉",
        description: "다음 챕터로 넘어가보세요!",
      });
      if (chapterId === TOTAL_CHAPTERS - 1) {
        confetti({
          particleCount: 100,
          spread: 70,
          origin: { y: 0.6 }
        });
      }
    }

    // 진행도 변경 이벤트 발생
    window.dispatchEvent(new CustomEvent('promptEngineeringProgressChanged'));
  };

  const handleNextStep = () => {
    if (activeStepIndex < TOTAL_CHAPTERS - 1) {
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

  const scrollToContent = () => {
    setTimeout(() => {
      window.scrollTo({ top: 100, behavior: 'smooth' });
    }, 50);
  };

  const handleStepClick = (id: string | number) => {
    // id is "chapter-0", "chapter-1" etc.
    if (typeof id === 'string' && id.startsWith('chapter-')) {
      const index = parseInt(id.split('-')[1]);
      if (!isNaN(index)) {
        setActiveStepIndex(index);
        scrollToContent();
      }
    }
  };

  const personas = [
    {
      name: "벤처캐피탈 투자심사역",
      points: [
        "시장 크기와 성장 가능성에 집중",
        "재무 지표와 유닛 이코노믹스 중시",
        "팀의 실행력을 가장 중요하게 평가",
      ],
      prompt: `당신은 10년 경력의 벤처캐피탈 투자심사역입니다.
스타트업 피칭 자료를 평가할 때, 시장 규모, 비즈니스 모델의 지속가능성, 팀의 실행력을 기준으로 분석합니다.
모든 평가에는 구체적인 근거와 개선 방향을 포함해야 합니다.`,
    },
    {
      name: "대학 물리학 튜터",
      points: [
        "복잡한 개념을 일상의 비유로 설명",
        "단계별로 문제 해결 과정 제시",
        "학생의 이해도를 확인하며 진행",
      ],
      prompt: `당신은 대학에서 물리학을 가르치는 친절한 튜터입니다.
복잡한 물리 개념을 학생이 이해하기 쉽도록 일상적인 예시와 비유를 사용하여 설명합니다.
문제를 풀 때는 단계별로 사고 과정을 보여주며, 학생이 스스로 이해했는지 확인 질문을 던집니다.`,
    },
    {
      name: "UX/UI 디자이너 멘토",
      points: [
        "사용자 경험과 접근성 최우선",
        "디자인 원칙과 트렌드 균형",
        "실무 적용 가능한 피드백 제공",
      ],
      prompt: `당신은 5년 이상의 실무 경험을 가진 UX/UI 디자이너 멘토입니다.
디자인 리뷰 시 사용자 경험, 접근성, 시각적 위계를 중심으로 평가하며,
최신 디자인 트렌드와 디자인 시스템 관점에서 실무에 바로 적용할 수 있는 구체적인 개선 방향을 제시합니다.`,
    },
  ];

  const chapters = [
    { id: "chapter-0", title: "0. 왜 프롬프트 엔지니어링이 먼저인가" },
    { id: "chapter-1", title: "1. 마인드셋" },
    { id: "chapter-2", title: "2. RCTFP 구조" },
    { id: "chapter-3", title: "3. ROSES 프레임워크" },
    { id: "chapter-4", title: "4. Few-shot & Chain-of-Thought" },
    { id: "chapter-5", title: "5. 출력 포맷 통제" },
    { id: "chapter-6", title: "6. 페르소나 & 컨텍스트" },
    { id: "chapter-7", title: "7. 모듈형 프롬프트 시스템" },
    { id: "chapter-8", title: "8. AIHub 프레임워크" },
    { id: "chapter-9", title: "9. 마스터 프롬프트 워크숍" },
  ];

  // Convert Set to Array for Sidebar
  const completedStepIds = Array.from(completedChapters).map(num => `chapter-${num}`);

  const renderContent = (index: number) => {
    switch (index) {
      case 0:
        return (
          <div className="space-y-6">
            <div className="prose prose-slate max-w-none">
              <p className="text-slate-600 leading-relaxed">
                ChatGPT, Claude, Gemini 같은 AI 도구들이 등장하면서 누구나 AI를 쓸 수 있게 되었습니다.
                하지만 같은 AI를 사용해도 결과물의 품질은 천차만별입니다.
              </p>
              <p className="text-slate-600 leading-relaxed">
                <strong className="text-emerald-600">핵심은?</strong> AI는 똑똑하지만 마음을 읽을 순 없습니다.
                당신이 원하는 결과를 얻으려면 명확한 지시를 내려야 합니다. 이것이 바로 프롬프트 엔지니어링입니다.
              </p>
              <p className="text-slate-600 leading-relaxed">
                AIHub의 모든 가이드북(글쓰기, 취업, 창업, 코딩 등)은 "좋은 프롬프트를 이미 알고 있다"는 전제로 작성되어 있습니다.
                따라서 이 코스를 먼저 완주하면 다른 모든 가이드북을 100% 활용할 수 있습니다.
              </p>
            </div>

            <ExamplePromptBlock
              title="좋은 프롬프트 예시"
              prompt={`나쁜 예: "마케팅 글 써줘"

좋은 예:
당신은 B2B SaaS 마케팅 전문가입니다.
스타트업 창업자를 대상으로, 우리 제품(AI 기반 고객 분석 도구)의 가치를 설명하는 블로그 글을 작성해주세요.

출력 형식:
- 제목 (50자 이내, SEO 최적화)
- 도입부 (문제 제기, 2-3문단)
- 본문 (솔루션 제시, 5-6문단)
- 결론 (CTA 포함, 2문단)

톤: 전문적이면서도 친근하게, 전문 용어는 쉽게 풀어서 설명`}
            />

            <TipsCard
              tips={[
                { type: "mistake", text: "너무 짧거나 애매한 지시: 'PPT 만들어줘', '보고서 써줘'" },
                { type: "mistake", text: "맥락 없이 작업만 요구: AI는 당신의 상황을 모릅니다" },
                { type: "tip", text: "구체적인 역할, 맥락, 형식을 명시하세요" },
                { type: "tip", text: "원하는 결과물의 예시를 함께 제공하면 더욱 좋습니다" },
              ]}
            />
          </div>
        );
      case 1:
        return (
          <div className="space-y-6">
            <div className="prose prose-slate max-w-none">
              <p className="text-slate-600 leading-relaxed">
                많은 사람들이 AI를 "마법 도구"로 생각합니다. 명령 한 번이면 완벽한 결과가 나올 거라 기대하죠.
                하지만 현실은 다릅니다.
              </p>
              <p className="text-slate-600 leading-relaxed">
                <strong className="text-emerald-600">핵심은?</strong> AI를 유능한 인턴이나 주니어 동료라고 생각하세요.
                명확한 지시와 맥락을 주면 훌륭하게 일하지만, 애매하게 지시하면 엉뚱한 결과를 냅니다.
              </p>
            </div>

            <div className="grid md:grid-cols-2 gap-4 my-6">
              <div className="bg-red-50 border border-red-100 rounded-lg p-4">
                <h4 className="font-semibold text-red-700 mb-2">❌ 잘못된 마인드셋</h4>
                <ul className="space-y-2 text-sm text-slate-600">
                  <li>• "AI가 알아서 해주겠지"</li>
                  <li>• "한 번에 완벽한 결과 기대"</li>
                  <li>• "실패하면 AI 탓"</li>
                </ul>
              </div>
              <div className="bg-green-50 border border-green-100 rounded-lg p-4">
                <h4 className="font-semibold text-green-700 mb-2">✅ 올바른 마인드셋</h4>
                <ul className="space-y-2 text-sm text-slate-600">
                  <li>• "내가 명확히 지시해야 함"</li>
                  <li>• "반복적으로 개선 (iterate)"</li>
                  <li>• "프롬프트 설계가 핵심"</li>
                </ul>
              </div>
            </div>

            <TipsCard
              tips={[
                { type: "tip", text: "첫 번째 결과가 마음에 안 들면 프롬프트를 수정하고 다시 시도하세요" },
                { type: "tip", text: "AI와의 대화는 '협업'입니다. 피드백을 주고받으며 개선하세요" },
                { type: "mistake", text: "한 번 실패했다고 포기하지 마세요. 프롬프트 조정이 필요한 신호입니다" },
              ]}
            />
          </div>
        );
      case 2:
        return (
          <div className="space-y-6">
            <div className="prose prose-slate max-w-none">
              <p className="text-slate-600 leading-relaxed">
                좋은 프롬프트는 다음 5가지 요소로 구성됩니다:
              </p>
              <ul className="text-slate-600 space-y-2 list-disc pl-5">
                <li><strong className="text-emerald-600">Role</strong> (역할): AI에게 어떤 역할을 맡길 것인가?</li>
                <li><strong className="text-emerald-600">Context</strong> (맥락): 어떤 상황/배경인가?</li>
                <li><strong className="text-emerald-600">Task</strong> (작업): 구체적으로 무엇을 해야 하는가?</li>
                <li><strong className="text-emerald-600">Format</strong> (형식): 결과물은 어떤 형태여야 하는가?</li>
                <li><strong className="text-emerald-600">Parameters</strong> (제약): 톤, 길이, 금지사항 등</li>
              </ul>
            </div>

            <div className="grid md:grid-cols-2 gap-4 my-6">
              <ExamplePromptBlock
                title="개선 전"
                prompt="대학 입시 자기소개서 써줘"
                variant="before"
              />
              <ExamplePromptBlock
                title="개선 후 (RCTFP 적용)"
                prompt={`Role: 당신은 10년 경력의 입시 컨설턴트입니다.

Context: 저는 컴퓨터공학과 지원을 준비 중인 고3 학생입니다. 교내 코딩 동아리 회장을 맡았고, 지역 해커톤에서 입상한 경험이 있습니다.

Task: 제 경험을 바탕으로 '왜 컴퓨터공학을 전공하고 싶은가'를 주제로 자기소개서 초안을 작성해주세요.

Format:
- 전체 800-1000자
- 3문단 구조 (계기-경험-포부)

Parameters:
- 톤: 진솔하고 열정적이게
- 피해야 할 것: 과장된 표현, 진부한 문장`}
                variant="after"
              />
            </div>

            <PracticeCard
              fields={[
                { id: "role", label: "Role (역할)", placeholder: "예: 당신은 경험 많은 마케팅 컨설턴트입니다" },
                { id: "context", label: "Context (맥락)", placeholder: "예: 신제품 런칭을 앞둔 스타트업입니다" },
                { id: "task", label: "Task (작업)", placeholder: "예: 제품 소개 이메일 초안을 작성하세요" },
                { id: "format", label: "Format (형식)", placeholder: "예: 제목 + 본문(3문단) + CTA 버튼 문구" },
                { id: "parameters", label: "Parameters (제약)", placeholder: "예: 친근한 톤, 300자 이내" },
              ]}
              onGenerate={(values) => {
                return `# Role\n${values.role || "[역할 입력 필요]"}\n\n# Context\n${values.context || "[맥락 입력 필요]"}\n\n# Task\n${values.task || "[작업 입력 필요]"}\n\n# Format\n${values.format || "[형식 입력 필요]"}\n\n# Parameters\n${values.parameters || "[제약사항 입력 필요]"}`;
              }}
            />
          </div>
        );
      case 3:
        return (
          <div className="space-y-6">
            <div className="prose prose-slate max-w-none">
              <p className="text-slate-600 leading-relaxed">
                RCTFP가 기본이라면, ROSES는 더 복잡한 작업(전략 수립, 분석, 컨설팅)을 위한 구조입니다.
              </p>
              <ul className="text-slate-600 space-y-2 list-disc pl-5">
                <li><strong className="text-emerald-600">Role</strong>: 전문가 역할 정의</li>
                <li><strong className="text-emerald-600">Objective</strong>: 궁극적 목표</li>
                <li><strong className="text-emerald-600">Scenario</strong>: 구체적 상황 묘사</li>
                <li><strong className="text-emerald-600">Expected Solution</strong>: 기대하는 솔루션 형태</li>
                <li><strong className="text-emerald-600">Steps</strong>: 검증 기준</li>
              </ul>
            </div>

            <ExamplePromptBlock
              title="ROSES 프롬프트 예시 - 사업 전략 수립"
              prompt={`Role: 당신은 20년 경력의 경영 전략 컨설턴트입니다.

Objective: 새로운 시장 진입 전략을 수립하고, 실행 가능한 로드맵을 제시하는 것입니다.

Scenario: 
- 회사: B2B SaaS 스타트업 (직원 50명, ARR $3M)
- 상황: 현재 한국 시장에서만 운영 중, 동남아 진출 검토 중
- 제품: 중소기업용 재고 관리 솔루션
- 예산: 마케팅 $200K, 현지화 $100K

Expected Solution:
1. 시장 분석 (TAM/SAM/SOM)
2. 진입 전략 (국가 우선순위, 진입 방식)
3. 6개월 실행 로드맵 (마일스톤 포함)
4. 리스크 분석 및 대응 방안

Steps:
1단계: 시장 규모와 성장성 분석
2단계: 경쟁 환경과 진입 장벽 평가
3단계: 최적 진입 전략 수립
4단계: 실행 계획과 리스크 관리`}
            />

            <TipsCard
              tips={[
                { type: "tip", text: "ROSES는 전략/분석/컨설팅처럼 깊이 있는 사고가 필요한 작업에 효과적입니다" },
                { type: "tip", text: "Steps 단계를 꼭 포함하세요. AI가 스스로 결과를 검증하게 만듭니다" },
                { type: "mistake", text: "간단한 작업에 ROSES를 쓰면 오히려 복잡해집니다. RCTFP로 충분합니다" },
              ]}
            />
          </div>
        );
      case 4:
        return (
          <div className="space-y-6">
            <div className="prose prose-slate max-w-none">
              <p className="text-slate-600 leading-relaxed">
                <strong className="text-emerald-600">Few-shot Learning</strong>: 원하는 결과의 예시를 2-3개 보여주면, AI가 패턴을 학습해 비슷한 품질로 작업합니다.
              </p>
              <p className="text-slate-600 leading-relaxed">
                <strong className="text-emerald-600">Chain-of-Thought (CoT)</strong>: "단계별로 생각하세요"라는 지시를 추가하면, AI가 중간 추론 과정을 보여주며 더 정확한 답을 냅니다.
              </p>
            </div>

            <div className="grid md:grid-cols-2 gap-4 my-6">
              <div>
                <h4 className="font-semibold text-slate-800 mb-3">일반 프롬프트</h4>
                <ExamplePromptBlock
                  prompt={`다음 리뷰의 감정을 분석하세요:
"배송은 빨랐는데 제품이 기대에 못 미쳤어요. 환불 고려 중입니다."`}
                  variant="before"
                />
                <p className="text-sm text-slate-500 mt-2">결과: "부정적" (근거 없음)</p>
              </div>
              <div>
                <h4 className="font-semibold text-slate-800 mb-3">Few-shot + CoT 프롬프트</h4>
                <ExamplePromptBlock
                  prompt={`다음 리뷰의 감정을 분석하세요. 단계별로 생각하며 근거를 제시하세요.

예시 1:
리뷰: "배송 빠르고 품질 좋아요!"
분석: 긍정 (배송, 품질 모두 만족)

예시 2:
리뷰: "품질은 괜찮은데 가격이 너무 비싸요"
분석: 중립/혼합 (품질 긍정, 가격 부정)

이제 분석하세요:
"배송은 빨랐는데 제품이 기대에 못 미쳤어요. 환불 고려 중입니다."`}
                  variant="after"
                />
                <p className="text-sm text-green-600 mt-2">
                  결과: "부정적 (배송 긍정이지만 제품 품질과 환불 언급으로 전체적으로 부정)"
                </p>
              </div>
            </div>

            <PracticeCard
              title="Few-shot 프롬프트 연습"
              fields={[
                { id: "task", label: "작업 설명", placeholder: "예: 제품명에서 카테고리를 추출하세요" },
                { id: "example1", label: "예시 1 (입력 → 출력)", placeholder: "입력: '애플 에어팟 프로 2세대'\n출력: '전자제품 > 오디오'" },
                { id: "example2", label: "예시 2", placeholder: "입력: '나이키 에어맥스 운동화'\n출력: '패션 > 신발'" },
                { id: "test", label: "테스트 입력", placeholder: "예: '삼성 갤럭시 버즈2'" },
              ]}
            />

            <TipsCard
              tips={[
                { type: "tip", text: "Few-shot: 예시 2-3개면 충분합니다. 너무 많으면 오히려 혼란스러워집니다" },
                { type: "tip", text: "CoT: 복잡한 추론(수학, 논리, 분석)이 필요한 작업에 효과적입니다" },
                { type: "mistake", text: "예시가 일관성 없으면 AI가 패턴을 학습하지 못합니다" },
              ]}
            />
          </div>
        );
      case 5:
        return (
          <div className="space-y-6">
            <div className="prose prose-slate max-w-none">
              <p className="text-slate-600 leading-relaxed">
                AI는 내용뿐 아니라 형식도 제어할 수 있습니다. JSON, 마크다운, 테이블, 심지어 코드까지 원하는 형태로 출력 가능합니다.
              </p>
              <p className="text-slate-600 leading-relaxed">
                <strong className="text-emerald-600">핵심은?</strong> 출력 형식을 명확히 지정하면, 결과물을 다른 시스템에 바로 연동하거나 후처리 없이 사용할 수 있습니다.
              </p>
            </div>

            <ExamplePromptBlock
              title="JSON 형식 지정 예시"
              prompt={`다음 제품 설명을 분석하여 JSON 형식으로 출력하세요:

입력: "삼성 갤럭시 S24 울트라, 256GB, 티타늄 그레이, 999,000원"

출력 형식:
{
  "brand": "제조사명",
  "model": "모델명",
  "storage": "용량 (숫자만)",
  "color": "색상",
  "price": "가격 (숫자만)"
}

주의: JSON 이외의 부연 설명은 절대 포함하지 마세요.`}
            />

            <ExamplePromptBlock
              title="마크다운 테이블 형식 예시"
              prompt={`경쟁사 3개의 SaaS 제품을 비교 분석하여 마크다운 테이블로 출력하세요:

| 항목 | 제품 A | 제품 B | 제품 C |
|------|--------|--------|--------|
| 가격 | | | |
| 주요 기능 | | | |
| 장점 | | | |
| 단점 | | | |
| 적합한 고객 | | | |

각 셀은 1-2줄로 간결하게 작성하세요.`}
            />

            <TipsCard
              tips={[
                { type: "tip", text: "구조화된 데이터가 필요하면 JSON을 사용하세요 (API 연동 등)" },
                { type: "tip", text: "형식 예시를 함께 제공하면 정확도가 높아집니다" },
                { type: "mistake", text: "'JSON으로 출력해줘'만 말하지 말고, 정확한 스키마(키 이름)를 지정하세요" },
              ]}
            />
          </div>
        );
      case 6:
        return (
          <div className="space-y-6">
            <div className="prose prose-slate max-w-none">
              <p className="text-slate-600 leading-relaxed">
                단순히 "마케터" 역할을 주는 것과 "10년 경력의 B2B SaaS 마케팅 전문가"를 주는 것은 결과가 완전히 다릅니다.
              </p>
              <p className="text-slate-600 leading-relaxed">
                <strong className="text-emerald-600">핵심은?</strong> 구체적인 페르소나(전문성, 관점, 경험)를 부여하면 AI가 해당 관점에서 사고하고 답변합니다.
              </p>
            </div>

            <div className="my-6">
              <h4 className="font-semibold text-slate-800 mb-4">페르소나 템플릿 선택</h4>
              <div className="grid md:grid-cols-3 gap-4 mb-6">
                {personas.map((persona, index) => (
                  <PersonaCard
                    key={index}
                    {...persona}
                    isSelected={selectedPersona === index}
                    onClick={() => setSelectedPersona(index)}
                  />
                ))}
              </div>

              <div className="bg-slate-50 border border-slate-200 rounded-xl p-6 shadow-sm">
                <h4 className="font-semibold text-slate-800 mb-3">선택된 페르소나 프롬프트:</h4>
                <ExamplePromptBlock prompt={personas[selectedPersona].prompt} />
              </div>
            </div>

            <TipsCard
              tips={[
                { type: "tip", text: "페르소나는 구체적일수록 좋습니다: '마케터' < 'B2B 마케터' < '10년 경력 B2B SaaS 마케터'" },
                { type: "tip", text: "여러 관점이 필요하면 페르소나를 바꿔가며 같은 질문을 해보세요" },
                { type: "mistake", text: "페르소나와 작업이 맞지 않으면 이상한 결과가 나옵니다 (예: 개발자에게 디자인 피드백 요청)" },
              ]}
            />
          </div>
        );
      case 7:
        return (
          <div className="space-y-6">
            <div className="prose prose-slate max-w-none">
              <p className="text-slate-600 leading-relaxed">
                매번 긴 프롬프트를 처음부터 작성하는 건 비효율적입니다.
                자주 쓰는 요소들을 모듈로 만들어 조합하면 빠르고 일관성 있게 작업할 수 있습니다.
              </p>
            </div>

            <div className="grid md:grid-cols-2 gap-4 my-6">
              <div className="bg-slate-50 border border-slate-200 rounded-lg p-4">
                <h4 className="font-semibold text-slate-800 mb-3">재사용 가능한 모듈</h4>
                <div className="space-y-2">
                  <div className="bg-white border border-slate-200 px-3 py-2 rounded text-sm font-mono text-slate-600">[PERSONA_VC]</div>
                  <div className="bg-white border border-slate-200 px-3 py-2 rounded text-sm font-mono text-slate-600">[PERSONA_DESIGNER]</div>
                  <div className="bg-white border border-slate-200 px-3 py-2 rounded text-sm font-mono text-slate-600">[FORMAT_BLOG]</div>
                  <div className="bg-white border border-slate-200 px-3 py-2 rounded text-sm font-mono text-slate-600">[FORMAT_JSON]</div>
                  <div className="bg-white border border-slate-200 px-3 py-2 rounded text-sm font-mono text-slate-600">[TONE_PROFESSIONAL]</div>
                  <div className="bg-white border border-slate-200 px-3 py-2 rounded text-sm font-mono text-slate-600">[CONSTRAINT_SHORT]</div>
                </div>
              </div>

              <div className="bg-white border border-slate-200 rounded-lg p-4 shadow-sm">
                <h4 className="font-semibold text-slate-800 mb-3">조합 예시</h4>
                <ExamplePromptBlock
                  prompt={`[PERSONA_VC]
당신은 10년 경력의 벤처캐피탈 투자심사역입니다.

[TASK]
이 스타트업의 비즈니스 모델을 평가하세요.

[FORMAT_JSON]
{
  "market_size": "점수 (1-10)",
  "team": "점수 (1-10)",
  "traction": "점수 (1-10)",
  "feedback": "종합 피드백"
}

[TONE_PROFESSIONAL]
전문적이고 객관적인 톤으로 작성하세요.`}
                />
              </div>
            </div>

            <TipsCard
              tips={[
                { type: "tip", text: "자주 쓰는 페르소나, 형식, 톤을 모듈로 저장해두세요 (노트 앱, Notion 등)" },
                { type: "tip", text: "모듈명은 [대문자_밑줄] 형식으로 통일하면 식별이 쉽습니다" },
                { type: "tip", text: "팀원과 모듈을 공유하면 협업 시 일관성이 높아집니다" },
              ]}
            />
          </div>
        );
      case 8:
        return (
          <div className="space-y-6">
            <div className="prose prose-slate max-w-none">
              <p className="text-slate-600 leading-relaxed">
                지금까지 배운 모든 기법(RCTFP, ROSES, Few-shot, CoT, 페르소나, 모듈)을 하나로 통합한 것이 AIHub 프레임워크입니다.
              </p>
              <p className="text-slate-600 leading-relaxed">
                <strong className="text-emerald-600">핵심은?</strong> 복잡한 프로젝트(사업 계획서, 논문, 전략 보고서 등)도 이 구조로 단계별로 해결할 수 있습니다.
              </p>
            </div>

            <ExamplePromptBlock
              title="AIHub 통합 프롬프트 예시"
              prompt={`# AIHub 프레임워크 - 사업 계획서 작성

## PERSONA
[PERSONA_BUSINESS_CONSULTANT]
당신은 20년 경력의 사업 컨설턴트로, 수백 개의 스타트업과 중소기업을 자문했습니다.

## CONTEXT
- 산업: 푸드테크 (배달음식 포장재 친환경 솔루션)
- 타깃: B2B (배달앱 플랫폼, 음식점)
- 팀: 창업자 2명 (기술, 영업)
- 단계: Pre-seed 투자 유치 준비

## OBJECTIVE
투자자에게 제출할 사업 계획서를 작성하여, 시드 투자 유치 가능성을 높이는 것

## TASK
1. 시장 분석 (TAM/SAM/SOM)
2. 문제 정의 및 솔루션
3. 비즈니스 모델
4. Go-to-Market 전략
5. 3개년 재무 계획
6. 리스크 및 대응 방안

## FORMAT
- 마크다운 형식
- 각 섹션별로 2-3페이지 분량
- 표, 그래프 구조 제안 포함

## PARAMETERS
- 톤: 전문적이면서도 투자자의 흥미를 끄는 스토리텔링
- 길이: 총 15-20페이지 분량
- 금지: 과장된 시장 추정, 불분명한 수익 모델

## CHAIN-OF-THOUGHT
각 섹션을 작성할 때, 왜 이 내용이 중요한지 투자자의 관점에서 설명을 포함하세요.

## SENSE CHECK
- 제시한 숫자와 가정이 현실적인가?
- 경쟁사 대비 차별점이 명확한가?
- 실행 가능성이 검증되었는가?`}
            />

            <TipsCard
              tips={[
                { type: "tip", text: "AIHub 프레임워크는 대형 프로젝트의 '마스터 프롬프트'로 사용하세요" },
                { type: "tip", text: "섹션이 많으면 한 번에 모두 요청하지 말고, 섹션별로 나눠 진행하세요" },
                { type: "mistake", text: "모든 작업에 이 구조를 쓸 필요는 없습니다. 복잡도에 따라 RCTFP만으로도 충분합니다" },
              ]}
            />
          </div>
        );
      case 9:
        return (
          <div className="space-y-6">
            <div className="prose prose-slate max-w-none">
              <p className="text-slate-600 leading-relaxed">
                지금까지 배운 모든 것을 종합해, 당신만의 "마스터 프롬프트"를 만들 차례입니다.
                이 프롬프트는 AIHub의 다른 가이드북에서도 반복해서 사용할 수 있습니다.
              </p>
              <p className="text-slate-600 leading-relaxed">
                <strong className="text-emerald-600">핵심은?</strong> 좋은 프롬프트는 한 번 만들어두면 계속 재사용할 수 있습니다.
                시간을 들여 정교하게 만드세요.
              </p>
            </div>

            <MasterPromptBuilder />
          </div>
        );
      default:
        return null;
    }
  };

  const completedCount = completedChapters.size;
  const progressPercentage = Math.round((completedCount / TOTAL_CHAPTERS) * 100);

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
          <span className="text-slate-900 font-medium">프롬프트 엔지니어링 입문</span>
        </div>

        {/* 1. Header */}
        <GuidebookHeader
          title="프롬프트 엔지니어링 입문"
          description="AI를 잘 쓰는 사람과 못 쓰는 사람의 차이는 결국 프롬프트 설계 능력입니다. 이 코스는 AIHub의 모든 가이드북을 보기 전에 먼저 완주하는 0번 트랙입니다."
          progress={progressPercentage}
          category="필수 코스"
          tags={['ChatGPT', 'Claude', 'Gemini']}
          duration="2시간"
          difficulty="입문"
        />

        <div className="space-y-12">
          {/* 2. Overview Cards */}
          <section className="space-y-8">
            <GuideOverviewCards
              summary="AI와 대화하는 법을 처음부터 끝까지 체계적으로 배웁니다. 기본기부터 고급 프레임워크까지 프롬프트 엔지니어링의 모든 것을 다룹니다."
              recommendations={[
                "AI를 처음 써보는 입문자",
                "업무 생산성을 높이고 싶은 직장인",
                "더 나은 결과물을 원하는 AI 사용자"
              ]}
              requirements={["ChatGPT 무료 계정 이상"]}
              corePrinciples={[
                "AI는 도구일 뿐, 지시는 인간의 몫입니다.",
                "명확한 맥락이 좋은 결과를 만듭니다.",
                "한 번에 완벽할 수 없습니다. 반복해서 개선하세요."
              ]}
            />
          </section>

          {/* 3. Content Area */}
          <section className="min-h-[500px]">
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 items-start">

              {/* Sidebar (Desktop: Left) */}
              <div className="hidden lg:block space-y-6 sticky top-24 lg:col-span-1">
                <GuideProgressSidebar
                  steps={chapters}
                  activeStepId={`chapter-${activeStepIndex}`}
                  completedStepIds={completedStepIds}
                  onStepClick={handleStepClick}
                />
              </div>

              {/* Main Content (Right) */}
              <div className="lg:col-span-2 space-y-8">
                <div className="animate-in fade-in slide-in-from-bottom-4 duration-500">

                  {/* Step Header */}
                  <div className="bg-white rounded-2xl border border-slate-100 shadow-sm overflow-hidden mb-6">
                    <div className="bg-slate-50 px-6 py-4 border-b border-slate-100 flex justify-between items-center">
                      <h2 className="text-xl font-bold text-slate-800">
                        {chapters[activeStepIndex].title}
                      </h2>
                      <div className="text-sm font-medium text-slate-400">
                        Step {activeStepIndex + 1}
                      </div>
                    </div>
                    <div className="p-8">
                      {renderContent(activeStepIndex)}
                    </div>
                  </div>

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
                        {activeStepIndex + 1} / {TOTAL_CHAPTERS}
                      </div>

                      <Button
                        variant={completedChapters.has(activeStepIndex) ? "secondary" : "outline"}
                        onClick={() => toggleChapterComplete(activeStepIndex)}
                        className={`gap-2 ${completedChapters.has(activeStepIndex) ? 'bg-emerald-100 text-emerald-700 hover:bg-emerald-200 border-emerald-200' : 'text-slate-500 hover:text-slate-900'}`}
                      >
                        <CheckCircle2 className={`w-4 h-4 ${completedChapters.has(activeStepIndex) ? 'fill-emerald-600 text-white' : ''}`} />
                        {completedChapters.has(activeStepIndex) ? '완료됨' : '완료 표시'}
                      </Button>

                      <Button
                        onClick={handleNextStep}
                        disabled={activeStepIndex === TOTAL_CHAPTERS - 1}
                        className="gap-2 pr-2.5 bg-emerald-600 hover:bg-emerald-700 text-white shadow-md hover:shadow-lg transition-all"
                      >
                        다음 Step
                        <ChevronRight className="w-4 h-4" />
                      </Button>
                    </div>
                  </div>
                </div>
              </div>

            </div>
          </section>
        </div>
      </main>
      <Footer />
    </div>
  );
};

export default PromptEngineering;
