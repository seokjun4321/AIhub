-- Enable RLS on presets table
ALTER TABLE public.presets ENABLE ROW LEVEL SECURITY;

-- Allow public read access to presets
CREATE POLICY "Presets are viewable by everyone" ON public.presets
  FOR SELECT
  USING (true);
