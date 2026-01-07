-- Updates prompt_pack data for Guide 14 with 6 specific packs
-- Based on User's provided "D) 프롬프트 팩 (6개)"
-- Table: guide_sections, Column: prompt_pack

UPDATE guide_sections
SET prompt_pack = '[
  {
    "id": "pack_1_text_to_video",
    "title": "기본 Text-to-Video 마스터",
    "description": "AI 영상 제작의 기초가 되는 Text-to-Video 프롬프트 공식. 인물, 풍경, 동물 등 다양한 장면에 범용적으로 사용 가능합니다.",
    "prompt": "[카메라 앵글]: A [피사체 + 구체적 묘사], [액션/움직임], in [환경 + 디테일]. [조명 스타일], [분위기 키워드].\\n\\n예시:\\nWide tracking shot: A young woman in a white blouse, walking slowly through a modern office hallway, sunlight streaming through large windows. Soft afternoon light, professional cinematic tone.",
    "usage": "AI 영상 제작을 처음 시작할 때 / 간단한 장면을 빠르게 만들 때 / 프롬프트 구조 학습용",
    "failurePatterns": "- ❌ 실패: \\"A woman walking.\\" (너무 단순)\\n- ✅ 수정: \\"Medium shot: A young woman in a red coat, walking briskly through a snowy park. Golden hour light, serene mood.\\"",
    "relatedStep": 1,
    "tags": ["입문", "범용", "Step 1"]
  },
  {
    "id": "pack_2_img_to_video",
    "title": "Image-to-Video 정밀 제어",
    "description": "이미지를 먼저 생성하고 이를 영상으로 변환하여 캐릭터와 스타일의 일관성을 완벽하게 유지하는 기법입니다.",
    "prompt": "[피사체] + [단순한 움직임 동사], [배경 변화 설명].\\n\\n예시:\\nShe slowly lifts the coffee cup to her lips and takes a sip, then places it back on the desk. Laptop screen glows softly.\\n\\n주의: 이미지 속 요소만 설명하세요. 없는 걸 추가하려 하지 마세요.",
    "usage": "캐릭터/브랜드 일관성이 필요할 때 / Text-to-Video 결과가 예측 불가능할 때 / 구도 고정",
    "failurePatterns": "- ❌ 실패: \\"A woman drinking coffee and then standing up and walking away.\\" (이미지에 없는 액션 추가)\\n- ✅ 수정: \\"She lifts the cup and sips, then sets it down gently.\\"",
    "relatedStep": 4,
    "tags": ["일관성", "고급", "Step 4"]
  },
  {
    "id": "pack_3_cinematic",
    "title": "시네마틱 카메라 워크 전문가",
    "description": "전문 영화 연출 용어(카메라 앵글, 조명)를 사용하여 영상의 퀄리티를 할리우드 영화 수준으로 끌어올리는 프롬프트입니다.",
    "prompt": "[전문 카메라 용어] + [전문 조명 용어]: [피사체], [액션], [환경]. [분위기].\\n\\n카메라 옵션: Drone shot / Low angle / Close-up dolly-in / Tracking shot / POV\\n조명 옵션: Golden hour / Backlight / Silhouette / Neon light / Soft diffused light\\n\\n예시:\\nLow angle tracking shot: A luxury sports car speeding through a neon-lit city street at night. Backlight from streetlights, cinematic motion blur, futuristic vibe.",
    "usage": "영화 같은 느낌을 내고 싶을 때 / 다이나믹한 연출이 필요할 때 / 포트폴리오용",
    "failurePatterns": "- ❌ 실패: \\"Wide tracking dolly crane shot with backlight and neon and golden hour.\\" (과도한 용어 나열)\\n- ✅ 수정: \\"Tracking shot: A car on a neon street, backlight glow.\\"",
    "relatedStep": 6,
    "tags": ["영화연출", "디테일", "Step 6"]
  },
  {
    "id": "pack_4_product_showcase",
    "title": "제품 쇼케이스 템플릿",
    "description": "제품의 디테일을 강조하고 고급스러운 분위기를 연출하는 광고 영상 전용 프롬프트입니다.",
    "prompt": "Close-up rotating shot: A [제품명] placed on [표면 재질], [조명 스타일] lighting, camera slowly orbits around the product to reveal [강조할 디테일].\\n\\n예시:\\nClose-up rotating shot: A luxury watch placed on black velvet, soft studio lighting with subtle reflections, camera orbits to reveal the glowing OLED screen and metallic strap.",
    "usage": "제품 광고 영상 / 이커머스 상세페이지 / 프리미엄 디테일 강조",
    "failurePatterns": "- ❌ 실패: \\"A watch on a table.\\" (디테일 부족)\\n- ✅ 수정: \\"A luxury watch on black velvet, studio light, camera orbits slowly.\\"",
    "relatedStep": 4,
    "tags": ["비즈니스", "광고", "Step 4"]
  },
  {
    "id": "pack_5_storytelling",
    "title": "스토리텔링 시퀀스 설계자",
    "description": "3~5개의 숏폼 클립을 연결하여 기승전결이 있는 15초 내러티브 영상을 만드는 시퀀스 프롬프트입니다.",
    "prompt": "Scene 1 (훅): [카메라]: [피사체], [강렬한 액션], [환경]. [조명].\\nScene 2 (전개): [카메라]: [피사체], [이어지는 액션], [같은 환경 또는 변화]. [같은 조명].\\nScene 3 (마무리): [카메라]: [피사체], [마지막 액션], [환경]. [같은 조명].\\n\\n공통 요소: 모든 장면에 같은 조명 키워드를 사용해 일관성 유지.\\n\\n예시:\\nScene 1: Wide shot: A robot walking through a futuristic city. Neon lights.\\nScene 2: Medium shot: The robot stops and looks at a holographic screen. Neon lights.\\nScene 3: Close-up: The robot\\'s eyes glow brighter. Neon lights, dramatic music.",
    "usage": "15초 숏폼 스토리 기획 / 여러 장면 연결 / 틱톡, 릴스용 제작",
    "failurePatterns": "- ❌ 실패: Scene 1은 \\"golden hour\\", Scene 2는 \\"neon light\\" (일관성 없음)\\n- ✅ 수정: 모든 장면에 \\"neon light\\" 통일",
    "relatedStep": 9,
    "tags": ["숏폼", "스토리", "Step 9"]
  },
  {
    "id": "pack_6_troubleshooting",
    "title": "트러블슈팅 & 고급 테크닉",
    "description": "생성 결과가 마음에 들지 않거나 에러가 날 때 문제를 해결하고 품질을 높이는 고급 수정 기법입니다.",
    "prompt": "문제 해결 체크리스트:\\n1. 프롬프트 길이 확인: 100자 이내로 줄이기\\n2. 한 번에 1개 액션만: \\"걷다가 뛰다가 점프\\" → \\"걷기\\"만\\n3. 구체적 묘사: \\"beautiful\\" → \\"wearing a red dress with white sneakers\\"\\n4. 도구 변경: Kling 안 되면 Hailuo 시도\\n5. Image-to-Video로 전환: Text-to-Video 포기하고 이미지 먼저 만들기\\n\\n고급 테크닉 - Negative Prompt (Runway Gen-3):\\n\\"Avoid: blurry, warped hands, morphing, distorted faces, flickering.\\"",
    "usage": "결과가 이상할 때 / 복잡한 장면 시도할 때 / 에러 자주 날 때",
    "failurePatterns": "- ❌ 실패: \\"A woman walking, talking on phone, eating pizza, looking around.\\" (다중 액션)\\n- ✅ 수정: \\"A woman walking while talking on phone.\\" (액션 2개로 축소)",
    "relatedStep": 3,
    "tags": ["문제해결", "심화", "Step 3"]
  }
]'::jsonb
WHERE guide_id = 14;
