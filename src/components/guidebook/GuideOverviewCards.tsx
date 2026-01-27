import { HighlightBold } from "@/components/ui/highlight-bold";
import { FileText, User, AppWindow, Lightbulb } from "lucide-react";

interface GuideOverviewCardsProps {
    summary?: string;
    recommendations?: string[];
    requirements?: string[];
    corePrinciples?: string[];
}

export function GuideOverviewCards({
    summary,
    recommendations = [],
    requirements = [],
    corePrinciples = []
}: GuideOverviewCardsProps) {
    // Helper to clean text
    const cleanText = (text: string) => text.replace(/^[\d\.\)\s]+/, '');

    return (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
            <div className="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm flex flex-col h-full">
                <div className="flex items-center gap-2 mb-3 text-green-600">
                    <FileText className="w-5 h-5" />
                    <h3 className="font-bold text-sm">한 줄 요약</h3>
                </div>
                <p className="text-sm text-slate-600 leading-relaxed flex-1">
                    {summary ? <HighlightBold text={summary} /> : "이 가이드에 대한 요약이 없습니다."}
                </p>
            </div>

            {/* Recommended For */}
            <div className="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm flex flex-col h-full">
                <div className="flex items-center gap-2 mb-3 text-green-600">
                    <User className="w-5 h-5" />
                    <h3 className="font-bold text-sm">이런 분께 추천</h3>
                </div>
                <div className="space-y-2">
                    {recommendations.length > 0 ? (
                        recommendations.map((item, idx) => (
                            <div key={idx} className="flex items-start gap-2 text-sm text-slate-600">
                                <span className="mt-1.5 w-1 h-1 bg-slate-400 rounded-full shrink-0" />
                                <span><HighlightBold text={cleanText(item)} /></span>
                            </div>
                        ))
                    ) : (
                        <div className="text-sm text-slate-400">추천 대상 정보가 없습니다.</div>
                    )}
                </div>
            </div>

            {/* Preparation */}
            <div className="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm flex flex-col h-full">
                <div className="flex items-center gap-2 mb-3 text-green-600">
                    <AppWindow className="w-5 h-5" />
                    <h3 className="font-bold text-sm">준비물</h3>
                </div>
                <div className="space-y-2">
                    {requirements.length > 0 ? (
                        requirements.map((item, idx) => (
                            <div key={idx} className="flex items-start gap-2 text-sm text-slate-600">
                                <span className="mt-1.5 w-1 h-1 bg-slate-400 rounded-full shrink-0" />
                                <span><HighlightBold text={cleanText(item)} /></span>
                            </div>
                        ))
                    ) : (
                        <div className="text-sm text-slate-400">준비물 정보가 없습니다.</div>
                    )}
                </div>
            </div>

            {/* Core Principles */}
            <div className="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm flex flex-col h-full">
                <div className="flex items-center gap-2 mb-3 text-green-600">
                    <Lightbulb className="w-5 h-5" />
                    <h3 className="font-bold text-sm">핵심 사용 원칙</h3>
                </div>
                <div className="space-y-2">
                    {corePrinciples.length > 0 ? (
                        corePrinciples.map((item, idx) => (
                            <div key={idx} className="flex items-start gap-2 text-sm text-slate-600">
                                <span className="mt-1.5 w-1 h-1 bg-slate-400 rounded-full shrink-0" />
                                <span><HighlightBold text={cleanText(item)} /></span>
                            </div>
                        ))
                    ) : (
                        <div className="text-sm text-slate-400">핵심 원칙 정보가 없습니다.</div>
                    )}
                </div>
            </div>
        </div >
    );
}
