-- Gemini Pricing Info Fix
-- "월, 고급" 같은 어색한 라벨을 "Advanced" 등으로 수정

UPDATE public.ai_models
SET pricing_info = 'Free: 무료 / Advanced: $19.99/월'
WHERE name = 'Gemini';

-- 혹시 ID가 다를 수 있으니 name like로도 처리 (보통 Gemini 혹은 Google Gemini)
UPDATE public.ai_models
SET pricing_info = 'Free: 무료 / Advanced: $19.99/월'
WHERE name = 'Google Gemini';
