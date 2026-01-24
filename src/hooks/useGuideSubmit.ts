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
                status: 'pending'
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

    return { submitGuide, isSubmitting };
}
