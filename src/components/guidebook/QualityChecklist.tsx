import { Checkbox } from "@/components/ui/checkbox";

export interface ChecklistItem {
    id: string;
    text: string;
    checked?: boolean; // Initial state if needed, mostly for display
}

interface QualityChecklistProps {
    items: ChecklistItem[];
}

export function QualityChecklist({ items }: QualityChecklistProps) {
    if (!items || items.length === 0) {
        return <div className="text-center py-8 text-slate-500">체크리스트가 없습니다.</div>;
    }

    return (
        <div className="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm">
            <h3 className="font-bold text-lg mb-6">품질 체크리스트</h3>
            <div className="space-y-4">
                {items.map((item) => (
                    <div key={item.id} className="flex items-start gap-3 p-3 hover:bg-slate-50 rounded-lg transition-colors cursor-pointer">
                        <Checkbox id={`qc-${item.id}`} className="mt-1 data-[state=checked]:bg-green-500 data-[state=checked]:border-green-500" />
                        <label
                            htmlFor={`qc-${item.id}`}
                            className="text-sm text-slate-700 leading-relaxed cursor-pointer select-none"
                        >
                            {item.text}
                        </label>
                    </div>
                ))}
            </div>
        </div>
    );
}
