-- post_votes 테이블 RLS 정책 완전 재설정
-- 기존 정책 모두 삭제
DROP POLICY IF EXISTS "Users can vote on posts" ON public.post_votes;
DROP POLICY IF EXISTS "Users can view their own votes" ON public.post_votes;
DROP POLICY IF EXISTS "Users can manage their own votes" ON public.post_votes;
DROP POLICY IF EXISTS "Authenticated users can manage votes" ON public.post_votes;

-- 새로운 정책 생성
-- 1. 조회 정책: 모든 인증된 사용자가 투표를 볼 수 있도록
CREATE POLICY "Authenticated users can view votes" ON public.post_votes
FOR SELECT USING (auth.role() = 'authenticated');

-- 2. 관리 정책: 사용자가 자신의 투표만 관리할 수 있도록
CREATE POLICY "Users can manage their own votes" ON public.post_votes
FOR ALL USING (auth.uid() = user_id);

-- post_views 테이블 RLS 정책도 확인
DROP POLICY IF EXISTS "Anyone can record post views" ON public.post_views;
CREATE POLICY "Anyone can record post views" ON public.post_views
FOR INSERT WITH CHECK (true);

-- comment_votes 테이블 RLS 정책도 확인
DROP POLICY IF EXISTS "Authenticated users can vote on comments" ON public.comment_votes;
CREATE POLICY "Authenticated users can vote on comments" ON public.comment_votes
FOR ALL USING (auth.uid() = user_id);
