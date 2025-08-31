import { useState, useMemo, useEffect } from "react";
import { useParams, Link } from "react-router-dom";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { Skeleton } from "@/components/ui/skeleton";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { SocialShare } from "@/components/ui/social-share";
import { 
  UserCircle, 
  Calendar, 
  MessageSquare, 
  Send, 
  ArrowLeft, 
  ThumbsUp, 
  ThumbsDown,
  Bookmark,
  Flag,
  Eye,
  Pin,
  Share2,
  MoreHorizontal,
  Image as ImageIcon
} from "lucide-react";
import { useAuth } from "@/hooks/useAuth";
import { toast } from "sonner";
import type { Database } from "@/integrations/supabase/types";

// Define a type for comments with nested replies
type CommentWithReplies = Database['public']['Tables']['comments']['Row'] & {
  profiles: { username: string | null } | null;
  replies: CommentWithReplies[];
};

// --- Data Loading Functions ---
const fetchPostById = async (id: string) => {
  const numericId = parseInt(id, 10);
  if (isNaN(numericId)) throw new Error("Invalid post ID");
  const { data, error } = await supabase
    .from('posts')
    .select(`
      *,
      profiles (username),
      community_sections (name, color, icon),
      post_categories (name, color, icon)
    `)
    .eq('id', numericId)
    .single();
  if (error) throw new Error(error.message);
  return data;
};

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

// 사용자의 투표 상태를 가져오는 함수
const fetchUserVote = async (postId: number, userId: string) => {
  const { data, error } = await supabase
    .from('post_votes')
    .select('vote_type')
    .eq('post_id', postId)
    .eq('user_id', userId)
    .single();
  
  if (error && error.code !== 'PGRST116') throw new Error(error.message);
  return data;
};

// 조회수 기록 함수
const recordPostView = async (postId: number, userId?: string) => {
  const { error } = await supabase
    .from('post_views')
    .insert({
      post_id: postId,
      user_id: userId || null,
    });
  
  if (error) console.error('Failed to record view:', error);
};

// --- 🔧 NEW: Comment Form Component ---
// A reusable form for both new comments and replies
const CommentForm = ({
  postId,
  parentId = null,
  onSuccess,
}: {
  postId: number;
  parentId?: number | null;
  onSuccess: () => void;
}) => {
  const { user } = useAuth();
  const queryClient = useQueryClient();
  const [content, setContent] = useState("");

     const addCommentMutation = useMutation({
     mutationFn: async (newContent: string) => {
       if (!user) throw new Error("User not logged in");
       const { data, error } = await supabase
         .from('comments')
         .insert({
           content: newContent,
           post_id: postId,
           author_id: user.id,
           parent_comment_id: parentId,
         })
        .select()
        .single();
      if (error) throw new Error(error.message);
      return data;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['comments', String(postId)] });
      setContent("");
      toast.success(parentId ? "답변이 등록되었습니다!" : "댓글이 등록되었습니다!");
      onSuccess();
    },
    onError: (error) => {
      toast.error(`등록에 실패했습니다: ${error.message}`);
    }
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (content.trim()) {
      addCommentMutation.mutate(content);
    }
  };

  if (!user) {
    return (
      <div className="text-center p-4 border rounded-lg mt-4">
        <p className="text-muted-foreground"><Link to="/auth" className="text-primary underline">로그인</Link> 후 댓글을 작성할 수 있습니다.</p>
      </div>
    );
  }

  return (
    <form onSubmit={handleSubmit} className="flex gap-2 mt-4">
      <Textarea
        placeholder={parentId ? "답변을 작성하세요..." : "댓글을 작성하세요..."}
        value={content}
        onChange={(e) => setContent(e.target.value)}
        disabled={addCommentMutation.isPending}
        rows={2}
      />
      <Button type="submit" size="icon" disabled={addCommentMutation.isPending}>
        <Send className="w-4 h-4" />
      </Button>
    </form>
  );
};

