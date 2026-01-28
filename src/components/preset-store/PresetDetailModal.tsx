import { useState, useEffect } from "react";
import { X, Heart, ExternalLink, Copy, Check, Lightbulb, FileText, Code, Settings } from "lucide-react";
import { Preset } from "@/types/preset";
import { HighlightBold } from "@/components/ui/highlight-bold";
import { useTossPayment } from "@/integrations/toss/useTossPayment";

interface PresetDetailModalProps {
    preset: Preset;
    onClose: () => void;
}

type TabType = "개요" | "예시" | "프롬프트/지침(복사)" | "변수 & 사용법";

const PresetDetailModal = ({ preset, onClose }: PresetDetailModalProps) => {
    const [activeTab, setActiveTab] = useState<TabType>("개요");
    const [isBookmarked, setIsBookmarked] = useState(false);
    const [copied, setCopied] = useState(false);

    // Payment Hook
    const { requestPayment } = useTossPayment();

    const handleBuy = async () => {
        try {
            // Safer ID generation for compatibility
            const orderId = `order_${Date.now()}_${Math.random().toString(36).substring(2, 9)}`;

            await requestPayment("카드", {
                amount: preset.price,
                orderId: orderId,
                orderName: preset.title,
                customerName: "AIHub User",
                successUrl: window.location.origin + "/payment/success",
                failUrl: window.location.origin + "/payment/fail",
            });
        } catch (error: any) {
            console.error("Payment failed", error);
            // Temporary alert for debugging
            alert(`결제 시작 실패: ${error.message || error}`);
        }
    };

    const tabs: TabType[] = ["개요", "예시", "프롬프트/지침(복사)", "변수 & 사용법"];

    // ESC 키로 모달 닫기
    useEffect(() => {
        const handleEsc = (e: KeyboardEvent) => {
            if (e.key === "Escape") {
                onClose();
            }
        };
        window.addEventListener("keydown", handleEsc);
        return () => window.removeEventListener("keydown", handleEsc);
    }, [onClose]);

    const handleCopy = async (text: string) => {
        await navigator.clipboard.writeText(text);
        setCopied(true);
        setTimeout(() => setCopied(false), 2000);
    };

    const handleFooterCopy = () => {
        // 현재 활성화된 탭에 따라 복사할 내용 결정
        if (activeTab === "프롬프트/지침(복사)") {
            handleCopy(preset.prompt.content);
        } else if (activeTab === "변수 & 사용법") {
            handleCopy(preset.variables.exampleInput);
        } else {
            handleCopy(preset.prompt.content);
        }
    };

    const handleToolOpen = () => {
        // AI 모델에 따라 적절한 툴 열기
        const urls: Record<string, string> = {
            "ChatGPT": "https://chat.openai.com/",
            "Gemini": "https://gemini.google.com/",
            "Claude": "https://claude.ai/"
        };
        const url = urls[preset.aiModel] || urls["ChatGPT"];
        window.open(url, "_blank");
    };

    const getTabIcon = (tab: TabType) => {
        switch (tab) {
            case "개요":
                return <Lightbulb className="w-5 h-5" />;
            case "예시":
                return <FileText className="w-5 h-5" />;
            case "프롬프트/지침(복사)":
                return <Code className="w-5 h-5" />;
            case "변수 & 사용법":
                return <Settings className="w-5 h-5" />;
        }
    };

    return (
        <div
            className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4"
            onClick={onClose}
        >
            <div
                className="bg-white rounded-2xl max-w-6xl w-full max-h-[90vh] overflow-hidden flex"
                onClick={(e) => e.stopPropagation()}
            >
                {/* Left Sidebar */}
                <div className="w-48 bg-gray-50 border-r border-gray-200 p-4 overflow-y-auto">
                    <div className="space-y-2">
                        {tabs.map((tab) => (
                            <button
                                key={tab}
                                onClick={() => setActiveTab(tab)}
                                className={`w-full flex items-center gap-3 px-4 py-3 rounded-lg text-sm font-medium transition-colors text-left ${activeTab === tab
                                    ? "bg-indigo-50 text-indigo-600"
                                    : "text-gray-700 hover:bg-gray-100"
                                    }`}
                            >
                                {getTabIcon(tab)}
                                <span className="text-xs leading-tight">{tab}</span>
                            </button>
                        ))}
                    </div>
                </div>

                {/* Main Content */}
                <div className="flex-1 flex flex-col">
                    {/* Header */}
                    <div className="p-6 border-b border-gray-200">
                        <div className="flex items-start justify-between">
                            <div className="flex-1">
                                <h2 className="text-2xl font-bold text-gray-900 mb-2">
                                    <HighlightBold text={preset.title} />
                                </h2>
                                <p className="text-gray-600">
                                    <HighlightBold text={preset.description} />
                                </p>
                            </div>
                            <button
                                onClick={onClose}
                                className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
                            >
                                <X className="w-5 h-5" />
                            </button>
                        </div>
                    </div>

                    {/* Tab Content */}
                    <div className="flex-1 overflow-y-auto p-6">
                        {activeTab === "개요" && (
                            <div className="space-y-6">
                                {/* 한 줄 요약 */}
                                <div className="bg-blue-50 border-l-4 border-blue-400 p-4 rounded-r-lg">
                                    <div className="flex items-start gap-3">
                                        <Lightbulb className="w-5 h-5 text-blue-600 mt-0.5 flex-shrink-0" />
                                        <div>
                                            <h3 className="font-semibold text-blue-900 mb-1">한 줄 요약</h3>
                                            <p className="text-blue-800 text-sm">
                                                <HighlightBold text={preset.overview.summary} />
                                            </p>
                                        </div>
                                    </div>
                                </div>

                                {/* 이럴 때 추천 */}
                                <div className="bg-emerald-50 border-l-4 border-emerald-400 p-4 rounded-r-lg">
                                    <h3 className="font-semibold text-emerald-900 mb-3">이럴 때 추천</h3>
                                    <ul className="space-y-2">
                                        {preset.overview.whenToUse.map((item, idx) => (
                                            <li key={idx} className="flex items-start gap-2 text-emerald-800 text-sm">
                                                <span className="text-emerald-600 mt-1">●</span>
                                                <span><HighlightBold text={item} /></span>
                                            </li>
                                        ))}
                                    </ul>
                                </div>

                                {/* 기대 결과 */}
                                <div className="bg-amber-50 border-l-4 border-amber-400 p-4 rounded-r-lg">
                                    <h3 className="font-semibold text-amber-900 mb-3">기대 결과</h3>
                                    <ul className="space-y-2">
                                        {preset.overview.expectedResults.map((item, idx) => (
                                            <li key={idx} className="flex items-start gap-2 text-amber-800 text-sm">
                                                <span className="text-amber-600 mt-1">●</span>
                                                <span><HighlightBold text={item} /></span>
                                            </li>
                                        ))}
                                    </ul>
                                </div>

                                {/* 프롬프트 마스터 */}
                                <div className="flex items-center gap-3 p-4 bg-gray-50 rounded-lg">
                                    <div className="w-10 h-10 bg-indigo-100 rounded-full flex items-center justify-center">
                                        <span className="text-indigo-600 text-lg">👤</span>
                                    </div>
                                    <div>
                                        <h3 className="font-semibold text-gray-900">프롬프트 마스터</h3>
                                        <p className="text-sm text-gray-600">
                                            <HighlightBold text={preset.overview.promptMaster} />
                                        </p>
                                    </div>
                                </div>
                            </div>
                        )}

                        {activeTab === "예시" && (
                            <div className="space-y-6">
                                <p className="text-gray-600 mb-4">이 프리셋으로 만들 수 있는 결과물 예시입니다.</p>
                                {preset.examples.map((example, idx) => (
                                    <div key={idx} className="space-y-4">
                                        <div className="bg-gray-50 p-4 rounded-lg">
                                            <h4 className="text-sm font-semibold text-red-600 mb-2">Before</h4>
                                            <p className="text-gray-700 text-sm">
                                                <HighlightBold text={example.before} />
                                            </p>
                                        </div>
                                        <div className="flex justify-center">
                                            <div className="w-8 h-8 bg-indigo-100 rounded-full flex items-center justify-center">
                                                <span className="text-indigo-600">→</span>
                                            </div>
                                        </div>
                                        <div className="bg-emerald-50 p-4 rounded-lg">
                                            <h4 className="text-sm font-semibold text-emerald-600 mb-2">After</h4>
                                            <pre className="text-gray-800 text-sm whitespace-pre-wrap font-sans">
                                                <HighlightBold text={example.after} />
                                            </pre>
                                        </div>
                                    </div>
                                ))}

                                {preset.examples.length > 1 && (
                                    <div className="bg-gray-50 p-4 rounded-lg">
                                        <h4 className="text-sm font-semibold text-gray-900 mb-2">제목 리뷰</h4>
                                        <p className="text-gray-700 text-sm">
                                            # 에어팟 프로 2를 구매했지 고민하시나요? 실제 3개월 사용 후기와 함께...
                                        </p>
                                    </div>
                                )}
                            </div>
                        )}

                        {activeTab === "프롬프트/지침(복사)" && (
                            <div className="space-y-4">
                                <div className="flex items-center justify-between mb-4">
                                    <div className="flex items-center gap-3 border-b border-gray-200 pb-2">
                                        <button className="px-4 py-2 text-sm font-medium text-indigo-600 border-b-2 border-indigo-600">
                                            메인
                                        </button>
                                        <button className="px-4 py-2 text-sm font-medium text-gray-500 hover:text-gray-700">
                                            옵션(스타일/분량)
                                        </button>
                                        <button className="px-4 py-2 text-sm font-medium text-gray-500 hover:text-gray-700">
                                            문체 예제
                                        </button>
                                    </div>
                                </div>

                                <div className="bg-gray-50 rounded-lg p-6 relative group">
                                    <button
                                        onClick={() => handleCopy(preset.prompt.content)}
                                        className="absolute top-4 right-4 px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition-colors flex items-center gap-2 text-sm font-medium"
                                    >
                                        {copied ? (
                                            <>
                                                <Check className="w-4 h-4" />
                                                복사됨
                                            </>
                                        ) : (
                                            <>
                                                <Copy className="w-4 h-4" />
                                                복사
                                            </>
                                        )}
                                    </button>
                                    <pre className="text-sm text-gray-800 whitespace-pre-wrap font-mono pr-24">
                                        <HighlightBold text={preset.prompt.content} />
                                    </pre>
                                </div>
                            </div>
                        )}

                        {activeTab === "변수 & 사용법" && (
                            <div className="space-y-6">
                                {/* 변수 가이드 */}
                                <div>
                                    <h3 className="text-lg font-semibold text-gray-900 mb-4">변수 가이드</h3>
                                    <div className="flex gap-2 mb-4">
                                        {preset.variables.guide.map((variable, idx) => (
                                            <span
                                                key={idx}
                                                className="px-3 py-1 bg-indigo-50 text-indigo-600 text-sm rounded-full"
                                            >
                                                {variable.name}
                                            </span>
                                        ))}
                                    </div>

                                    <div className="overflow-x-auto">
                                        <table className="w-full border-collapse">
                                            <thead>
                                                <tr className="bg-gray-50">
                                                    <th className="px-4 py-3 text-left text-sm font-semibold text-gray-900 border-b">
                                                        변수
                                                    </th>
                                                    <th className="px-4 py-3 text-left text-sm font-semibold text-gray-900 border-b">
                                                        설명
                                                    </th>
                                                    <th className="px-4 py-3 text-left text-sm font-semibold text-gray-900 border-b">
                                                        예시
                                                    </th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {preset.variables.guide.map((variable, idx) => (
                                                    <tr key={idx} className="border-b border-gray-200">
                                                        <td className="px-4 py-3 text-sm text-indigo-600 font-mono">
                                                            {variable.name}
                                                        </td>
                                                        <td className="px-4 py-3 text-sm text-gray-700">
                                                            <HighlightBold text={variable.description} />
                                                        </td>
                                                        <td className="px-4 py-3 text-sm text-gray-600">
                                                            <HighlightBold text={variable.example} />
                                                        </td>
                                                    </tr>
                                                ))}
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                {/* 예시 입력 */}
                                <div>
                                    <h3 className="text-lg font-semibold text-gray-900 mb-2">예시 입력</h3>
                                    <div className="bg-gray-50 p-4 rounded-lg">
                                        <p className="text-sm text-gray-700 font-mono whitespace-pre-wrap">
                                            <HighlightBold text={preset.variables.exampleInput} />
                                        </p>
                                    </div>
                                </div>

                                {/* 사용법 */}
                                <div className="bg-blue-50 border-l-4 border-blue-400 p-4 rounded-r-lg">
                                    <h3 className="text-lg font-semibold text-blue-900 mb-3">30초 사용법</h3>
                                    <ol className="space-y-2">
                                        {preset.variables.usageSteps.map((step, idx) => (
                                            <li key={idx} className="flex items-start gap-3 text-blue-800 text-sm">
                                                <span className="flex-shrink-0 w-6 h-6 bg-blue-600 text-white rounded-full flex items-center justify-center text-xs font-semibold">
                                                    {idx + 1}
                                                </span>
                                                <span><HighlightBold text={step} /></span>
                                            </li>
                                        ))}
                                    </ol>
                                </div>

                                {/* ChatGPT로 이동 */}
                                <button className="w-full py-3 border-2 border-gray-300 rounded-lg text-gray-700 font-medium hover:bg-gray-50 transition-colors flex items-center justify-center gap-2">
                                    <ExternalLink className="w-4 h-4" />
                                    ChatGPT로 이동
                                </button>
                            </div>
                        )}
                    </div>

                    {/* Footer Actions */}
                    <div className="p-6 border-t border-gray-200 bg-gray-50 flex items-center justify-between relative z-10">
                        <div className="flex items-center gap-3">
                            <span className="text-sm text-gray-600">
                                {preset.isFree ? "무료" : `₩${preset.price.toLocaleString()}`}
                            </span>
                        </div>

                        <div className="flex items-center gap-3">
                            <button
                                onClick={() => setIsBookmarked(!isBookmarked)}
                                className={`p-2 rounded-lg transition-colors ${isBookmarked
                                    ? "bg-red-50 text-red-600"
                                    : "bg-gray-100 text-gray-600 hover:bg-gray-200"
                                    }`}
                            >
                                <Heart className={`w-5 h-5 ${isBookmarked ? "fill-current" : ""}`} />
                            </button>

                            <button
                                onClick={handleToolOpen}
                                className="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 font-medium hover:bg-gray-100 transition-colors flex items-center gap-2"
                            >
                                <ExternalLink className="w-4 h-4" />
                                사용할 툴 열기
                            </button>

                            {/* Payment Integration: Show Buy button if not free */}
                            {!preset.isFree ? (
                                <button
                                    onClick={handleBuy}
                                    className="px-6 py-2 bg-indigo-600 text-white rounded-lg font-medium hover:bg-indigo-700 transition-colors flex items-center gap-2"
                                >
                                    <span>₩{preset.price ? preset.price.toLocaleString() : 0} 구매하기</span>
                                </button>
                            ) : (
                                <button
                                    onClick={handleFooterCopy}
                                    className="px-6 py-2 bg-indigo-600 text-white rounded-lg font-medium hover:bg-indigo-700 transition-colors flex items-center gap-2"
                                >
                                    {copied ? (
                                        <>
                                            <Check className="w-4 h-4" />
                                            복사됨
                                        </>
                                    ) : (
                                        <>
                                            <Copy className="w-4 h-4" />
                                            복사하기
                                        </>
                                    )}
                                </button>
                            )}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default PresetDetailModal;
