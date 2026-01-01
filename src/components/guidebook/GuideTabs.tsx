import { Tabs, TabsList, TabsTrigger, TabsContent } from "@/components/ui/tabs";
import { Lightbulb, MessageSquare, CheckSquare, AlertTriangle, ArrowLeftRight, ArrowRight } from "lucide-react";
import { UsageScenarios, Scenario } from "./UsageScenarios";
import { PromptPack, PromptItem } from "./PromptPack";
import { QualityChecklist, ChecklistItem } from "./QualityChecklist";
import { CommonMistakes, MistakeItem } from "./CommonMistakes";
import { BeforeAfter, ComparisonItem } from "./BeforeAfter";

interface GuideTabsProps {
    scenarios: Scenario[];
    prompts: PromptItem[];
    checklist: ChecklistItem[];
    mistakes: MistakeItem[];
    comparisons: ComparisonItem[];
    nextGuideId?: number; // For "Next Guide" tab content
}

export function GuideTabs({
    scenarios,
    prompts,
    checklist,
    mistakes,
    comparisons,
}: GuideTabsProps) {
    return (
        <Tabs defaultValue="scenarios" className="w-full">
            <div className="overflow-x-auto pb-2 scrollbar-hide">
                <TabsList className="w-full justify-center h-auto p-1 bg-transparent border-b border-slate-100 rounded-none gap-2 mb-6">
                    <TabsTrigger
                        value="scenarios"
                        className="gap-2 px-4 py-2.5 rounded-full data-[state=active]:bg-slate-900 data-[state=active]:text-white data-[state=active]:shadow-none bg-white text-slate-500 border border-slate-200"
                    >
                        <Lightbulb className="w-4 h-4" />
                        사용 시나리오
                    </TabsTrigger>
                    <TabsTrigger
                        value="prompts"
                        className="gap-2 px-4 py-2.5 rounded-full data-[state=active]:bg-slate-900 data-[state=active]:text-white data-[state=active]:shadow-none bg-white text-slate-500 border border-slate-200"
                    >
                        <MessageSquare className="w-4 h-4" />
                        프롬프트 팩
                    </TabsTrigger>
                    <TabsTrigger
                        value="checklist"
                        className="gap-2 px-4 py-2.5 rounded-full data-[state=active]:bg-slate-900 data-[state=active]:text-white data-[state=active]:shadow-none bg-white text-slate-500 border border-slate-200"
                    >
                        <CheckSquare className="w-4 h-4" />
                        품질 체크리스트
                    </TabsTrigger>
                    <TabsTrigger
                        value="mistakes"
                        className="gap-2 px-4 py-2.5 rounded-full data-[state=active]:bg-slate-900 data-[state=active]:text-white data-[state=active]:shadow-none bg-white text-slate-500 border border-slate-200"
                    >
                        <AlertTriangle className="w-4 h-4" />
                        자주 하는 실수
                    </TabsTrigger>
                    <TabsTrigger
                        value="beforeafter"
                        className="gap-2 px-4 py-2.5 rounded-full data-[state=active]:bg-slate-900 data-[state=active]:text-white data-[state=active]:shadow-none bg-white text-slate-500 border border-slate-200"
                    >
                        <ArrowLeftRight className="w-4 h-4" />
                        Before/After
                    </TabsTrigger>
                    <TabsTrigger
                        value="next"
                        className="gap-2 px-4 py-2.5 rounded-full data-[state=active]:bg-slate-900 data-[state=active]:text-white data-[state=active]:shadow-none bg-white text-slate-500 border border-slate-200"
                    >
                        <ArrowRight className="w-4 h-4" />
                        다음 가이드
                    </TabsTrigger>
                </TabsList>
            </div>

            <TabsContent value="scenarios" className="mt-0">
                <UsageScenarios scenarios={scenarios} />
            </TabsContent>

            <TabsContent value="prompts" className="mt-0">
                <PromptPack prompts={prompts} />
            </TabsContent>

            <TabsContent value="checklist" className="mt-0">
                <QualityChecklist items={checklist} />
            </TabsContent>

            <TabsContent value="mistakes" className="mt-0">
                <CommonMistakes items={mistakes} />
            </TabsContent>

            <TabsContent value="beforeafter" className="mt-0">
                <BeforeAfter items={comparisons} />
            </TabsContent>

            <TabsContent value="next" className="mt-0">
                <div className="bg-white p-8 rounded-2xl border border-slate-100 text-center text-slate-500 py-16">
                    다음 단계 가이드가 준비 중입니다.
                </div>
            </TabsContent>
        </Tabs>
    );
}
