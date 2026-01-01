
import { Clock, Users, BarChart, BookOpen, Wrench } from "lucide-react";

interface InfoCardProps {
    icon: React.ReactNode;
    label: string;
    value: string;
    description: string;
}

function InfoCard({ icon, label, value, description }: InfoCardProps) {
    return (
        <div className="flex flex-col p-5 bg-white rounded-2xl border border-slate-100 shadow-sm hover:shadow-md transition-shadow">
            <div className="flex items-start justify-between mb-4">
                <div className="p-2.5 bg-slate-50 rounded-xl text-slate-700">
                    {icon}
                </div>
            </div>
            <div>
                <p className="text-sm font-medium text-slate-500 mb-1">{label}</p>
                <h3 className="text-lg font-bold text-slate-900 mb-1">{value}</h3>
                <p className="text-xs text-slate-400">{description}</p>
            </div>
        </div>
    );
}

export interface InfoGridProps {
    duration?: string;
    targetAudience?: string;
    difficulty?: string;
    toolName?: string;
}

export function InfoGrid({
    duration = "약 20분",
    targetAudience = "누구나",
    difficulty = "초급",
    toolName = "AI Tool"
}: InfoGridProps) {
    const items = [
        {
            icon: <Clock className="w-5 h-5" />,
            label: "소요 시간",
            value: duration,
            description: "실습 포함 예상 시간"
        },
        {
            icon: <Users className="w-5 h-5" />,
            label: "수강 대상",
            value: targetAudience,
            description: "입문자부터 누구나"
        },
        {
            icon: <BarChart className="w-5 h-5" />,
            label: "난이도",
            value: difficulty,
            description: "쉽게 따라할 수 있음"
        },
        {
            icon: <Wrench className="w-5 h-5" />,
            label: "사용 도구",
            value: toolName,
            description: "Free / Plus 모드 무관"
        }
    ];

    return (
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
            {items.map((item, index) => (
                <InfoCard key={index} {...item} />
            ))}
        </div>
    );
}
