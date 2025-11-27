import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { MessageSquare, CheckCircle2 } from "lucide-react";
import { Link } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { Skeleton } from "@/components/ui/skeleton";
import { formatDistanceToNow } from "date-fns";
import { ko } from "date-fns/locale";

interface Post {
    id: number;
    title: string;
    created_at: string;
    comment_count: number;
    upvotes_count: number;
    profiles: {
        username: string;
        avatar_url: string | null;
    } | null;
    post_categories: {
        name: string;
    } | null;
}

interface SolvedPost extends Post {
    accepted_answer_id: number;
}

const CommunityActivity = () => {
    // 최근 질문 가져오기
    const { data: recentQuestions, isLoading: isQuestionsLoading } = useQuery({
        queryKey: ['home-recent-questions'],
        queryFn: async () => {
            const { data, error } = await supabase
                .from('posts')
                .select(`
                    id,
                    title,
                    created_at,
                    comment_count,
                    upvotes_count,
                    profiles (username, avatar_url),
                    post_categories (name)
                `)
                .eq('post_categories.name', '질문') // 카테고리 이름으로 필터링 (주의: 실제 DB에 '질문' 카테고리가 있어야 함)
                .order('created_at', { ascending: false })
                .limit(3);

            if (error) throw error;
            // post_categories 필터링이 Supabase 조인에서 완벽하지 않을 수 있어 클라이언트에서 한 번 더 확인
            return (data as unknown as Post[]).filter(post => post.post_categories?.name === '질문');
        }
    });

    // 해결된 문제 가져오기
    const { data: solvedProblems, isLoading: isSolvedLoading } = useQuery({
        queryKey: ['home-solved-problems'],
        queryFn: async () => {
            const { data, error } = await supabase
                .from('posts')
                .select(`
                    id,
                    title,
                    created_at,
                    comment_count,
                    upvotes_count,
                    accepted_answer_id,
                    profiles (username, avatar_url)
                `)
                .not('accepted_answer_id', 'is', null)
                .order('created_at', { ascending: false })
                .limit(2);

            if (error) throw error;
            return data as SolvedPost[];
        }
    });

    const isLoading = isQuestionsLoading || isSolvedLoading;

    if (isLoading) {
        return (
            <section className="py-20">
                <div className="container mx-auto px-6">
                    <div className="text-center mb-12">
                        <h2 className="text-3xl font-bold mb-4">커뮤니티 활동</h2>
                        <p className="text-muted-foreground">다른 사용자들과 지식을 공유하고 함께 성장하세요</p>
                    </div>
                    <div className="grid grid-cols-1 lg:grid-cols-2 gap-12">
                        <div className="space-y-4">
                            {[1, 2, 3].map(i => <Skeleton key={i} className="h-24 w-full" />)}
                        </div>
                        <div className="space-y-4">
                            {[1, 2].map(i => <Skeleton key={i} className="h-24 w-full" />)}
                        </div>
                    </div>
                </div>
            </section>
        );
    }

    return (
        <section className="py-20">
            <div className="container mx-auto px-6">
                <div className="text-center mb-12">
                    <h2 className="text-3xl font-bold mb-4">커뮤니티 활동</h2>
                    <p className="text-muted-foreground">다른 사용자들과 지식을 공유하고 함께 성장하세요</p>
                </div>

                <div className="grid grid-cols-1 lg:grid-cols-2 gap-12">
                    {/* 최근 질문 */}
                    <div>
                        <div className="flex items-center gap-2 mb-6">
                            <MessageSquare className="w-5 h-5 text-green-500" />
                            <h3 className="text-xl font-bold">최근 질문</h3>
                        </div>
                        <div className="space-y-4">
                            {recentQuestions?.length === 0 ? (
                                <div className="text-center py-8 text-muted-foreground">아직 등록된 질문이 없습니다.</div>
                            ) : (
                                recentQuestions?.map((q) => (
                                    <Link key={q.id} to={`/community/${q.id}`}>
                                        <Card className="p-4 hover:shadow-md transition-all cursor-pointer">
                                            <div className="flex gap-4">
                                                <Avatar className="w-10 h-10 bg-green-100 text-green-600">
                                                    <AvatarImage src={q.profiles?.avatar_url || undefined} />
                                                    <AvatarFallback>{q.profiles?.username?.[0] || 'U'}</AvatarFallback>
                                                </Avatar>
                                                <div className="flex-1">
                                                    <div className="flex items-center gap-2 mb-1">
                                                        <span className="font-semibold text-sm">{q.profiles?.username || '익명'}</span>
                                                        <Badge variant="secondary" className="text-xs font-normal">
                                                            {q.post_categories?.name || '질문'}
                                                        </Badge>
                                                    </div>
                                                    <h4 className="font-medium mb-2 line-clamp-1">{q.title}</h4>
                                                    <div className="flex items-center gap-4 text-xs text-muted-foreground">
                                                        <span>{formatDistanceToNow(new Date(q.created_at), { addSuffix: true, locale: ko })}</span>
                                                        <div className="flex items-center gap-1">
                                                            <MessageSquare className="w-3 h-3" />
                                                            {q.comment_count}
                                                        </div>
                                                        <div className="flex items-center gap-1">
                                                            <span>👍</span>
                                                            {q.upvotes_count}
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </Card>
                                    </Link>
                                ))
                            )}
                        </div>
                    </div>

                    {/* 최근 해결된 문제 */}
                    <div>
                        <div className="flex items-center gap-2 mb-6">
                            <CheckCircle2 className="w-5 h-5 text-green-500" />
                            <h3 className="text-xl font-bold">최근 해결된 문제</h3>
                        </div>
                        <div className="space-y-4">
                            {solvedProblems?.length === 0 ? (
                                <div className="text-center py-8 text-muted-foreground">아직 해결된 문제가 없습니다.</div>
                            ) : (
                                solvedProblems?.map((p) => (
                                    <Link key={p.id} to={`/community/${p.id}`}>
                                        <Card className="p-4 hover:shadow-md transition-all cursor-pointer border-green-500/20 bg-green-50/30">
                                            <div className="flex gap-4">
                                                <Avatar className="w-10 h-10 bg-green-600 text-white">
                                                    <AvatarImage src={p.profiles?.avatar_url || undefined} />
                                                    <AvatarFallback>{p.profiles?.username?.[0] || 'U'}</AvatarFallback>
                                                </Avatar>
                                                <div className="flex-1">
                                                    <div className="flex items-center gap-2 mb-1">
                                                        <span className="font-semibold text-sm">{p.profiles?.username || '익명'}</span>
                                                        <Badge className="bg-green-500 hover:bg-green-600 text-xs">
                                                            해결됨
                                                        </Badge>
                                                    </div>
                                                    <h4 className="font-medium mb-2 line-clamp-1">{p.title}</h4>
                                                    <div className="bg-white/50 p-2 rounded-md text-sm text-muted-foreground mb-2">
                                                        <span className="font-semibold text-green-700 mr-2">해결 완료</span>
                                                        답변을 확인해보세요!
                                                    </div>
                                                    <span className="text-xs text-muted-foreground">
                                                        {formatDistanceToNow(new Date(p.created_at), { addSuffix: true, locale: ko })}
                                                    </span>
                                                </div>
                                            </div>
                                        </Card>
                                    </Link>
                                ))
                            )}
                        </div>
                    </div>
                </div>

                <div className="text-center mt-12">
                    <Button size="lg" className="bg-green-600 hover:bg-green-700 text-white px-8" asChild>
                        <Link to="/community">커뮤니티 참여하기</Link>
                    </Button>
                </div>
            </div>
        </section>
    );
};

export default CommunityActivity;
