import { useDraggable } from '@dnd-kit/core';
import { cn } from '@/lib/utils';
import { Type, ListTodo, Lightbulb, AlertTriangle, TerminalSquare, Split, CheckSquare } from 'lucide-react';
import { BlockType } from './GuideBuilderLayout';

const tools = [
    { type: 'step', label: 'Step 추가', icon: ListTodo, desc: '새로운 단계를 추가합니다' },
    { type: 'action', label: 'Action', icon: TerminalSquare, desc: '구체적인 행동 지침' },
    { type: 'tips', label: '꿀팁 & 실수', icon: Lightbulb, desc: '도움이 되는 팁 박스' },
    { type: 'warning', label: '주의사항', icon: AlertTriangle, desc: '중요 경고 박스' },
    { type: 'prompt', label: '프롬프트', icon: TerminalSquare, desc: 'AI 프롬프트 코드 블록' },
    { type: 'checklist', label: '체크리스트', icon: CheckSquare, desc: '완료 확인용 리스트' },
    { type: 'branch', label: 'A/B 분기', icon: Split, desc: '선택형 시나리오' },
];

export function BuilderSidebar() {
    return (
        <div className="flex flex-col h-full">
            <div className="p-6 border-b border-slate-100">
                <h2 className="font-bold text-slate-900 border-l-4 border-emerald-500 pl-3">도구 상자</h2>
                <p className="text-xs text-slate-500 mt-1 pl-3">필요한 블록을 드래그하세요</p>
            </div>

            <div className="flex-1 overflow-y-auto p-4 space-y-3">
                {tools.map((tool) => (
                    <DraggableTool key={tool.type} tool={tool} />
                ))}
            </div>
        </div>
    );
}

function DraggableTool({ tool }: { tool: any }) {
    const { attributes, listeners, setNodeRef, isDragging } = useDraggable({
        id: `tool-${tool.type}`,
        data: {
            type: tool.type as BlockType,
        },
    });

    const Icon = tool.icon;

    const isStep = tool.type === 'step';

    return (
        <div
            ref={setNodeRef}
            {...listeners}
            {...attributes}
            className={cn(
                "group flex items-center gap-4 p-4 rounded-2xl border shadow-sm transition-all cursor-grab active:cursor-grabbing mb-3",
                isStep
                    ? "bg-emerald-50 border-emerald-200 hover:bg-emerald-100/50 hover:shadow-emerald-100"
                    : "bg-white border-slate-100 hover:shadow-md hover:border-emerald-200"
            )}
        >
            <div className={cn(
                "w-12 h-12 rounded-2xl flex items-center justify-center transition-colors",
                isStep
                    ? "bg-white text-emerald-600 border border-emerald-100"
                    : "bg-slate-50 border border-slate-100 text-slate-600 group-hover:text-emerald-600 group-hover:bg-emerald-50"
            )}>
                <Icon className={cn("w-6 h-6", isStep && "fill-emerald-100")} />
            </div>
            <div className="flex-1">
                <h3 className={cn("text-base font-bold mb-0.5", isStep ? "text-emerald-900" : "text-slate-900")}>
                    {tool.label}
                </h3>
                <p className={cn("text-xs", isStep ? "text-emerald-600" : "text-slate-500")}>
                    {tool.desc}
                </p>
            </div>
        </div>
    );
}
