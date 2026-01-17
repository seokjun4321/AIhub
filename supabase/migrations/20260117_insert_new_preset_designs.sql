-- 1. The "Backlit" Sunlight (SDXL / MJ)
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  'The "Backlit" Sunlight (SDXL / MJ)',
  '역광(Backlight) 상황에서 머리카락이 빛나는 효과(Rim light)와 자연스러운 그림자를 통해 CG 느낌을 지웁니다.',
  '여행 사진, 에어비앤비 호스트 프로필, 라이프스타일 사진으로 활용하기 좋습니다.',
  'https://placehold.co/600x400?text=Backlit+Sunlight',
  NULL,
  ARRAY['GoldenHour', 'Backlit', 'Lifestyle', 'Sunlight'],
  'Instagram AI Art Community',
  'medium shot of a man drinking coffee on a balcony during golden hour, strong backlight, lens flare, dust particles in air, sun kissed skin, genuine smile, squinting eyes, shot on 35mm lens, photorealistic --ar 16:9 --v 6.0 --style raw',
  '[{"key": "Model", "value": "Midjourney V6.0"}, {"key": "Lighting", "value": "Backlight/Golden Hour"}, {"key": "Aspect Ratio", "value": "16:9"}]'::jsonb,
  ARRAY['활동(drinking coffee -> reading book, laughing)을 변경하여 다양한 라이프스타일을 연출해보세요.', '배경 장소(balcony -> beach, park)를 바꾸면 여행지 느낌을 낼 수 있습니다.']
);

-- 2. Trendy Cafe Date (Cafe Window)
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  'Trendy Cafe Date (Cafe Window)',
  '성수동이나 연남동의 힙한 카페 창가에서 자연광을 받으며 커피를 마시는 자연스러운 모습입니다.',
  '인스타그램 피드, 일상 브이로그 썸네일, 남이 찍어준 사진 느낌에 적합합니다.',
  'https://placehold.co/600x400?text=Cafe+Window',
  NULL,
  ARRAY['KoreanGirl', 'Cafe', 'DailyLook', 'Candid'],
  'Midjourney Showcase',
  'candid photo of a beautiful korean woman sitting at a trendy cafe window in Seoul, drinking iced latte, looking away from camera, natural sunlight hitting face, wearing oversized beige cardigan, soft focus background, shot on iPhone 15 Pro, authentic daily life, hyper-realistic, 4k --ar 4:5 --v 6.0 --style raw',
  '[{"key": "Model", "value": "Midjourney V6.0"}, {"key": "Style", "value": "Raw"}, {"key": "Aspect Ratio", "value": "4:5"}]'::jsonb,
  ARRAY['음료(iced latte -> matcha latte, dessert)를 변경하여 디테일을 살려보세요.', '의상(beige cardigan -> floral dress)을 계절감에 맞춰 변경할 수 있습니다.']
);

-- 3. Mirror Selfie (Flash On)
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  'Mirror Selfie (Flash On)',
  '어두운 실내나 현관 거울 앞에서 플래시를 터뜨려 찍은, 얼굴을 살짝 가린 힙한 거울 셀카입니다.',
  'OOTD(Daily Outfit), 거울샷, 힙한 감성 연출에 유용합니다.',
  'https://placehold.co/600x400?text=Mirror+Selfie',
  NULL,
  ARRAY['MirrorSelfie', 'FlashPhotography', 'OOTD', 'Hip'],
  'Pinterest K-Fashion',
  'mirror selfie of a trendy korean girl, holding iphone covering half face, camera flash on, wearing streetwear, crop top and wide denim pants, messy room background, slightly grainy, amateur photography aesthetic, instagram story vibe, realistic lighting --ar 9:16 --v 6.0 --style raw',
  '[{"key": "Model", "value": "Midjourney V6.0"}, {"key": "Lighting", "value": "Flash On"}, {"key": "View", "value": "Mirror Selfie"}]'::jsonb,
  ARRAY['의상 스타일(streetwear -> minimalist, vintage)을 변경하여 OOTD를 다양하게 표현하세요.', '배경(messy room -> elevator, fitting room)을 변경하여 장소감을 줄 수 있습니다.']
);

