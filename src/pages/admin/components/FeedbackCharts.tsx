import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { FeedbackData } from '../FeedbackDashboard';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Cell, AreaChart, Area } from 'recharts';

interface FeedbackChartsProps {
    data: FeedbackData[];
    type: 'category' | 'timeline';
}

export const FeedbackCharts = ({ data, type }: FeedbackChartsProps) => {

    // 1. Category Issues Analysis
    if (type === 'category') {
        const issuesOnly = data.filter(d => ['bug', 'prompt_error', 'content_confusing', 'tool_diff'].includes(d.category || ''));
        const counts: Record<string, number> = {};
        issuesOnly.forEach(d => {
            const key = d.category || 'unknown';
            counts[key] = (counts[key] || 0) + 1;
        });

        const chartData = Object.entries(counts).map(([name, value]) => ({
            name: name.replace('_', ' ').toUpperCase(), value
        })).sort((a, b) => b.value - a.value);

        return (
            <Card>
                <CardHeader>
                    <CardTitle className="text-sm font-semibold text-slate-700">이슈 유형 분석</CardTitle>
                </CardHeader>
                <CardContent className="h-[300px]">
                    <ResponsiveContainer width="100%" height="100%">
                        <BarChart data={chartData} layout="vertical" margin={{ top: 5, right: 30, left: 40, bottom: 5 }}>
                            <CartesianGrid strokeDasharray="3 3" horizontal={true} vertical={false} stroke="#E2E8F0" />
                            <XAxis type="number" hide />
                            <YAxis dataKey="name" type="category" width={100} tick={{ fontSize: 10 }} interval={0} />
                            <Tooltip
                                contentStyle={{ borderRadius: '8px', border: 'none', boxShadow: '0 4px 12px rgba(0,0,0,0.1)' }}
                                cursor={{ fill: '#F1F5F9' }}
                            />
                            <Bar dataKey="value" fill="#0F172A" barSize={20} radius={[0, 4, 4, 0]}>
                                {chartData.map((entry, index) => (
                                    <Cell key={`cell-${index}`} fill={['#EF4444', '#F59E0B', '#3B82F6', '#64748B'][index % 4]} />
                                ))}
                            </Bar>
                        </BarChart>
                    </ResponsiveContainer>
                </CardContent>
            </Card>
        );
    }

    // 2. Weekly Trend (Mocked Logic for cleanliness, but simplified)
    const sortedData = [...data].sort((a, b) => new Date(a.created_at).getTime() - new Date(b.created_at).getTime());

    // Group by Day (Last 7 days)
    const dailyCounts: Record<string, number> = {};
    const now = new Date();
    for (let i = 6; i >= 0; i--) {
        const d = new Date(now);
        d.setDate(d.getDate() - i);
        const key = d.toISOString().split('T')[0].slice(5); // MM-DD
        dailyCounts[key] = 0;
    }

    sortedData.forEach(d => {
        const dateStr = d.created_at.split('T')[0].slice(5);
        if (dailyCounts[dateStr] !== undefined) {
            dailyCounts[dateStr]++;
        }
    });

    const timelineData = Object.entries(dailyCounts).map(([date, count]) => ({ date, count }));

    return (
        <Card>
            <CardHeader>
                <CardTitle className="text-sm font-semibold text-slate-700">주간 피드백 추이</CardTitle>
            </CardHeader>
            <CardContent className="h-[300px]">
                <ResponsiveContainer width="100%" height="100%">
                    <AreaChart data={timelineData} margin={{ top: 10, right: 30, left: 0, bottom: 0 }}>
                        <defs>
                            <linearGradient id="colorCount" x1="0" y1="0" x2="0" y2="1">
                                <stop offset="5%" stopColor="#10B981" stopOpacity={0.2} />
                                <stop offset="95%" stopColor="#10B981" stopOpacity={0} />
                            </linearGradient>
                        </defs>
                        <XAxis dataKey="date" tick={{ fontSize: 12 }} stroke="#94A3B8" />
                        <YAxis tick={{ fontSize: 12 }} stroke="#94A3B8" />
                        <Tooltip />
                        <Area type="monotone" dataKey="count" stroke="#10B981" fillOpacity={1} fill="url(#colorCount)" strokeWidth={2} />
                    </AreaChart>
                </ResponsiveContainer>
            </CardContent>
        </Card>
    );
};
