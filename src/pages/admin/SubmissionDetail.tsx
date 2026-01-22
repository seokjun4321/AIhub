import { useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import Navbar from "@/components/ui/navbar";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle, CardDescription, CardFooter } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Textarea } from "@/components/ui/textarea";
import { Separator } from "@/components/ui/separator";
import { ChevronLeft, CheckCircle2, XCircle, ExternalLink } from "lucide-react";
import { useToast } from "@/components/ui/use-toast";
import { format } from "date-fns";

interface Submission {
    id: string;
    type: 'prompt' | 'agent' | 'workflow' | 'template' | 'design';
    title: string;
    status: 'pending' | 'approved' | 'rejected';
    content: any;
    images: string[];
    user_id: string;
    submitted_at: string;
    reviewed_at?: string;
    admin_notes?: string;
}

const SubmissionDetail = () => {
    const { id } = useParams();
    const navigate = useNavigate();
    const { toast } = useToast();
    const [adminNotes, setAdminNotes] = useState("");
    const [isProcessing, setIsProcessing] = useState(false);

    const { data: submission, isLoading, refetch } = useQuery({
        queryKey: ['submission', id],
        queryFn: async () => {
            const { data, error } = await supabase
                .from('content_submissions' as any)
                .select('*')
                .eq('id', id)
                .single();

            if (error) throw error;
            return data as unknown as Submission;
        },
        enabled: !!id
    });

    const handleApprove = async () => {
        if (!submission) return;
        if (!confirm("정말 이 콘텐츠를 승인하시겠습니까? 승인 시 즉시 스토어에 등록됩니다.")) return;
        setIsProcessing(true);

        try {
            const content = submission.content;
            // Fetch author profile for better display name
            const { data: profile } = await supabase
                .from('profiles')
                .select('username, full_name')
                .eq('id', submission.user_id)
                .single();

            const authorName = profile?.username || profile?.full_name || "알수없음";

            const commonFields = {
                title: submission.title,
                one_liner: content.one_liner,
                price: content.price || 0,
                author: authorName, // Use nickname instead of UUID
                user_id: submission.user_id, // Link to actual user profile
                created_at: new Date().toISOString()
            };

            let insertError = null;


            // 1. Insert into target table based on type
            if (submission.type === 'prompt') {
                // Generate badges based on difficulty
                let badges = [];
                if (content.difficulty === 'Beginner') badges.push({ text: "초급", color: "green" });
                else if (content.difficulty === 'Intermediate') badges.push({ text: "중급", color: "blue" });
                else if (content.difficulty === 'Advanced') badges.push({ text: "고급", color: "red" });

                const { error } = await supabase.from('preset_prompt_templates' as any).insert({
                    ...commonFields,
                    // category: 'General', // Column does not exist
                    prompt: content.prompt,
                    description: content.one_liner, // simplified mapping
                    example_io: content.example_io,
                    difficulty: content.difficulty,
                    compatible_tools: content.compatible_tools,
                    tips: content.tips,
                    prompt_en: content.prompt_en,
                    variables: content.variables,
                    tags: content.tags, // Added tags mapping
                    badges: badges.length > 0 ? badges : null
                });
                insertError = error;
            }
            else if (submission.type === 'agent') {
                // IMPORTANT: Map platform name to strictly match DB constraint (GPT, Claude, Gemini, Perplexity)
                let platformName = content.platform || 'GPT';
                if (platformName === 'ChatGPT') platformName = 'GPT';
                if (platformName === 'ChatGPT (GPTs)') platformName = 'GPT';
                if (platformName === 'Gemini (Gems)') platformName = 'Gemini';

                // Fetch related AI Model ID
                let relatedModelIds = [];
                // Map platform to search query for AI Model ID
                const modelQueryName = platformName === 'GPT' ? 'ChatGPT' : platformName;

                const { data: aiModel } = await supabase
                    .from('ai_models')
                    .select('id')
                    .ilike('name', `%${modelQueryName}%`)
                    .limit(1)
                    .single();

                if (aiModel) {
                    relatedModelIds.push(aiModel.id);
                }

                const { error } = await supabase.from('preset_agents' as any).insert({
                    ...commonFields,
                    description: content.one_liner,
                    url: content.url,
                    instructions: content.instructions,
                    capabilities: content.capabilities,
                    requirements: content.requirements,
                    example_questions: content.example_questions,
                    example_conversation: content.example_conversation,
                    platform: platformName,
                    related_ai_model_ids: relatedModelIds
                });
                insertError = error;
            }
            else if (submission.type === 'workflow') {
                const { error } = await supabase.from('preset_workflows' as any).insert({
                    ...commonFields,
                    description: content.description || content.one_liner,
                    complexity: content.complexity,
                    duration: content.duration,
                    apps: content.apps, // Already mapped in frontend
                    diagram_url: content.diagram_url,
                    download_url: content.download_url,
                    steps: content.steps,
                    requirements: content.requirements,
                    warnings: content.warnings,
                    platform: content.platform, // Added platform
                    import_info: content.import_info, // Added import info
                    related_ai_model_ids: content.related_ai_model_id ? [content.related_ai_model_id] : []
                });
                insertError = error;
            }
            else if (submission.type === 'template') {
                const { error } = await supabase.from('preset_templates' as any).insert({
                    ...commonFields,
                    category: (content.format === 'Google Sheets') ? 'Sheets' : (content.format || 'Other'),
                    duplicate_url: content.url,
                    setup_steps: content.setup_steps,
                    includes: content.includes || [], // Map includes
                    description: content.description || content.one_liner, // Detailed description
                    image_url: submission.images && submission.images.length > 0 ? submission.images[0] : null, // First image as main
                    preview_images: submission.images, // All images for preview slider
                    related_ai_model_ids: content.related_ai_model_id ? [content.related_ai_model_id] : []
                });
                insertError = error;
            }
            else if (submission.type === 'design') {
                // Determine images based on Generation Type
                // Text-to-Image: image_url = After Image (Result), after_image_url = NULL
                // Image-to-Image: image_url = Before Image (Source), after_image_url = After Image (Result)

                let mainImageUrl = content.after_image;
                let afterImageUrl = null;

                if (content.generation_type === 'image-to-image') {
                    mainImageUrl = content.before_image;
                    afterImageUrl = content.after_image;
                }

                // ALSO: Check if we have params to find related Model ID like we did for Agent
                // For now, defaulting tool to 'Midjourney' as placeholder or extracting from params? 
                // The user didn't ask for Model ID linking here yet, but good to keep in mind.

                const { error } = await supabase.from('preset_designs' as any).insert({
                    ...commonFields,
                    prompt_text: content.prompt_text,
                    image_url: mainImageUrl,
                    after_image_url: afterImageUrl,
                    description: content.description || content.one_liner, // Use detailed description
                    input_tips: content.input_tips, // Map input_tips
                    related_ai_model_ids: content.related_ai_model_id ? [content.related_ai_model_id] : [], // Map related AI model
                    params: [
                        { key: "Generation Type", value: content.generation_type === 'image-to-image' ? 'Image-to-Image' : 'Text-to-Image' },
                        { key: "Model Info", value: content.model_info },
                        { key: "Aspect Ratio", value: content.aspect_ratio }
                    ].filter(item => item.value) // Filter out empty values
                });
                insertError = error;
            }

            if (insertError) throw insertError;

            // 2. Update submission status
            const { error: updateError } = await supabase
                .from('content_submissions' as any)
                .update({
                    status: 'approved',
                    reviewed_at: new Date().toISOString(),
                    admin_notes: adminNotes
                })
                .eq('id', id);

            if (updateError) throw updateError;

            toast({ title: "승인 완료", description: "콘텐츠가 스토어에 등록되었습니다." });
            refetch();

        } catch (error: any) {
            console.error(error);
            toast({ title: "처리 실패", description: error.message, variant: "destructive" });
        } finally {
            setIsProcessing(false);
        }
    };

    const handleReject = async () => {
        if (!submission) return;

        if (!adminNotes) {
            toast({ title: "반려 사유 입력 필요", description: "관리자 노트에 반려 사유를 적어주세요.", variant: "destructive" });
            return;
        }
        if (!confirm("정말 반려하시겠습니까?")) return;
        setIsProcessing(true);

        try {
            const { error } = await supabase
                .from('content_submissions' as any)
                .update({
                    status: 'rejected',
                    reviewed_at: new Date().toISOString(),
                    admin_notes: adminNotes
                })
                .eq('id', id);

            if (error) throw error;

            toast({ title: "반려 완료", description: "제출 상태가 반려로 변경되었습니다." });
            refetch();
        } catch (error: any) {
            toast({ title: "오류 발생", description: error.message, variant: "destructive" });
        } finally {
            setIsProcessing(false);
        }
    };

    if (isLoading) return <div className="p-10 text-center">Loading...</div>;
    if (!submission) return <div className="p-10 text-center">Submission not found</div>;

    const content = submission.content || {};

    return (
        <div className="min-h-screen bg-muted/40 pb-20">
            <Navbar />
            <div className="container mx-auto py-10 px-6 max-w-5xl">
                <Button variant="ghost" className="mb-6 pl-0 hover:bg-transparent" onClick={() => navigate('/admin/submissions')}>
                    <ChevronLeft className="w-4 h-4 mr-2" /> 목록으로 돌아가기
                </Button>

                <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
                    {/* Left: Content Detail */}
                    <div className="lg:col-span-2 space-y-6">
                        <Card>
                            <CardHeader>
                                <div className="flex justify-between items-start">
                                    <div>
                                        <Badge variant="outline" className="mb-2 capitalize">{submission.type}</Badge>
                                        <CardTitle className="text-2xl">{submission.title}</CardTitle>
                                        <CardDescription className="mt-1">
                                            제출일: {format(new Date(submission.submitted_at), "yyyy-MM-dd HH:mm")}
                                        </CardDescription>
                                    </div>
                                    <Badge className={
                                        submission.status === 'approved' ? 'bg-green-500' :
                                            submission.status === 'rejected' ? 'bg-red-500' : 'bg-yellow-500'
                                    }>
                                        {submission.status.toUpperCase()}
                                    </Badge>
                                </div>
                            </CardHeader>
                            <CardContent className="space-y-6">
                                {/* Images */}
                                {submission.images && submission.images.length > 0 && (
                                    <div className="grid grid-cols-2 gap-4">
                                        {submission.images.map((img, idx) => (
                                            <img key={idx} src={img} alt={`Preview ${idx}`} className="rounded-lg border w-full h-auto object-cover" />
                                        ))}
                                    </div>
                                )}

                                <Separator />

                                <div className="grid grid-cols-2 gap-4 text-sm">
                                    <div>
                                        <div className="font-semibold text-muted-foreground mb-1">가격</div>
                                        <div>{content.price ? `${content.price.toLocaleString()}원` : "무료"}</div>
                                    </div>
                                    <div>
                                        <div className="font-semibold text-muted-foreground mb-1">작성자 ID</div>
                                        <div className="font-mono text-xs">{submission.user_id}</div>
                                    </div>
                                    <div>
                                        <div className="font-semibold text-muted-foreground mb-1">한 줄 소개</div>
                                        <div>{content.one_liner}</div>
                                    </div>
                                    <div>
                                        <div className="font-semibold text-muted-foreground mb-1">태그</div>
                                        <div className="flex gap-2 flex-wrap">
                                            {content.tags?.map((t: string) => <Badge key={t} variant="secondary">{t}</Badge>)}
                                        </div>
                                    </div>
                                </div>

                                <Separator />

                                {/* Dynamic Content View */}
                                <div className="bg-slate-50 p-4 rounded-lg border text-sm font-mono whitespace-pre-wrap overflow-x-auto">
                                    <h4 className="font-bold text-slate-700 mb-2 font-sans">Raw Content Data</h4>
                                    {JSON.stringify(content, null, 2)}
                                </div>
                            </CardContent>
                        </Card>
                    </div>

                    {/* Right: Admin Actions */}
                    <div className="space-y-6">
                        <Card>
                            <CardHeader>
                                <CardTitle>관리자 검토</CardTitle>
                            </CardHeader>
                            <CardContent className="space-y-4">
                                <div className="space-y-2">
                                    <label className="text-sm font-medium">관리자 노트 (반려 사유)</label>
                                    <Textarea
                                        placeholder="반려 시 사유를 입력하거나, 승인 시 참고사항을 적으세요."
                                        rows={5}
                                        value={adminNotes}
                                        onChange={(e) => setAdminNotes(e.target.value)}
                                        disabled={submission.status !== 'pending'}
                                    />
                                </div>

                                {submission.status === 'pending' && (
                                    <div className="flex gap-3 pt-4">
                                        <Button
                                            variant="outline"
                                            className="w-full border-red-200 text-red-600 hover:bg-red-50 hover:text-red-700"
                                            onClick={handleReject}
                                            disabled={isProcessing}
                                        >
                                            <XCircle className="w-4 h-4 mr-2" /> 반려
                                        </Button>
                                        <Button
                                            className="w-full bg-green-600 hover:bg-green-700"
                                            onClick={handleApprove}
                                            disabled={isProcessing}
                                        >
                                            <CheckCircle2 className="w-4 h-4 mr-2" /> 승인
                                        </Button>
                                    </div>
                                )}
                            </CardContent>
                            <CardFooter className="bg-muted/20 text-xs text-muted-foreground p-4">
                                {submission.status === 'approved' && <div className="flex items-center gap-2 text-green-600"><CheckCircle2 className="w-4 h-4" /> 이미 승인된 항목입니다.</div>}
                                {submission.status === 'rejected' && <div className="flex items-center gap-2 text-red-600"><XCircle className="w-4 h-4" /> 이미 반려된 항목입니다.</div>}
                            </CardFooter>
                        </Card>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default SubmissionDetail;