-- 4. Luxury Hotel Night View (Signiel Vibe)
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  'Luxury Hotel Night View',
  '시그니엘 같은 고층 호텔 창가에서 샤워가운을 입고 야경을 배경으로 와인을 든 럭셔리한 무드입니다.',
  '호캉스, 럭셔리 라이프스타일, 기념일 사진 연출에 적합합니다. (Negative Prompt 포함됨)',
  'https://placehold.co/600x400?text=Luxury+Hotel',
  NULL,
  ARRAY['Luxury', 'Hotel', 'NightView', 'Influencer'],
  'Civitai',
  'beautiful korean woman standing near window in a luxury hotel room at night, wearing white bathrobe, holding a glass of red wine, blurred city night skyline in background, bokeh, soft ambient lighting, elegance, wealthy lifestyle, highly detailed face, 8k photograph',
  '[{"key": "Model", "value": "SDXL (RealVisXL)"}, {"key": "Setting", "value": "Luxury Hotel"}, {"key": "Negative Prompt", "value": "cartoon, painting, illustration, 3d render, distorted hands, bad anatomy, ugly"}]'::jsonb,
  ARRAY['시간대(night -> morning sunrise)를 변경하여 다른 무드를 연출해보세요.', '소품(wine -> champagne, coffee)을 변경하여 상황에 맞는 연출이 가능합니다.']
);

-- 5. Pilates/Gym Workout
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  'Pilates/Gym Workout',
  '필라테스 기구 앞에서 레깅스를 입고 운동 후 쉬고 있는 건강하고 탄탄한 모습입니다.',
  '운동 인증샷, 오운완(오늘 운동 완료), 건강미를 강조하는 바디프로필 등에 좋습니다.',
  'https://placehold.co/600x400?text=Pilates+Workout',
  NULL,
  ARRAY['Pilates', 'Workout', 'KBeauty', 'BodyProfile'],
  'Instagram Health Community',
  'full body shot of a fit korean woman in a pilates studio, wearing pastel color leggings and sports bra, sweaty skin, tying hair up, natural lighting from window, gym equipment in background, healthy lifestyle, shot on Sony A7III, depth of field, realistic --ar 2:3 --v 6.0 --style raw',
  '[{"key": "Model", "value": "Midjourney V6.0"}, {"key": "Activity", "value": "Pilates/Workout"}, {"key": "Aspect Ratio", "value": "2:3"}]'::jsonb,
  ARRAY['운동 종류(pilates -> yoga, weight training)에 따라 배경 기구를 변경해보세요.', '의상 색상(pastel color -> black, neon)을 변경하여 스타일을 다르게 할 수 있습니다.']
);

-- 6. Airport Fashion (Paparazzi Style)
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  'Airport Fashion (Paparazzi Style)',
  '횡단보도를 건너거나 공항 게이트를 나서는 순간을 포착한 듯한 자연스러운 전신 샷입니다.',
  '공항 패션, 셀럽 파파라치, 여행 출발 컨셉에 어울립니다.',
  'https://placehold.co/600x400?text=Airport+Fashion',
  NULL,
  ARRAY['AirportFashion', 'StreetSnap', 'Celeb', 'FullBody'],
  'Discord Midjourney',
  'street photography of a stylish korean influencer walking at Incheon airport, wearing sunglasses, trench coat, carrying a suitcase, wind blowing hair, candid shot, motion blur, paparazzi style, daylight, urban background, photorealistic, 8k --ar 3:4 --v 6.0 --style raw',
  '[{"key": "Model", "value": "Midjourney V6.0"}, {"key": "Style", "value": "Paparazzi"}, {"key": "Aspect Ratio", "value": "3:4"}]'::jsonb,
  ARRAY['계절감(trench coat -> t-shirt, puffer jacket)을 변경하여 날씨를 표현하세요.', '액세서리(sunglasses -> headphones, hat)를 추가하여 디테일을 살릴 수 있습니다.']
);

