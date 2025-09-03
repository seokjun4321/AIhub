import { useState, useMemo, useEffect, useRef } from "react";
import { useParams, Link, useNavigate } from "react-router-dom";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { Skeleton } from "@/components/ui/skeleton";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { MentionInput } from "@/components/ui/mention-input";
import { SocialShare } from "@/components/ui/social-share";
import { AcceptAnswer } from "@/components/ui/accept-answer";
import { processMentions, renderMentionsAsLinks, renderMentionsAsReactElements } from "@/lib/mentions";
import { cn } from "@/lib/utils";
import { UserProfilePopup } from "@/components/ui/user-profile-popup";
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
  Image as ImageIcon,
  Edit,
  Trash2,
  CheckCircle2
} from "lucide-react";
import { useAuth } from "@/hooks/useAuth";
import { usePoints } from "@/hooks/usePoints";
import { toast } from "sonner";
import type { Database } from "@/integrations/supabase/types";

// Define a type for comments with nested replies
type CommentWithReplies = Database['public']['Tables']['comments']['Row'] & {
  profiles: { username: string | null } | null;
  replies: CommentWithReplies[];
  is_accepted?: boolean;
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
    .select('*, profiles (username), is_accepted')
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
  addPointsForComment,
  postAuthorId,
  initialMention = "",
}: {
  postId: number;
  parentId?: number | null;
  onSuccess: () => void;
  addPointsForComment: (commentId: number) => void;
  postAuthorId?: string;
  initialMention?: string;
}) => {
  const { user } = useAuth();
  const queryClient = useQueryClient();
  const [content, setContent] = useState(initialMention);

  // 해당 게시물에 이미 댓글을 작성했는지 확인하는 쿼리
  const { data: existingComments } = useQuery({
    queryKey: ['userCommentsOnPost', postId, user?.id],
    queryFn: async () => {
      if (!user?.id) return [];
      const { data, error } = await supabase
        .from('comments')
        .select('id')
        .eq('post_id', postId)
        .eq('author_id', user.id)
        .is('parent_comment_id', null); // 최상위 댓글만 확인
      
      if (error) throw error;
      return data || [];
    },
    enabled: !!user?.id && !parentId, // 답변이 아닌 최상위 댓글만 확인
  });

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
      
      // 멘션 처리
      await processMentions(newContent, user.id, undefined, data.id);
      
      return data;
    },
    onSuccess: (data) => {
      queryClient.invalidateQueries({ queryKey: ['comments', String(postId)] });
      queryClient.invalidateQueries({ queryKey: ['userCommentsOnPost', postId, user?.id] });
      // 프로필 > 내 댓글 / 사용자 통계 갱신을 위해 관련 쿼리 무효화
      if (user?.id) {
        queryClient.invalidateQueries({ queryKey: ['userComments', user.id] });
        queryClient.invalidateQueries({ queryKey: ['userStats', user.id] });
      }
      setContent("");
      toast.success(parentId ? "답변이 등록되었습니다!" : "댓글이 등록되었습니다!");
      
      // 포인트 적립 조건:
      // 1. 자기 게시물이 아닌 경우
      // 2. 최상위 댓글인 경우 (답변이 아닌 경우)
      // 3. 해당 게시물에 처음 댓글을 작성하는 경우
      const shouldAddPoints = 
        postAuthorId && user && postAuthorId !== user.id && // 자기 게시물이 아닌 경우
        !parentId && // 최상위 댓글인 경우
        existingComments && existingComments.length === 0; // 해당 게시물에 처음 댓글을 작성하는 경우
      
      if (shouldAddPoints) {
        addPointsForComment(data.id);
      }
      
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
    <form onSubmit={handleSubmit} className="w-full">
      <div className="flex gap-2 w-full">
        <MentionInput
          value={content}
          onChange={setContent}
          placeholder={parentId ? "답변을 작성하세요... (@사용자명으로 멘션 가능)" : "댓글을 작성하세요... (@사용자명으로 멘션 가능)"}
          disabled={addCommentMutation.isPending}
          className="flex-1 w-full min-h-[40px] text-sm"
        />
        <Button type="submit" size="icon" disabled={addCommentMutation.isPending} className="self-start">
          <Send className="w-4 h-4" />
        </Button>
      </div>
    </form>
  );
};

