import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import Navbar from "@/components/ui/navbar";
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { AlertCircle, CheckCircle2, XCircle, ChevronRight, Inbox } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { format } from "date-fns";

const SubmissionList = () => {
    const navigate = useNavigate();

    const { data: submissions, isLoading } = useQuery({
        queryKey: ['admin-submissions'],
        queryFn: async () => {
            const { data, error } = await supabase
                .from('content_submissions' as any)
                .select('*')
                .order('submitted_at', { ascending: false });

            if (error) throw error;
            return data;
        }
    });

    const getStatusColor = (status: string) => {
        switch (status) {
            case 'pending': return 'bg-yellow-100 text-yellow-800 border-yellow-200';
            case 'approved': return 'bg-green-100 text-green-800 border-green-200';
            case 'rejected': return 'bg-red-100 text-red-800 border-red-200';
            default: return 'bg-slate-100 text-slate-800';
        }
    };

    return (
        <div className="min-h-screen bg-muted/40 pb-20">
            <Navbar />
            <div className="container mx-auto py-10 px-6">
                <div className="flex items-center justify-between mb-8">
                    <div>
                        <h1 className="text-3xl font-bold flex items-center gap-3">
                            <Inbox className="w-8 h-8 text-primary" />
                            제출 관리
                        </h1>
                        <p className="text-muted-foreground mt-2">
                            사용자들이 제출한 콘텐츠를 검토하고 승인합니다.
                        </p>
                    </div>
                </div>

                <Card>
                    <CardHeader>
                        <CardTitle>제출 목록 ({submissions?.length || 0})</CardTitle>
                        <CardDescription>최근 제출된 순서대로 표시됩니다.</CardDescription>
                    </CardHeader>
                    <CardContent>
                        {isLoading ? (
                            <div className="text-center py-12 text-muted-foreground">로딩 중...</div>
                        ) : !submissions?.length ? (
                            <div className="text-center py-12 text-muted-foreground">
                                제출된 콘텐츠가 없습니다.
                            </div>
                        ) : (
                            <div className="divide-y relative">
                                {submissions.map((item: any) => (
                                    <div
                                        key={item.id}
                                        className="py-4 px-2 flex items-center justify-between hover:bg-slate-50 transition-colors cursor-pointer rounded-lg"
                                        onClick={() => navigate(`/admin/submissions/${item.id}`)}
                                    >
                                        <div className="flex items-center gap-4">
                                            <div className="w-2 h-2 rounded-full bg-blue-500" />
                                            <div>
                                                <div className="flex items-center gap-2 mb-1">
                                                    <span className="font-medium text-slate-900">{item.title}</span>
                                                    <Badge variant="outline" className="text-xs capitalize">
                                                        {item.type}
                                                    </Badge>
                                                </div>
                                                <div className="text-sm text-slate-500 flex items-center gap-2">
                                                    <span>{format(new Date(item.submitted_at), "yyyy-MM-dd HH:mm")}</span>
                                                    <span>•</span>
                                                    <span>by {item.user_id.slice(0, 8)}...</span>
                                                </div>
                                            </div>
                                        </div>

                                        <div className="flex items-center gap-4">
                                            <Badge variant="secondary" className={getStatusColor(item.status)}>
                                                {item.status.toUpperCase()}
                                            </Badge>
                                            <ChevronRight className="w-5 h-5 text-slate-400" />
                                        </div>
                                    </div>
                                ))}
                            </div>
                        )}
                    </CardContent>
                </Card>
            </div>
        </div>
    );
};

export default SubmissionList;
