-- Drop the existing policy to avoid conflict and ensure we have the correct permission
drop policy if exists "Allow public read access" on ai_models;

-- Re-create the policy to allow everyone to read ai_models
create policy "Allow public read access"
  on ai_models for select
  using (true);

-- Ensure RLS is enabled
alter table ai_models enable row level security;