// --- 🔧 NEW: Recursive Comment Component ---
const Comment = ({ 
  comment, 
  postId, 
  post,
  addPointsForComment,
  allComments,
  isReply = false,
  onReplyToReply,
  replyState,
  onReplyStateChange,
  onProfileClick
}: { 
  comment: CommentWithReplies; 
  postId: number;
  post?: { author_id: string; category_id: number };
  addPointsForComment: (commentId: number) => void;
  allComments: CommentWithReplies[];
  isReply?: boolean;
  onReplyToReply?: (parentCommentId: number, mentionText: string) => void;
  replyState?: { isReplying: boolean; mentionText: string };
  onReplyStateChange?: (isReplying: boolean, mentionText: string) => void;
  onProfileClick?: (username: string, event: React.MouseEvent) => void;
}) => {
  const [showReplies, setShowReplies] = useState(false);
  const [isEditing, setIsEditing] = useState(false);
  const [editContent, setEditContent] = useState(comment.content);
  const { user } = useAuth();
  const queryClient = useQueryClient();
  
  // 답글 상태 관리
  const isReplying = replyState?.isReplying || false;
  const mentionText = replyState?.mentionText || "";

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
    onSuccess: (result) => {
      queryClient.invalidateQueries({ queryKey: ['comments', String(postId)] });
      // 댓글 작성자에게 포인트 적립 (추천인 경우)
      if (result.action === 'voted' && comment.author_id && comment.author_id !== user?.id) {
        addPointsForVote('comment', comment.id);
      }
    },
    onError: (error) => {
      toast.error(`오류가 발생했습니다: ${error.message}`);
    },
  });

  const handleCommentVote = (voteType: number) => {
    commentVoteMutation.mutate({ voteType });
  };

  // 댓글 수정 뮤테이션
  const editCommentMutation = useMutation({
    mutationFn: async (newContent: string) => {
      if (!user) throw new Error("로그인이 필요합니다.");
      
      const { error } = await supabase
        .from('comments')
        .update({ 
          content: newContent,
          is_edited: true,
          updated_at: new Date().toISOString()
        })
        .eq('id', comment.id)
        .eq('author_id', user.id);
      
      if (error) throw new Error(error.message);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['comments', String(postId)] });
      setIsEditing(false);
      toast.success("댓글이 수정되었습니다!");
    },
    onError: (error) => {
      toast.error(`수정 실패: ${error.message}`);
    },
  });

  // 댓글 삭제 뮤테이션
  const deleteCommentMutation = useMutation({
    mutationFn: async () => {
      if (!user) throw new Error("로그인이 필요합니다.");
      
      const { error } = await supabase
        .from('comments')
        .delete()
        .eq('id', comment.id)
        .eq('author_id', user.id);
      
      if (error) throw new Error(error.message);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['comments', String(postId)] });
      toast.success("댓글이 삭제되었습니다!");
    },
    onError: (error) => {
      toast.error(`삭제 실패: ${error.message}`);
    },
  });

  const handleEditComment = () => {
    if (editContent.trim()) {
      editCommentMutation.mutate(editContent);
    }
  };

  const handleDeleteComment = () => {
    if (confirm("정말로 이 댓글을 삭제하시겠습니까?")) {
      deleteCommentMutation.mutate();
    }
  };

  // 이미 채택된 답변이 있는지 확인
  const hasAcceptedAnswer = allComments.some(c => c.is_accepted);

  return (
    <div className="flex flex-col">
      <Card key={comment.id} className={cn(
        "transition-all duration-200",
        comment.is_accepted && "border-2 border-green-200 bg-green-50/30 shadow-md",
        isReply && "ml-8 scale-95"
      )}>
        <CardHeader className={cn(
          "pb-2 px-3 pt-3",
          isReply && "pb-1 px-2 pt-2"
        )}>
          <div className={cn(
            "flex items-center gap-2 text-muted-foreground mb-1",
            isReply ? "text-xs" : "text-xs"
          )}>
            <UserCircle className={cn("w-3 h-3", isReply && "w-2 h-2")} />
            <button
              onClick={(e) => onProfileClick?.(comment.profiles?.username || 'anonymous', e)}
              className="hover:text-primary hover:underline transition-colors cursor-pointer"
            >
              {comment.profiles?.username || '익명'}
            </button>
            <span>·</span>
            <span>{new Date(comment.created_at).toLocaleString()}</span>
            {comment.is_edited && (
              <>
                <span>·</span>
                <span className="text-xs">수정됨</span>
              </>
            )}
            {comment.is_accepted && (
              <>
                <span>·</span>
                <Badge variant="secondary" className="bg-green-100 text-green-800 border-green-200 text-xs px-1 py-0">
                  <CheckCircle2 className="w-2 h-2 mr-1" />
                  채택된 답변
                </Badge>
              </>
            )}
          </div>
          {isEditing ? (
            <div className="space-y-2">
              <MentionInput
                value={editContent}
                onChange={setEditContent}
                placeholder="댓글을 수정하세요..."
                disabled={editCommentMutation.isPending}
                className={cn(
                  "w-full min-h-[40px] text-sm",
                  isReply && "text-xs"
                )}
              />
              <div className="flex gap-2">
                <Button
                  size="sm"
                  onClick={handleEditComment}
                  disabled={editCommentMutation.isPending || !editContent.trim()}
                  className="h-7 px-3 text-xs"
                >
                  {editCommentMutation.isPending ? "수정 중..." : "수정 완료"}
                </Button>
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => {
                    setIsEditing(false);
                    setEditContent(comment.content);
                  }}
                  disabled={editCommentMutation.isPending}
                  className="h-7 px-3 text-xs"
                >
                  취소
                </Button>
              </div>
            </div>
          ) : (
            <p className={cn(
              "leading-relaxed",
              isReply ? "text-xs" : "text-sm",
              comment.is_accepted && "font-medium"
            )}>
              {renderMentionsAsReactElements(comment.content, onProfileClick)}
            </p>
          )}
        </CardHeader>
        <CardContent className={cn(
          "pt-0 px-3 pb-2",
          isReply && "pt-0 px-2 pb-1"
        )}>
          <div className="flex items-center gap-3">
            <div className="flex items-center gap-1">
              <Button
                variant="ghost"
                size="sm"
                onClick={() => handleCommentVote(1)}
                disabled={!user || commentVoteMutation.isPending}
                className={cn(
                  "hover:bg-blue-100 hover:text-blue-700 text-xs",
                  isReply ? "h-6 px-1" : "h-7 px-2"
                )}
              >
                <ThumbsUp className={cn("mr-1", isReply ? "w-2 h-2" : "w-3 h-3")} />
                {comment.upvotes_count || 0}
              </Button>
              <Button
                variant="ghost"
                size="sm"
                onClick={() => handleCommentVote(-1)}
                disabled={!user || commentVoteMutation.isPending}
                className={cn(
                  "hover:bg-red-100 hover:text-red-700 text-xs",
                  isReply ? "h-6 px-1" : "h-7 px-2"
                )}
              >
                <ThumbsDown className={cn("mr-1", isReply ? "w-2 h-2" : "w-3 h-3")} />
                {comment.downvotes_count || 0}
              </Button>
            </div>

            {/* 답변 채택 기능 - 질문 카테고리이고 최상위 댓글인 경우만 표시 */}
            {post && post.category_id === 1 && !comment.parent_comment_id && (
              <AcceptAnswer
                commentId={comment.id}
                postId={postId}
                postAuthorId={post.author_id}
                commentAuthorId={comment.author_id}
                isAccepted={comment.is_accepted || false}
                hasAcceptedAnswer={hasAcceptedAnswer}
              />
            )}

            {!isReply ? (
              <Button 
                variant="ghost" 
                size="sm" 
                onClick={() => {
                  if (onReplyStateChange) {
                    onReplyStateChange(!isReplying, "");
                  }
                }} 
                className="h-7 px-2 text-xs"
              >
                답변 달기
              </Button>
            ) : (
              <Button 
                variant="ghost" 
                size="sm" 
                onClick={() => {
                  // 대댓글에서는 원래 댓글에 멘션으로 답변
                  if (onReplyToReply && comment.parent_comment_id) {
                    const mentionText = `@${comment.profiles?.username || '익명'} `;
                    onReplyToReply(comment.parent_comment_id, mentionText);
                  }
                }}
                className="h-6 px-1 text-xs"
              >
                답변 달기
              </Button>
            )}
            {/* 댓글 작성자만 보이는 수정/삭제 버튼 */}
            {user && comment.author_id === user.id && !isEditing && (
              <>
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={() => setIsEditing(true)}
                  className={cn(
                    "hover:bg-blue-50 hover:text-blue-600",
                    isReply ? "h-6 px-1" : "h-7 px-2"
                  )}
                >
                  <Edit className={cn(isReply ? "w-2 h-2" : "w-3 h-3")} />
                </Button>
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={handleDeleteComment}
                  disabled={deleteCommentMutation.isPending}
                  className={cn(
                    "hover:bg-red-50 hover:text-red-600",
                    isReply ? "h-6 px-1" : "h-7 px-2"
                  )}
                >
                  <Trash2 className={cn(isReply ? "w-2 h-2" : "w-3 h-3")} />
                </Button>
              </>
            )}
            
            <Button
              variant="ghost"
              size="sm"
              onClick={() => toast.info("신고 기능은 곧 추가될 예정입니다!")}
              className={cn(
                "hover:bg-red-50 hover:text-red-600",
                isReply ? "h-6 px-1" : "h-7 px-2"
              )}
            >
              <Flag className={cn(isReply ? "w-2 h-2" : "w-3 h-3")} />
            </Button>
          </div>
        </CardContent>
      </Card>

      {isReplying && (
        <div className="ml-8 mt-3">
          <CommentForm 
            postId={postId} 
            parentId={comment.id} 
            onSuccess={() => {
              if (onReplyStateChange) {
                onReplyStateChange(false, "");
              }
            }} 
            addPointsForComment={addPointsForComment}
            postAuthorId={post?.author_id}
            initialMention={mentionText}
          />
        </div>
      )}

      {/* 답글 표시 버튼과 답글 목록 */}
      {comment.replies && comment.replies.length > 0 && (
        <div className="ml-8 mt-2">
          {!showReplies ? (
            <Button
              variant="ghost"
              size="sm"
              onClick={() => setShowReplies(true)}
              className="text-xs text-blue-600 hover:text-blue-700 hover:bg-blue-50 h-6 px-2"
            >
              답글 {comment.replies.length}개 보기
            </Button>
          ) : (
            <div className="space-y-2 mt-2">
              {comment.replies.map(reply => (
                <Comment 
                  key={reply.id} 
                  comment={reply} 
                  postId={postId} 
                  post={post} 
                  addPointsForComment={addPointsForComment} 
                  allComments={allComments}
                  isReply={true}
                  onReplyToReply={onReplyToReply}
                  onProfileClick={onProfileClick}
                />
              ))}
              <Button
                variant="ghost"
                size="sm"
                onClick={() => setShowReplies(false)}
                className="text-xs text-gray-500 hover:text-gray-700 h-6 px-2"
              >
                답글 숨기기
              </Button>
            </div>
          )}
        </div>
      )}
    </div>
  );
};

