import { useEffect, useState } from 'react';
import { supabase } from '@/integrations/supabase/client';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Loader2, MessageSquare, Bug, ThumbsUp, AlertCircle } from 'lucide-react';
import { FeedbackStats } from './components/FeedbackStats';
import { FeedbackCharts } from './components/FeedbackCharts';
import { FeedbackTable } from './components/FeedbackTable';

export interface FeedbackData {
    id: string;
    created_at: string;
    trigger: string;
    entity_type: string;
    entity_id: string;
    step_id: string;
    category: string;
    rating: number;
    message: string;
    page_url: string;
    metadata: any;
    user_id: string;
}

export const FeedbackDashboard = () => {
    const [feedbacks, setFeedbacks] = useState<FeedbackData[]>([]);
    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        fetchFeedbacks();
    }, []);

    const fetchFeedbacks = async () => {
        setIsLoading(true);
        try {
            const { data, error } = await supabase
                .from('feedbacks')
                .select('*')
                .order('created_at', { ascending: false });

            if (error) throw error;
            setFeedbacks(data || []);
        } catch (error) {
            console.error('Error fetching feedbacks:', error);
        } finally {
            setIsLoading(false);
        }
    };

    if (isLoading) {
        return (
            <div className="flex h-screen items-center justify-center">
                <Loader2 className="w-8 h-8 animate-spin text-slate-400" />
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-slate-50/50 p-8 space-y-8">
            <div className="max-w-7xl mx-auto space-y-8">

                {/* Header */}
                <div>
                    <h1 className="text-3xl font-bold text-slate-900 tracking-tight">Feedback Dashboard</h1>
                    <p className="text-slate-500 mt-2">사용자 피드백 현황을 한눈에 파악하세요.</p>
                </div>

                {/* 1. Stats Cards */}
                <FeedbackStats data={feedbacks} />

                {/* 2. Charts */}
                <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                    <FeedbackCharts data={feedbacks} type="category" />
                    <FeedbackCharts data={feedbacks} type="timeline" />
                </div>

                {/* 3. Detailed Table */}
                <Card className="border-slate-200 shadow-sm">
                    <CardHeader>
                        <CardTitle className="flex items-center gap-2">
                            <MessageSquare className="w-5 h-5 text-slate-500" />
                            최근 피드백 리스트
                        </CardTitle>
                    </CardHeader>
                    <CardContent>
                        <FeedbackTable data={feedbacks} />
                    </CardContent>
                </Card>

            </div>
        </div>
    );
};

export default FeedbackDashboard;
