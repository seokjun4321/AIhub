-- Step 11 Copy Block - Simple Version
UPDATE guide_steps
SET content = $$#### (B) 해야 할 일
- 최종 영상 기술 스펙 확인 (해상도, 비트레이트, 포맷)
- 플랫폼별 권장 사양 비교
- 제목/설명/태그 작성 (SEO 키워드 포함)
- 썸네일 제작
- 업로드 또는 예약 게시

#### (C) 복붙 블록

**YouTube Shorts:**
- 해상도: 1080x1920 (9:16)
- 길이: 15~60초
- 업로드 시간: 저녁 7~9시

**Instagram Reels:**
- 해상도: 1080x1920 (9:16)
- 길이: 15~30초
- 해시태그: 10~15개

**TikTok:**
- 해상도: 1080x1920 (9:16)
- 사운드: 트렌딩 음원
- 게시 시간: 오후 12시, 저녁 8시

**공통:**
- 코덱: H.264 MP4
- 자막: 영상 내장$$
WHERE guide_id = 14 AND step_order = 11;
