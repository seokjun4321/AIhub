-- Fix AI Model ID Validation in approve_guide_submission
-- Ensures the ai_model_id exists before inserting into guides table

DROP FUNCTION IF EXISTS approve_guide_submission(UUID);

CREATE OR REPLACE FUNCTION approve_guide_submission(submission_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_submission RECORD;
    v_guide_data JSONB;
    v_metadata JSONB;
    v_blocks JSONB;
    v_prompts JSONB;
    v_new_guide_id BIGINT;
    v_category_id INTEGER;
    v_model_id INTEGER;
    v_block JSONB;
    v_idx INTEGER;

    v_children JSONB;
    v_child JSONB;
    v_child_idx INTEGER;
    v_constructed_content TEXT;
    v_child_text TEXT;
    v_child_type TEXT;
    v_tips_aggregated TEXT;
    v_checklist_source TEXT;
BEGIN
    SELECT * INTO v_submission FROM guide_submissions WHERE id = submission_id;

    IF v_submission IS NULL THEN
        RAISE EXCEPTION 'Submission not found';
    END IF;

    v_guide_data := v_submission.guide_data;
    v_metadata := v_guide_data->'metadata';
    v_blocks := v_guide_data->'blocks';
    v_prompts := v_guide_data->'prompts';

    v_category_id := COALESCE((v_metadata->>'categoryId')::INTEGER, 1);

    -- AI Model Logic with Validation
    v_model_id := NULL;

    -- 1. Try to get from metadata (global selection)
    IF v_metadata->>'aiModelId' IS NOT NULL AND (v_metadata->>'aiModelId')::INTEGER > 0 THEN
        -- Validate that this model actually exists
        SELECT id INTO v_model_id
        FROM ai_models
        WHERE id = (v_metadata->>'aiModelId')::INTEGER
        LIMIT 1;
    END IF;

    -- 2. If not found, fallback to first available model
    IF v_model_id IS NULL THEN
        SELECT id INTO v_model_id FROM ai_models ORDER BY id LIMIT 1;
    END IF;

    -- 3. Final safety check - if still no model, raise error
    IF v_model_id IS NULL THEN
        RAISE EXCEPTION 'No AI models available in database. Please add at least one AI model first.';
    END IF;

    INSERT INTO guides (
        title,
        category_id,
        ai_model_id,
        difficulty_level,
        estimated_time,
        description,
        tags,
        image_url
    ) VALUES (
        v_submission.title,
        v_category_id,
        v_model_id,
        COALESCE(v_metadata->>'difficulty', 'Beginner'),
        COALESCE(v_metadata->>'duration', '10 min'),
        COALESCE(v_metadata->>'summary', ''),
        COALESCE(
            (SELECT array_agg(x) FROM jsonb_array_elements_text(v_metadata->'tags') t(x)),
            ARRAY[]::text[]
        ),
        'https://placehold.co/600x400?text=Guide'
    ) RETURNING id INTO v_new_guide_id;

    -- 4. Overview Sections (Robust Split)
    -- Using chr(10) for newline and TRIM for whitespace/carriage-return cleanup

    INSERT INTO guide_sections (guide_id, section_order, section_type, title, content)
    VALUES (v_new_guide_id, 1, 'summary', '한 줄 요약', v_metadata->>'summary');

    -- Target Audience
    INSERT INTO guide_sections (guide_id, section_order, section_type, title, data)
    VALUES (v_new_guide_id, 2, 'target_audience', '이런 분께 추천',
        COALESCE(
            (
                SELECT jsonb_agg(REGEXP_REPLACE(TRIM(elem), '^([-*•]|\d+\.)\s*', ''))
                FROM unnest(string_to_array(v_metadata->>'targetAudience', chr(10))) AS elem
                WHERE TRIM(elem) <> ''
            ),
            '[]'::jsonb
        )
    );

    -- Requirements
    INSERT INTO guide_sections (guide_id, section_order, section_type, title, data)
    VALUES (v_new_guide_id, 3, 'preparation', '준비물',
        COALESCE(
            (
                SELECT jsonb_agg(REGEXP_REPLACE(TRIM(elem), '^([-*•]|\d+\.)\s*', ''))
                FROM unnest(string_to_array(v_metadata->>'requirements', chr(10))) AS elem
                WHERE TRIM(elem) <> ''
            ),
            '[]'::jsonb
        )
    );

    -- Core Principles
    INSERT INTO guide_sections (guide_id, section_order, section_type, title, data)
    VALUES (v_new_guide_id, 4, 'core_principles', '핵심 사용 원칙',
        COALESCE(
            (
                SELECT jsonb_agg(REGEXP_REPLACE(TRIM(elem), '^([-*•]|\d+\.)\s*', ''))
                FROM unnest(string_to_array(v_metadata->>'corePrinciples', chr(10))) AS elem
                WHERE TRIM(elem) <> ''
            ),
            '[]'::jsonb
        )
    );

    -- 5. Steps
    IF jsonb_array_length(v_blocks) > 0 THEN
        FOR v_idx IN 0..jsonb_array_length(v_blocks) - 1 LOOP
            v_block := v_blocks->v_idx;

            v_constructed_content := '';
            -- Combine Tips & Common Mistakes
            v_tips_aggregated := COALESCE(v_block->'content'->>'tips', '');
            IF COALESCE(v_block->'content'->>'commonMistakes', '') <> '' THEN
                IF v_tips_aggregated <> '' THEN v_tips_aggregated := v_tips_aggregated || E'\n'; END IF;
                v_tips_aggregated := v_tips_aggregated || (v_block->'content'->>'commonMistakes');
            END IF;

            v_children := v_block->'children';

            IF jsonb_array_length(v_children) > 0 THEN
                FOR v_child_idx IN 0..jsonb_array_length(v_children) - 1 LOOP
                     v_child := v_children->v_child_idx;
                     v_child_type := v_child->>'type';
                     v_child_text := COALESCE(v_child->'content'->>'text', '');

                     IF v_child_type = 'action' THEN
                        -- Action needs text
                        IF v_child_text <> '' THEN
                            v_constructed_content := v_constructed_content || E'\n\n#### (B) 해야 할 일\n' || v_child_text || E'\n\n';
                        END IF;

                     ELSIF v_child_type = 'branch' THEN
                          -- Structured to Markdown for Branch (Does not rely on 'text' field)
                          v_constructed_content := v_constructed_content || E'\n\n#### (E) Branch: 분기\n\n' ||
                              COALESCE(v_child->'content'->>'question', '') || E'\n\n' ||
                              '**' || COALESCE(v_child->'content'->>'optionA', 'Option A') || '**' || E'\n' ||
                              COALESCE(v_child->'content'->>'descriptionA', '') || E'\n\n' ||
                              '**' || COALESCE(v_child->'content'->>'optionB', 'Option B') || '**' || E'\n' ||
                              COALESCE(v_child->'content'->>'descriptionB', '') || E'\n\n';

                     ELSIF v_child_type = 'prompt' THEN
                        IF v_child_text <> '' THEN
                            v_constructed_content := v_constructed_content || E'\n\n' || '```' || E'\n' || v_child_text || E'\n' || '```' || E'\n\n';
                        END IF;

                     ELSIF v_child_type = 'tips' OR v_child_type = 'warning' THEN
                          IF v_child_text <> '' THEN
                              IF v_tips_aggregated <> '' THEN
                                  v_tips_aggregated := v_tips_aggregated || E'\n';
                              END IF;
                              v_tips_aggregated := v_tips_aggregated || v_child_text;
                          END IF;

                     ELSE
                         -- Fallback for text-based blocks
                         IF v_child_text <> '' THEN
                             v_constructed_content := v_constructed_content || v_child_text || E'\n\n';
                         END IF;
                     END IF;
                END LOOP;
            END IF;

            IF v_tips_aggregated <> '' THEN
                v_constructed_content := v_constructed_content || E'\n\n#### Tip\n' || v_tips_aggregated || E'\n\n';
            END IF;

            -- Combine Checklist & Mini Checklist
            v_checklist_source := COALESCE(v_block->'content'->>'checklist', '');
            IF COALESCE(v_block->'content'->>'miniChecklist', '') <> '' THEN
                IF v_checklist_source <> '' THEN v_checklist_source := v_checklist_source || E'\n'; END IF;
                v_checklist_source := v_checklist_source || (v_block->'content'->>'miniChecklist');
            END IF;

            INSERT INTO guide_steps (
                guide_id,
                step_order,
                title,
                goal,
                content,
                tips,
                done_when,
                checklist
            ) VALUES (
                v_new_guide_id,
                v_idx + 1,
                COALESCE(v_block->'content'->>'title', 'Step ' || (v_idx + 1)),
                COALESCE(v_block->'content'->>'goal', ''),
                TRIM(Both E'\n' FROM v_constructed_content),
                v_tips_aggregated,
                COALESCE(v_block->'content'->>'doneWhen', ''),

                -- Robust Checklist Split
                COALESCE(
                    (
                        SELECT jsonb_agg(
                            jsonb_build_object(
                                'id', 'chk_' || (v_idx + 1) || '_' || rn,
                                'text', final_text
                            )
                        )
                        FROM (
                            SELECT
                                CASE WHEN cleaned_text = '' THEN TRIM(elem) ELSE cleaned_text END as final_text,
                                row_number() OVER () as rn
                            FROM (
                                SELECT
                                    elem,
                                    REGEXP_REPLACE(TRIM(elem), '^([-*•]|\d+\.)\s*', '') as cleaned_text
                                FROM unnest(string_to_array(v_checklist_source, chr(10))) AS elem
                            ) raw_sub
                            WHERE TRIM(elem) <> ''
                        ) sub
                    ),
                    '[]'::jsonb
                )
            );
        END LOOP;
    END IF;

    IF jsonb_array_length(v_prompts) > 0 THEN
        INSERT INTO guide_sections (guide_id, section_order, section_type, title, data)
        VALUES (v_new_guide_id, 5, 'prompt_pack', '프롬프트 팩', v_prompts);
    END IF;

    UPDATE guide_submissions
    SET status = 'approved',
        reviewed_at = NOW()
    WHERE id = submission_id;

    RETURN jsonb_build_object('success', true, 'guide_id', v_new_guide_id);

EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object('success', false, 'error', SQLERRM);
END;
$$;
