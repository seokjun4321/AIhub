import { TemplateItem } from "@/data/mockData";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogFooter } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { ChevronLeft, ChevronRight, Check } from "lucide-react";
import { useState } from "react";
import { cn } from "@/lib/utils";
import { ScrollArea } from "@/components/ui/scroll-area";

interface TemplateModalProps {
    item: TemplateItem;
    isOpen: boolean;
    onClose: () => void;
}

const TemplateModal = ({ item, isOpen, onClose }: TemplateModalProps) => {
    const [currentImageIndex, setCurrentImageIndex] = useState(0);

    const nextImage = () => {
        setCurrentImageIndex((prev) => (prev + 1) % item.previewImages.length);
    };

    const prevImage = () => {
        setCurrentImageIndex((prev) => (prev - 1 + item.previewImages.length) % item.previewImages.length);
    };

    return (
        <Dialog open={isOpen} onOpenChange={onClose}>
            <DialogContent className="max-w-5xl h-[85vh] p-0 flex flex-col gap-0 overflow-hidden">
                {/* Header */}
                <div className="p-6 border-b border-border bg-card">
                    <div className="flex items-center gap-3 mb-2">
                        <Badge variant="outline" className="border-primary/50 text-primary">
                            {item.category}
                        </Badge>
                        <Badge variant={item.price === 0 ? "secondary" : "default"} className={item.price === 0 ? "bg-emerald-100 text-emerald-800" : ""}>
                            {item.price === 0 ? "무료" : `₩${item.price.toLocaleString()}`}
                        </Badge>
                        <DialogTitle className="text-2xl font-bold">{item.title}</DialogTitle>
                    </div>
                    <DialogDescription className="text-base text-foreground/80">
                        {item.oneLiner}
                    </DialogDescription>
                </div>

                <div className="flex flex-1 overflow-hidden">
                    <div className="grid grid-cols-5 h-full w-full">
                        {/* Left: Image Carousel */}
                        <div className="col-span-3 bg-black/5 relative group h-full flex items-center justify-center p-8">
                            <img
                                src={item.previewImages[currentImageIndex]}
                                alt={`Preview ${currentImageIndex + 1}`}
                                className="max-w-full max-h-full object-contain rounded-lg shadow-lg"
                            />

                            {item.previewImages.length > 1 && (
                                <>
                                    <Button
                                        variant="secondary"
                                        size="icon"
                                        className="absolute left-4 top-1/2 -translate-y-1/2 opacity-0 group-hover:opacity-100 transition-opacity"
                                        onClick={prevImage}
                                    >
                                        <ChevronLeft className="w-4 h-4" />
                                    </Button>
                                    <Button
                                        variant="secondary"
                                        size="icon"
                                        className="absolute right-4 top-1/2 -translate-y-1/2 opacity-0 group-hover:opacity-100 transition-opacity"
                                        onClick={nextImage}
                                    >
                                        <ChevronRight className="w-4 h-4" />
                                    </Button>

                                    <div className="absolute bottom-4 left-1/2 -translate-x-1/2 flex gap-1.5">
                                        {item.previewImages.map((_, idx) => (
                                            <div
                                                key={idx}
                                                className={cn(
                                                    "w-2 h-2 rounded-full transition-colors",
                                                    idx === currentImageIndex ? "bg-primary" : "bg-primary/20"
                                                )}
                                            />
                                        ))}
                                    </div>
                                </>
                            )}
                        </div>

                        {/* Right: Details */}
                        <div className="col-span-2 bg-card border-l border-border flex flex-col h-full">
                            <ScrollArea className="flex-1 p-6">
                                <div className="space-y-8">
                                    <div>
                                        <h3 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider mb-3">Includes</h3>
                                        <div className="grid grid-cols-1 gap-2">
                                            {item.includes.map((inc, idx) => (
                                                <div key={idx} className="flex items-center gap-2 p-2 bg-muted/20 rounded border border-border">
                                                    <Check className="w-4 h-4 text-green-600" />
                                                    <span className="text-sm">{inc}</span>
                                                </div>
                                            ))}
                                        </div>
                                    </div>

                                    <div>
                                        <h3 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider mb-3">Quick Setup</h3>
                                        {item.price > 0 ? (
                                            <div className="bg-slate-50 p-4 rounded-lg border border-slate-100 text-center">
                                                <p className="text-sm text-slate-500">
                                                    구매 후 설정 가이드를 확인하실 수 있습니다.
                                                </p>
                                            </div>
                                        ) : (
                                            <div className="space-y-4">
                                                {item.setupSteps.map((step, idx) => (
                                                    <div key={idx} className="flex gap-3">
                                                        <div className="w-6 h-6 rounded-full bg-primary/10 text-primary flex items-center justify-center shrink-0 font-bold text-xs">
                                                            {idx + 1}
                                                        </div>
                                                        <p className="text-sm leading-relaxed text-muted-foreground">{step}</p>
                                                    </div>
                                                ))}
                                            </div>
                                        )}
                                    </div>

                                    <div>
                                        <h3 className="text-sm font-semibold text-muted-foreground uppercase tracking-wider mb-2">Tags</h3>
                                        <div className="flex flex-wrap gap-1.5">
                                            {item.tags.map((tag, i) => (
                                                <span key={i} className="px-2 py-0.5 bg-secondary text-secondary-foreground text-xs rounded-sm">
                                                    #{tag}
                                                </span>
                                            ))}
                                        </div>
                                    </div>
                                </div>
                            </ScrollArea>

                            <div className="p-4 border-t border-border space-y-2">
                                {item.price > 0 ? (
                                    <Button className="w-full bg-blue-600 hover:bg-blue-700" size="lg">
                                        구매하기 ({item.price.toLocaleString()}원)
                                    </Button>
                                ) : (
                                    <>
                                        <Button className="w-full" size="lg" onClick={() => window.open(item.duplicateUrl, '_blank')}>
                                            사용하기 (Duplicate)
                                        </Button>
                                        <Button variant="outline" className="w-full" onClick={() => window.open(item.previewUrl, '_blank')}>
                                            웹에서 미리보기
                                        </Button>
                                    </>
                                )}
                            </div>
                        </div>
                    </div>
                </div>
            </DialogContent>
        </Dialog>
    );
};

export default TemplateModal;
