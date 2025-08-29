-- 1. 기존의 함수들을 확실하게 삭제합니다.
DROP FUNCTION IF EXISTS rate_model(bigint, uuid, real);
DROP FUNCTION IF EXISTS update_ai_model_rating();
DROP TRIGGER IF EXISTS on_rating_change ON public.ratings;

-- 2. UPDATE를 먼저 시도하고, 없으면 INSERT하는 방식으로 새 함수를 생성합니다.
CREATE OR REPLACE FUNCTION rate_model(model_id_param BIGINT, user_id_param UUID, new_rating REAL)
RETURNS void AS $$
DECLARE
  updated_rows INT;
BEGIN
    -- 먼저 ratings 테이블에 해당 유저와 모델에 대한 평가 기록이 있는지 찾아 UPDATE를 시도합니다.
    UPDATE public.ratings
    SET rating = new_rating, created_at = NOW()
    WHERE ai_model_id = model_id_param AND user_id = user_id_param;

    -- 방금 실행한 UPDATE가 실제로 행을 변경했는지 확인합니다.
    GET DIAGNOSTICS updated_rows = ROW_COUNT;

    -- 만약 변경된 행이 없다면(updated_rows = 0), 그것은 이 유저의 첫 평가이므로 INSERT를 실행합니다.
    IF updated_rows = 0 THEN
        INSERT INTO public.ratings (ai_model_id, user_id, rating)
        VALUES (model_id_param, user_id_param, new_rating);
    END IF;

    -- 마지막으로, ai_models 테이블의 평균 평점과 평가 수를 다시 계산하여 업데이트합니다.
    UPDATE public.ai_models
    SET
        rating_count = (
            SELECT COUNT(*)
            FROM public.ratings
            WHERE ai_model_id = model_id_param
        ),
        average_rating = (
            SELECT AVG(rating)
            FROM public.ratings
            WHERE ai_model_id = model_id_param
        )
    WHERE id = model_id_param;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;