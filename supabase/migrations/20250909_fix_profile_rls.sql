-- 프로필 이미지 업로드 RLS 정책 수정
-- profiles 테이블의 RLS 정책을 더 명확하게 설정

-- 기존 정책 삭제
DROP POLICY IF EXISTS "Profiles are viewable by everyone" ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON public.profiles;

-- 새로운 정책 생성
-- 1. 모든 사용자가 프로필을 볼 수 있음
CREATE POLICY "Profiles are viewable by everyone" ON public.profiles
FOR SELECT USING (true);

-- 2. 인증된 사용자가 자신의 프로필을 업데이트할 수 있음 (avatar_url 포함)
CREATE POLICY "Users can update own profile" ON public.profiles
FOR UPDATE TO authenticated USING (auth.uid() = id);

-- 3. 인증된 사용자가 자신의 프로필을 생성할 수 있음
CREATE POLICY "Users can insert own profile" ON public.profiles
FOR INSERT TO authenticated WITH CHECK (auth.uid() = id);

-- 4. 인증된 사용자가 자신의 프로필을 삭제할 수 있음 (필요시)
CREATE POLICY "Users can delete own profile" ON public.profiles
FOR DELETE TO authenticated USING (auth.uid() = id);

-- Storage 버킷 정책도 확인
-- avatars 버킷에 대한 정책이 없다면 생성
-- (이 부분은 Supabase Dashboard에서 Storage > Policies에서 확인/설정 필요)

