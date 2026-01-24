-- Enable RLS on ai_models if not already enabled
alter table ai_models enable row level security;

-- Create policy to allow everyone to read ai_models
create policy "Allow public read access"
  on ai_models for select
  using (true);

-- Also ensure guides and presets have policies if they are part of v1 view
-- But the user specifically mentioned ai_models is missing.
