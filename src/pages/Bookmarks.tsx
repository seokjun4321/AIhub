import { useState, useRef, useEffect } from "react";
import { useInfiniteQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Link } from "react-router-dom";
import { Skeleton } from "@/components/ui/skeleton";
import { SocialShare } from "@/components/ui/social-share";
import {
  MessageSquare,
  UserCircle,
  ThumbsUp,
  ThumbsDown,
  Clock,
  MessageCircle,
  Bookmark,
  Flag,
  Eye,
  Pin,
  Loader2,
  BookmarkIcon
} from "lucide-react";
import { useAuth } from "@/hooks/useAuth";
import { toast } from "sonner";

// 페이지당 게시글 수
const POSTS_PER_PAGE = 10;

// 북마크된 게시글 타입 정의
interface BookmarkedPost {
  id: number;
  title: string;
  content: string | null;
  created_at: string;
  upvotes_count: number | null;
  downvotes_count: number | null;
  view_count: number | null;
  comment_count: number | null;
  is_pinned: boolean | null;
  is_locked: boolean | null;
  images: string[] | null;
  profiles: { username: string | null } | null;
  community_sections: { name: string; color: string | null; icon: string | null } | null;
  post_categories: { name: string; color: string | null; icon: string | null } | null;
}

// 북마크된 게시글 데이터를 가져오는 함수
const fetchBookmarkedPosts = async ({
  pageParam = 0,
  userId
}: {
  pageParam?: number;
  userId: string;
}) => {
  let query = supabase
    .from('post_bookmarks')
    .select(`
      created_at,
      posts (
        id,
        title,
        content,
        created_at,
        upvotes_count,
        downvotes_count,
        view_count,
        comment_count,
        is_pinned,
        is_locked,
        images,
        profiles ( username ),
        community_sections ( name, color, icon ),
        post_categories ( name, color, icon )
      )
    `)
    .eq('user_id', userId)
    .order('created_at', { ascending: false })
    .range(pageParam * POSTS_PER_PAGE, (pageParam + 1) * POSTS_PER_PAGE - 1);

  const { data, error } = await query;
  if (error) throw new Error(error.message);

  // 북마크 데이터에서 게시글만 추출
  const posts = (data?.map(item => item.posts).filter(Boolean) || []) as unknown as BookmarkedPost[];

  return {
    data: posts,
    nextCursor: posts.length === POSTS_PER_PAGE ? pageParam + 1 : null,
  };
};

