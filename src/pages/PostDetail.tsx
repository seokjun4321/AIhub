import { useState, useMemo } from "react";
import { useParams, Link } from "react-router-dom";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { Skeleton } from "@/components/ui/skeleton";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { UserCircle, Calendar, MessageSquare, Send, ArrowLeft, CornerDownRight } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
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
    .select('*, profiles (username)')
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
      toast.success(parentId ? "Reply posted successfully!" : "Comment posted successfully!");
      onSuccess();
    },
    onError: (error) => {
      toast.error(`Failed to post: ${error.message}`);
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
        <p className="text-muted-foreground"><Link to="/auth" className="text-primary underline">Log in</Link> to post a reply.</p>
      </div>
    );
  }

  return (
    <form onSubmit={handleSubmit} className="flex gap-2 mt-4">
      <Textarea
        placeholder={parentId ? "Write a reply..." : "Write a comment..."}
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

  return (
    <div className="flex flex-col">
      <Card key={comment.id}>
        <CardHeader>
          <div className="flex items-center gap-2 text-sm text-muted-foreground mb-2">
            <UserCircle className="w-4 h-4" />
            <span>{comment.profiles?.username || 'Anonymous'}</span>
            <span>·</span>
            <span>{new Date(comment.created_at).toLocaleString()}</span>
          </div>
          <p>{comment.content}</p>
        </CardHeader>
        <CardContent>
          <Button variant="ghost" size="sm" onClick={() => setIsReplying(!isReplying)}>
            답변 달기
          </Button>
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
              <h1 className="text-4xl md:text-5xl font-bold tracking-tight">{post.title}</h1>
              <div className="flex items-center gap-8 mt-6 text-sm text-muted-foreground">
                <div className="flex items-center gap-2">
                  <UserCircle className="w-4 h-4" />
                  <span>by {post.profiles?.username || 'Anonymous'}</span>
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
          
          <section>
            <h2 className="text-2xl font-bold mb-4 flex items-center gap-2">
              <MessageSquare className="w-6 h-6" />
              답변 ({comments?.length || 0})
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
                <CardTitle>답변 달기</CardTitle>
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