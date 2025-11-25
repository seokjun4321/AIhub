import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Sparkles, Send } from "lucide-react";

const Hero = () => {
    return (
        <section className="relative pt-32 pb-20 overflow-hidden">
            <div className="container mx-auto px-6 relative z-10">
                <div className="flex flex-col items-center text-center max-w-4xl mx-auto">
                    <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-primary/5 text-primary text-sm font-medium mb-8 animate-fade-in">
                        <Sparkles className="w-4 h-4" />
                        <span>AI 기반 추천 시스템</span>
                    </div>

                    <h1 className="text-4xl md:text-6xl font-bold tracking-tight mb-6 bg-gradient-to-r from-gray-900 to-gray-600 bg-clip-text text-transparent animate-fade-in [animation-delay:200ms]">
                        문제만 말하면, AIHub가<br />
                        해결책을 찾아드려요.
                    </h1>

                    <p className="text-xl text-muted-foreground mb-12 max-w-2xl animate-fade-in [animation-delay:400ms]">
                        AI 도구, 가이드북, 워크플로우까지 자동 추천.
                    </p>

                    <div className="w-full max-w-2xl relative mb-8 animate-fade-in [animation-delay:600ms]">
                        <div className="relative flex items-center">
                            <div className="absolute left-4 p-1.5 bg-blue-600 rounded-lg">
                                <Sparkles className="w-4 h-4 text-white" />
                            </div>
                            <Input
                                type="text"
                                placeholder="예: 코딩 테스트 준비 중인데 추천해 줄 수 있어?"
                                className="w-full h-16 pl-16 pr-14 text-lg rounded-2xl border-2 border-border/50 shadow-lg focus-visible:ring-primary/20 transition-all"
                            />
                            <Button
                                size="icon"
                                className="absolute right-3 w-10 h-10 rounded-xl bg-blue-600 hover:bg-blue-700 text-white shadow-md transition-all hover:scale-105"
                            >
                                <Send className="w-5 h-5" />
                            </Button>
                        </div>
                        <div className="absolute -bottom-6 left-0 w-full text-xs text-muted-foreground text-left pl-4 opacity-70">
                            Enter를 눌러 메시지 전송 | Shift + Enter로 줄바꿈
                        </div>
                    </div>

                    <div className="flex flex-wrap justify-center gap-3 animate-fade-in [animation-delay:800ms] mt-4">
                        {["이미지 생성 AI 추천", "블로그 글 작성 가이드", "마케팅 자동화"].map((tag) => (
                            <Button
                                key={tag}
                                variant="outline"
                                size="sm"
                                className="rounded-full bg-background/50 hover:bg-background hover:border-primary/30 transition-all"
                            >
                                {tag}
                            </Button>
                        ))}
                    </div>
                </div>
            </div>

            {/* Background Elements */}
            <div className="absolute top-0 left-0 w-full h-full overflow-hidden -z-10 pointer-events-none">
                <div className="absolute top-1/4 left-1/4 w-96 h-96 bg-primary/5 rounded-full blur-3xl opacity-50 mix-blend-multiply animate-blob" />
                <div className="absolute top-1/3 right-1/4 w-96 h-96 bg-blue-500/5 rounded-full blur-3xl opacity-50 mix-blend-multiply animate-blob [animation-delay:2s]" />
                <div className="absolute bottom-1/4 left-1/2 w-96 h-96 bg-blue-600/5 rounded-full blur-3xl opacity-50 mix-blend-multiply animate-blob [animation-delay:4s]" />
            </div>
        </section>
    );
};

export default Hero;
