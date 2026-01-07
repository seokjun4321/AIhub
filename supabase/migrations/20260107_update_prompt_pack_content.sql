-- Update Guide 14 Prompt Pack with New Content
-- This migration updates the prompt_pack data in guide_sections table

UPDATE guide_sections
SET data = $$[
  {
    "id": "prompt-1",
    "title": "프롬프트 #1: 기본 Text-to-Video 마스터",
    "description": "- AI 영상 제작을 처음 시작할 때\n- 간단한 장면(인물, 풍경, 동물)을 빠르게 만들고 싶을 때\n- 프롬프트 구조를 학습하고 싶을 때",
    "prompt": "[카메라 앵글]: A [피사체 + 구체적 묘사], [액션/움직임], in [환경 + 디테일]. [조명 스타일], [분위기 키워드].\n\n예시:\nWide tracking shot: A young woman in a white blouse, walking slowly through a modern office hallway, sunlight streaming through large windows. Soft afternoon light, professional cinematic tone.",
    "failurePatterns": "❌ 실패: \"A woman walking.\" (너무 단순)\n✅ 수정: \"Medium shot: A young woman in a red coat, walking briskly through a snowy park. Golden hour light, serene mood.\"",
    "relatedStep": [1, 2, 3]
  },
  {
    "id": "prompt-2",
    "title": "프롬프트 #2: Image-to-Video 정밀 제어",
    "description": "- 캐릭터/브랜드 일관성이 필요할 때\n- Text-to-Video 결과가 예측 불가능해 답답할 때\n- 특정 구도/각도를 정확히 고정하고 싶을 때",
    "prompt": "[피사체] + [단순한 움직임 동사], [배경 변화 설명].\n\n예시:\nShe slowly lifts the coffee cup to her lips and takes a sip, then places it back on the desk. Laptop screen glows softly.\n\n주의: 이미지 속 요소만 설명하세요. 없는 걸 추가하려 하지 마세요.",
    "failurePatterns": "❌ 실패: \"A woman drinking coffee and then standing up and walking away.\" (이미지에 없는 액션 추가)\n✅ 수정: \"She lifts the cup and sips, then sets it down gently.\"",
    "relatedStep": [4]
  },
  {
    "id": "prompt-3",
    "title": "프롬프트 #3: 시네마틱 카메라 워크 전문가",
    "description": "- 영화 같은 느낌을 내고 싶을 때\n- 단조로운 결과물에 다이나믹함을 추가하고 싶을 때\n- 포트폴리오/비즈니스 영상에서 프로페셔널함을 과시하고 싶을 때",
    "prompt": "[전문 카메라 용어] + [전문 조명 용어]: [피사체], [액션], [환경]. [분위기].\n\n카메라 옵션: Drone shot / Low angle / Close-up dolly-in / Tracking shot / POV\n조명 옵션: Golden hour / Backlight / Silhouette / Neon light / Soft diffused light\n\n예시:\nLow angle tracking shot: A luxury sports car speeding through a neon-lit city street at night. Backlight from streetlights, cinematic motion blur, futuristic vibe.",
    "failurePatterns": "❌ 실패: \"Wide tracking dolly crane shot with backlight and neon and golden hour.\" (과도한 용어 나열)\n✅ 수정: \"Tracking shot: A car on a neon street, backlight glow.\"",
    "relatedStep": [6]
  },
  {
    "id": "prompt-4",
    "title": "프롬프트 #4: 제품 쇼케이스 템플릿",
    "description": "- 전자제품, 패션, 화장품 등 제품 광고 영상을 만들 때\n- 전자상거래 페이지용 짧은 데모 영상이 필요할 때\n- 제품의 디테일과 프리미엄 느낌을 강조하고 싶을 때",
    "prompt": "Close-up rotating shot: A [제품명] placed on [표면 재질], [조명 스타일] lighting, camera slowly orbits around the product to reveal [강조할 디테일].\n\n예시:\nClose-up rotating shot: A silver smartwatch placed on black marble, soft studio lighting with subtle reflections, camera orbits to reveal the glowing OLED screen and metallic strap.",
    "failurePatterns": "❌ 실패: \"A watch on a table.\" (디테일 부족)\n✅ 수정: \"A luxury watch on black velvet, studio light, camera orbits slowly.\"",
    "relatedStep": [4, 6]
  },
  {
    "id": "prompt-5",
    "title": "프롬프트 #5: 스토리텔링 시퀀스 설계자",
    "description": "- 3~5개 클립을 연결한 짧은 스토리를 만들 때\n- 유튜브 숏츠, 릴스, 틱톡용 15초 내러티브 영상을 기획할 때\n- 일관된 스타일로 여러 장면을 연결하고 싶을 때",
    "prompt": "Scene 1 (훅): [카메라]: [피사체], [강렬한 액션], [환경]. [조명].\nScene 2 (전개): [카메라]: [피사체], [이어지는 액션], [같은 환경 또는 변화]. [같은 조명].\nScene 3 (마무리): [카메라]: [피사체], [마지막 액션], [환경]. [같은 조명].\n\n공통 요소: 모든 장면에 같은 조명 키워드를 사용해 일관성 유지.\n\n예시:\nScene 1: Wide shot: A robot walking through a futuristic city. Neon lights.\nScene 2: Medium shot: The robot stops and looks at a holographic screen. Neon lights.\nScene 3: Close-up: The robot's eyes glow brighter. Neon lights, dramatic music.",
    "failurePatterns": "❌ 실패: Scene 1은 \"golden hour\", Scene 2는 \"neon light\" (일관성 없음)\n✅ 수정: 모든 장면에 \"neon light\" 통일",
    "relatedStep": [9]
  },
  {
    "id": "prompt-6",
    "title": "프롬프트 #6: 트러블슈팅 & 고급 테크닉",
    "description": "- 생성 결과가 이상하거나 프롬프트가 무시될 때\n- AI가 \"이해 못 함\" 에러를 자주 낼 때\n- 복잡한 장면(여러 캐릭터, 복잡한 동작)을 시도할 때",
    "prompt": "문제 해결 체크리스트:\n1. 프롬프트 길이 확인: 100자 이내로 줄이기\n2. 한 번에 1개 액션만: \"걷다가 뛰다가 점프\" → \"걷기\"만\n3. 구체적 묘사: \"beautiful\" → \"wearing a red dress with white sneakers\"\n4. 도구 변경: Kling 안 되면 Hailuo 시도\n5. Image-to-Video로 전환: Text-to-Video 포기하고 이미지 먼저 만들기\n\n고급 테크닉 - Negative Prompt (Runway Gen-3):\n\"Avoid: blurry, warped hands, morphing, distorted faces, flickering.\"",
    "failurePatterns": "❌ 실패: \"A woman walking, talking on phone, eating pizza, looking around.\" (다중 액션)\n✅ 수정: \"A woman walking while talking on phone.\" (액션 2개로 축소)",
    "relatedStep": [3, 5, 10]
  }
]$$
WHERE guide_id = 14 AND section_type = 'prompt_pack';
