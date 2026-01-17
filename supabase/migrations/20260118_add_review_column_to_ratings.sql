-- Add review column to ratings table if it doesn't exist
ALTER TABLE public.ratings
ADD COLUMN IF NOT EXISTS review text;

-- Optional: Update RLS policies if needed to allow updating the review column
-- (Assuming existing policies likely cover UPDATE on the row based on user_id, which usually covers all columns unless restricted)
