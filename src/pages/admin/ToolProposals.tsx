import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import Navbar from "@/components/ui/navbar";
import { Button } from "@/components/ui/button";
import {
    Table,
    TableBody,
    TableCell,
    TableHead,
    TableHeader,
    TableRow,
} from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import { toast } from "sonner";
import { Check, X, ExternalLink, Loader2 } from "lucide-react";
import { useAuth } from "@/hooks/useAuth";

interface ToolProposal {
    id: number;
    name: string;
    website_url: string;
    description: string;
    status: "pending" | "approved" | "rejected";
    created_at: string;
    category_id: number;
    categories: { name: string } | null;
}

const ToolProposals = () => {
    const { user } = useAuth();
    const navigate = useNavigate();
    const queryClient = useQueryClient();

    // 관리자 권한 체크 (실제로는 더 정교해야 함)
    useEffect(() => {
        if (!user) {
            navigate("/auth");
        }
    }, [user, navigate]);

    const { data: proposals, isLoading } = useQuery({
        queryKey: ["toolProposals"],
        queryFn: async () => {
            const { data, error } = await supabase
                .from("tool_proposals" as any)
                .select(`
          *,
          categories (name)
        `)
                .order("created_at", { ascending: false });

            if (error) throw error;
            return data as unknown as ToolProposal[];
        },
    });

    const updateStatusMutation = useMutation({
        mutationFn: async ({ id, status }: { id: number; status: string }) => {
            const { error } = await supabase
                .from("tool_proposals" as any)
                .update({ status })
                .eq("id", id);
            if (error) throw error;
        },
        onSuccess: () => {
            queryClient.invalidateQueries({ queryKey: ["toolProposals"] });
            toast.success("상태가 업데이트되었습니다.");
        },
        onError: (error) => {
            toast.error(`업데이트 실패: ${error.message}`);
        },
    });

    const handleApprove = async (proposal: ToolProposal) => {
        // 1. ai_models 테이블에 추가
        try {
            const { error: insertError } = await supabase.from("ai_models").insert({
                name: proposal.name,
                website_url: proposal.website_url,
                description: proposal.description,
                category_id: proposal.category_id,
                provider: "Community User", // 임시
                average_rating: 0,
                rating_count: 0,
            });

            if (insertError) throw insertError;

            // 2. 제안 상태를 approved로 변경
            updateStatusMutation.mutate({ id: proposal.id, status: "approved" });
            toast.success("도구가 승인되어 목록에 추가되었습니다!");
        } catch (error: any) {
            toast.error(`승인 처리 실패: ${error.message}`);
        }
    };

    return (
        <div className="min-h-screen bg-background">
            <Navbar />
            <main className="container mx-auto px-6 py-24">
                <h1 className="text-3xl font-bold mb-8">도구 제안 관리</h1>

                <div className="bg-card border rounded-xl shadow-sm overflow-hidden">
                    <Table>
                        <TableHeader>
                            <TableRow>
                                <TableHead>날짜</TableHead>
                                <TableHead>이름</TableHead>
                                <TableHead>카테고리</TableHead>
                                <TableHead>URL</TableHead>
                                <TableHead>상태</TableHead>
                                <TableHead className="text-right">액션</TableHead>
                            </TableRow>
                        </TableHeader>
                        <TableBody>
                            {isLoading ? (
                                <TableRow>
                                    <TableCell colSpan={6} className="text-center py-8">
                                        <Loader2 className="h-6 w-6 animate-spin mx-auto" />
                                    </TableCell>
                                </TableRow>
                            ) : proposals?.length === 0 ? (
                                <TableRow>
                                    <TableCell colSpan={6} className="text-center py-8 text-muted-foreground">
                                        제안된 도구가 없습니다.
                                    </TableCell>
                                </TableRow>
                            ) : (
                                proposals?.map((proposal) => (
                                    <TableRow key={proposal.id}>
                                        <TableCell>
                                            {new Date(proposal.created_at).toLocaleDateString()}
                                        </TableCell>
                                        <TableCell className="font-medium">
                                            <div>{proposal.name}</div>
                                            <div className="text-xs text-muted-foreground truncate max-w-[200px]">
                                                {proposal.description}
                                            </div>
                                        </TableCell>
                                        <TableCell>
                                            <Badge variant="outline">
                                                {proposal.categories?.name || "Unknown"}
                                            </Badge>
                                        </TableCell>
                                        <TableCell>
                                            <a
                                                href={proposal.website_url}
                                                target="_blank"
                                                rel="noopener noreferrer"
                                                className="text-blue-500 hover:underline flex items-center gap-1"
                                            >
                                                Link <ExternalLink className="h-3 w-3" />
                                            </a>
                                        </TableCell>
                                        <TableCell>
                                            <Badge
                                                variant={
                                                    proposal.status === "approved"
                                                        ? "default" // "success" variant might not exist, using default
                                                        : proposal.status === "rejected"
                                                            ? "destructive"
                                                            : "secondary"
                                                }
                                            >
                                                {proposal.status}
                                            </Badge>
                                        </TableCell>
                                        <TableCell className="text-right">
                                            {proposal.status === "pending" && (
                                                <div className="flex justify-end gap-2">
                                                    <Button
                                                        size="sm"
                                                        variant="outline"
                                                        className="h-8 w-8 p-0 text-green-600 border-green-200 hover:bg-green-50"
                                                        onClick={() => handleApprove(proposal)}
                                                        title="승인"
                                                    >
                                                        <Check className="h-4 w-4" />
                                                    </Button>
                                                    <Button
                                                        size="sm"
                                                        variant="outline"
                                                        className="h-8 w-8 p-0 text-red-600 border-red-200 hover:bg-red-50"
                                                        onClick={() =>
                                                            updateStatusMutation.mutate({
                                                                id: proposal.id,
                                                                status: "rejected",
                                                            })
                                                        }
                                                        title="거절"
                                                    >
                                                        <X className="h-4 w-4" />
                                                    </Button>
                                                </div>
                                            )}
                                        </TableCell>
                                    </TableRow>
                                ))
                            )}
                        </TableBody>
                    </Table>
                </div>
            </main>
        </div>
    );
};

export default ToolProposals;
