-- Restore Guide 14 Prompt Pack Data
-- guide_prompts must be linked to a step_id
-- We'll link them to the first step of Guide 14

-- First, get the first step ID of Guide 14
DO $MAIN$
DECLARE
    first_step_id INTEGER;
BEGIN
    SELECT id INTO first_step_id 
    FROM guide_steps 
    WHERE guide_id = 14 
    ORDER BY step_order ASC 
    LIMIT 1;

    -- Delete existing prompts linked to Guide 14 steps
    DELETE FROM guide_prompts 
    WHERE step_id IN (
        SELECT id FROM guide_steps WHERE guide_id = 14
    );

    -- Insert new prompts linked to the first step
    INSERT INTO guide_prompts (step_id, label, text, prompt_order) VALUES
    (first_step_id, '프롬프트 #1: 기본 Text-to-Video 마스터',
    $PROMPT$[카메라 앵글]: A [피사체 + 구체적 묘사], [액션/움직임], in [환경 + 디테일]. [조명 스타일], [분위기 키워드].

예시:
Wide tracking shot: A young woman in a white blouse, walking slowly through a modern office hallway, sunlight streaming through large windows. Soft afternoon light, professional cinematic tone.$PROMPT$, 1),
    (first_step_id, '프롬프트 #2: Image-to-Video 정밀 제어',
    $PROMPT$[피사체] + [단순한 움직임 동사], [배경 변화 설명].

예시:
She slowly lifts the coffee cup to her lips and takes a sip, then places it back on the desk. Laptop screen glows softly.

주의: 이미지 속 요소만 설명하세요. 없는 걸 추가하려 하지 마세요.$PROMPT$, 2),
    (first_step_id, '프롬프트 #3: 시네마틱 카메라 워크 전문가',
    $PROMPT$[전문 카메라 용어] + [전문 조명 용어]: [피사체], [액션], [환경]. [분위기].

카메라 옵션: Drone shot / Low angle / Close-up dolly-in / Tracking shot / POV
조명 옵션: Golden hour / Backlight / Silhouette / Neon light / Soft diffused light

예시:
Low angle tracking shot: A luxury sports car speeding through a neon-lit city street at night. Backlight from streetlights, cinematic motion blur, futuristic vibe.$PROMPT$, 3),
    (first_step_id, '프롬프트 #4: 제품 쇼케이스 템플릿',
    $PROMPT$Close-up rotating shot: A [제품명] placed on [표면 재질], [조명 스타일] lighting, camera slowly orbits around the product to reveal [강조할 디테일].

예시:
Close-up rotating shot: A silver smartwatch placed on black marble, soft studio lighting with subtle reflections, camera orbits to reveal the glowing OLED screen and metallic strap.$PROMPT$, 4),
    (first_step_id, '프롬프트 #5: 스토리텔링 시퀀스 설계자',
    $PROMPT$Scene 1 (훅): [카메라]: [피사체], [강렬한 액션], [환경]. [조명].
Scene 2 (전개): [카메라]: [피사체], [이어지는 액션], [같은 환경 또는 변화]. [같은 조명].
Scene 3 (마무리): [카메라]: [피사체], [마지막 액션], [환경]. [같은 조명].

공통 요소: 모든 장면에 같은 조명 키워드를 사용해 일관성 유지.

예시:
Scene 1: Wide shot: A robot walking through a futuristic city. Neon lights.
Scene 2: Medium shot: The robot stops and looks at a holographic screen. Neon lights.
Scene 3: Close-up: The robot's eyes glow brighter. Neon lights, dramatic music.$PROMPT$, 5),
    (first_step_id, '프롬프트 #6: 트러블슈팅 & 고급 테크닉',
    $PROMPT$문제 해결 체크리스트:
1. 프롬프트 길이 확인: 100자 이내로 줄이기
2. 한 번에 1개 액션만: "걷다가 뛰다가 점프" → "걷기"만
3. 구체적 묘사: "beautiful" → "wearing a red dress with white sneakers"
4. 도구 변경: Kling 안 되면 Hailuo 시도
5. Image-to-Video로 전환: Text-to-Video 포기하고 이미지 먼저 만들기

고급 테크닉 - Negative Prompt (Runway Gen-3):
"Avoid: blurry, warped hands, morphing, distorted faces, flickering."$PROMPT$, 6);
END $MAIN$;
