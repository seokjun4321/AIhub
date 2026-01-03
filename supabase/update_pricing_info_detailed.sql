-- AI 도구 Pricing Info 상세 업데이트 (다중 플랜 반영)
-- 차트 시각화를 위해 "PlanName: Price" 형식으로 업데이트

-- 1. Cursor (ID: 121)
UPDATE public.ai_models
SET pricing_info = 'Hobby: Free / Pro: $20/월 / Business: $40/월'
WHERE name = 'Cursor';

-- 2. ChatGPT (ID: 1 or 41)
UPDATE public.ai_models
SET pricing_info = 'Free: 무료 / Plus: $20/월 / Team: $25/월'
WHERE name LIKE 'ChatGPT%';

-- 3. Claude (ID: 83)
UPDATE public.ai_models
SET pricing_info = 'Free: 무료 / Pro: $20/월 / Team: $25/월'
WHERE name LIKE 'Claude%';

-- 4. Perplexity (ID: 84)
UPDATE public.ai_models
SET pricing_info = 'Free: 무료 / Pro: $20/월'
WHERE name LIKE 'Perplexity%';

-- 5. Midjourney (ID: 85)
UPDATE public.ai_models
SET pricing_info = 'Basic: $10/월 / Standard: $30/월 / Pro: $60/월'
WHERE name LIKE 'Midjourney%';

-- 6. GitHub Copilot (ID: 93)
UPDATE public.ai_models
SET pricing_info = 'Student: 무료 / Individual: $10/월 / Business: $19/월'
WHERE name LIKE 'GitHub Copilot%';

-- 7. DeepL (ID: 111)
UPDATE public.ai_models
SET pricing_info = 'Free: 무료 / Starter: $8.74/월 / Advanced: $28.74/월'
WHERE name LIKE 'DeepL%';

-- 8. Notion AI (ID: 89)
UPDATE public.ai_models
SET pricing_info = 'Add-on: $8/월 / Plus: $10/월'
WHERE name LIKE 'Notion AI%';

-- 9. Canva (ID: 100)
UPDATE public.ai_models
SET pricing_info = 'Free: 무료 / Pro: $12.99/월 / Team: $14.99/월'
WHERE name LIKE 'Canva%';

-- 10. Wrtn (ID: 101)
UPDATE public.ai_models
SET pricing_info = 'Free: 무료 (GPT-4 포함) / Pro: 11,900원/월'
WHERE name LIKE 'Wrtn%';

-- 11. Vrew (ID: 106)
UPDATE public.ai_models
SET pricing_info = 'Free: 무료 (120분) / Light: 7,900원/월 / Standard: 13,900원/월'
WHERE name LIKE 'Vrew%';

-- 12. Gamma (ID: 104)
UPDATE public.ai_models
SET pricing_info = 'Free: 무료 (400 credits) / Plus: $8/월 / Pro: $15/월'
WHERE name LIKE 'Gamma%';

-- 13. Naver CLOVA X (ID: 119)
UPDATE public.ai_models
SET pricing_info = 'Beta: 무료'
WHERE name LIKE 'Naver CLOVA X%';

-- 14. Adobe Firefly (ID: 87)
UPDATE public.ai_models
SET pricing_info = 'Free: 무료 (25 credits) / Premium: $4.99/월'
WHERE name LIKE 'Adobe Firefly%';

-- 15. Stable Diffusion (ID: 88)
UPDATE public.ai_models
SET pricing_info = 'Local: 무료 / DreamStudio: $10 (1,000 credits)'
WHERE name LIKE 'Stable Diffusion%';

-- 16. Jasper (ID: 91)
UPDATE public.ai_models
SET pricing_info = 'Creator: $39/월 / Pro: $59/월'
WHERE name LIKE 'Jasper%';

-- 17. Speak (ID: 112)
UPDATE public.ai_models
SET pricing_info = 'Premium: 12,400원/월 / Premium Plus: 23,200원/월'
WHERE name LIKE 'Speak%';

-- 18. ELSA Speak (ID: 113)
UPDATE public.ai_models
SET pricing_info = 'Free: 무료 / Pro: $11.99/월 / Premium: $19.99/분기'
WHERE name LIKE 'ELSA Speak%';

-- 19. CopyKiller (ID: 103)
UPDATE public.ai_models
SET pricing_info = 'Lite: 무료 (1일 3건) / Pro: 9,900원 (1건) / Users: 16,500원/월'
WHERE name LIKE 'CopyKiller%';

-- 20. Runwary (ID: 107)
UPDATE public.ai_models
SET pricing_info = 'Free: 무료 (125 credits) / Standard: $12/월 / Pro: $28/월'
WHERE name LIKE 'Runway%';

-- 21. Replit (ID: 94)
UPDATE public.ai_models
SET pricing_info = 'Starter: 무료 / Core: $20/월'
WHERE name LIKE 'Replit%';
