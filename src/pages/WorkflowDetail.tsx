import { useNavigate, useParams } from "react-router-dom";
import { MOCK_WORKFLOWS } from "@/data/mockData";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { ArrowLeft, Clock, Activity, Download, AlertTriangle, CheckCircle2, Lock } from "lucide-react";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";

const WorkflowDetail = () => {
    const { id } = useParams();
    const navigate = useNavigate();
    const item = MOCK_WORKFLOWS.find(w => w.id === id);

    if (!item) {
        return <div className="min-h-screen flex items-center justify-center">워크플로우를 찾을 수 없습니다.</div>;
    }

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
                                        {item.complexity} Complexity
                                    </Badge>
                                    <div className="flex items-center text-sm text-muted-foreground">
                                        <Clock className="w-3.5 h-3.5 mr-1" />
                                        {item.duration}
                                    </div>
                                </div>
                                <h1 className="text-3xl md:text-4xl font-bold mb-3 text-foreground">{item.title}</h1>
                                <p className="text-xl text-muted-foreground">{item.oneLiner}</p>
                            </div>

                            <Button size="lg" className="rounded-full px-8">
                                <Download className="w-4 h-4 mr-2" />
                                워크플로우 다운로드
                            </Button>
                        </div>
                    </div>
                </div>

                <div className="max-w-7xl mx-auto px-4 py-12">
                    <div className="grid grid-cols-1 lg:grid-cols-3 gap-12">
                        {/* Main Content */}
                        <div className="lg:col-span-2 space-y-12">
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
                                <div className="space-y-6 relative before:absolute before:left-4 before:top-4 before:h-full before:w-0.5 before:bg-border/50">
                                    {item.steps.map((step, idx) => (
                                        <div key={idx} className="relative pl-12">
                                            <div className="absolute left-0 top-0 w-8 h-8 rounded-full bg-background border-2 border-primary text-primary flex items-center justify-center font-bold z-10">
                                                {idx + 1}
                                            </div>
                                            <div className="bg-card border border-border rounded-xl p-6 shadow-sm">
                                                <h3 className="text-lg font-bold mb-2">{step.title}</h3>
                                                <p className="text-muted-foreground leading-relaxed">{step.description}</p>
                                            </div>
                                        </div>
                                    ))}
                                </div>
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

                            {/* Credentials */}
                            <div className="bg-card border border-border rounded-xl p-6 shadow-sm">
                                <h3 className="font-bold mb-4 flex items-center gap-2">
                                    <Lock className="w-4 h-4 text-muted-foreground" />
                                    필요한 권한/계정
                                </h3>
                                <ul className="space-y-3">
                                    {item.credentials.map((cred, idx) => (
                                        <li key={idx} className="flex items-start gap-2 text-sm text-muted-foreground">
                                            <CheckCircle2 className="w-4 h-4 text-green-600 mt-0.5 shrink-0" />
                                            {cred}
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
            </main>

            <Footer />
        </div>
    );
};

export default WorkflowDetail;