const Bookmarks = () => {
  const { user } = useAuth();
  const queryClient = useQueryClient();
  const loadMoreRef = useRef<HTMLDivElement>(null);

  // 무한 스크롤 북마크 데이터
  const {
    data: bookmarksData,
    fetchNextPage,
    hasNextPage,
    isFetchingNextPage,
    isLoading,
    error,
  } = useInfiniteQuery({
    queryKey: ['bookmarks', user?.id],
    queryFn: ({ pageParam }) => fetchBookmarkedPosts({ pageParam, userId: user!.id }),
    getNextPageParam: (lastPage) => lastPage.nextCursor,
    initialPageParam: 0,
    enabled: !!user,
  });

  // 무한 스크롤 감지를 위한 Intersection Observer
  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        if (entries[0].isIntersecting && hasNextPage && !isFetchingNextPage) {
          fetchNextPage();
        }
      },
      { threshold: 0.1 }
    );

    if (loadMoreRef.current) {
      observer.observe(loadMoreRef.current);
    }

    return () => observer.disconnect();
  }, [fetchNextPage, hasNextPage, isFetchingNextPage]);

  // 전체 북마크 데이터를 평면화
  const posts = bookmarksData?.pages.flatMap(page => page.data) || [];

  // 북마크 제거 뮤테이션
  const removeBookmarkMutation = useMutation({
    mutationFn: async (postId: number) => {
      if (!user) throw new Error("로그인이 필요합니다.");

      const { error } = await supabase
        .from('post_bookmarks')
        .delete()
        .eq('post_id', postId)
        .eq('user_id', user.id);

      if (error) throw new Error(error.message);
      return { action: 'removed' };
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['bookmarks', user?.id] });
      toast.success("북마크가 제거되었습니다!");
    },
    onError: (error) => {
      toast.error(`오류가 발생했습니다: ${error.message}`);
    },
  });

  const handleRemoveBookmark = (postId: number) => {
    removeBookmarkMutation.mutate(postId);
  };

  if (!user) {
    return (
      <div className="min-h-screen bg-background">
        <Navbar />
        <main className="pt-24 pb-12">
          <div className="container mx-auto px-6">
            <div className="text-center py-12">
              <BookmarkIcon className="w-12 h-12 text-muted-foreground mx-auto mb-4" />
              <h3 className="text-lg font-medium text-muted-foreground mb-2">
                로그인이 필요합니다
              </h3>
              <p className="text-muted-foreground mb-4">
                북마크를 확인하려면 로그인해주세요.
              </p>
              <Button asChild>
                <Link to="/auth">
                  로그인하기
                </Link>
              </Button>
            </div>
          </div>
        </main>
        <Footer />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      <main className="pt-24 pb-12">
        <div className="container mx-auto px-6">
          <div className="mb-8">
            <h1 className="text-4xl md:text-5xl font-bold">북마크</h1>
            <p className="text-xl text-muted-foreground mt-4">
              저장한 게시글들을 확인하세요.
            </p>
          </div>

          {isLoading ? (
            <div className="space-y-4">
              {[...Array(5)].map((_, i) => <Skeleton key={i} className="h-32 w-full" />)}
            </div>
          ) : error ? (
            <div>에러가 발생했습니다: {error.message}</div>
          ) : (
            <div className="space-y-4">
              {posts?.map((post) => (
                <Card key={post.id} className={`hover:shadow-md transition-shadow ${post.is_pinned ? 'border-l-4 border-l-yellow-500' : ''}`}>
                  <CardHeader>
                    <div className="flex items-start justify-between">
                      <div className="flex-1">
                        <div className="flex items-center gap-2 mb-2">
                          {post.is_pinned && (
                            <Badge variant="secondary" className="bg-yellow-100 text-yellow-800">
                              <Pin className="w-3 h-3 mr-1" />
                              고정
                            </Badge>
                          )}
                          {post.community_sections && (
                            <Badge
                              variant="secondary"
                              style={{ backgroundColor: post.community_sections.color + '20', color: post.community_sections.color }}
                            >
                              {post.community_sections.name}
                            </Badge>
                          )}
                          {post.post_categories && (
                            <Badge
                              variant="outline"
                              style={{ borderColor: post.post_categories.color, color: post.post_categories.color }}
                            >
                              {post.post_categories.name}
                            </Badge>
                          )}
                        </div>
                        <Link to={`/community/${post.id}`}>
                          <CardTitle className="text-lg hover:text-primary transition-colors">
                            {post.title}
                          </CardTitle>
                        </Link>
                        <CardDescription className="mt-2 line-clamp-2">
                          {post.content?.replace(/<[^>]*>/g, '').substring(0, 150)}...
                        </CardDescription>

                        {/* 이미지 미리보기 */}
                        {post.images && post.images.length > 0 && (
                          <div className="mt-3 flex gap-2 overflow-x-auto">
                            {post.images.slice(0, 3).map((imageUrl, index) => (
                              <img
                                key={index}
                                src={imageUrl}
                                alt={`게시글 이미지 ${index + 1}`}
                                className="w-16 h-16 object-cover rounded-md border flex-shrink-0"
                                onError={(e) => {
                                  e.currentTarget.src = '/placeholder.svg';
                                }}
                              />
                            ))}
                            {post.images.length > 3 && (
                              <div className="w-16 h-16 bg-muted rounded-md border flex items-center justify-center flex-shrink-0">
                                <span className="text-xs text-muted-foreground">
                                  +{post.images.length - 3}
                                </span>
                              </div>
                            )}
                          </div>
                        )}
                      </div>
                    </div>

                    <div className="flex items-center justify-between pt-4">
                      <div className="flex items-center gap-4 text-sm text-muted-foreground">
                        <div className="flex items-center gap-1">
                          <UserCircle className="w-4 h-4" />
                          <span>{post.profiles?.username || '익명'}</span>
                        </div>
                        <span>{new Date(post.created_at).toLocaleDateString()}</span>
                        <div className="flex items-center gap-1">
                          <Eye className="w-4 h-4" />
                          <span>{post.view_count || 0}</span>
                        </div>
                        <div className="flex items-center gap-1">
                          <MessageCircle className="w-4 h-4" />
                          <span>{post.comment_count || 0}</span>
                        </div>
                      </div>

                      <div className="flex items-center gap-2">
                        <Button
                          variant="ghost"
                          size="sm"
                          onClick={() => handleRemoveBookmark(post.id)}
                          disabled={removeBookmarkMutation.isPending}
                          className="bg-yellow-100 text-yellow-700 hover:bg-yellow-200"
                        >
                          <Bookmark className="w-4 h-4" />
                        </Button>

                        {/* SNS 공유 버튼 */}
                        <div onClick={(e) => e.stopPropagation()}>
                          <SocialShare
                            url={`${window.location.origin}/community/${post.id}`}
                            title={post.title}
                            description={post.content?.replace(/<[^>]*>/g, '').substring(0, 100)}
                            hashtags={['AIHub', '커뮤니티', post.post_categories?.name || '']}
                          />
                        </div>
                      </div>
                    </div>
                  </CardHeader>
                </Card>
              ))}

              {/* 무한 스크롤 로딩 인디케이터 */}
              <div ref={loadMoreRef} className="flex justify-center py-8">
                {isFetchingNextPage && (
                  <div className="flex items-center gap-2 text-muted-foreground">
                    <Loader2 className="w-4 h-4 animate-spin" />
                    더 많은 북마크를 불러오는 중...
                  </div>
                )}
                {!hasNextPage && posts.length > 0 && (
                  <div className="text-muted-foreground text-sm">
                    모든 북마크를 확인했습니다.
                  </div>
                )}
              </div>

              {posts?.length === 0 && (
                <div className="text-center py-12">
                  <BookmarkIcon className="w-12 h-12 text-muted-foreground mx-auto mb-4" />
                  <h3 className="text-lg font-medium text-muted-foreground mb-2">
                    아직 북마크한 게시글이 없습니다
                  </h3>
                  <p className="text-muted-foreground mb-4">
                    관심 있는 게시글을 북마크해보세요!
                  </p>
                  <Button asChild>
                    <Link to="/community">
                      커뮤니티로 가기
                    </Link>
                  </Button>
                </div>
              )}
            </div>
          )}
        </div>
      </main>
      <Footer />
    </div>
  );
};

export default Bookmarks;
