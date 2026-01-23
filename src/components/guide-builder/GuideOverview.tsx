import { Card, CardContent } from "@/components/ui/card";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Input } from "@/components/ui/input";
import { FileText, Users, Package, Lightbulb, Type } from "lucide-react";

export function GuideOverview() {
    return (
        <div className="space-y-6 mb-8 animate-in fade-in slide-in-from-bottom-4 duration-700">
            <div className="text-center mb-8">
                <h1 className="text-3xl font-bold text-slate-900 mb-2">가이드북 기본 정보</h1>
                <p className="text-slate-500">독자들이 가장 먼저 보게 될 핵심 정보를 입력해주세요.</p>
            </div>

            {/* 0. 제목 (필수) */}
            <Card className="border-emerald-100 shadow-sm hover:shadow-md transition-shadow mb-6">
                <CardContent className="p-6">
                    <div className="flex items-center gap-2 mb-4 text-emerald-700 font-bold">
                        <Type className="w-5 h-5" />
                        <h3>가이드북 제목</h3>
                    </div>
                    <Input
                        placeholder="매력적인 가이드북 제목을 입력하세요 (예: 3시간 만에 끝내는 AI 창업)"
                        className="text-lg font-bold h-12 border-emerald-100 focus:border-emerald-500 bg-emerald-50/30"
                    />
                </CardContent>
            </Card>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                {/* 1. 한 줄 요약 */}
                <Card className="border-emerald-100 shadow-sm hover:shadow-md transition-shadow">
                    <CardContent className="p-6">
                        <div className="flex items-center gap-2 mb-4 text-emerald-700 font-bold">
                            <FileText className="w-5 h-5" />
                            <h3>한 줄 요약</h3>
                        </div>
                        <Textarea
                            placeholder="이 가이드북은 어떤 문제를 해결해주나요?"
                            className="min-h-[120px] resize-none border-emerald-100 focus:border-emerald-500 bg-emerald-50/30"
                        />
                    </CardContent>
                </Card>

                {/* 2. 이런 분께 추천 */}
                <Card className="border-emerald-100 shadow-sm hover:shadow-md transition-shadow">
                    <CardContent className="p-6">
                        <div className="flex items-center gap-2 mb-4 text-emerald-700 font-bold">
                            <Users className="w-5 h-5" />
                            <h3>이런 분께 추천</h3>
                        </div>
                        <Textarea
                            placeholder="• AI 창업을 준비하는 대학생&#13;&#10;• 과제 시간을 단축하고 싶은 분"
                            className="min-h-[120px] resize-none border-emerald-100 focus:border-emerald-500 bg-emerald-50/30"
                        />
                    </CardContent>
                </Card>

                {/* 3. 준비물 */}
                <Card className="border-emerald-100 shadow-sm hover:shadow-md transition-shadow">
                    <CardContent className="p-6">
                        <div className="flex items-center gap-2 mb-4 text-emerald-700 font-bold">
                            <Package className="w-5 h-5" />
                            <h3>준비물</h3>
                        </div>
                        <Textarea
                            placeholder="• ChatGPT Plus 계정&#13;&#10;• 인터넷이 가능한 PC"
                            className="min-h-[120px] resize-none border-emerald-100 focus:border-emerald-500 bg-emerald-50/30"
                        />
                    </CardContent>
                </Card>

                {/* 4. 핵심 사용 원칙 */}
                <Card className="border-emerald-100 shadow-sm hover:shadow-md transition-shadow">
                    <CardContent className="p-6">
                        <div className="flex items-center gap-2 mb-4 text-emerald-700 font-bold">
                            <Lightbulb className="w-5 h-5" />
                            <h3>핵심 사용 원칙</h3>
                        </div>
                        <Textarea
                            placeholder="• 구체성이 답이다&#13;&#10;• 대화로 다듬기"
                            className="min-h-[120px] resize-none border-emerald-100 focus:border-emerald-500 bg-emerald-50/30"
                        />
                    </CardContent>
                </Card>
            </div>

            <div className="my-8 flex items-center gap-4">
                <div className="h-px bg-slate-200 flex-1" />
                <span className="text-slate-400 text-sm font-medium">여기부터 Step 상세 내용</span>
                <div className="h-px bg-slate-200 flex-1" />
            </div>
        </div>
    );
}
