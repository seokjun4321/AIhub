import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Link } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { Skeleton } from "@/components/ui/skeleton";
import { MessageSquare, UserCircle, PlusCircle } from "lucide-react";

// Supabase에서 posts 데이터를 가져오는 함수
const fetchPosts = async () => {
  // posts 테이블과 함께 profiles 테이블에서 username을 가져옵니다.
  const { data, error } = await supabase
    .from('posts')
    .select(`
      id,
      title,
      created_at,
      profiles ( username )
    `)
    .order('created_at', { ascending: false });

  if (error) throw new Error(error.message);
  return data;
};

const Community = () => {
  const { data: posts, isLoading, error } = useQuery({
    queryKey: ['posts'],
    queryFn: fetchPosts,
  });

  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      <main className="pt-24 pb-12">
        <div className="container mx-auto px-6">
          <div className="flex justify-between items-center mb-12">
            <div className="text-center md:text-left">
              <h1 className="text-4xl md:text-5xl font-bold">커뮤니티</h1>
              <p className="text-xl text-muted-foreground mt-4">
                AI에 대해 궁금한 점을 질문하고 지식을 나눠보세요.
              </p>
            </div>
            <Button asChild>
              <Link to="/community/new">
                <PlusCircle className="mr-2 h-4 w-4" />
                새 질문 올리기
              </Link>
            </Button>
          </div>

          {isLoading ? (
            <div className="space-y-4">
              {[...Array(5)].map((_, i) => <Skeleton key={i} className="h-24 w-full" />)}
            </div>
          ) : error ? (
            <div>에러가 발생했습니다: {error.message}</div>
          ) : (
            <div className="space-y-4">
              {posts?.map((post) => (
                <Link to={`/community/${post.id}`} key={post.id}>
                  <Card className="hover:border-primary/50 transition-colors">
                    <CardHeader>
                      <CardTitle className="text-lg">{post.title}</CardTitle>
                      <div className="flex items-center gap-4 text-sm text-muted-foreground pt-2">
                        <div className="flex items-center gap-1">
                          <UserCircle className="w-4 h-4" />
                          <span>{post.profiles?.username || '익명'}</span>
                        </div>
                        <span>{new Date(post.created_at).toLocaleString()}</span>
                      </div>
                    </CardHeader>
                  </Card>
                </Link>
              ))}
            </div>
          )}
        </div>
      </main>
      <Footer />
    </div>
  );
};

export default Community;