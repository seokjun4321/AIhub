import { useState } from 'react';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from "@/components/ui/dialog";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { FeedbackData } from '../FeedbackDashboard';
import { format } from 'date-fns';
import { Eye, ExternalLink, Filter } from 'lucide-react';

interface FeedbackTableProps {
    data: FeedbackData[];
}

export const FeedbackTable = ({ data }: FeedbackTableProps) => {
    const [filter, setFilter] = useState('all');
    const [selectedFeedback, setSelectedFeedback] = useState<FeedbackData | null>(null);

    const filteredData = data.filter(d => {
        if (filter === 'all') return true;
        if (filter === 'bug') return d.category === 'bug' || d.category === 'prompt_error';
        if (filter === 'guidebook') return d.trigger === 'guidebook_complete';
        if (filter === 'micro') return d.trigger === 'preset_copy';
        return true;
    });

    const getCategoryBadge = (category: string, trigger: string) => {
        if (trigger === 'preset_copy') return <Badge variant="outline" className="text-slate-500">Micro</Badge>;

        switch (category) {
            case 'bug': return <Badge className="bg-red-100 text-red-800 hover:bg-red-200">Bug</Badge>;
            case 'prompt_error': return <Badge className="bg-red-100 text-red-800 hover:bg-red-200">Prompt Err</Badge>;
            case 'feature': return <Badge className="bg-amber-100 text-amber-800 hover:bg-amber-200">Feature</Badge>;
            case 'content_confusing': return <Badge className="bg-blue-100 text-blue-800 hover:bg-blue-200">Content</Badge>;
            default: return <Badge variant="secondary" className="bg-slate-100 text-slate-600">{category}</Badge>;
        }
    };

    return (
        <div className="space-y-4">
            {/* Toolbar */}
            <div className="flex justify-between items-center">
                <div className="flex items-center gap-2">
                    <Filter className="w-4 h-4 text-slate-500" />
                    <Select value={filter} onValueChange={setFilter}>
                        <SelectTrigger className="w-[180px]">
                            <SelectValue placeholder="Filter by type" />
                        </SelectTrigger>
                        <SelectContent>
                            <SelectItem value="all">All Feedbacks</SelectItem>
                            <SelectItem value="bug">Issues Only</SelectItem>
                            <SelectItem value="guidebook">Guidebook Only</SelectItem>
                            <SelectItem value="micro">Micro Feedback</SelectItem>
                        </SelectContent>
                    </Select>
                </div>
                <div className="text-sm text-slate-500">
                    Showing {filteredData.length} entries
                </div>
            </div>

            {/* Data Table */}
            <div className="rounded-md border">
                <Table>
                    <TableHeader>
                        <TableRow className="bg-slate-50/50">
                            <TableHead className="w-[100px]">Type</TableHead>
                            <TableHead>Category</TableHead>
                            <TableHead>Message / Entity</TableHead>
                            <TableHead className="w-[100px]">Rating</TableHead>
                            <TableHead className="w-[150px]">Date</TableHead>
                            <TableHead className="w-[80px]">Action</TableHead>
                        </TableRow>
                    </TableHeader>
                    <TableBody>
                        {filteredData.slice(0, 10).map((feedback) => (
                            <TableRow key={feedback.id}>
                                <TableCell className="font-medium text-xs text-slate-500 uppercase">
                                    {feedback.trigger.replace('_', ' ')}
                                </TableCell>
                                <TableCell>
                                    {getCategoryBadge(feedback.category || 'N/A', feedback.trigger)}
                                </TableCell>
                                <TableCell className="max-w-[300px]">
                                    <div className="truncate font-medium text-slate-700">
                                        {feedback.message || (feedback.entity_id ? `Ref: ${feedback.entity_id.slice(0, 20)}...` : '-')}
                                    </div>
                                    <div className="text-xs text-slate-400 truncate">
                                        {feedback.page_url}
                                    </div>
                                </TableCell>
                                <TableCell>
                                    {feedback.rating !== null ? (
                                        <span className={feedback.rating >= 4 || feedback.rating === 1 ? "text-emerald-600 font-bold" : "text-slate-400"}>
                                            {feedback.rating === 1 && feedback.trigger === 'preset_copy' ? '👍' :
                                                feedback.rating === 0 && feedback.trigger === 'preset_copy' ? '👎' :
                                                    `⭐ ${feedback.rating}`}
                                        </span>
                                    ) : '-'}
                                </TableCell>
                                <TableCell className="text-slate-500 text-sm">
                                    {format(new Date(feedback.created_at), 'MM-dd HH:mm')}
                                </TableCell>
                                <TableCell>
                                    <Button variant="ghost" size="sm" onClick={() => setSelectedFeedback(feedback)}>
                                        <Eye className="w-4 h-4 text-slate-400 hover:text-slate-900" />
                                    </Button>
                                </TableCell>
                            </TableRow>
                        ))}
                        {filteredData.length === 0 && (
                            <TableRow>
                                <TableCell colSpan={6} className="h-24 text-center text-slate-500">
                                    No feedback found.
                                </TableCell>
                            </TableRow>
                        )}
                    </TableBody>
                </Table>
            </div>

            {/* Detail Dialog */}
            <Dialog open={!!selectedFeedback} onOpenChange={() => setSelectedFeedback(null)}>
                <DialogContent className="max-w-2xl">
                    <DialogHeader>
                        <DialogTitle>Feedback Detail</DialogTitle>
                        <DialogDescription>
                            Created at {selectedFeedback && format(new Date(selectedFeedback.created_at), 'yyyy-MM-dd HH:mm:ss')}
                        </DialogDescription>
                    </DialogHeader>

                    {selectedFeedback && (
                        <div className="grid gap-4 py-4">
                            <div className="grid grid-cols-2 gap-4">
                                <div className="space-y-1">
                                    <label className="text-xs font-bold text-slate-500 uppercase">User</label>
                                    <div className="text-sm">{selectedFeedback.user_id?.slice(0, 8) || 'Anonymous'}</div>
                                </div>
                                <div className="space-y-1">
                                    <label className="text-xs font-bold text-slate-500 uppercase">Page URL</label>
                                    <div className="text-sm truncate text-blue-600 hover:underline cursor-pointer" onClick={() => window.open(selectedFeedback.page_url, '_blank')}>
                                        {selectedFeedback.page_url} <ExternalLink className="w-3 h-3 inline ml-1" />
                                    </div>
                                </div>
                            </div>

                            <div className="space-y-1 p-4 bg-slate-50 rounded-lg border">
                                <label className="text-xs font-bold text-slate-500 uppercase block mb-2">Message</label>
                                <p className="text-sm whitespace-pre-wrap leading-relaxed">
                                    {selectedFeedback.message || 'No written message.'}
                                </p>
                            </div>

                            <div className="grid grid-cols-2 gap-4 text-xs text-slate-500">
                                <div>Trigger: {selectedFeedback.trigger}</div>
                                <div>Entity ID: {selectedFeedback.entity_id}</div>
                                <div>Category: {selectedFeedback.category}</div>
                                <div>User Agent: {selectedFeedback.metadata?.userAgent?.slice(0, 30)}...</div>
                            </div>
                        </div>
                    )}
                </DialogContent>
            </Dialog>
        </div>
    );
};