-- 7. Close-up Beauty (Glass Skin)
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  'Close-up Beauty (Glass Skin)',
  '잡티는 살짝 있지만 맑고 투명한 ''유리알 피부(Glass Skin)''를 강조한 초근접 인물 사진입니다.',
  '뷰티 화보, 스킨케어 광고, 메이크업 디테일 샷으로 활용하기 좋습니다. (Negative Prompt 포함됨)',
  'https://placehold.co/600x400?text=Glass+Skin',
  NULL,
  ARRAY['Skincare', 'GlassSkin', 'Makeup', 'Portrait'],
  'Civitai',
  'extreme close-up portrait of a young korean woman, clear glowing skin, minimal makeup, natural eyebrows, brown eyes, detailed skin texture, pores visible, soft studio lighting, beauty photography, sharp focus, f/2.8',
  '[{"key": "Model", "value": "SDXL (Juggernaut XL)"}, {"key": "Focus", "value": "Skin Texture"}, {"key": "Negative Prompt", "value": "airbrushed, plastic skin, smooth skin, blur, heavy makeup, painting, fake"}]'::jsonb,
  ARRAY['메이크업 스타일(minimal -> glossy lips, red lips)을 변경하여 다른 뷰티 룩을 연출하세요.', '눈동자 색(brown -> gray, hazel)을 변경하여 이국적인 느낌을 줄 수 있습니다.']
);

-- 8. Han River Picnic (Sunset)
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  'Han River Picnic (Sunset)',
  '해 질 녘 한강 공원 돗자리에 앉아 카메라를 보며 환하게 웃는 여친짤의 정석입니다.',
  '한강 피크닉, 봄/가을 감성, 데이트 스냅 사진으로 추천합니다.',
  'https://placehold.co/600x400?text=Han+River+Picnic',
  NULL,
  ARRAY['HanRiver', 'Picnic', 'Sunset', 'GirlfriendMaterial'],
  'Midjourney Showcase',
  'medium shot of a cute korean girl sitting on a picnic mat at Han River park during golden hour, sunset background, wearing a floral dress, smiling at camera, hair glowing from backlight, casual vibe, film photography style, Kodak Portra 400, heartwarming --ar 3:2 --v 6.0 --style raw',
  '[{"key": "Model", "value": "Midjourney V6.0"}, {"key": "Vibe", "value": "Warm/Sunset"}, {"key": "Aspect Ratio", "value": "3:2"}]'::jsonb,
  ARRAY['시간대(sunset -> sunny afternoon, night)를 변경하여 다른 피크닉 분위기를 즐겨보세요.', '배경(Han River -> Central Park, beach)을 변경하여 여행지 느낌을 낼 수도 있습니다.']
);

-- 9. Retro Film Camera Vibe (Hongdae Street)
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  'Retro Film Camera Vibe',
  '밤거리의 네온사인 앞에서 필름 카메라로 찍은 듯 노이즈가 있고 초점이 살짝 나간 빈티지 감성입니다.',
  '필름 카메라, 레트로, 홍대 거리의 힙한 밤 분위기를 연출할 때 좋습니다.',
  'https://placehold.co/600x400?text=Retro+Film+Vibe',
  NULL,
  ARRAY['Film', 'Retro', 'Hongdae', 'NightPortrait'],
  'Twitter AI Art',
  'flash photography of a beautiful korean girl standing on a street in Hongdae at night, neon signs, looking at camera, red eye effect, film grain, vintage aesthetic, disposable camera style, blurry background, candid, youth vibe --ar 2:3 --v 6.0 --style raw',
  '[{"key": "Model", "value": "Midjourney V6.0"}, {"key": "Style", "value": "Disposable Camera"}, {"key": "Aspect Ratio", "value": "2:3"}]'::jsonb,
  ARRAY['장소(Hongdae -> Tokyo Shibuya, Times Square)를 변경하여 도시의 밤 분위기를 바꿔보세요.', '필름 느낌(disposable camera -> Polaroid)을 변경하여 다른 질감을 시도해보세요.']
);

-- 10. Car Interior Selfie
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  'Car Interior Selfie',
  '낮 시간대, 차 안 조수석이나 운전석에서 안전벨트를 매고 찍은 자연스러운 셀카입니다.',
  '드라이브, 차 안 셀카, 여유로운 일상을 보여주는 라이프스타일 컷입니다.',
  'https://placehold.co/600x400?text=Car+Selfie',
  NULL,
  ARRAY['CarSelfie', 'Drive', 'Lifestyle', 'Sunny'],
  'Midjourney Discord',
  'selfie inside a car, beautiful korean woman, wearing sunglasses on head, seatbelt on, sunlight streaming through window, shadows on face, leather seats background, casual chic, shot on smartphone, high quality, realistic skin tone --ar 4:5 --v 6.0 --style raw',
  '[{"key": "Model", "value": "Midjourney V6.0"}, {"key": "Lighting", "value": "Natural Sunlight"}, {"key": "Setting", "value": "Car Interior"}]'::jsonb,
  ARRAY['날씨(sunlight -> raining)를 변경하여 차 안에서의 감성적인 무드를 연출해보세요.', '시점(selfie -> side profile)을 변경하여 다른 구도를 시도할 수 있습니다.']
);

