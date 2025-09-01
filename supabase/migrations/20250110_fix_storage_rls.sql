-- Storage 버킷 RLS 정책 수정
-- avatars 버킷에 대한 정책 설정

-- avatars 버킷이 존재하지 않으면 생성
INSERT INTO storage.buckets (id, name, public)
VALUES ('avatars', 'avatars', true)
ON CONFLICT (id) DO NOTHING;

-- avatars 버킷의 기존 정책 삭제
DROP POLICY IF EXISTS "Avatar images are publicly accessible" ON storage.objects;
DROP POLICY IF EXISTS "Users can upload their own avatar" ON storage.objects;
DROP POLICY IF EXISTS "Users can update their own avatar" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete their own avatar" ON storage.objects;

-- avatars 버킷에 대한 새로운 정책 생성

-- 1. 모든 사용자가 아바타 이미지를 볼 수 있음
CREATE POLICY "Avatar images are publicly accessible" ON storage.objects
FOR SELECT USING (bucket_id = 'avatars');

-- 2. 인증된 사용자가 아바타를 업로드할 수 있음 (파일명이 사용자 ID로 시작하는 경우)
CREATE POLICY "Users can upload their own avatar" ON storage.objects
FOR INSERT TO authenticated 
WITH CHECK (
  bucket_id = 'avatars' 
  AND name LIKE auth.uid()::text || '%'
);

-- 3. 인증된 사용자가 자신의 아바타를 업데이트할 수 있음
CREATE POLICY "Users can update their own avatar" ON storage.objects
FOR UPDATE TO authenticated 
USING (
  bucket_id = 'avatars' 
  AND name LIKE auth.uid()::text || '%'
)
WITH CHECK (
  bucket_id = 'avatars' 
  AND name LIKE auth.uid()::text || '%'
);

-- 4. 인증된 사용자가 자신의 아바타를 삭제할 수 있음
CREATE POLICY "Users can delete their own avatar" ON storage.objects
FOR DELETE TO authenticated 
USING (
  bucket_id = 'avatars' 
  AND name LIKE auth.uid()::text || '%'
);
