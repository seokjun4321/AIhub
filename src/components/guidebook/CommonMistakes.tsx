import { AlertTriangle, XCircle, CheckCircle2 } from "lucide-react";

export interface MistakeItem {
    id: string;
    mistake: string;
    solution: string;
}

interface CommonMistakesProps {
    items: MistakeItem[];
}

export function CommonMistakes({ items }: CommonMistakesProps) {
    if (!items || items.length === 0) {
        return <div className="text-center py-8 text-slate-500">등록된 자주 하는 실수가 없습니다.</div>;
    }

    return (
        <div className="grid grid-cols-1 gap-4">
            {items.map((item) => (
                <div key={item.id} className="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm">
                    <div className="flex items-start gap-4 mb-4">
                        <div className="p-2 bg-red-50 text-red-500 rounded-lg shrink-0">
                            <AlertTriangle className="w-5 h-5" />
                        </div>
                        <div>
                            <h4 className="font-bold text-slate-900 mb-1">실수하기 쉬운 점</h4>
                            <p className="text-sm text-slate-600">{item.mistake}</p>
                        </div>
                    </div>

                    <div className="pl-14">
                        <div className="bg-green-50 p-4 rounded-xl border border-green-100 flex items-start gap-3">
                            <CheckCircle2 className="w-5 h-5 text-green-600 shrink-0 mt-0.5" />
                            <div>
                                <span className="font-semibold text-green-700 block mb-1">해결 방법</span>
                                <p className="text-sm text-green-800 leading-relaxed">{item.solution}</p>
                            </div>
                        </div>
                    </div>
                </div>
            ))}
        </div>
    );
}
