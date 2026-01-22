import { useNavigate, useParams } from "react-router-dom";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import { WorkflowItem } from "@/data/mockData";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { ArrowLeft, Clock, Activity, Download, AlertTriangle, CheckCircle2, Lock } from "lucide-react";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";

const WorkflowDetail = () => {
    const { id } = useParams();
    const navigate = useNavigate();

    const { data: item, isLoading } = useQuery({
        queryKey: ['workflow', id],
        queryFn: async () => {
            const { data, error } = await supabase
                .from('preset_workflows' as any)
                .select('*')
                .eq('id', id)
                .single();

            if (error) throw error;

            const workflowData = data as any;

            return {
                id: workflowData.id,
                title: workflowData.title,
                author: workflowData.author,
                description: workflowData.description,
                complexity: workflowData.complexity,
                duration: workflowData.duration,
                apps: workflowData.apps,
                oneLiner: workflowData.one_liner,
                diagramUrl: workflowData.diagram_url,
                download_url: workflowData.download_url,
                steps: workflowData.steps,
                requirements: workflowData.requirements,
                credentials: undefined, // Removed from schema
                warnings: workflowData.warnings,
                platform: workflowData.platform,
                importInfo: workflowData.import_info,
                price: workflowData.price || 0
            } as WorkflowItem;
        }
    });

    if (isLoading) {
        return <div className="min-h-screen flex items-center justify-center">로딩 중...</div>;
    }

    if (!item) {
        return <div className="min-h-screen flex items-center justify-center">워크플로우를 찾을 수 없습니다.</div>;
    }

    const handleDownload = () => {
        if (item.download_url && item.download_url !== '#') {
            window.open(item.download_url, '_blank');
        } else {
            alert("다운로드 링크가 준비되지 않았습니다.");
        }
    };

    return (
        <div className="min-h-screen bg-background font-sans">
            <Navbar />

            <main className="pt-24 pb-20">
                {/* Header */}
                <div className="border-b border-border bg-card">
                    <div className="max-w-7xl mx-auto px-4 py-8">
                        <Button variant="ghost" className="mb-6 pl-0 hover:pl-0 hover:bg-transparent text-muted-foreground hover:text-foreground" onClick={() => navigate(-1)}>
                            <ArrowLeft className="w-4 h-4 mr-2" />
                            목록으로 돌아가기
                        </Button>

                        <div className="flex flex-col md:flex-row md:items-start justify-between gap-6">
                            <div>
                                <div className="flex items-center gap-3 mb-3">
                                    <Badge variant={item.complexity === "Simple" ? "secondary" : item.complexity === "Medium" ? "default" : "destructive"}>
                                        {item.complexity === "Simple" ? "초급" : item.complexity === "Medium" ? "중급" : item.complexity === "Complex" ? "고급" : item.complexity}
                                    </Badge>
                                    {item.platform && (
                                        <Badge variant="outline" className="border-primary/20 bg-primary/5 text-primary">
                                            {item.platform}
                                        </Badge>
                                    )}
                                    <div className="flex items-center text-sm text-muted-foreground">
                                        <Clock className="w-3.5 h-3.5 mr-1" />
                                        {item.duration}
                                    </div>
                                    {item.price > 0 && (
                                        <Badge className="bg-blue-100 text-blue-700 hover:bg-blue-200">
                                            {item.price.toLocaleString()}원
                                        </Badge>
                                    )}
                                </div>
                                <h1 className="text-3xl md:text-4xl font-bold mb-3 text-foreground">{item.title}</h1>
                                <p className="text-xl text-muted-foreground">{item.oneLiner}</p>
                            </div>

                            {item.price > 0 ? (
                                <Button size="lg" className="rounded-full px-8 bg-blue-600 hover:bg-blue-700 mt-4 md:mt-0">
                                    구매하기 ({item.price.toLocaleString()}원)
                                </Button>
                            ) : (
                                <Button size="lg" className="rounded-full px-8" onClick={handleDownload}>
                                    <Download className="w-4 h-4 mr-2" />
                                    워크플로우 다운로드
                                </Button>
                            )}
                        </div>
                    </div>
                </div>

                <div className="max-w-7xl mx-auto px-4 py-12">
                    <div className="grid grid-cols-1 lg:grid-cols-3 gap-12">
                        {/* Main Content */}
                        <div className="lg:col-span-2 space-y-12">
                            {/* Overview Section */}
                            <section>
                                <h2 className="text-2xl font-bold mb-6">개요</h2>
                                <ReactMarkdown
                                    remarkPlugins={[remarkGfm]}
                                    components={{
                                        p: ({ node, ...props }) => <p className="mb-4 text-muted-foreground leading-relaxed transition-colors" {...props} />,
                                        ul: ({ node, ...props }) => <ul className="grid gap-4 mb-6 list-none pl-0" {...props} />,
                                        li: ({ node, ...props }) => (
                                            <li className="bg-card border border-border/60 rounded-xl p-5 shadow-sm hover:shadow-md transition-all duration-200" {...props} />
                                        ),
                                        strong: ({ node, ...props }) => {
                                            const text = String(props.children);
                                            const isProblem = text.includes('문제');
                                            const isSolution = text.includes('해결책');

                                            if (isProblem) {
                                                return <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-rose-100 text-rose-700 mr-2">{props.children}</span>
                                            }
                                            if (isSolution) {
                                                return <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-emerald-100 text-emerald-700 mr-2">{props.children}</span>
                                            }
                                            return <span className="font-bold text-foreground mr-1">{props.children}</span>
                                        }
                                    }}
                                >
                                    {item.description}
                                </ReactMarkdown>
                            </section>

                            {/* Diagram Section */}
                            <section>
                                <h2 className="text-2xl font-bold mb-6">워크플로우 다이어그램</h2>
                                <div className="rounded-2xl border border-border overflow-hidden bg-white shadow-sm">
                                    <img src={item.diagramUrl} alt="Workflow Diagram" className="w-full h-auto object-cover" />
                                </div>
                            </section>

                            {/* Steps Section */}
                            <section>
                                <h2 className="text-2xl font-bold mb-6 flex items-center gap-2">
                                    <Activity className="w-6 h-6 text-primary" />
                                    작동 원리
                                </h2>
                                {item.price > 0 ? (
                                    <div className="bg-slate-50 border border-slate-200 rounded-xl p-8 text-center text-slate-500">
                                        <div className="mb-3 p-2 bg-slate-200 inline-block rounded-full text-slate-600">
                                            <Lock className="w-6 h-6" />
                                        </div>
                                        <p className="font-medium text-slate-900 mb-1">상세 단계가 잠겨있습니다</p>
                                        <p className="text-xs">구매 후 전체 작동 원리를 확인하세요.</p>
                                    </div>
                                ) : (
                                    <div className="space-y-4 relative before:absolute before:left-3.5 before:top-2 before:h-full before:w-0.5 before:bg-border/50">
                                        {item.steps.map((step, idx) => (
                                            <div key={idx} className="relative pl-10">
                                                <div className="absolute left-0 top-0 w-7 h-7 rounded-full bg-background border-2 border-primary text-primary flex items-center justify-center font-bold text-sm z-10">
                                                    {idx + 1}
                                                </div>
                                                <div className="bg-card border border-border rounded-lg p-4 shadow-sm hover:border-primary/50 transition-colors">
                                                    <h3 className="font-semibold text-base mb-1">{step.title}</h3>
                                                    <p className="text-sm text-muted-foreground leading-relaxed">{step.description}</p>
                                                </div>
                                            </div>
                                        ))}
                                    </div>
                                )}
                            </section>
                        </div>

                        {/* Sidebar */}
                        <div className="space-y-8">
                            {/* Required Apps */}
                            <div className="bg-card border border-border rounded-xl p-6 shadow-sm">
                                <h3 className="font-bold mb-4">연동되는 앱</h3>
                                <div className="space-y-3">
                                    {item.apps.map((app, idx) => (
                                        <div key={idx} className="flex items-center gap-3 p-3 bg-muted/30 rounded-lg">
                                            <div className="w-10 h-10 bg-white rounded-lg border border-border shadow-sm flex items-center justify-center font-bold text-xs text-muted-foreground">
                                                APP
                                            </div>
                                            <span className="font-semibold">{app.name}</span>
                                        </div>
                                    ))}
                                </div>
                            </div>



                            {/* Import Method */}
                            {item.importInfo && (
                                <div className="bg-card border border-border rounded-xl p-6 shadow-sm">
                                    <h3 className="font-bold mb-4 flex items-center gap-2">
                                        <Download className="w-4 h-4 text-muted-foreground" />
                                        가져오는 방법
                                    </h3>
                                    {item.price > 0 ? (
                                        <div className="text-sm text-slate-500 text-center py-4 bg-slate-50 rounded-lg">
                                            구매 후 확인 가능합니다.
                                        </div>
                                    ) : (
                                        <div className="text-sm text-muted-foreground leading-relaxed prose prose-sm max-w-none prose-a:text-primary prose-a:underline hover:prose-a:text-primary/80">
                                            <ReactMarkdown remarkPlugins={[remarkGfm]}>
                                                {item.importInfo}
                                            </ReactMarkdown>
                                        </div>
                                    )}
                                </div>
                            )}

                            {/* Requirements */}
                            <div className="bg-card border border-border rounded-xl p-6 shadow-sm">
                                <h3 className="font-bold mb-4 flex items-center gap-2">
                                    <Lock className="w-4 h-4 text-muted-foreground" />
                                    필요한 권한/계정
                                </h3>
                                <ul className="space-y-3">
                                    {item.requirements.map((req, idx) => (
                                        <li key={idx} className="flex items-start gap-2 text-sm text-muted-foreground">
                                            <CheckCircle2 className="w-4 h-4 text-green-600 mt-0.5 shrink-0" />
                                            {req}
                                        </li>
                                    ))}
                                </ul>
                            </div>

                            {/* Warnings */}
                            {item.warnings && item.warnings.length > 0 && (
                                <div className="bg-amber-50 border border-amber-100 rounded-xl p-6">
                                    <h3 className="font-bold text-amber-900 mb-4 flex items-center gap-2">
                                        <AlertTriangle className="w-4 h-4" />
                                        주의사항
                                    </h3>
                                    <ul className="space-y-2">
                                        {item.warnings.map((warn, idx) => (
                                            <li key={idx} className="text-sm text-amber-800 list-disc list-inside">
                                                {warn}
                                            </li>
                                        ))}
                                    </ul>
                                </div>
                            )}
                        </div>
                    </div>
                </div>
            </main >

            <Footer />
        </div >
    );
};

export default WorkflowDetail;
