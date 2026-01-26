import { useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import Navbar from "@/components/ui/navbar";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle, CardDescription, CardFooter } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Textarea } from "@/components/ui/textarea";
import { Separator } from "@/components/ui/separator";
import { ChevronLeft, CheckCircle2, XCircle } from "lucide-react";
import { useToast } from "@/components/ui/use-toast";
import { format } from "date-fns";

interface GuideSubmission {
    id: string;
    title: string;
    category: string;
    submission_type: string;
    status: 'pending' | 'approved' | 'rejected';
    guide_data: any;
    user_id: string;
    submitted_at: string;
    reviewed_at?: string;
    original_guide_id?: string;
}

const GuideSubmissionDetail = () => {
    const { id } = useParams();
    const navigate = useNavigate();
    const { toast } = useToast();
    const [adminNotes, setAdminNotes] = useState("");
    const [isProcessing, setIsProcessing] = useState(false);

    const { data: submission, isLoading, refetch } = useQuery({
        queryKey: ['guide-submission', id],
        queryFn: async () => {
            const { data, error } = await supabase
                .from('guide_submissions' as any)
                .select('*')
                .eq('id', id)
                .single();

            if (error) throw error;
            return data as unknown as GuideSubmission;
        },
        enabled: !!id
    });

    const handleApprove = async () => {
        if (!submission) return;
        if (!confirm("정말 이 가이드북을 승인하시겠습니까? 승인 시 실제 가이드로 발행됩니다.")) return;

        setIsProcessing(true);
        try {
            const { data, error } = await supabase.rpc('approve_guide_submission', {
                submission_id: submission.id
            });

            if (error) throw error;

            // @ts-ignore
            if (data && !data.success) {
                // @ts-ignore
                throw new Error(data.error);
            }

            toast({ title: "승인 완료", description: "가이드북이 성공적으로 발행되었습니다." });
            refetch();
        } catch (error: any) {
            console.error("Approval error:", error);
            toast({ title: "승인 실패", description: error.message, variant: "destructive" });
        } finally {
            setIsProcessing(false);
        }
    };

    const handleReject = async () => {
        toast({ title: "준비 중", description: "반려 기능은 아직 개발 중입니다." });
    };

    if (isLoading) return <div className="p-10 text-center">Loading...</div>;
    if (!submission) return <div className="p-10 text-center">Submission not found</div>;

    const content = submission.guide_data || {};
    const metadata = content.metadata || {};

    return (
        <div className="min-h-screen bg-muted/40 pb-20">
            <Navbar />
            <div className="container mx-auto py-10 px-6 max-w-5xl">
                <Button variant="ghost" className="mb-6 pl-0 hover:bg-transparent" onClick={() => navigate('/admin/guide-submissions')}>
                    <ChevronLeft className="w-4 h-4 mr-2" /> 목록으로 돌아가기
                </Button>

                <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
                    {/* Left: Content Detail */}
                    <div className="lg:col-span-2 space-y-6">
                        <Card>
                            <CardHeader>
                                <div className="flex justify-between items-start">
                                    <div>
                                        <Badge variant="outline" className="mb-2 capitalize">{submission.submission_type || 'new'}</Badge>
                                        <CardTitle className="text-2xl">{submission.title}</CardTitle>
                                        <CardDescription className="mt-1">
                                            제출일: {format(new Date(submission.submitted_at), "yyyy-MM-dd HH:mm")}
                                        </CardDescription>
                                    </div>
                                    <Badge className={
                                        submission.status === 'approved' ? 'bg-green-500' :
                                            submission.status === 'rejected' ? 'bg-red-500' : 'bg-yellow-500'
                                    }>
                                        {submission.status?.toUpperCase() || "UNKNOWN"}
                                    </Badge>
                                </div>
                            </CardHeader>
                            <CardContent className="space-y-6">
                                <Separator />

                                <div className="grid grid-cols-2 gap-4 text-sm">
                                    <div>
                                        <div className="font-semibold text-muted-foreground mb-1">카테고리</div>
                                        <div>{submission.category || metadata.categoryId || "-"}</div>
                                    </div>
                                    <div>
                                        <div className="font-semibold text-muted-foreground mb-1">작성자 ID</div>
                                        <div className="font-mono text-xs">{submission.user_id}</div>
                                    </div>
                                    <div className="col-span-2">
                                        <div className="font-semibold text-muted-foreground mb-1">요약</div>
                                        <div>{metadata.summary || "-"}</div>
                                    </div>
                                    <div className="col-span-2">
                                        <div className="font-semibold text-muted-foreground mb-1">타겟 독자</div>
                                        <div>{metadata.targetAudience || "-"}</div>
                                    </div>
                                </div>

                                <Separator />

                                {/* Dynamic Content View */}
                                <div className="bg-slate-50 p-4 rounded-lg border text-sm font-mono whitespace-pre-wrap overflow-x-auto max-h-[600px] overflow-y-auto">
                                    <h4 className="font-bold text-slate-700 mb-2 font-sans sticky top-0 bg-slate-50 pb-2 border-b">Raw Guide Data (JSON)</h4>
                                    {JSON.stringify(content, null, 2)}
                                </div>
                            </CardContent>
                        </Card>
                    </div>

                    {/* Right: Admin Actions */}
                    <div className="space-y-6">
                        <Card>
                            <CardHeader>
                                <CardTitle>관리자 검토</CardTitle>
                            </CardHeader>
                            <CardContent className="space-y-4">
                                <div className="space-y-2">
                                    <label className="text-sm font-medium">관리자 노트</label>
                                    <Textarea
                                        placeholder="메모를 남기세요."
                                        rows={5}
                                        value={adminNotes}
                                        onChange={(e) => setAdminNotes(e.target.value)}
                                        disabled={true}
                                    />
                                    <p className="text-xs text-muted-foreground">* 현재 버전에서는 보기만 가능합니다.</p>
                                </div>

                                <div className="flex gap-3 pt-4">
                                    <Button
                                        variant="outline"
                                        className="w-full border-red-200 text-red-600 hover:bg-red-50 hover:text-red-700"
                                        onClick={handleReject}
                                        disabled={isProcessing}
                                    >
                                        <XCircle className="w-4 h-4 mr-2" /> 반려
                                    </Button>
                                    <Button
                                        className="w-full bg-green-600 hover:bg-green-700"
                                        onClick={handleApprove}
                                        disabled={isProcessing}
                                    >
                                        <CheckCircle2 className="w-4 h-4 mr-2" /> 승인
                                    </Button>
                                </div>
                            </CardContent>
                        </Card>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default GuideSubmissionDetail;
