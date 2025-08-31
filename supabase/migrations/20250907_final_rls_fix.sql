-- 최종 RLS 정책 수정
-- 모든 커뮤니티 관련 테이블의 RLS 정책을 완전히 재설정

-- post_votes 테이블 RLS 정책 완전 재설정
DROP POLICY IF EXISTS "Authenticated users can view votes" ON public.post_votes;
DROP POLICY IF EXISTS "Users can manage their own votes" ON public.post_votes;
DROP POLICY IF EXISTS "Users can vote on posts" ON public.post_votes;
DROP POLICY IF EXISTS "Users can view their own votes" ON public.post_votes;
DROP POLICY IF EXISTS "Authenticated users can manage votes" ON public.post_votes;

-- post_votes: 모든 인증된 사용자가 모든 투표를 볼 수 있고, 자신의 투표만 관리 가능
CREATE POLICY "Authenticated users can view all votes" ON public.post_votes
FOR SELECT TO authenticated USING (true);

CREATE POLICY "Users can manage own votes" ON public.post_votes
FOR ALL TO authenticated USING (auth.uid() = user_id);

-- post_bookmarks 테이블 RLS 정책 재설정
DROP POLICY IF EXISTS "Users can manage own bookmarks" ON public.post_bookmarks;
DROP POLICY IF EXISTS "Authenticated users can manage bookmarks" ON public.post_bookmarks;

CREATE POLICY "Users can manage own bookmarks" ON public.post_bookmarks
FOR ALL TO authenticated USING (auth.uid() = user_id);

-- post_views 테이블 RLS 정책 재설정
DROP POLICY IF EXISTS "Anyone can record post views" ON public.post_views;
DROP POLICY IF EXISTS "Authenticated users can record views" ON public.post_views;

-- 인증된 사용자와 익명 사용자 모두 조회수 기록 가능
CREATE POLICY "Anyone can record post views" ON public.post_views
FOR INSERT TO authenticated, anon WITH CHECK (true);

-- comment_votes 테이블 RLS 정책 재설정
DROP POLICY IF EXISTS "Authenticated users can vote on comments" ON public.comment_votes;

CREATE POLICY "Users can manage own comment votes" ON public.comment_votes
FOR ALL TO authenticated USING (auth.uid() = user_id);

-- posts 테이블 RLS 정책 확인
DROP POLICY IF EXISTS "Posts are viewable by everyone" ON public.posts;
DROP POLICY IF EXISTS "Users can manage own posts" ON public.posts;

CREATE POLICY "Posts are viewable by everyone" ON public.posts
FOR SELECT USING (true);

CREATE POLICY "Users can manage own posts" ON public.posts
FOR ALL USING (auth.uid() = author_id);

-- comments 테이블 RLS 정책 확인
DROP POLICY IF EXISTS "Comments are viewable by everyone" ON public.comments;
DROP POLICY IF EXISTS "Users can manage own comments" ON public.comments;

CREATE POLICY "Comments are viewable by everyone" ON public.comments
FOR SELECT USING (true);

CREATE POLICY "Users can manage own comments" ON public.comments
FOR ALL USING (auth.uid() = author_id);

-- profiles 테이블 RLS 정책 확인
DROP POLICY IF EXISTS "Profiles are viewable by everyone" ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON public.profiles;

CREATE POLICY "Profiles are viewable by everyone" ON public.profiles
FOR SELECT USING (true);

CREATE POLICY "Users can update own profile" ON public.profiles
FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON public.profiles
FOR INSERT WITH CHECK (auth.uid() = id);
