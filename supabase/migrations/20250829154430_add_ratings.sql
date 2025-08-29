-- 1. 평점을 저장할 ratings 테이블 생성
CREATE TABLE ratings (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    ai_model_id BIGINT NOT NULL REFERENCES public.ai_models(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    rating REAL NOT NULL CHECK (rating >= 0 AND rating <= 5),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (ai_model_id, user_id) -- 한 사용자는 한 모델에 한 번만 평점을 매길 수 있도록 설정
);

-- RLS (Row Level Security) 설정
ALTER TABLE public.ratings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow authenticated users to manage their own ratings" 
ON public.ratings
FOR ALL
USING (auth.uid() = public.ratings.user_id) -- public.ratings 테이블의 user_id임을 명시
WITH CHECK (auth.uid() = public.ratings.user_id); -- 여기도 동일하게 수정

CREATE POLICY "Allow all users to read ratings"
ON public.ratings
FOR SELECT
USING (true);


-- 2. ai_models 테이블에 평균 평점과 평가 수를 저장할 컬럼 추가
ALTER TABLE public.ai_models
ADD COLUMN average_rating REAL NOT NULL DEFAULT 0,
ADD COLUMN rating_count INT NOT NULL DEFAULT 0;


-- 3. 평점이 변경될 때마다 ai_models 테이블을 자동으로 업데이트하는 함수 생성
CREATE OR REPLACE FUNCTION update_ai_model_rating()
RETURNS TRIGGER AS $$
BEGIN
    -- 평점이 추가, 수정, 삭제된 ai_model_id에 대해 평균 평점과 평가 수를 다시 계산
    UPDATE public.ai_models
    SET
        rating_count = (
            SELECT COUNT(*)
            FROM public.ratings
            WHERE ai_model_id = COALESCE(NEW.ai_model_id, OLD.ai_model_id)
        ),
        average_rating = (
            SELECT AVG(rating)
            FROM public.ratings
            WHERE ai_model_id = COALESCE(NEW.ai_model_id, OLD.ai_model_id)
        )
    WHERE id = COALESCE(NEW.ai_model_id, OLD.ai_model_id);

    RETURN NULL; -- 결과는 중요하지 않으므로 NULL 반환
END;
$$ LANGUAGE plpgsql;


-- 4. ratings 테이블에 데이터 변경이 있을 때마다 위 함수를 실행시키는 트리거 생성
CREATE TRIGGER on_rating_change
AFTER INSERT OR UPDATE OR DELETE ON public.ratings
FOR EACH ROW
EXECUTE FUNCTION update_ai_model_rating();