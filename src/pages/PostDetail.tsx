import { useState } from "react";
import { useParams, Link } from "react-router-dom";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { Skeleton } from "@/components/ui/skeleton";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { UserCircle, Calendar, MessageSquare, Send, ArrowLeft } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { useAuth } from "@/hooks/useAuth";
import { toast } from "sonner";

// --- 데이터 로딩 함수들 ---
const fetchPostById = async (id: string) => {
  const numericId = parseInt(id, 10);
  if (isNaN(numericId)) throw new Error("Invalid post ID");

  const { data, error } = await supabase
    .from('posts')
    .select('*, profiles (username)')
    .eq('id', numericId)
    .single();

  if (error) throw new Error(error.message);
  return data;
};

// 댓글을 가져오는 함수 추가
const fetchCommentsByPostId = async (postId: string) => {
  const numericId = parseInt(postId, 10);
  if (isNaN(numericId)) throw new Error("Invalid post ID");

  const { data, error } = await supabase
    .from('comments')
    .select('*, profiles (username)')
    .eq('post_id', numericId)
    .order('created_at', { ascending: true });

  if (error) throw new Error(error.message);
  return data;
};

const PostDetail = () => {
  const { id } = useParams<{ id: string }>();
  const { user } = useAuth();
  const queryClient = useQueryClient();
  const [newComment, setNewComment] = useState("");

  // 게시글 데이터 가져오기
  const { data: post, isLoading: isPostLoading, error: postError } = useQuery({
    queryKey: ['post', id],
    queryFn: () => fetchPostById(id!),
    enabled: !!id,
  });

  // 댓글 데이터 가져오기
  const { data: comments, isLoading: areCommentsLoading } = useQuery({
    queryKey: ['comments', id],
    queryFn: () => fetchCommentsByPostId(id!),
    enabled: !!id,
  });

  // 댓글 추가 뮤테이션 (데이터 변경 시 사용)
  const addCommentMutation = useMutation({
    mutationFn: async (content: string) => {
      if (!user || !id) throw new Error("User not logged in or post ID missing");
      
      const { data, error } = await supabase
        .from('comments')
        .insert({
          content,
          post_id: parseInt(id, 10),
          author_id: user.id,
        })
        .select()
        .single();
      
      if (error) throw new Error(error.message);
      return data;
    },
    onSuccess: () => {
      // 성공 시 'comments' 쿼리를 무효화하여 최신 데이터로 다시 불러옵니다.
      queryClient.invalidateQueries({ queryKey: ['comments', id] });
      setNewComment("");
      toast.success("댓글이 성공적으로 등록되었습니다!");
    },
    onError: (error) => {
      toast.error(`댓글 등록 실패: ${error.message}`);
    }
  });

  const handleCommentSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (newComment.trim()) {
      addCommentMutation.mutate(newComment);
    }
  };

  // --- 렌더링 로직 ---
  if (isPostLoading) return <div>Loading post...</div>; // 간단한 로딩
  if (postError) return <div>Error: {postError.message}</div>;
  if (!post) return <div>Post not found.</div>;

  return (
    <div className="min-h-screen">
      <Navbar />
      <main className="pt-24 pb-12">
        <div className="container mx-auto px-6 max-w-4xl">
          <div className="mb-6">
            <Button asChild variant="outline">
              <Link to="/community">
                <ArrowLeft className="mr-2 h-4 w-4" />
                목록으로
              </Link>
            </Button>
          </div>
          {/* 게시글 본문 */}
          <article>
            <header className="mb-8">
              <h1 className="text-4xl md:text-5xl font-bold tracking-tight">{post.title}</h1>
              <div className="flex items-center gap-8 mt-6 text-sm text-muted-foreground">
                <div className="flex items-center gap-2">
                  <UserCircle className="w-4 h-4" />
                  <span>by {post.profiles?.username || '익명'}</span>
                </div>
                <div className="flex items-center gap-2">
                  <Calendar className="w-4 h-4" />
                  <span>{new Date(post.created_at).toLocaleString()}</span>
                </div>
              </div>
            </header>
            <Card className="mb-8">
              <CardContent className="p-6">
                <div className="prose dark:prose-invert max-w-none">
                  <p>{post.content}</p>
                </div>
              </CardContent>
            </Card>
          </article>
          
          {/* 댓글 섹션 */}
          <section>
            <h2 className="text-2xl font-bold mb-4 flex items-center gap-2">
              <MessageSquare className="w-6 h-6" />
              답변 ({comments?.length || 0})
            </h2>
            
            {/* 댓글 목록 */}
            <div className="space-y-4 mb-8">
              {areCommentsLoading ? (
                <Skeleton className="h-20 w-full" />
              ) : (
                comments?.map(comment => (
                  <Card key={comment.id}>
                    <CardHeader>
                      <div className="flex items-center gap-2 text-sm text-muted-foreground mb-2">
                        <UserCircle className="w-4 h-4" />
                        <span>{comment.profiles?.username || '익명'}</span>
                        <span>·</span>
                        <span>{new Date(post.created_at).toLocaleString()}</span>
                      </div>
                      <p>{comment.content}</p>
                    </CardHeader>
                  </Card>
                ))
              )}
            </div>

            {/* 댓글 작성 폼 */}
            {user ? (
              <Card>
                <CardHeader>
                  <CardTitle>답변 달기</CardTitle>
                </CardHeader>
                <CardContent>
                  <form onSubmit={handleCommentSubmit} className="flex gap-2">
                    <Textarea
                      placeholder="답변을 입력하세요..."
                      value={newComment}
                      onChange={(e) => setNewComment(e.target.value)}
                      disabled={addCommentMutation.isPending}
                    />
                    <Button type="submit" size="icon" disabled={addCommentMutation.isPending}>
                      <Send className="w-4 h-4" />
                    </Button>
                  </form>
                </CardContent>
              </Card>
            ) : (
              <div className="text-center p-4 border rounded-lg">
                <p className="text-muted-foreground"><Link to="/auth" className="text-primary underline">로그인</Link> 후 답변을 작성할 수 있습니다.</p>
              </div>
            )}
          </section>
        </div>
      </main>
      <Footer />
    </div>
  );
};

export default PostDetail;