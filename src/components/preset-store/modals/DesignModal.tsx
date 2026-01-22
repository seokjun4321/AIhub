import { DesignItem } from "@/data/mockData";
import { Dialog, DialogContent, DialogTitle } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Copy, Check, Lightbulb, X, Wand2 } from "lucide-react";
import { useState, useRef, useEffect } from "react";
import { cn } from "@/lib/utils";
import { ScrollArea } from "@/components/ui/scroll-area";
import * as VisuallyHidden from "@radix-ui/react-visually-hidden";

interface DesignModalProps {
    item: DesignItem;
    isOpen: boolean;
    onClose: () => void;
}

const DesignModal = ({ item, isOpen, onClose }: DesignModalProps) => {
    const [sliderPosition, setSliderPosition] = useState(50);
    const [isDragging, setIsDragging] = useState(false);
    const containerRef = useRef<HTMLDivElement>(null);
    const dragStartPos = useRef<number>(0);
    const [isLightboxOpen, setIsLightboxOpen] = useState(false);
    const [lightboxSrc, setLightboxSrc] = useState<string | null>(null);

    const [copiedPrompt, setCopiedPrompt] = useState(false);
    const [copiedParams, setCopiedParams] = useState<string | null>(null);

    const handleMove = (clientX: number) => {
        if (!containerRef.current) return;
        const rect = containerRef.current.getBoundingClientRect();
        const x = Math.max(0, Math.min(clientX - rect.left, rect.width));
        setSliderPosition((x / rect.width) * 100);
    };

    const onMouseDown = (e: React.MouseEvent) => {
        dragStartPos.current = e.clientX;
        if (item.afterImage) {
            setIsDragging(true);
        }
    };

    const onContainerMouseUp = (e: React.MouseEvent) => {
        // Handle local drag stop immediately
        if (isDragging) setIsDragging(false);

        // Detect Click (vs Drag) - threshold of 5px
        const delta = Math.abs(e.clientX - dragStartPos.current);
        if (delta < 5) {
            if (!containerRef.current) return;

            // Single Image Case
            if (!item.afterImage) {
                setLightboxSrc(item.beforeImage);
                setIsLightboxOpen(true);
                return;
            }

            // Comparison Case - Split Click
            const rect = containerRef.current.getBoundingClientRect();
            const clickX = e.clientX - rect.left;
            const clickPercent = (clickX / rect.width) * 100;

            // Updated Logic: Left side is now BeforeImage (Original), Right side is AfterImage (Generated)
            if (clickPercent < sliderPosition) {
                setLightboxSrc(item.beforeImage);
            } else {
                setLightboxSrc(item.afterImage);
            }
            setIsLightboxOpen(true);
        }
    };

    // Global mouse event handling
    useEffect(() => {
        const handleGlobalMouseMove = (e: MouseEvent) => {
            if (isDragging) handleMove(e.clientX);
        };
        const handleGlobalMouseUp = () => setIsDragging(false);

        if (isDragging) {
            window.addEventListener('mousemove', handleGlobalMouseMove);
            window.addEventListener('mouseup', handleGlobalMouseUp);
        }
        return () => {
            window.removeEventListener('mousemove', handleGlobalMouseMove);
            window.removeEventListener('mouseup', handleGlobalMouseUp);
        };
    }, [isDragging]);

    const handleCopyPrompt = () => {
        navigator.clipboard.writeText(item.promptText);
        setCopiedPrompt(true);
        setTimeout(() => setCopiedPrompt(false), 2000);
    };

    const handleCopyParam = (key: string, value: string) => {
        navigator.clipboard.writeText(value);
        setCopiedParams(key);
        setTimeout(() => setCopiedParams(null), 2000);
    };

    return (
        <Dialog open={isOpen} onOpenChange={onClose}>
            <DialogContent className="max-w-5xl h-[750px] max-h-[90vh] p-0 flex flex-col gap-0 overflow-hidden bg-white rounded-xl shadow-2xl border-0">
                <VisuallyHidden.Root>
                    <DialogTitle>{item.title}</DialogTitle>
                </VisuallyHidden.Root>

                {/* Header Section */}
                <div className="px-8 py-6 border-b border-slate-100 flex items-start justify-between bg-white shrink-0 z-10">
                    <div>
                        <div className="flex gap-2 mb-3">
                            {item.tags.map((tag, i) => (
                                <Badge key={i} variant="secondary" className="bg-slate-100 text-slate-600 hover:bg-slate-200 px-3 py-1 font-normal text-xs rounded-full">
                                    {tag}
                                </Badge>
                            ))}
                        </div>
                        <h2 className="text-2xl font-bold text-slate-900 mb-1 tracking-tight">{item.title}</h2>
                        <p className="text-slate-500 font-medium">{item.oneLiner}</p>
                    </div>
                    <Button variant="ghost" size="icon" onClick={onClose} className="rounded-full hover:bg-slate-100 text-slate-400">
                        <X className="w-5 h-5" />
                    </Button>
                </div>

                {/* Main Content Body (Split Layout) */}
                <div className="flex flex-1 overflow-hidden">
                    {/* Left: Image Comparison Slider (Padded Container) */}
                    <div className="w-[55%] h-full bg-slate-50 p-8 flex items-center justify-center">
                        <div
                            className={cn(
                                "relative w-full h-full max-h-[480px] rounded-2xl overflow-hidden shadow-sm border border-slate-200/60 bg-white cursor-zoom-in",
                                item.afterImage ? "select-none group" : ""
                            )}
                            ref={containerRef}
                            onMouseDown={onMouseDown}
                            onMouseUp={onContainerMouseUp}
                        >
                            {/* Background Image: If Comparison, show After (Right Side), else Before (Full) */}
                            <img
                                src={item.afterImage ? item.afterImage : item.beforeImage}
                                alt="Main"
                                className="absolute top-0 left-0 w-full h-full object-cover pointer-events-none"
                            />

                            {/* Comparison Slider Logic (Only if afterImage exists) */}
                            {item.afterImage && (
                                <>
                                    {/* Overlay Image (Before/Original) - Clipped Left Side */}
                                    <div
                                        className="absolute top-0 left-0 w-full h-full overflow-hidden pointer-events-none"
                                        style={{ clipPath: `inset(0 ${100 - sliderPosition}% 0 0)` }}
                                    >
                                        <img src={item.beforeImage} alt="Original" className="absolute top-0 left-0 w-full h-full object-cover" />
                                    </div>

                                    {/* Labels */}
                                    <div className="absolute top-4 left-4 text-white/90 text-xs font-bold drop-shadow-md select-none bg-black/20 backdrop-blur-[2px] px-2.5 py-1 rounded pointer-events-none">Original</div>
                                    <div className="absolute top-4 right-4 text-white/90 text-xs font-bold drop-shadow-md select-none bg-black/20 backdrop-blur-[2px] px-2.5 py-1 rounded pointer-events-none">Generated</div>

                                    {/* Draggable Handle Line */}
                                    <div
                                        className="absolute inset-y-0 w-[1.5px] bg-white hover:shadow-[0_0_15px_rgba(255,255,255,0.8)] z-20 group cursor-ew-resize"
                                        style={{ left: `${sliderPosition}%` }}
                                    >
                                        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-9 h-9 bg-white rounded-full shadow-lg flex items-center justify-center transition-transform hover:scale-110">
                                            <div className="flex gap-[3px]">
                                                <div className="w-[2px] h-3.5 bg-slate-300 rounded-full" />
                                                <div className="w-[2px] h-3.5 bg-slate-300 rounded-full" />
                                            </div>
                                        </div>
                                    </div>

                                    <div className="absolute bottom-5 left-1/2 -translate-x-1/2 text-white/90 text-xs font-medium bg-black/40 px-3 py-1.5 rounded-full backdrop-blur-sm opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none">
                                        드래그하여 비교 / 클릭하여 확대
                                    </div>
                                </>
                            )}
                        </div>
                    </div>

                    {/* Right: Details & Actions */}
                    <div className="w-[45%] flex flex-col bg-white border-l border-slate-100">
                        <ScrollArea className="flex-1">
                            <div className="p-8 space-y-8">
                                {/* Prompt Section */}
                                <div className="space-y-3">
                                    <div className="flex items-center justify-between">
                                        <h3 className="font-bold text-slate-800 flex items-center gap-2 text-sm">
                                            프롬프트
                                        </h3>
                                        {!item.price && (
                                            <Button
                                                variant="ghost"
                                                size="sm"
                                                className="h-7 w-7 p-0 hover:bg-slate-100 text-slate-400 hover:text-slate-600"
                                                onClick={handleCopyPrompt}
                                            >
                                                {copiedPrompt ? <Check className="w-3.5 h-3.5 text-green-600" /> : <Copy className="w-3.5 h-3.5" />}
                                            </Button>
                                        )}
                                    </div>
                                    {item.price > 0 ? (
                                        <div className="bg-slate-50 border border-slate-100 rounded-xl p-8 flex flex-col items-center justify-center text-center text-slate-500">
                                            <div className="bg-slate-200 p-2 rounded-full mb-3 text-slate-600">
                                                <Wand2 className="w-5 h-5" />
                                            </div>
                                            <p className="font-medium text-slate-900 mb-1">프롬프트가 잠겨있습니다</p>
                                            <p className="text-xs mb-4">구매 후 전체 프롬프트를 확인하세요.</p>
                                            <Button size="sm" className="bg-blue-600 hover:bg-blue-700 w-full max-w-[120px]">
                                                구매하기
                                            </Button>
                                        </div>
                                    ) : (
                                        <div className="bg-slate-50 border border-slate-100 rounded-xl p-5 text-[13px] leading-relaxed text-slate-600 font-mono relative transition-colors hover:border-slate-200">
                                            {item.promptText}
                                        </div>
                                    )}
                                </div>

                                {/* Parameters Section */}
                                <div className="space-y-3">
                                    <h3 className="font-bold text-slate-800 flex items-center gap-2 text-sm">
                                        <Wand2 className="w-3.5 h-3.5" />
                                        파라미터
                                    </h3>
                                    {item.price > 0 ? (
                                        <div className="bg-slate-50 border border-slate-100 rounded-xl p-6 text-center text-sm text-slate-500">
                                            구매 후 파라미터 설정을 볼 수 있습니다.
                                        </div>
                                    ) : (
                                        <div className="bg-slate-50 border border-slate-100 rounded-xl overflow-hidden">
                                            {item.params.map((param, idx) => (
                                                <div key={idx} className={cn(
                                                    "flex items-start justify-between p-4 group hover:bg-slate-100/50 transition-colors",
                                                    idx !== item.params.length - 1 && "border-b border-slate-100/60"
                                                )}>
                                                    <div className="flex gap-4 items-start flex-1 min-w-0">
                                                        <span className="text-xs font-medium text-slate-500 w-24 shrink-0 pt-0.5">{param.key}</span>
                                                        <span className="text-xs font-medium text-slate-900 font-mono break-words whitespace-pre-wrap">{param.value}</span>
                                                    </div>
                                                    <Button
                                                        variant="ghost"
                                                        size="icon"
                                                        className="h-6 w-6 opacity-0 group-hover:opacity-100 transition-opacity text-slate-400 hover:text-slate-600 shrink-0"
                                                        onClick={() => handleCopyParam(param.key, param.value)}
                                                    >
                                                        {copiedParams === param.key ?
                                                            <Check className="w-3 h-3 text-green-600" /> :
                                                            <Copy className="w-3 h-3" />
                                                        }
                                                    </Button>
                                                </div>
                                            ))}
                                        </div>
                                    )}
                                </div>

                                {/* Padding for bottom scroll */}
                                <div className="h-4" />
                            </div>
                        </ScrollArea>

                        {/* Floating Copy Button Area (Bottom of Right Col) */}
                        <div className="p-6 border-t border-slate-100 bg-white">
                            {item.price > 0 ? (
                                <Button
                                    size="lg"
                                    className="w-full bg-blue-600 hover:bg-blue-700 text-white rounded-xl h-12 text-sm font-semibold shadow-lg shadow-blue-200 transition-all hover:shadow-xl hover:-translate-y-0.5"
                                >
                                    구매하기 ({item.price.toLocaleString()}원)
                                </Button>
                            ) : (
                                <Button
                                    size="lg"
                                    className="w-full bg-[#1e293b] hover:bg-[#0f172a] text-white rounded-xl h-12 text-sm font-semibold shadow-lg shadow-slate-200 transition-all hover:shadow-xl hover:-translate-y-0.5"
                                    onClick={handleCopyPrompt}
                                >
                                    {copiedPrompt ? (
                                        <>
                                            <Check className="w-4 h-4 mr-2" /> 복사되었습니다
                                        </>
                                    ) : (
                                        <>
                                            <Copy className="w-4 h-4 mr-2" /> 프롬프트 복사
                                        </>
                                    )}
                                </Button>
                            )}
                        </div>
                    </div>
                </div>

                {/* Footer: Tips - Full Width */}
                <div className="bg-slate-50 border-t border-slate-100 shrink-0 px-8 py-5">
                    <div className="flex flex-col gap-3">
                        <h4 className="flex items-center gap-2 text-amber-600 font-bold text-sm">
                            <Lightbulb className="w-4 h-4 fill-amber-100" />
                            이 프리셋이 잘 먹는 입력 사진
                        </h4>
                        <ul className="grid grid-cols-1 gap-1 text-slate-600 text-sm pl-1">
                            {item.inputTips.map((tip, idx) => (
                                <li key={idx} className="flex items-center gap-2.5">
                                    <span className="w-1.5 h-1.5 rounded-full bg-slate-300 shrink-0" />
                                    {tip}
                                </li>
                            ))}
                        </ul>
                    </div>
                </div>

                {/* Lightbox Overlay */}
                {isLightboxOpen && lightboxSrc && (
                    <div
                        className="fixed inset-0 z-50 bg-black/95 flex items-center justify-center p-8 transition-opacity duration-300 animate-in fade-in"
                        onClick={() => setIsLightboxOpen(false)}
                    >
                        <button
                            className="absolute top-6 right-6 p-2 rounded-full bg-black/50 text-white/70 hover:text-white hover:bg-white/20 transition-all"
                            onClick={() => setIsLightboxOpen(false)}
                        >
                            <X className="w-8 h-8" />
                        </button>
                        <img
                            src={lightboxSrc}
                            alt="Full view"
                            className="max-w-full max-h-full object-contain shadow-2xl rounded-sm"
                            onClick={(e) => e.stopPropagation()}
                        />
                    </div>
                )}
            </DialogContent>
        </Dialog>
    );
};

export default DesignModal;
