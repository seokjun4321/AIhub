-- Create feedbacks table
create table if not exists public.feedbacks (
  id uuid default gen_random_uuid() primary key,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  user_id uuid references auth.users(id), -- 로그인한 경우 user_id 저장
  
  -- Feedback Context
  trigger text not null, -- 'global_widget', 'guidebook_complete', 'preset_copy'
  entity_type text,      -- 'guidebook', 'preset', 'workflow' (optional)
  entity_id text,        -- 해당 콘텐츠 ID (optional)
  step_id text,          -- 가이드북의 경우 step ID (optional)
  page_url text,         -- 피드백을 보낸 페이지 URL

  -- User Input
  category text,         -- 'bug', 'feature', 'content', 'other' (Global Only)
  rating integer,        -- 1~5 (Global), 0/1 (Micro)
  message text,          -- 주관식 내용
  email text,            -- 답변 받을 이메일 (optional)
  
  -- Metadata (Flexible JSON)
  metadata jsonb default '{}'::jsonb -- device, browser, etc.
);

-- Enable RLS
alter table public.feedbacks enable row level security;

-- Policies
-- 1. Enable insert for everyone (Anon + Authenticated)
create policy "Enable insert for everyone" on public.feedbacks
  for insert
  with check (true);

-- 2. Enable read for admins only (or users for their own feedback)
-- For now, let's allow users to see their own feedback
create policy "Users can see their own feedback" on public.feedbacks
  for select
  using (auth.uid() = user_id);

-- 3. (Optional) Service Role can do everything (default)
