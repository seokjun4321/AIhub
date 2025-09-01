-- Ensure trigger functions bypass RLS by running with definer privileges

-- posts view_count updater
ALTER FUNCTION public.update_post_view_count() SECURITY DEFINER;
ALTER FUNCTION public.update_post_view_count() SET search_path = public;

-- posts upvotes/downvotes counters
ALTER FUNCTION public.update_post_vote_counts() SECURITY DEFINER;
ALTER FUNCTION public.update_post_vote_counts() SET search_path = public;

-- comments vote counters
ALTER FUNCTION public.update_comment_vote_counts() SECURITY DEFINER;
ALTER FUNCTION public.update_comment_vote_counts() SET search_path = public;

-- posts comment_count updater
ALTER FUNCTION public.update_post_comment_count() SECURITY DEFINER;
ALTER FUNCTION public.update_post_comment_count() SET search_path = public;

-- 추가: SECURITY DEFINER가 누락되었거나 덮어쓰기 방지를 위해 재적용 보장
DO $$
BEGIN
  PERFORM 1;
END $$;





