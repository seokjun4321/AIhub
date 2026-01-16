import { useNavigate } from "react-router-dom";
import Navbar from "@/components/ui/navbar";
import { Card, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { FileText, MessageSquare, Shield, Inbox } from "lucide-react";

const AdminHub = () => {
    const navigate = useNavigate();

    return (
        <div className="min-h-screen bg-muted/40 pb-20">
            <Navbar />
            <div className="container mx-auto py-10 px-6">
                <div className="flex items-center gap-4 mb-8">
                    <Shield className="w-8 h-8 text-primary" />
                    <h1 className="text-3xl font-bold">관리자 허브</h1>
                </div>

                <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
                    {/* Tool Proposals Card */}
                    <Card
                        className="hover:shadow-lg transition-shadow cursor-pointer border-l-4 border-l-blue-500"
                        onClick={() => navigate('/admin/proposals')}
                    >
                        <CardHeader>
                            <div className="flex items-center gap-3 mb-2">
                                <FileText className="w-6 h-6 text-blue-500" />
                                <CardTitle>도구 제안 관리</CardTitle>
                            </div>
                            <CardDescription>
                                사용자들이 제출한 새로운 AI 도구 제안을 검토하고 승인합니다.
                            </CardDescription>
                        </CardHeader>
                    </Card>

                    {/* Feedback Dashboard Card */}
                    <Card
                        className="hover:shadow-lg transition-shadow cursor-pointer border-l-4 border-l-emerald-500"
                        onClick={() => navigate('/admin/feedback')}
                    >
                        <CardHeader>
                            <div className="flex items-center gap-3 mb-2">
                                <MessageSquare className="w-6 h-6 text-emerald-500" />
                                <CardTitle>피드백 대시보드</CardTitle>
                            </div>
                            <CardDescription>
                                사용자 피드백 통계, 이슈 리포트, 건의사항을 한눈에 확인합니다.
                            </CardDescription>
                        </CardHeader>
                    </Card>
                    {/* Submission Management Card */}
                    <Card
                        className="hover:shadow-lg transition-shadow cursor-pointer border-l-4 border-l-purple-500"
                        onClick={() => navigate('/admin/submissions')}
                    >
                        <CardHeader>
                            <div className="flex items-center gap-3 mb-2">
                                <Inbox className="w-6 h-6 text-purple-500" />
                                <CardTitle>제출 관리</CardTitle>
                            </div>
                            <CardDescription>
                                사용자가 판매 등록한 프롬프트/템플릿을 검토하고 승인합니다.
                            </CardDescription>
                        </CardHeader>
                    </Card>
                </div>
            </div>
        </div>
    );
};

export default AdminHub;