-- 11. ID Photo / Passport Photo
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  'ID Photo / Passport Photo',
  '사진관에서 찍은 듯한 완벽한 대칭과 조명, 깔끔한 헤어스타일의 고화질 증명사진입니다.',
  '증명사진, 여권사진, 깔끔한 프로필 이미지가 필요할 때 유용합니다. (Negative Prompt 포함됨)',
  'https://placehold.co/600x400?text=ID+Photo',
  NULL,
  ARRAY['IDPhoto', 'Passport', 'Clean', 'Beauty'],
  'Civitai',
  'formal id photo of a pretty korean woman, white background, looking straight at camera, neutral expression, light makeup, black hair tied back, white shirt, studio lighting, sharp focus, high definition, symmetrical face',
  '[{"key": "Model", "value": "SDXL"}, {"key": "Usage", "value": "ID/Passport"}, {"key": "Negative Prompt", "value": "shadows, tilted head, smiling, teeth, accessories, glasses, textured background"}]'::jsonb,
  ARRAY['의상(white shirt -> suit, casual tee)을 변경하여 용도(취업용, 민증용)에 맞게 조절하세요.', '헤어스타일(tied back -> loose hair)을 변경하여 이미지를 바꿀 수 있습니다.']
);

-- 12. Y2K Digicam Flash Vibe
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  'Y2K Digicam Flash Vibe',
  '어두운 곳에서 옛날 디지털 카메라로 플래시를 터뜨려 찍은 듯한 날것의 느낌을 줍니다.',
  'Y2K, 2000년대 초반 디카, 빈티지 감성의 인스타 피드용 사진입니다.',
  'https://placehold.co/600x400?text=Y2K+Digicam',
  NULL,
  ARRAY['Y2K', 'Digicam', 'FlashPhotography', 'Vintage', 'Candid'],
  'Midjourney Showcase',
  'candid photo taken with an early 2000s digital camera, flash on, messy hair young korean woman looking at camera, wearing oversized graphic t-shirt, dark room, grainy, low resolution aesthetic, authentic vintage vibe, time stamp in corner --ar 4:5 --v 6.0 --style raw',
  '[{"key": "Model", "value": "Midjourney V6.0"}, {"key": "Style", "value": "Y2K/Digicam"}, {"key": "Aspect Ratio", "value": "4:5"}]'::jsonb,
  ARRAY['소품(graphic t-shirt -> flip phone, headphones)을 추가하여 Y2K 감성을 더해보세요.', '필터 효과(time stamp -> date stamp orange)를 텍스트로 명시하면 더욱 리얼합니다.']
);

-- 13. Golden Hour "Cold Girl" Selfie
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  'Golden Hour "Cold Girl" Selfie',
  '해 질 녘 햇살(골든아워)을 받아 빛나는 피부와 나른한 분위기를 연출하는 초근접 셀카입니다.',
  '뷰티 인플루언서, 감성 셀카, 겨울철 ''Cold Girl'' 메이크업 룩에 적합합니다.',
  'https://placehold.co/600x400?text=Cold+Girl+Selfie',
  NULL,
  ARRAY['GoldenHour', 'Selfie', 'SunKissed', 'FilmGrain', 'Portrait'],
  'Reddit r/midjourney',
  'extreme close-up selfie of a beautiful young asian woman lying in bed, golden hour sunlight hitting face, rosy cheeks and nose, "cold girl" makeup look, natural skin texture, freckles, soft fluffy blanket, sleepy eyes, film grain, kodak portra 400 --ar 4:5 --v 6.0 --style raw',
  '[{"key": "Model", "value": "Midjourney V6.0"}, {"key": "Look", "value": "Cold Girl Makeup"}, {"key": "Lighting", "value": "Golden Hour"}]'::jsonb,
  ARRAY['계절감(fluffy blanket -> summer dress)을 변경하여 다른 계절의 골든아워를 표현해보세요.', '표정(sleepy eyes -> winking, smiling)을 변경하여 매력을 어필할 수 있습니다.']
);

