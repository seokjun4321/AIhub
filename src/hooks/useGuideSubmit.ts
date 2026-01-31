import { useState } from 'react';
import { supabase } from '@/integrations/supabase/client';
import { GuideBlock, GuideMetadata } from '@/components/guide-builder/GuideBuilderLayout';
import { useToast } from '@/hooks/use-toast';
import { PromptItem } from '@/components/guidebook/PromptPack';

export function useGuideSubmit() {
    const [isSubmitting, setIsSubmitting] = useState(false);
    const { toast } = useToast();

    const submitGuide = async (metadata: GuideMetadata, blocks: GuideBlock[], prompts: PromptItem[]) => {
        setIsSubmitting(true);
        try {
            const { data: { user } } = await supabase.auth.getUser();
            if (!user) {
                throw new Error("로그인이 필요합니다.");
            }

            // Validate required fields
            if (!metadata.title) {
                throw new Error("가이드 제목을 입력해주세요.");
            }
            if (!metadata.categoryId) {
                throw new Error("카테고리를 선택해주세요.");
            }

            // Submit to guide_submissions table
            // @ts-ignore - guide_submissions not in generated types yet
            const { error } = await supabase.from('guide_submissions').insert({
                user_id: user.id,
                guide_data: {
                    metadata,
                    blocks,
                    prompts
                },
                status: 'pending',
                title: metadata.title,
                category: metadata.categoryId?.toString() || 'Uncategorized',
                submission_type: metadata.submissionType || 'new',
                original_guide_id: metadata.originalGuideId || null
            });

            if (error) throw error;

            toast({
                title: "제출 완료!",
                description: "가이드북이 제출되었습니다. 관리자 승인 후 공개됩니다.",
                variant: "default",
            });

        } catch (error: any) {
            console.error(error);
            toast({
                title: "제출 실패",
                description: error.message || "알 수 없는 오류가 발생했습니다.",
                variant: "destructive",
            });
        } finally {
            setIsSubmitting(false);
        }
    };

    const saveDraft = async (metadata: GuideMetadata, blocks: GuideBlock[], prompts: PromptItem[], draftId?: string) => {
        setIsSubmitting(true);
        try {
            const { data: { user } } = await supabase.auth.getUser();
            if (!user) throw new Error("로그인이 필요합니다.");

            if (!metadata.title) {
                // Drafts should at least have a title to be identified
                throw new Error("임시 저장을 위해 제목을 입력해주세요.");
            }

            const submissionData = {
                user_id: user.id,
                guide_data: {
                    metadata,
                    blocks,
                    prompts
                },
                status: 'draft',
                title: metadata.title,
                category: metadata.categoryId?.toString() || 'Uncategorized',
                submission_type: metadata.submissionType || 'new',
                original_guide_id: metadata.originalGuideId || null
            };

            let data, error;

            if (draftId) {
                // Update existing draft - exclude user_id to avoid permission issues
                const { user_id, ...updateData } = submissionData;
                const result = await supabase
                    .from('guide_submissions' as any)
                    .update(updateData)
                    .eq('id', draftId)
                    .select()
                    .single();
                data = result.data;
                error = result.error;
            } else {
                // Create new draft
                const result = await supabase
                    .from('guide_submissions' as any)
                    .insert(submissionData)
                    .select()
                    .single();
                data = result.data;
                error = result.error;
            }

            if (error) throw error;

            toast({
                title: "임시 저장 완료",
                description: "가이드북이 임시 저장되었습니다.",
                variant: "default",
            });

            return data?.id; // Return ID so UI can update URL

        } catch (error: any) {
            console.error(error);
            toast({
                title: "저장 실패",
                description: error.message || "알 수 없는 오류가 발생했습니다.",
                variant: "destructive",
            });
            return null;
        } finally {
            setIsSubmitting(false);
        }
    };

    return { submitGuide, saveDraft, isSubmitting };
}
