export interface ComparisonItem {
    id: string;
    before: string;
    after: string;
    description?: string;
}

interface BeforeAfterProps {
    items: ComparisonItem[];
}

export function BeforeAfter({ items }: BeforeAfterProps) {
    if (!items || items.length === 0) {
        return <div className="text-center py-8 text-slate-500">Before/After 비교 데이터가 없습니다.</div>;
    }

    return (
        <div className="space-y-8">
            {items.map((item) => (
                <div key={item.id} className="space-y-4">
                    {item.description && (
                        <h3 className="font-bold text-lg text-slate-900">{item.description}</h3>
                    )}
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                        {/* Before */}
                        <div className="bg-slate-50 p-6 rounded-2xl border border-slate-200">
                            <div className="inline-block px-3 py-1 bg-slate-200 text-slate-600 rounded-full text-xs font-bold mb-4">
                                BEFORE
                            </div>
                            <div className="text-sm text-slate-600 font-mono whitespace-pre-wrap leading-relaxed">
                                {item.before}
                            </div>
                        </div>

                        {/* After */}
                        <div className="bg-green-50 p-6 rounded-2xl border border-green-200">
                            <div className="inline-block px-3 py-1 bg-green-200 text-green-700 rounded-full text-xs font-bold mb-4">
                                AFTER
                            </div>
                            <div className="text-sm text-slate-800 font-mono whitespace-pre-wrap leading-relaxed">
                                {item.after}
                            </div>
                        </div>
                    </div>
                </div>
            ))}
        </div>
    );
}
