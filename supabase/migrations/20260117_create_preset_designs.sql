-- Drop table to start fresh (avoids "policy already exists" errors and duplicates)
DROP TABLE IF EXISTS preset_designs CASCADE;

-- Create preset_designs table
CREATE TABLE preset_designs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  one_liner TEXT NOT NULL,
  description TEXT,
  tags TEXT[] DEFAULT '{}',
  image_url TEXT NOT NULL, -- Main image
  after_image_url TEXT,    -- Optional: Only for Before/After comparison
  author TEXT,
  prompt_text TEXT,
  params JSONB DEFAULT '[]'::jsonb,
  input_tips TEXT[] DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS
ALTER TABLE preset_designs ENABLE ROW LEVEL SECURITY;

-- Policy
CREATE POLICY "Public designs are viewable by everyone" ON preset_designs
  FOR SELECT USING (true);

-- Insert Data

-- 1. Cinematic Portrait (Midjourney V6)
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  'Cinematic Portrait (Midjourney V6)',
  '피부 질감과 조명을 극대화하여 실제 촬영본 같은 느낌을 주는 인물 프롬프트입니다.',
  '이 프롬프트는 8k 해상도의 극사실주의 인물 사진을 생성합니다. 35mm 렌즈와 f/1.8 조리개 설정을 시뮬레이션하여 부드러운 배경 흐림 효과(보케)와 선명한 인물 디테일을 구현합니다.',
  'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?auto=format&fit=crop&q=80&w=1000', -- Placeholder
  NULL,
  ARRAY['Portrait', 'Cinematic', 'Hyperrealistic', 'Photography'],
  'Midjourney Showcase (Top Rated)',
  'extreme close-up of a Scandinavian woman with freckles, blue eyes, natural skin texture, soft cinematic lighting, shot on 35mm lens, f/1.8, shallow depth of field, hyper-detailed, photorealistic, 8k --ar 4:5 --v 6.0 --style raw',
  '[{"key": "Model", "value": "Midjourney V6.0"}, {"key": "Aspect Ratio", "value": "4:5"}, {"key": "Style", "value": "Raw"}]'::jsonb,
  ARRAY['인물의 국적, 나이, 머리 색 등을 변경하여 다양하게 활용해보세요.', '조명 키워드(soft, dramatic, natural)를 변경하면 분위기가 달라집니다.']
);

-- 2. Niji Anime Style (Niji V6)
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  'Niji Anime Style (Niji V6)',
  '니지저니 V6의 강점인 빛 표현과 감성적인 분위기를 살린 소녀 일러스트입니다.',
  '애니메이션 아트와 라이트 노벨 표지 스타일에 최적화되어 있습니다. 신카이 마코토 스타일의 섬세한 배경 묘사와 빛의 활용이 특징입니다.',
  'https://placehold.co/600x400?text=Niji+Anime', -- Placeholder
  NULL,
  ARRAY['Anime', 'Niji', 'Illustration', 'Atmospheric'],
  'Niji Journey Discord Best',
  'a girl standing on a train platform during sunset, wind blowing hair, emotional atmosphere, lens flare, detailed background, makoto shinkai style, vibrant colors, high quality --ar 16:9 --niji 6',
  '[{"key": "Model", "value": "Niji Journey V6"}, {"key": "Aspect Ratio", "value": "16:9"}, {"key": "Style", "value": "Makoto Shinkai"}]'::jsonb,
  ARRAY['배경 장소(기차역, 교실, 옥상)를 바꾸면 다양한 연출이 가능합니다.', '시간대(일몰, 밤, 새벽)를 명시하여 분위기를 조절하세요.']
);

-- 3. Isometric 3D Room (Stable Diffusion XL)
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  'Isometric 3D Room (SDXL)',
  '블렌더(Blender)로 작업한 듯한 깔끔한 아이소메트릭 뷰의 방 디자인입니다.',
  '게임 에셋이나 인테리어 디자인 시안으로 활용하기 좋습니다. 귀엽고 아기자기한 3D 렌더링 스타일로 방의 구조와 소품 배치를 한눈에 보여줍니다.',
  'https://placehold.co/600x400?text=Isometric+Room', -- Placeholder
  NULL,
  ARRAY['Isometric', '3D', 'Interior', 'Cute'],
  'Civitai (SDXL Prompts)',
  'isometric view of a cozy gamer room, neon lighting, computer setup, bean bag chair, posters on wall, night time, 3d render, blender style, cute, low poly, soft lighting, occlusion, 8k',
  '[{"key": "Model", "value": "SDXL 1.0"}, {"key": "Style", "value": "Blender 3D"}, {"key": "View", "value": "Isometric"}]'::jsonb,
  ARRAY['방의 테마(게이머 룸, 서재, 카페)를 변경해보세요.', '조명 색상(neon, warm, cool)을 지정하면 분위기가 바뀝니다.']
);

