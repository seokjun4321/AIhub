import { useState } from 'react';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { supabase } from '@/integrations/supabase/client';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { CheckCircle2, Check } from 'lucide-react';
import { useAuth } from '@/hooks/useAuth';
import { usePoints } from '@/hooks/usePoints';
import { toast } from 'sonner';
import { cn } from '@/lib/utils';

interface AcceptAnswerProps {
  commentId: number;
  postId: number;
  postAuthorId: string;
  commentAuthorId: string; // 답변 작성자 ID 추가
  isAccepted: boolean;
  hasAcceptedAnswer: boolean; // 이미 채택된 답변이 있는지 확인
  onAcceptToggle?: () => void;
}

export const AcceptAnswer = ({
  commentId,
  postId,
  postAuthorId,
  commentAuthorId,
  isAccepted,
  hasAcceptedAnswer,
  onAcceptToggle
}: AcceptAnswerProps) => {
  const { user } = useAuth();
  const { addPointsForAcceptedAnswer } = usePoints();
  const queryClient = useQueryClient();
  const [isLoading, setIsLoading] = useState(false);

  // 현재 사용자가 질문 작성자인지 확인
  const isQuestionAuthor = user?.id === postAuthorId;
  
  // 게시물 작성자가 자신의 댓글에 대해 채택할 수 없도록 확인
  const isCommentAuthor = user?.id === commentAuthorId;
  const canAccept = isQuestionAuthor && !isCommentAuthor && !hasAcceptedAnswer;

  const acceptMutation = useMutation({
    mutationFn: async () => {
      if (!user) throw new Error("로그인이 필요합니다.");
      
      const { error } = await supabase
        .from('comments')
        .update({ is_accepted: true })
        .eq('id', commentId);
      
      if (error) throw new Error(error.message);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['comments', postId.toString()] });
      queryClient.invalidateQueries({ queryKey: ['post', postId.toString()] });
      
      toast.success("답변이 채택되었습니다!");
      // 답변 작성자에게 포인트 적립
      addPointsForAcceptedAnswer(commentId, commentAuthorId);
      
      onAcceptToggle?.();
    },
    onError: (error) => {
      console.error('Accept answer error:', error);
      toast.error(`오류가 발생했습니다: ${error.message}`);
    },
  });

  const handleAccept = () => {
    setIsLoading(true);
    acceptMutation.mutate();
    setTimeout(() => setIsLoading(false), 1000);
  };

  // 질문 작성자가 아니거나, 질문 작성자가 자신의 댓글에 대해 채택하려는 경우 버튼을 보여주지 않음
  if (!canAccept) {
    // 하지만 채택된 답변이라면 배지는 표시
    return isAccepted ? (
      <Badge variant="secondary" className="bg-green-100 text-green-800 border-green-200">
        <CheckCircle2 className="w-3 h-3 mr-1" />
        채택된 답변
      </Badge>
    ) : null;
  }

  return (
    <div className="flex items-center gap-2">
      {isAccepted ? (
        <Badge variant="secondary" className="bg-green-100 text-green-800 border-green-200">
          <CheckCircle2 className="w-3 h-3 mr-1" />
          채택된 답변
        </Badge>
      ) : (
        <Button
          variant="outline"
          size="sm"
          onClick={handleAccept}
          disabled={isLoading || acceptMutation.isPending}
          className={cn(
            "border-green-200 text-green-700 hover:bg-green-50 hover:text-green-800",
            "transition-colors duration-200"
          )}
        >
          <Check className="w-4 h-4 mr-1" />
          {isLoading || acceptMutation.isPending ? "처리 중..." : "답변 채택"}
        </Button>
      )}
    </div>
  );
};

