import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { cn } from "@/lib/utils";
import { 
  Plus, 
  Minus, 
  MessageSquare, 
  FileText, 
  ThumbsUp, 
  CheckCircle, 
  Calendar, 
  Flame,
  Award,
  Star
} from "lucide-react";

interface PointHistoryItem {
  id: number;
  action_type: string;
  points: number;
  description?: string;
  created_at: string;
}

interface PointHistoryProps {
  history: PointHistoryItem[];
  className?: string;
}

const actionIcons: Record<string, any> = {
  'post_created': FileText,
  'comment_added': MessageSquare,
  'post_upvoted': ThumbsUp,
  'comment_upvoted': ThumbsUp,
  'answer_accepted': CheckCircle,
  'daily_login': Calendar,
  'streak_bonus': Flame,
  'first_post': Star,
  'first_comment': Star,
  'profile_completed': Award,
  'helpful_answer': CheckCircle,
  'quality_post': Star,
  'level_up': Star,
  'achievement_earned': Award,
};

const actionLabels: Record<string, string> = {
  'post_created': '게시글 작성',
  'comment_added': '댓글 작성',
  'post_upvoted': '게시글 추천받음',
  'comment_upvoted': '댓글 추천받음',
  'answer_accepted': '답변 채택됨',
  'daily_login': '일일 로그인',
  'streak_bonus': '연속 활동 보너스',
  'first_post': '첫 게시글 작성',
  'first_comment': '첫 댓글 작성',
  'profile_completed': '프로필 완성',
  'helpful_answer': '도움이 되는 답변',
  'quality_post': '고품질 게시글',
  'level_up': '레벨업 보너스',
  'achievement_earned': '업적 달성',
};

export function PointHistory({ history, className }: PointHistoryProps) {
  return (
    <Card className={className}>
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Star className="w-5 h-5 text-yellow-500" />
          포인트 이력
        </CardTitle>
      </CardHeader>
      <CardContent>
        <div className="space-y-3">
          {history.length === 0 ? (
            <p className="text-gray-500 text-center py-4">아직 포인트 이력이 없습니다.</p>
          ) : (
            history.map((item) => {
              const Icon = actionIcons[item.action_type] || Star;
              const label = actionLabels[item.action_type] || item.action_type;
              const isPositive = item.points > 0;

              return (
                <div 
                  key={item.id}
                  className="flex items-center justify-between p-3 rounded-lg border bg-gray-50"
                >
                  <div className="flex items-center gap-3">
                    <div className={cn(
                      "p-2 rounded-full",
                      isPositive ? "bg-green-100" : "bg-red-100"
                    )}>
                      <Icon className={cn(
                        "w-4 h-4",
                        isPositive ? "text-green-600" : "text-red-600"
                      )} />
                    </div>
                    <div>
                      <p className="font-medium text-gray-900">{label}</p>
                      {item.description && (
                        <p className="text-sm text-gray-600">{item.description}</p>
                      )}
                      <p className="text-xs text-gray-500">
                        {new Date(item.created_at).toLocaleString()}
                      </p>
                    </div>
                  </div>
                  <Badge 
                    className={cn(
                      "flex items-center gap-1",
                      isPositive 
                        ? "bg-green-500 hover:bg-green-600" 
                        : "bg-red-500 hover:bg-red-600"
                    )}
                  >
                    {isPositive ? (
                      <Plus className="w-3 h-3" />
                    ) : (
                      <Minus className="w-3 h-3" />
                    )}
                    <span>{Math.abs(item.points)}P</span>
                  </Badge>
                </div>
              );
            })
          )}
        </div>
      </CardContent>
    </Card>
  );
}

// 간단한 포인트 이력 (최근 5개만)
export function SimplePointHistory({ history, className }: PointHistoryProps) {
  const recentHistory = history.slice(0, 5);

  return (
    <div className={cn("space-y-2", className)}>
      {recentHistory.map((item) => {
        const Icon = actionIcons[item.action_type] || Star;
        const label = actionLabels[item.action_type] || item.action_type;
        const isPositive = item.points > 0;

        return (
          <div 
            key={item.id}
            className="flex items-center justify-between p-2 rounded-md bg-gray-50"
          >
            <div className="flex items-center gap-2">
              <Icon className={cn(
                "w-4 h-4",
                isPositive ? "text-green-600" : "text-red-600"
              )} />
              <span className="text-sm text-gray-700">{label}</span>
            </div>
            <Badge 
              className={cn(
                "text-xs",
                isPositive 
                  ? "bg-green-500 hover:bg-green-600" 
                  : "bg-red-500 hover:bg-red-600"
              )}
            >
              {isPositive ? '+' : ''}{item.points}P
            </Badge>
          </div>
        );
      })}
    </div>
  );
}