-- 4. Knolling Photography (Midjourney)
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  'Knolling Photography (Midjourney)',
  '사물을 직각으로 나란히 배열하여 깔끔하고 세련된 느낌을 주는 ''놀링(Knolling)'' 기법입니다.',
  '제품 홍보나 여행 장비 소개에 효과적입니다. 위에서 내려다보는 구도(Overhead shot)로 모든 물건을 정갈하게 정리하여 보여줍니다.',
  'https://placehold.co/600x400?text=Knolling', -- Placeholder
  NULL,
  ARRAY['Knolling', 'Flatlay', 'Product', 'Design'],
  'Instagram AI Art Community',
  'knolling photography of vintage camera gear, lenses, film rolls, leather bag, coffee cup, wooden table background, organized layout, overhead shot, professional lighting, high resolution --ar 3:2 --v 6.0',
  '[{"key": "Model", "value": "Midjourney V6.0"}, {"key": "Aspect Ratio", "value": "3:2"}, {"key": "View", "value": "Overhead"}]'::jsonb,
  ARRAY['나열할 물건들의 종류(캠핑 장비, 화장품, 문구류)를 구체적으로 나열하세요.', '배경 소재(wooden table, white background)를 변경할 수 있습니다.']
);

-- 5. Cyberpunk Cityscape (Stable Diffusion 1.5)
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  'Cyberpunk Cityscape (SD 1.5)',
  '비 오는 사이버펑크 도시의 네온 사인과 반사광을 강조한 클래식한 스타일입니다.',
  'SF 소설 삽화나 배경 화면으로 적합합니다. 비에 젖은 바닥에 반사되는 네온 불빛과 높은 마천루, 날아다니는 자동차가 미래적인 분위기를 자아냅니다.',
  'https://placehold.co/600x400?text=Cyberpunk', -- Placeholder
  NULL,
  ARRAY['Cyberpunk', 'SciFi', 'City', 'Neon'],
  'Reddit r/StableDiffusion',
  'futuristic cyberpunk city street at night, raining, neon lights, reflections on wet pavement, towering skyscrapers, flying cars, volumetric lighting, highly detailed, digital painting, artstation style',
  '[{"key": "Model", "value": "Stable Diffusion 1.5"}, {"key": "Checkpoint", "value": "CyberRealistic"}, {"key": "Style", "value": "Artstation"}]'::jsonb,
  ARRAY['날씨(raining, fog)를 변경하여 도시의 분위기를 바꿔보세요.', '색상 톤(cyan and magenta, orange and teal)을 지정하면 더 영화 같은 느낌을 줍니다.']
);

-- 6. Minimalist Vector Logo (Midjourney)
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  'Minimalist Vector Logo (Midjourney)',
  '복잡함을 덜어내고 기하학적 형태를 강조한 미니멀리스트 벡터 로고입니다.',
  '브랜딩이나 아이콘 디자인에 활용할 수 있습니다. 깔끔한 선과 단순한 형태, 제한된 컬러 팔레트를 사용하여 전문적이고 현대적인 느낌을 줍니다.',
  'https://placehold.co/600x400?text=Vector+Logo', -- Placeholder
  NULL,
  ARRAY['Logo', 'Vector', 'Minimalist', 'Branding'],
  'X (Twitter) AI Designers',
  'minimalist vector logo of a fox head, geometric shapes, flat design, orange and white color palette, white background, professional, clean lines, vector art --no shading --v 6.0',
  '[{"key": "Model", "value": "Midjourney V6.0"}, {"key": "Style", "value": "Flat Vector"}, {"key": "Background", "value": "White"}]'::jsonb,
  ARRAY['동물이나 사물(fox, mountain, camera)을 단순한 형태로 표현해보세요.', '원하는 브랜드 컬러(orange and white)를 명시하면 좋습니다.']
);