const PostDetail = () => {
  const { id } = useParams<{ id: string }>();
  const { user } = useAuth();
  const { addPointsForComment, addPointsForVote, addPointsForAcceptedAnswer } = usePoints();
  const queryClient = useQueryClient();
  const navigate = useNavigate();
  
  const postId = id ? parseInt(id, 10) : 0;
  
  // 댓글 답글 상태 관리
  const [commentReplyStates, setCommentReplyStates] = useState<{ [key: number]: { isReplying: boolean; mentionText: string } }>({});
  
  // 프로필 팝업 상태 관리
  const [profilePopup, setProfilePopup] = useState<{
    isOpen: boolean;
    username: string;
    position: { x: number; y: number };
  }>({
    isOpen: false,
    username: '',
    position: { x: 0, y: 0 }
  });

  // 대댓글에서 답변 달기 핸들러
  const handleReplyToReply = (parentCommentId: number, mentionText: string) => {
    setCommentReplyStates(prev => ({
      ...prev,
      [parentCommentId]: {
        isReplying: true,
        mentionText: mentionText
      }
    }));
  };

  // 프로필 팝업 핸들러
  const handleProfileClick = (username: string, event: React.MouseEvent) => {
    event.preventDefault();
    const rect = event.currentTarget.getBoundingClientRect();
    const popupWidth = 320; // 팝업 너비 (w-80 = 320px)
    const popupHeight = 250; // 예상 팝업 높이 (더 작게 조정)
    
    // 화면 경계 확인 및 위치 조정 - 오른쪽에 표시
    let x = rect.right + 10; // 클릭한 요소 오른쪽에 표시
    let y = rect.top + rect.height / 2 - popupHeight / 2; // 세로 중앙 정렬
    
    // 화면 왼쪽 경계 확인
    if (x < 10) {
      x = 10;
    }
    
    // 화면 오른쪽 경계 확인 (오른쪽에 공간이 없으면 왼쪽에 표시)
    if (x + popupWidth > window.innerWidth - 10) {
      x = rect.left - popupWidth - 10; // 왼쪽에 표시
    }
    
    // 화면 위쪽 경계 확인
    if (y < 10) {
      y = 10;
    }
    
    // 화면 아래쪽 경계 확인
    if (y + popupHeight > window.innerHeight - 50) {
      y = window.innerHeight - popupHeight - 50;
    }
    
    setProfilePopup({
      isOpen: true,
      username,
      position: { x, y }
    });
  };

  const closeProfilePopup = () => {
    setProfilePopup(prev => ({ ...prev, isOpen: false }));
  };

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

  // 🔧 NEW: Supabase Realtime 구독 - posts 테이블 업데이트를 실시간으로 반영
  useEffect(() => {
    if (!postId) return;

    const channel = supabase
      .channel(`post-${postId}`)
      .on(
        'postgres_changes',
        { event: 'UPDATE', schema: 'public', table: 'posts', filter: `id=eq.${postId}` },
        (payload) => {
          const updatedPost = payload.new as { 
            upvotes_count?: number; 
            downvotes_count?: number; 
            view_count?: number;
            comment_count?: number;
          };
          
          queryClient.setQueryData(['post', id], (prev: any) => {
            if (!prev) return prev;
            return {
              ...prev,
              upvotes_count: updatedPost.upvotes_count ?? prev.upvotes_count,
              downvotes_count: updatedPost.downvotes_count ?? prev.downvotes_count,
              view_count: updatedPost.view_count ?? prev.view_count,
              comment_count: updatedPost.comment_count ?? prev.comment_count,
            };
          });
        }
      )
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, [postId, id, queryClient]);

  // 조회수 기록 (개발 모드 StrictMode로 인한 중복 실행 방지)
  const hasRecordedViewRef = useRef(false);
  useEffect(() => {
    if (!postId) return;
    if (hasRecordedViewRef.current) return;
    hasRecordedViewRef.current = true;
    recordPostView(postId, user?.id);
  }, [postId]);

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
        // 게시글 작성자에게 포인트 적립 (추천인 경우)
        if (result.action === 'voted' && post?.author_id && post.author_id !== user?.id) {
          addPointsForVote('post', postId);
        }
      }
    },
    onError: (error) => {
      toast.error(`오류가 발생했습니다: ${error.message}`);
    },
  });

  // 게시글 삭제 뮤테이션
  const deletePostMutation = useMutation({
    mutationFn: async () => {
      if (!user) throw new Error("로그인이 필요합니다.");
      
      // 게시글 작성자 확인
      const { data: existingPost, error: fetchError } = await supabase
        .from('posts')
        .select('author_id')
        .eq('id', postId)
        .single();
      
      if (fetchError) throw new Error(fetchError.message);
      if (existingPost.author_id !== user.id) throw new Error("삭제 권한이 없습니다.");
      
      const { error } = await supabase
        .from('posts')
        .delete()
        .eq('id', postId);
      
      if (error) throw new Error(error.message);
    },
    onSuccess: () => {
      toast.success("게시글이 삭제되었습니다!");
      navigate('/community');
    },
    onError: (error) => {
      toast.error(`삭제 실패: ${error.message}`);
    },
  });

  const handleDeletePost = () => {
    if (confirm("정말로 이 게시글을 삭제하시겠습니까?")) {
      deletePostMutation.mutate();
    }
  };

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

    // 채택된 답변을 맨 위로 정렬
    nested.sort((a, b) => {
      if (a.is_accepted && !b.is_accepted) return -1;
      if (!a.is_accepted && b.is_accepted) return 1;
      return new Date(a.created_at).getTime() - new Date(b.created_at).getTime();
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
            <Button
              variant="outline"
              onClick={() => {
                // sessionStorage에서 저장된 커뮤니티 스크롤 위치 가져오기
                const savedScrollY = sessionStorage.getItem('communityScrollY');
                const y = savedScrollY ? parseInt(savedScrollY) : 0;
                
                // console.log('PostDetail: 저장된 커뮤니티 스크롤 위치 사용:', y);
                
                // 즉시 네비게이션
                navigate('/community', { 
                  state: { restoreY: y },
                  replace: false
                });
              }}
            >
              <ArrowLeft className="mr-2 h-4 w-4" />
              목록으로
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
                   {/* 게시글 작성자만 보이는 수정/삭제 버튼 */}
                   {user && post.author_id === user.id && (
                     <>
                       <Button
                         variant="ghost"
                         size="sm"
                         asChild
                       >
                         <Link to={`/community/edit/${post.id}`}>
                           <Edit className="w-4 h-4 mr-1" />
                           수정
                         </Link>
                       </Button>
                       <Button
                         variant="ghost"
                         size="sm"
                         onClick={handleDeletePost}
                         disabled={deletePostMutation.isPending}
                         className="text-red-600 hover:text-red-700 hover:bg-red-50"
                       >
                         <Trash2 className="w-4 h-4 mr-1" />
                         삭제
                       </Button>
                     </>
                   )}
                   
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
                  <p>{renderMentionsAsReactElements(post.content, handleProfileClick)}</p>
                </div>
                
                {/* 게시글 이미지 표시 - 레딧 스타일 */}
                {post.images && post.images.length > 0 && (
                  <div className="mt-6">
                    <div className="space-y-6">
                      {post.images.map((imageUrl, index) => (
                        <div key={index} className="relative group">
                          <img
                            src={imageUrl}
                            alt={`게시글 이미지 ${index + 1}`}
                            className="w-full rounded-lg cursor-pointer hover:opacity-95 transition-opacity"
                            style={{ 
                              maxHeight: '80vh',
                              objectFit: 'contain',
                              backgroundColor: '#f8f9fa'
                            }}
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
                    : "hover:bg-blue-100 hover:text-blue-700"
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
            <h2 className="text-xl font-bold mb-3 flex items-center gap-2">
              <MessageSquare className="w-5 h-5" />
              댓글 ({comments?.length || 0})
            </h2>
            
            {/* 댓글 작성창 - 맨 위에 고정 */}
            <Card className="sticky top-20 z-30 bg-background/95 backdrop-blur-sm border border-primary/20 shadow-md mb-3">
              <CardHeader className="pb-1 px-3 pt-2">
                <CardTitle className="text-sm flex items-center gap-2">
                  <MessageSquare className="w-3 h-3 text-primary" />
                  댓글 작성
                </CardTitle>
              </CardHeader>
              <CardContent className="pt-0 px-0 pb-2">
                <div className="px-3">
                  <CommentForm 
                    postId={postId} 
                    onSuccess={() => {}} 
                    addPointsForComment={addPointsForComment} 
                    postAuthorId={post?.author_id}
                  />
                </div>
              </CardContent>
            </Card>
            
            {/* 댓글 목록 */}
            <div className="space-y-3">
              {areCommentsLoading ? (
                <Skeleton className="h-20 w-full" />
              ) : (
                nestedComments.map(comment => (
                  <Comment 
                    key={comment.id} 
                    comment={comment} 
                    postId={postId} 
                    post={post ? { author_id: post.author_id, category_id: post.category_id } : undefined}
                    addPointsForComment={addPointsForComment}
                    allComments={nestedComments}
                    isReply={false}
                    onReplyToReply={handleReplyToReply}
                    replyState={commentReplyStates[comment.id]}
                    onReplyStateChange={(isReplying, mentionText) => {
                      setCommentReplyStates(prev => ({
                        ...prev,
                        [comment.id]: { isReplying, mentionText }
                      }));
                    }}
                    onProfileClick={handleProfileClick}
                  />
                ))
              )}
            </div>
          </section>
        </div>
      </main>
      <Footer />
      
      {/* 프로필 팝업 */}
      <UserProfilePopup
        username={profilePopup.username}
        isOpen={profilePopup.isOpen}
        onClose={closeProfilePopup}
        position={profilePopup.position}
      />
    </div>
  );
};

export default PostDetail;