// --- 🔧 NEW: Recursive Comment Component ---
const Comment = ({ comment, postId }: { comment: CommentWithReplies; postId: number }) => {
  const [isReplying, setIsReplying] = useState(false);
  const { user } = useAuth();
  const queryClient = useQueryClient();

  // 댓글 투표 뮤테이션
  const commentVoteMutation = useMutation({
    mutationFn: async ({ voteType }: { voteType: number }) => {
      if (!user) throw new Error("로그인이 필요합니다.");
      
      // 현재 사용자의 투표 상태 확인
      const { data: currentVote } = await supabase
        .from('comment_votes')
        .select('vote_type')
        .eq('comment_id', comment.id)
        .eq('user_id', user.id)
        .single();
      
      // 같은 투표를 다시 누르면 취소
      if (currentVote && currentVote.vote_type === voteType) {
        const { error } = await supabase
          .from('comment_votes')
          .delete()
          .eq('comment_id', comment.id)
          .eq('user_id', user.id);
        
        if (error) throw new Error(error.message);
        return { action: 'removed' };
      }
      
      // 다른 투표로 변경하거나 새로 투표
      if (currentVote) {
        const { error } = await supabase
          .from('comment_votes')
          .update({ vote_type: voteType })
          .eq('comment_id', comment.id)
          .eq('user_id', user.id);
        
        if (error) throw new Error(error.message);
        return { action: 'changed' };
      } else {
        const { error } = await supabase
          .from('comment_votes')
          .insert({
            comment_id: comment.id,
            user_id: user.id,
            vote_type: voteType,
          });
        
        if (error) throw new Error(error.message);
        return { action: 'voted' };
      }
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['comments', String(postId)] });
    },
    onError: (error) => {
      toast.error(`오류가 발생했습니다: ${error.message}`);
    },
  });

  const handleCommentVote = (voteType: number) => {
    commentVoteMutation.mutate({ voteType });
  };

  return (
    <div className="flex flex-col">
      <Card key={comment.id}>
        <CardHeader>
          <div className="flex items-center gap-2 text-sm text-muted-foreground mb-2">
            <UserCircle className="w-4 h-4" />
            <span>{comment.profiles?.username || '익명'}</span>
            <span>·</span>
            <span>{new Date(comment.created_at).toLocaleString()}</span>
            {comment.is_edited && (
              <>
                <span>·</span>
                <span className="text-xs">수정됨</span>
              </>
            )}
          </div>
          <p>{comment.content}</p>
        </CardHeader>
        <CardContent>
          <div className="flex items-center gap-4">
            <div className="flex items-center gap-2">
              <Button
                variant="ghost"
                size="sm"
                onClick={() => handleCommentVote(1)}
                disabled={!user || commentVoteMutation.isPending}
                className="hover:bg-green-100 hover:text-green-700"
              >
                <ThumbsUp className="w-4 h-4 mr-1" />
                {comment.upvotes_count || 0}
              </Button>
              <Button
                variant="ghost"
                size="sm"
                onClick={() => handleCommentVote(-1)}
                disabled={!user || commentVoteMutation.isPending}
                className="hover:bg-red-100 hover:text-red-700"
              >
                <ThumbsDown className="w-4 h-4 mr-1" />
                {comment.downvotes_count || 0}
              </Button>
            </div>
            <Button variant="ghost" size="sm" onClick={() => setIsReplying(!isReplying)}>
              답변 달기
            </Button>
            <Button
              variant="ghost"
              size="sm"
              onClick={() => toast.info("신고 기능은 곧 추가될 예정입니다!")}
              className="hover:bg-red-50 hover:text-red-600"
            >
              <Flag className="w-4 h-4" />
            </Button>
          </div>
        </CardContent>
      </Card>

      {isReplying && (
        <div className="ml-8 mt-2">
          <CommentForm postId={postId} parentId={comment.id} onSuccess={() => setIsReplying(false)} />
        </div>
      )}

      {comment.replies && comment.replies.length > 0 && (
        <div className="ml-8 mt-4 space-y-4 border-l-2 pl-4">
          {comment.replies.map(reply => (
            <Comment key={reply.id} comment={reply} postId={postId} />
          ))}
        </div>
      )}
    </div>
  );
};