-- 7. Claymorphism 3D Character (DALL-E 3 / MJ)
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  'Claymorphism 3D Character',
  '클레이(점토) 질감의 둥글둥글하고 귀여운 3D 캐릭터 스타일입니다.',
  'UI/UX 일러스트나 아동용 콘텐츠에 적합합니다. 매트한 질감과 부드러운 파스텔 톤 색감이 특징이며, 3D 렌더링 느낌을 살려줍니다.',
  'https://placehold.co/600x400?text=Clay+Character', -- Placeholder
  NULL,
  ARRAY['Claymorphism', '3D', 'Character', 'Cute'],
  'Pinterest AI Trends',
  'cute 3d character of a robot holding a flower, claymorphism style, soft pastel colors, matte texture, studio lighting, plain background, 3d render, high quality',
  '[{"key": "Model", "value": "DALL-E 3 / Midjourney"}, {"key": "Style", "value": "Claymorphism"}, {"key": "Texture", "value": "Matte"}]'::jsonb,
  ARRAY['캐릭터의 행동(holding a flower, waving)을 묘사해보세요.', '파스텔 톤 색상(soft pink, mint green)이 잘 어울립니다.']
);

-- 8. Architectural Sketch (Stable Diffusion XL)
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  'Architectural Sketch (SDXL)',
  '연필과 마커로 그린 듯한 건축 러프 스케치 느낌을 구현합니다.',
  '건축 아이디어 구상이나 초기 드로잉 시안으로 활용하기 좋습니다. 흰 종이 위에 연필 선과 마커 채색 느낌을 살려 자연스러운 스케치 효과를 냅니다.',
  'https://placehold.co/600x400?text=Arch+Sketch', -- Placeholder
  NULL,
  ARRAY['Architecture', 'Sketch', 'Drawing', 'Design'],
  'Civitai Models',
  'architectural sketch of a modern villa, pencil drawing, marker coloring, rough lines, white paper background, concept art, perspective view, detailed',
  '[{"key": "Model", "value": "SDXL"}, {"key": "Style", "value": "Pencil & Marker"}, {"key": "View", "value": "Perspective"}]'::jsonb,
  ARRAY['건물의 종류(villa, museum, skyscraper)를 변경해보세요.', '재료 느낌(watercolor, charcoal)을 프롬프트에 추가해 변형할 수 있습니다.']
);

-- 9. Food Photography (Midjourney)
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  'Food Photography (Midjourney)',
  '식욕을 자극하는 조명과 시즐감을 살린 상업용 음식 사진 스타일입니다.',
  '메뉴판이나 음식 블로그, 광고 배너에 사용하기 좋습니다. 접사(Macro) 렌즈 효과와 전문적인 조명으로 음식의 질감을 생생하게 표현합니다.',
  'https://placehold.co/600x400?text=Food+Photo', -- Placeholder
  NULL,
  ARRAY['Food', 'Photography', 'Delicious', 'Commercial'],
  'Midjourney Showcase',
  'close-up shot of a gourmet beef burger with melting cheese, fresh lettuce, sesame bun, steam rising, dark moody background, professional food photography, macro lens, 8k, sharp focus --ar 4:5 --v 6.0',
  '[{"key": "Model", "value": "Midjourney V6.0"}, {"key": "Aspect Ratio", "value": "4:5"}, {"key": "Lens", "value": "Macro"}]'::jsonb,
  ARRAY['음식의 상태(melting, steam rising)를 묘사하여 생동감을 더하세요.', '배경 분위기(dark moody, bright airy)를 설정하여 컨셉을 잡으세요.']
);

-- 10. Double Exposure (Midjourney)
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  'Double Exposure (Midjourney)',
  '두 가지 이미지를 겹쳐 몽환적이고 예술적인 효과를 내는 이중 노출 기법입니다.',
  '앨범 커버나 포스터, 예술 작품으로 활용하기 좋습니다. 실루엣 안에 다른 풍경이나 이미지를 결합하여 초현실적인 분위기를 연출합니다.',
  'https://placehold.co/600x400?text=Double+Exposure', -- Placeholder
  NULL,
  ARRAY['DoubleExposure', 'Artistic', 'Surreal', 'Creative'],
  'Discord Creative Prompts',
  'double exposure of a bear silhouette and a pine forest, misty mountains inside the bear, white background, surreal art, monochrome, high contrast, detailed --ar 3:4 --v 6.0',
  '[{"key": "Model", "value": "Midjourney V6.0"}, {"key": "Aspect Ratio", "value": "3:4"}, {"key": "Technique", "value": "Double Exposure"}]'::jsonb,
  ARRAY['실루엣이 될 피사체(bear, woman profile)와 내부 이미지(forest, galaxy)를 조합해보세요.', '흑백(monochrome) 처리하면 더욱 예술적인 느낌이 납니다.']
);
