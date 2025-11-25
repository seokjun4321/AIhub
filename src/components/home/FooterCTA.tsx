import { Button } from "@/components/ui/button";
import { Sparkles, ArrowRight } from "lucide-react";
import { Link } from "react-router-dom";

const FooterCTA = () => {
    return (
        <section className="py-24 relative overflow-hidden">
            <div className="container mx-auto px-6 relative z-10">
                <div className="max-w-3xl mx-auto text-center">
                    <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-green-100 text-green-700 text-sm font-medium mb-6">
                        <Sparkles className="w-4 h-4" />
                        <span>지금 바로 시작하세요</span>
                    </div>

                    <h2 className="text-4xl font-bold mb-6">
                        AI 활용, 더 이상 어렵지 않습니다
                    </h2>

                    <p className="text-xl text-muted-foreground mb-10">
                        AIHub와 함께라면 누구나 쉽게 AI를 업무와 일상에 활용할 수 있습니다.<br />
                        지금 무료로 시작해보세요.
                    </p>

                    <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
                        <Button size="lg" className="bg-green-600 hover:bg-green-700 text-white px-8 h-12 text-base w-full sm:w-auto" asChild>
                            <Link to="/auth?tab=signup" className="flex items-center gap-2">
                                무료로 시작하기
                                <ArrowRight className="w-4 h-4" />
                            </Link>
                        </Button>
                        <Button size="lg" variant="outline" className="px-8 h-12 text-base w-full sm:w-auto" asChild>
                            <Link to="/about">자세히 알아보기</Link>
                        </Button>
                    </div>

                    <p className="mt-6 text-sm text-muted-foreground">
                        신용카드 등록 불필요 • 언제든지 무료로 시작
                    </p>
                </div>
            </div>

            {/* Background Gradients */}
            <div className="absolute top-0 left-0 w-full h-full overflow-hidden -z-10 pointer-events-none">
                <div className="absolute bottom-0 left-1/2 -translate-x-1/2 w-[1000px] h-[400px] bg-gradient-to-t from-green-50 to-transparent opacity-50" />
            </div>
        </section>
    );
};

export default FooterCTA;
