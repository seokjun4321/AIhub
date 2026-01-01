import { Badge } from "@/components/ui/badge";
import { Clock, FileText, MessageSquare, Search, Sparkles, AlertTriangle } from "lucide-react";

export interface Scenario {
    id: string;
    title: string;
    description: string;
    toolName?: string;
    icon?: string; // Icon name
}

interface UsageScenariosProps {
    scenarios: Scenario[];
}

// Helper to map icon name to component
const getIcon = (name?: string) => {
    switch (name) {
        case 'clock': return <Clock className="w-5 h-5" />;
        case 'file': return <FileText className="w-5 h-5" />;
        case 'message': return <MessageSquare className="w-5 h-5" />;
        case 'search': return <Search className="w-5 h-5" />;
        case 'sparkles': return <Sparkles className="w-5 h-5" />;
        case 'alert': return <AlertTriangle className="w-5 h-5" />;
        default: return <Sparkles className="w-5 h-5" />;
    }
};

export function UsageScenarios({ scenarios }: UsageScenariosProps) {
    if (!scenarios || scenarios.length === 0) {
        return <div className="text-center py-8 text-slate-500">사용 시나리오가 없습니다.</div>;
    }

    return (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {scenarios.map((item) => (
                <div key={item.id} className="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm flex flex-col items-start hover:border-green-200 transition-colors">
                    <div className="flex items-center gap-3 mb-3">
                        <div className="p-2 bg-green-50 text-green-600 rounded-lg">
                            {getIcon(item.icon)}
                        </div>
                        <h4 className="font-bold text-slate-900">{item.title}</h4>
                    </div>
                    <p className="text-sm text-slate-600 mb-4 leading-relaxed">
                        {item.description}
                    </p>
                    {item.toolName && (
                        <Badge variant="secondary" className="text-xs bg-slate-100 text-slate-600 font-normal hover:bg-slate-200">
                            {item.toolName}
                        </Badge>
                    )}
                </div>
            ))}
        </div>
    );
}
