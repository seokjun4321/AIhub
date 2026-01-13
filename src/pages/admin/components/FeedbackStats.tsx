import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { FeedbackData } from '../FeedbackDashboard';
import { Users, Bug, Star, MessageSquare } from 'lucide-react';

interface FeedbackStatsProps {
    data: FeedbackData[];
}

export const FeedbackStats = ({ data }: FeedbackStatsProps) => {

    const totalCount = data.length;
    const bugCount = data.filter(f => f.category === 'bug' || f.category === 'prompt_error').length;

    const ratedFeedbacks = data.filter(f => f.rating !== null && f.rating !== undefined);

    // Normalize Ratings: Map 0/1 (Micro) to 1/5 scale
    const totalScore = ratedFeedbacks.reduce((acc, cur) => {
        let score = cur.rating;
        // Check if it's micro-feedback (0 or 1)
        if (cur.trigger === 'preset_copy' || cur.rating <= 1) {
            score = cur.rating === 1 ? 5 : 1;
        }
        return acc + score;
    }, 0);

    const avgRating = ratedFeedbacks.length > 0
        ? (totalScore / ratedFeedbacks.length).toFixed(1)
        : '0.0';

    const recentCount = data.filter(f => {
        const date = new Date(f.created_at);
        const now = new Date();
        const diffTime = Math.abs(now.getTime() - date.getTime());
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        return diffDays <= 7;
    }).length;

    return (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            <Card>
                <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                    <CardTitle className="text-sm font-medium">Total Feedback</CardTitle>
                    <MessageSquare className="h-4 w-4 text-muted-foreground" />
                </CardHeader>
                <CardContent>
                    <div className="text-2xl font-bold">{totalCount}</div>
                    <p className="text-xs text-muted-foreground">누적 피드백 수</p>
                </CardContent>
            </Card>
            <Card>
                <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                    <CardTitle className="text-sm font-medium">Avg Rating</CardTitle>
                    <Star className="h-4 w-4 text-amber-500" />
                </CardHeader>
                <CardContent>
                    <div className="text-2xl font-bold">{avgRating}</div>
                    <p className="text-xs text-muted-foreground">평균 평점 (5.0 만점)</p>
                </CardContent>
            </Card>
            <Card>
                <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                    <CardTitle className="text-sm font-medium">Issues Reports</CardTitle>
                    <Bug className="h-4 w-4 text-red-500" />
                </CardHeader>
                <CardContent>
                    <div className="text-2xl font-bold">{bugCount}</div>
                    <p className="text-xs text-muted-foreground">버그/프롬프트 오류 신고</p>
                </CardContent>
            </Card>
            <Card>
                <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                    <CardTitle className="text-sm font-medium">This Week</CardTitle>
                    <Users className="h-4 w-4 text-emerald-500" />
                </CardHeader>
                <CardContent>
                    <div className="text-2xl font-bold">+{recentCount}</div>
                    <p className="text-xs text-muted-foreground">최근 7일 신규</p>
                </CardContent>
            </Card>
        </div>
    );
};