-- 14. Moody Webcam Collage
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  'Moody Webcam Collage',
  '어두운 방에서 맥북 웹캠으로 찍은 듯한 저화질의 몽환적이고 키치한 분위기입니다.',
  '포토부스(인생네컷), 웹캠, 하이틴 감성, 틱톡 재질의 이미지를 연출합니다.',
  'https://placehold.co/600x400?text=Webcam+Collage',
  NULL,
  ARRAY['Webcam', 'PhotoBooth', 'Collage', 'LoFi', 'Aesthetic'],
  'Pinterest / Twitter',
  '3-frame vertical photo booth strip, low quality webcam aesthetic, young korean influencer girl in a dark bedroom, moody lighting from monitor screen, casual black tank top, looking at camera, slightly blurry, cute heart stickers overlay, grainy texture, Gen Z vibe --ar 2:5 --v 6.0',
  '[{"key": "Model", "value": "Midjourney V6.0"}, {"key": "Format", "value": "Photo Strip"}, {"key": "Vibe", "value": "Low Quality/Webcam"}]'::jsonb,
  ARRAY['스티커(heart stickers -> star stickers, glitter)를 변경하여 꾸미기 요소를 더해보세요.', '배경 조명(monitor screen -> purple neon light)을 변경하여 방 분위기를 바꿀 수 있습니다.']
);

-- 15. Hip Cafe "Off-Duty" Candid
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  'Hip Cafe "Off-Duty" Candid',
  '힙한 카페에서 꾸안꾸(꾸민 듯 안 꾸민 듯) 스타일로 자연스럽게 어딘가를 응시하는 모습입니다.',
  'OOTD, 카페 투어, 인플루언서들의 자연스러운 일상 사진(여친짤) 느낌입니다.',
  'https://placehold.co/600x400?text=Cafe+Candid',
  NULL,
  ARRAY['Cafe', 'OOTD', 'Candid', 'KoreanStyle', 'StreetSnap'],
  'Instagram Fashion Curators',
  'candid street style photography of a trendy korean woman sitting at a hip cafe patio, wearing a beanie and oversized blazer, drinking iced coffee, looking away casually, sunlight, film grain, authentic moment, blurred background people, shot on film --ar 4:5 --v 6.0 --style raw',
  '[{"key": "Model", "value": "Midjourney V6.0"}, {"key": "Style", "value": "Candid Street"}, {"key": "Aspect Ratio", "value": "4:5"}]'::jsonb,
  ARRAY['패션 아이템(beanie -> cap, sunglasses)을 변경하여 스타일링을 다르게 해보세요.', '행동(drinking coffee -> checking phone, laughing)을 변경하여 자연스러운 순간을 포착하세요.']
);

-- 16. The "Mirror Check" Flash Selfie
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  'The "Mirror Check" Flash Selfie',
  '핫플레이스의 거울 앞에서 플래시를 터뜨려 얼굴을 반쯤 가리고 찍는, 쿨하고 시크한 무드의 거울 셀카입니다.',
  '데일리룩, 힙한 포인트, MZ세대 감성의 거울샷 연출에 최적입니다. (Negative Prompt 포함됨)',
  'https://placehold.co/600x400?text=Mirror+Check+Selfie',
  NULL,
  ARRAY['MirrorSelfie', 'Flash', 'CoolGirl', 'Streetwear', 'Vibe'],
  'Civitai',
  'mirror selfie, flash enabled, young attractive asian woman in a trendy outfit, cargo pants and crop top, holding smartphone covering half face, cool edgy bathroom interior with graffiti, harsh flash lighting, realistic film grain, candid instagram story aesthetic',
  '[{"key": "Model", "value": "SDXL"}, {"key": "Vibe", "value": "Edgy/Flash"}, {"key": "Negative Prompt", "value": "professional studio photo, glamorous, highly polished, smooth skin, 3d render, cartoon"}]'::jsonb,
  ARRAY['배경(bathroom -> club restroom, street mirror)을 변경하여 힙한 장소를 묘사해보세요.', '포즈(covering half face -> peace sign, hair touch)를 변경하여 다양한 거울샷을 연출할 수 있습니다.']
);
