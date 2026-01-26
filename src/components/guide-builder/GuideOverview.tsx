import { Card, CardContent } from "@/components/ui/card";
import { Textarea } from "@/components/ui/textarea";
import { BulletPointTextarea } from "@/components/ui/bullet-point-textarea";
import { Input } from "@/components/ui/input";
import { FileText, Users, Package, Lightbulb, Type } from "lucide-react";
import { GuideMetadata } from "./GuideBuilderLayout";
import { useState, useEffect } from "react";
import { supabase } from "@/integrations/supabase/client";

interface GuideOverviewProps {
    metadata: GuideMetadata;
    onChange: (key: keyof GuideMetadata, value: any) => void;
}

export function GuideOverview({ metadata, onChange }: GuideOverviewProps) {
    const [categories, setCategories] = useState<{ id: number, name: string }[]>([]);
    const [aiModels, setAiModels] = useState<{ id: number, name: string }[]>([]);

    useEffect(() => {
        supabase.from('categories')
            .select('id, name')
            .order('name')
            .then(({ data }) => {
                if (data) setCategories(data);
            });

        supabase.from('ai_models')
            .select('id, name')
            .order('name')
            .then(({ data }) => {
                if (data) setAiModels(data);
            });
    }, []);

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
                        value={metadata.title}
                        onChange={(e) => onChange('title', e.target.value)}
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
                            value={metadata.summary}
                            onChange={(e) => onChange('summary', e.target.value)}
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
                        <BulletPointTextarea
                            placeholder="• AI 창업을 준비하는 대학생&#13;&#10;• 과제 시간을 단축하고 싶은 분"
                            className="min-h-[120px] resize-none border-emerald-100 focus:border-emerald-500 bg-emerald-50/30"
                            value={metadata.targetAudience}
                            onChange={(e) => onChange('targetAudience', e.target.value)}
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
                        <BulletPointTextarea
                            placeholder="• ChatGPT Plus 계정&#13;&#10;• 인터넷이 가능한 PC"
                            className="min-h-[120px] resize-none border-emerald-100 focus:border-emerald-500 bg-emerald-50/30"
                            value={metadata.requirements}
                            onChange={(e) => onChange('requirements', e.target.value)}
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
                        <BulletPointTextarea
                            placeholder="• 구체성이 답이다&#13;&#10;• 대화로 다듬기"
                            className="min-h-[120px] resize-none border-emerald-100 focus:border-emerald-500 bg-emerald-50/30"
                            value={metadata.corePrinciples}
                            onChange={(e) => onChange('corePrinciples', e.target.value)}
                        />
                    </CardContent>
                </Card>
            </div>

            {/* Extra Metadata (Category, Difficulty, Duration, Tags) */}
            <Card className="border-emerald-100 shadow-sm hover:shadow-md transition-shadow mb-6">
                <CardContent className="p-6">
                    <div className="flex items-center gap-2 mb-4 text-emerald-700 font-bold">
                        <Type className="w-5 h-5" />
                        <h3>추가 정보</h3>
                    </div>
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                        {/* Category */}
                        <div className="space-y-2">
                            <label className="text-sm font-medium text-slate-700">카테고리</label>
                            <select
                                className="flex h-10 w-full rounded-md border border-input bg-emerald-50/30 px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
                                value={metadata.categoryId}
                                onChange={(e) => onChange('categoryId', parseInt(e.target.value))}
                            >
                                <option value="">카테고리를 선택하세요</option>
                                {categories.map(cat => (
                                    <option key={cat.id} value={cat.id}>{cat.name}</option>
                                ))}
                            </select>
                        </div>

                        {/* AI Model */}
                        <div className="space-y-2">
                            <label className="text-sm font-medium text-slate-700">사용 AI 모델</label>
                            <select
                                className="flex h-10 w-full rounded-md border border-input bg-emerald-50/30 px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
                                value={metadata.aiModelId || ''}
                                onChange={(e) => onChange('aiModelId', parseInt(e.target.value))}
                            >
                                <option value="">AI 모델을 선택하세요</option>
                                {aiModels.map(model => (
                                    <option key={model.id} value={model.id}>{model.name}</option>
                                ))}
                            </select>
                        </div>

                        {/* Difficulty */}
                        <div className="space-y-2">
                            <label className="text-sm font-medium text-slate-700">난이도</label>
                            <select
                                className="flex h-10 w-full rounded-md border border-input bg-emerald-50/30 px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
                                value={metadata.difficulty}
                                onChange={(e) => onChange('difficulty', e.target.value)}
                            >
                                <option value="Beginner">Beginner</option>
                                <option value="Intermediate">Intermediate</option>
                                <option value="Advanced">Advanced</option>
                            </select>
                        </div>

                        {/* Duration */}
                        <div className="space-y-2">
                            <label className="text-sm font-medium text-slate-700">소요 시간</label>
                            <Input
                                placeholder="예: 10분, 1시간"
                                className="bg-emerald-50/30"
                                value={metadata.duration}
                                onChange={(e) => onChange('duration', e.target.value)}
                            />
                        </div>

                        {/* Tags */}
                        <div className="space-y-2">
                            <label className="text-sm font-medium text-slate-700">태그 (쉼표로 구분)</label>
                            <Input
                                placeholder="예: AI, 자동화, 생산성"
                                className="bg-emerald-50/30"
                                value={Array.isArray(metadata.tags) ? metadata.tags.join(', ') : metadata.tags}
                                onChange={(e) => onChange('tags', e.target.value.split(',').map(tag => tag.trim()))}
                            />
                        </div>
                    </div>
                </CardContent>
            </Card>

            <div className="my-8 flex items-center gap-4">
                <div className="h-px bg-slate-200 flex-1" />
                <span className="text-slate-400 text-sm font-medium">여기부터 Step 상세 내용</span>
                <div className="h-px bg-slate-200 flex-1" />
            </div>
        </div>
    );
}
