import { useParams, Link } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { Skeleton } from "@/components/ui/skeleton";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { UserCircle, Calendar, MessageSquare } from "lucide-react";
import { Button } from "@/components/ui/button";

// URL의 ID를 기반으로 특정 게시글 1개를 가져오는 함수
const fetchPostById = async (id: string) => {
  const numericId = parseInt(id, 10);
  if (isNaN(numericId)) throw new Error("Invalid post ID");

  const { data, error } = await supabase
    .from('posts')
    .select(`
      *,
      profiles (username)
    `)
    .eq('id', numericId)
    .single();

  if (error) throw new Error(error.message);
  return data;
};

const PostDetail = () => {
  const { id } = useParams<{ id: string }>();

  const { data: post, isLoading, error } = useQuery({
    queryKey: ['post', id],
    queryFn: () => {
      if (!id) throw new Error("Post ID is required");
      return fetchPostById(id);
    },
    enabled: !!id,
  });

  if (isLoading) {
    return (
      <div className="min-h-screen">
        <Navbar />
        <main className="pt-24 container mx-auto px-6 max-w-4xl">
          <Skeleton className="h-12 w-3/4 mb-4" />
          <div className="flex items-center gap-8 mb-8">
            <Skeleton className="h-5 w-24" />
            <Skeleton className="h-5 w-32" />
          </div>
          <div className="space-y-4 mt-8">
            <Skeleton className="h-4 w-full" />
            <Skeleton className="h-4 w-full" />
            <Skeleton className="h-4 w-5/6" />
          </div>
        </main>
      </div>
    );
  }

  if (error) return <div>Error: {error.message}</div>;
  if (!post) return <div>Post not found.</div>;

  return (
    <div className="min-h-screen">
      <Navbar />
      <main className="pt-24 pb-12">
        <div className="container mx-auto px-6 max-w-4xl">
          <article>
            <header className="mb-8">
              <h1 className="text-4xl md:text-5xl font-bold tracking-tight">{post.title}</h1>
              <div className="flex items-center gap-8 mt-6 text-sm text-muted-foreground">
                <div className="flex items-center gap-2">
                  <UserCircle className="w-4 h-4" />
                  {/* profiles 테이블이 null일 경우를 대비하여 옵셔널 체이닝(?.) 사용 */}
                  <span>by {post.profiles?.username || '익명'}</span>
                </div>
                <div className="flex items-center gap-2">
                  <Calendar className="w-4 h-4" />
                  <span>{new Date(post.created_at).toLocaleDateString()}</span>
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
          
          <section>
            <h2 className="text-2xl font-bold mb-4 flex items-center gap-2">
              <MessageSquare className="w-6 h-6" />
              답변
            </h2>
            {/* 답변 목록 및 답변 작성 폼은 여기에 추가됩니다. */}
            <div className="text-center py-8 border rounded-lg">
              <p className="text-muted-foreground">아직 답변 기능이 구현되지 않았습니다.</p>
            </div>
          </section>

        </div>
      </main>
      <Footer />
    </div>
  );
};

export default PostDetail;