const PostDetail = () => {
  const { id } = useParams<{ id: string }>();
  const { user } = useAuth();
  const queryClient = useQueryClient();
  
  const postId = id ? parseInt(id, 10) : 0;

  const { data: post, isLoading: isPostLoading, error: postError } = useQuery({
    queryKey: ['post', id],
    queryFn: () => fetchPostById(id!),
    enabled: !!id,
  });

  const { data: comments, isLoading: areCommentsLoading } = useQuery({
    queryKey: ['comments', id],
    queryFn: () => fetchCommentsByPostId(id!),
    enabled: !!id,
  });

  // 사용자의 투표 상태
  const { data: userVote } = useQuery({
    queryKey: ['userVote', postId, user?.id],
    queryFn: () => {
      if (!user?.id || !postId) return null;
      return fetchUserVote(postId, user.id);
    },
    enabled: !!user && !!postId,
  });

  // 사용자의 북마크 상태
  const { data: isBookmarked } = useQuery({
    queryKey: ['userBookmark', postId, user?.id],
    queryFn: async () => {
      if (!user?.id || !postId) return false;
      const { data, error } = await supabase
        .from('post_bookmarks')
        .select('id')
        .eq('post_id', postId)
        .eq('user_id', user.id)
        .single();
      
      if (error && error.code !== 'PGRST116') throw new Error(error.message);
      return !!data;
    },
    enabled: !!user && !!postId,
  });

  // 조회수 기록
  useEffect(() => {
    if (postId) {
      recordPostView(postId, user?.id);
    }
  }, [postId, user?.id]);

  // 투표 뮤테이션
  const voteMutation = useMutation({
    mutationFn: async ({ voteType }: { voteType: number }) => {
      if (!user) throw new Error("로그인이 필요합니다.");
      
      // 현재 사용자의 투표 상태 확인
      const { data: currentVote } = await supabase
        .from('post_votes')
        .select('vote_type')
        .eq('post_id', postId)
        .eq('user_id', user.id)
        .single();
      
      // 같은 투표를 다시 누르면 취소
      if (currentVote && currentVote.vote_type === voteType) {
        const { error } = await supabase
          .from('post_votes')
          .delete()
          .eq('post_id', postId)
          .eq('user_id', user.id);
        
        if (error) throw new Error(error.message);
        return { action: 'removed' };
      }
      
      // 다른 투표로 변경하거나 새로 투표
      if (currentVote) {
        // 기존 투표가 있으면 업데이트
        const { error } = await supabase
          .from('post_votes')
          .update({ vote_type: voteType })
          .eq('post_id', postId)
          .eq('user_id', user.id);
        
        if (error) throw new Error(error.message);
        return { action: 'changed' };
      } else {
        // 새 투표 삽입
        const { error } = await supabase
          .from('post_votes')
          .insert({
            post_id: postId,
            user_id: user.id,
            vote_type: voteType,
          });
        
        if (error) throw new Error(error.message);
        return { action: 'voted' };
      }
    },
    onSuccess: (result) => {
      queryClient.invalidateQueries({ queryKey: ['post', id] });
      if (result.action === 'removed') {
        toast.success("투표가 취소되었습니다!");
      } else if (result.action === 'changed') {
        toast.success("투표가 변경되었습니다!");
      } else {
        toast.success("투표가 반영되었습니다!");
      }
    },
    onError: (error) => {
      toast.error(`오류가 발생했습니다: ${error.message}`);
    },
  });

  // 북마크 뮤테이션
  const bookmarkMutation = useMutation({
    mutationFn: async ({ isBookmarked }: { isBookmarked: boolean }) => {
      if (!user) throw new Error("로그인이 필요합니다.");
      
      if (isBookmarked) {
        // 북마크 제거
        const { error } = await supabase
          .from('post_bookmarks')
          .delete()
          .eq('post_id', postId)
          .eq('user_id', user.id);
        
        if (error) throw new Error(error.message);
        return { action: 'removed' };
      } else {
        // 북마크 추가
        const { error } = await supabase
          .from('post_bookmarks')
          .insert({
            post_id: postId,
            user_id: user.id,
          });
        
        if (error) throw new Error(error.message);
        return { action: 'added' };
      }
    },
    onSuccess: (result) => {
      queryClient.invalidateQueries({ queryKey: ['userBookmark', postId, user?.id] });
      if (result.action === 'removed') {
        toast.success("북마크가 제거되었습니다!");
      } else {
        toast.success("북마크에 추가되었습니다!");
      }
    },
    onError: (error) => {
      toast.error(`오류가 발생했습니다: ${error.message}`);
    },
  });

  const handleVote = (voteType: number) => {
    voteMutation.mutate({ voteType });
  };

  const handleBookmark = () => {
    bookmarkMutation.mutate({ isBookmarked: !!isBookmarked });
  };

  // --- 🔧 NEW: Logic to structure comments into a tree ---
  const nestedComments = useMemo(() => {
    if (!comments) return [];
    const commentMap: { [key: number]: CommentWithReplies } = {};
    const nested: CommentWithReplies[] = [];

    comments.forEach(comment => {
      commentMap[comment.id] = { ...comment, replies: [] };
    });

    comments.forEach(comment => {
      if (comment.parent_comment_id && commentMap[comment.parent_comment_id]) {
        commentMap[comment.parent_comment_id].replies.push(commentMap[comment.id]);
      } else {
        nested.push(commentMap[comment.id]);
      }
    });

    return nested;
  }, [comments]);

  if (isPostLoading) return <div>Loading post...</div>;
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
          <article>
            <header className="mb-8">
              <div className="flex items-center gap-2 mb-4">
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
              <h1 className="text-4xl md:text-5xl font-bold tracking-tight">{post.title}</h1>
              <div className="flex items-center justify-between mt-6">
                <div className="flex items-center gap-8 text-sm text-muted-foreground">
                  <div className="flex items-center gap-2">
                    <UserCircle className="w-4 h-4" />
                    <span>by {post.profiles?.username || 'Anonymous'}</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <Calendar className="w-4 h-4" />
                    <span>{new Date(post.created_at).toLocaleString()}</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <Eye className="w-4 h-4" />
                    <span>{post.view_count || 0} 조회</span>
                  </div>
                </div>
                
                {/* 액션 버튼들 */}
                <div className="flex items-center gap-2">
                  {/* SNS 공유 버튼 */}
                  <SocialShare
                    url={window.location.href}
                    title={post.title}
                    description={post.content?.substring(0, 100)}
                    hashtags={['AIHub', '커뮤니티', post.post_categories?.name || '']}
                  />
                  
                  <Button
                    variant="ghost"
                    size="sm"
                    onClick={handleBookmark}
                    disabled={!user || bookmarkMutation.isPending}
                    className={`${
                      isBookmarked
                        ? "bg-yellow-100 text-yellow-700 hover:bg-yellow-200" 
                        : "hover:bg-gray-100"
                    }`}
                  >
                    <Bookmark className="w-4 h-4" />
                  </Button>
                  <Button
                    variant="ghost"
                    size="sm"
                    onClick={() => toast.info("신고 기능은 곧 추가될 예정입니다!")}
                    className="hover:bg-red-50 hover:text-red-600"
                  >
                    <Flag className="w-4 h-4" />
                  </Button>
                </div>
              </div>
            </header>
            <Card className="mb-8">
              <CardContent className="p-6">
                <div className="prose dark:prose-invert max-w-none">
                  <p>{post.content}</p>
                </div>
                
                {/* 게시글 이미지 표시 */}
                {post.images && post.images.length > 0 && (
                  <div className="mt-6">
                    <h3 className="text-lg font-semibold mb-3">첨부된 이미지</h3>
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                      {post.images.map((imageUrl, index) => (
                        <div key={index} className="relative group">
                          <img
                            src={imageUrl}
                            alt={`게시글 이미지 ${index + 1}`}
                            className="w-full h-48 object-cover rounded-lg border cursor-pointer hover:opacity-90 transition-opacity"
                            onClick={() => window.open(imageUrl, '_blank')}
                            onError={(e) => {
                              e.currentTarget.src = '/placeholder.svg';
                            }}
                          />
                        </div>
                      ))}
                    </div>
                  </div>
                )}

              </CardContent>
            </Card>

            {/* 투표 섹션 */}
            <div className="flex items-center justify-center gap-4 mb-8">
              <Button
                variant="ghost"
                size="lg"
                onClick={() => handleVote(1)}
                disabled={!user || voteMutation.isPending}
                className={`${
                  userVote?.vote_type === 1 
                    ? "bg-blue-100 text-blue-700 hover:bg-blue-200" 
                    : "hover:bg-green-100 hover:text-green-700"
                }`}
              >
                <ThumbsUp className="w-6 h-6 mr-2" />
                추천 {post.upvotes_count || 0}
              </Button>
              <Button
                variant="ghost"
                size="lg"
                onClick={() => handleVote(-1)}
                disabled={!user || voteMutation.isPending}
                className={`${
                  userVote?.vote_type === -1 
                    ? "bg-red-100 text-red-700 hover:bg-red-200" 
                    : "hover:bg-red-100 hover:text-red-700"
                }`}
              >
                <ThumbsDown className="w-6 h-6 mr-2" />
                비추천 {post.downvotes_count || 0}
              </Button>
            </div>
          </article>
          
          <section>
            <h2 className="text-2xl font-bold mb-4 flex items-center gap-2">
              <MessageSquare className="w-6 h-6" />
              댓글 ({comments?.length || 0})
            </h2>
            
            <div className="space-y-6 mb-8">
              {areCommentsLoading ? (
                <Skeleton className="h-20 w-full" />
              ) : (
                nestedComments.map(comment => (
                  <Comment key={comment.id} comment={comment} postId={postId} />
                ))
              )}
            </div>
            
            <Card>
              <CardHeader>
                <CardTitle>댓글 작성</CardTitle>
              </CardHeader>
              <CardContent>
                <CommentForm postId={postId} onSuccess={() => {}} />
              </CardContent>
            </Card>
          </section>
        </div>
      </main>
      <Footer />
    </div>
  );
};

export default PostDetail;