import { Button } from "@/components/ui/button";
import { ArrowRight, Play } from "lucide-react";
import { HighlightBold } from "@/components/ui/highlight-bold";

interface GuidebookHeaderProps {
  title: string;
  description: string;
  progress?: number;
  category?: string;
  toolName?: string;
  logoUrl?: string;
  duration?: string;
  difficulty?: string;
  tags?: string[];
}

export function GuidebookHeader({
  title,
  description,
  progress = 0,
  category = "가이드",
  toolName = "AI Tool",
  logoUrl,
  duration,
  difficulty,
  tags
}: GuidebookHeaderProps) {
  return (
    <div className="flex flex-col md:flex-row justify-between items-start gap-6 mb-8 bg-white p-8 rounded-2xl shadow-sm border border-slate-100">
      <div className="flex-1 space-y-4">
        <div className="flex flex-col gap-4 mb-4">
          <div>
            <div className="flex flex-wrap items-center gap-2 mb-2">
              <span className="bg-green-100 text-green-700 px-2.5 py-1 rounded text-xs font-bold uppercase tracking-wide">
                {category}
              </span>
              {difficulty && (
                <span className="text-slate-400 text-sm px-2 border-l border-slate-300">
                  난이도: {difficulty}
                </span>
              )}
              {duration && (
                <span className="text-slate-400 text-sm px-2 border-l border-slate-300">
                  {String(duration).includes('분') || String(duration).includes('시간') ? duration : `${duration}분`} 소요
                </span>
              )}
              {tags && tags.length > 0 && tags.map((tag, index) => (
                <span key={index} className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-slate-100 text-slate-600">
                  {tag}
                </span>
              ))}
            </div>
            <h1 className="text-3xl font-bold tracking-tight text-slate-900 leading-tight">
              <HighlightBold text={title} />
            </h1>
          </div>
        </div>

        <p className="text-lg text-slate-500 max-w-2xl leading-relaxed">
          <HighlightBold text={description} />
        </p>
      </div>

      <div className="flex items-center gap-4 bg-slate-50 p-6 rounded-2xl border border-slate-100 min-w-[240px]">
        {/* Circular Progress */}
        <div className="relative w-16 h-16">
          <svg className="w-full h-full transform -rotate-90">
            <circle
              className="text-slate-200"
              strokeWidth="6"
              stroke="currentColor"
              fill="transparent"
              r="28"
              cx="32"
              cy="32"
            />
            <circle
              className="text-green-500 transition-all duration-1000 ease-out"
              strokeWidth="6"
              strokeDasharray={2 * Math.PI * 28}
              strokeDashoffset={2 * Math.PI * 28 * (1 - progress / 100)}
              strokeLinecap="round"
              stroke="currentColor"
              fill="transparent"
              r="28"
              cx="32"
              cy="32"
            />
          </svg>
          <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2">
            <span className="text-sm font-bold text-slate-900">{progress}%</span>
          </div>
        </div>
        <div>
          <p className="text-sm font-medium text-slate-500">나의 진행률</p>
          <p className="text-sm text-slate-400">
            {progress === 0 ? "아직 시작하지 않음" : progress === 100 ? "완료됨" : "진행 중"}
          </p>
        </div>
      </div>
    </div>
  );
}
