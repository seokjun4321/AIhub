-- 17. 3D Figure Product Visualization (I2I)
INSERT INTO preset_designs (title, one_liner, description, image_url, after_image_url, tags, author, prompt_text, params, input_tips) VALUES (
  '3D Figure Product Visualization',
  '실제 동물이나 캐릭터 사진을 입력하면, 이를 반다이(BANDAI) 스타일의 상용화된 1/7 스케일 3D 피규어 제품 사진으로 변환해 줍니다.',
  '실제 동물이나 캐릭터 사진을 입력하면, 이를 반다이(BANDAI) 스타일의 상용화된 1/7 스케일 3D 피규어 제품 사진으로 변환해 줍니다.',
  'https://placehold.co/600x400?text=Original+Image',
  'https://placehold.co/600x400?text=3D+Figure+Render',
  ARRAY['I2I', '3DFigure', 'ProductDesign', 'CommercialRender', 'BandaiStyle', 'ToyPackaging'],
  'Unknown',
  'create a 1/7 scale commercialized figure of thecharacter in the illustration, in a realistic styie and environment.Place the figure on a computer desk, using a circular transparent acrylic base without any text.On the computer screen, display the ZBrush modeling process of the figure.Next to the computer screen, place a BANDAl-style toy packaging box printedwith the original artwork.',
  '[{"key": "Model", "value": "Image-to-Image"}, {"key": "Style", "value": "Bandai Figure"}, {"key": "Scale", "value": "1/7"}]'::jsonb,
  ARRAY['사람이나 동물의 전신이 잘 나온 사진을 사용하면 효과가 좋습니다.', '배경이 복잡하지 않은 사진이 피규어 변환에 유리합니다.']
);
