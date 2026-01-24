
import { useState } from 'react';
import { supabase } from '@/integrations/supabase/client';
import { GuideBlock, GuideMetadata } from '@/components/guide-builder/GuideBuilderLayout';
import { useToast } from '@/hooks/use-toast';
import { PromptItem } from '@/components/guidebook/PromptPack';

export function useGuideSave() {
    const [isSaving, setIsSaving] = useState(false);
    const { toast } = useToast();

    const saveGuide = async (metadata: GuideMetadata, blocks: GuideBlock[], prompts: PromptItem[]) => {
        setIsSaving(true);
        try {
            const { data: { user } } = await supabase.auth.getUser();
            if (!user) {
                throw new Error("로그인이 필요합니다.");
            }

            // 1. Save Guide Metadata
            // For now, we assume creating a NEW guide or updating if we had an ID.
            // Since we don't have an ID in the builder yet, let's assume specific ID placeholder or generate one.
            // Actually, we should probably generate an ID or let the DB handle it.
            // But to keep it simple for this "Builder" demo, let's UPSERT based on a fixed ID or create new.
            // Let's create a NEW guide every time for now, or use a huge random number to avoid collision in this dev environment.
            // Ideally URL has /edit/:id.

            // For this implementation, we'll CREATE a new guide ID based on timestamp to avoid collisions
            // and log it.
            const guideId = Math.floor(Date.now() / 1000); // Integer ID

            // Mapping Difficulty to ENUM if needed, but schema says text usually? 
            // 20260110 says `difficulty_level` column.

            // Find category ID
            // We'll Default to a known category or create one implicitly? 
            // Better to fetch one.
            let categoryId = 1;
            const { data: categoryData } = await supabase.from('categories').select('id').limit(1).single();
            if (categoryData) categoryId = categoryData.id;

            // Find AI Model ID
            let aiModelId = 1;
            const { data: modelData } = await supabase.from('ai_models').select('id').limit(1).single();
            if (modelData) aiModelId = modelData.id;

            const { error: guideError } = await supabase.from('guides').upsert({
                id: guideId,
                title: metadata.title,
                description: metadata.summary, // Description usually holds the summary
                difficulty_level: metadata.difficulty.toLowerCase(),
                estimated_time: metadata.duration,
                tags: metadata.tags,
                author_id: user.id,
                category_id: categoryId,
                ai_model_id: aiModelId,
                // Defaults
                image_url: 'https://images.unsplash.com/photo-1553484771-371af27278d4',
                writing_purpose: 'created_by_builder'
            });

            if (guideError) throw guideError;

            // 2. Save Guide Sections (Metadata)
            const sectionsToSave = [
                {
                    guide_id: guideId,
                    section_order: 1,
                    section_type: 'summary',
                    title: '한 줄 요약',
                    content: metadata.summary
                },
                {
                    guide_id: guideId,
                    section_order: 2,
                    section_type: 'target_audience',
                    title: '이런 분께 추천',
                    data: JSON.stringify(metadata.targetAudience.split('\n').filter(Boolean))
                },
                {
                    guide_id: guideId,
                    section_order: 3,
                    section_type: 'preparation',
                    title: '준비물',
                    data: JSON.stringify(metadata.requirements.split('\n').filter(Boolean))
                },
                {
                    guide_id: guideId,
                    section_order: 4,
                    section_type: 'core_principles',
                    title: '핵심 사용 원칙',
                    data: JSON.stringify(metadata.corePrinciples.split('\n').filter(Boolean))
                }
            ];

            // Clean up existing sections first (iff updating, but here we are creating fresh ID so okay)
            // But if we reused ID, we should delete first. 
            // Let's just insert.
            const { error: sectionError } = await supabase.from('guide_sections').insert(sectionsToSave);
            if (sectionError) throw sectionError;

            // 3. Save Steps
            const steps = blocks.filter(b => b.type === 'step');
            const stepsToSave = steps.map((step, index) => {
                const stepOrder = index + 1;

                // Aggregate Children to Content (Markdown)
                let contentMd = "";
                const children = step.children || [];

                children.forEach(child => {
                    if (child.type === 'action') {
                        contentMd += `#### Action\n${child.content?.text || ''}\n\n`;
                    }
                    if (child.type === 'warning') {
                        contentMd += `> [!WARNING]\n> ${child.content?.text || ''}\n\n`;
                    }
                    if (child.type === 'image') {
                        // Placeholder for future image implementation
                        contentMd += `![Image](${child.content?.url || ''})\n\n`;
                    }
                });

                // Aggregate Tips
                let tipsMd = "";
                if (step.content?.commonMistakes) {
                    tipsMd += `### 자주하는 실수\n${step.content.commonMistakes}\n\n`;
                }
                children.forEach(child => {
                    if (child.type === 'tips') {
                        tipsMd += `### 팁\n${child.content?.text || ''}\n\n`;
                    }
                });

                // Checklist to JSONB
                const checklistRaw = step.content?.miniChecklist || "";
                const checklistItems = checklistRaw.split('\n').filter((t: string) => t.trim().length > 0).map((t: string, idx: number) => ({
                    id: `s${stepOrder}_c${idx}`,
                    text: t.replace(/^[•-]\s*/, '').trim()
                }));

                return {
                    guide_id: guideId,
                    step_order: stepOrder,
                    title: step.content?.title || `Step ${stepOrder}`,
                    goal: step.content?.goal,
                    done_when: step.content?.doneWhen,
                    content: contentMd,
                    tips: tipsMd,
                    checklist: JSON.stringify(checklistItems)
                };
            });

            if (stepsToSave.length > 0) {
                const { error: stepsError } = await supabase.from('guide_steps').insert(stepsToSave);
                if (stepsError) throw stepsError;
            }

            // 4. Save Prompt Pack (as a Section)
            // Collect all prompts from blocks (steps -> children -> prompt)
            // AND the global prompts state if any (though currently Builder might duplicate logic)
            // The `prompts` argument passed to this function is the source of truth for the 'Prompt Pack' tab.

            // Need to map PromptItem to the schema expected by `prompt_pack` section
            const promptPackData = prompts.map(p => ({
                id: p.id,
                title: p.title,
                description: p.description,
                prompt: p.prompt,
                failurePatterns: p.failurePatterns,
                relatedStep: p.relatedStep
            }));

            if (promptPackData.length > 0) {
                const { error: promptError } = await supabase.from('guide_sections').insert({
                    guide_id: guideId,
                    section_order: 5, // After core principles
                    section_type: 'prompt_pack',
                    title: '프롬프트 팩',
                    data: JSON.stringify(promptPackData)
                });
                if (promptError) throw promptError;
            }

            toast({
                title: "저장 성공!",
                description: "가이드북이 성공적으로 저장되었습니다.",
                variant: "default",
            });

        } catch (error: any) {
            console.error(error);
            toast({
                title: "저장 실패",
                description: error.message || "알 수 없는 오류가 발생했습니다.",
                variant: "destructive",
            });
        } finally {
            setIsSaving(false);
        }
    };

    return { saveGuide, isSaving };
}
