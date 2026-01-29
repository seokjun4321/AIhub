-- Create guide_step_blocks table for structured content blocks (example, image, copy)
-- This table stores structured data for new block types that cannot be represented in plain markdown

CREATE TABLE IF NOT EXISTS public.guide_step_blocks (
    id SERIAL PRIMARY KEY,
    step_id INTEGER NOT NULL REFERENCES public.guide_steps(id) ON DELETE CASCADE,
    block_type TEXT NOT NULL, -- 'example', 'image', 'copy'
    block_order INTEGER NOT NULL DEFAULT 0,

    -- Example Block Fields
    title TEXT,
    description TEXT,
    example_text TEXT,
    example_type TEXT, -- 'success', 'warning', 'info'

    -- Image Block Fields
    image_url TEXT,
    caption TEXT,
    alt TEXT,
    width TEXT,

    -- Copy Block Fields
    text TEXT,
    language TEXT,

    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    CONSTRAINT valid_block_type CHECK (block_type IN ('example', 'image', 'copy'))
);

-- Indexes for performance
CREATE INDEX idx_guide_step_blocks_step_id ON public.guide_step_blocks(step_id);
CREATE INDEX idx_guide_step_blocks_type ON public.guide_step_blocks(block_type);

-- RLS Policies
ALTER TABLE public.guide_step_blocks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Step blocks are viewable by everyone"
ON public.guide_step_blocks FOR SELECT USING (true);

CREATE POLICY "Authors can manage own step blocks"
ON public.guide_step_blocks FOR ALL USING (
    EXISTS (
        SELECT 1 FROM public.guide_steps
        JOIN public.guides ON guides.id = guide_steps.guide_id
        WHERE guide_steps.id = guide_step_blocks.step_id
        AND guides.author_id = auth.uid()
    )
);

-- Trigger for updated_at
CREATE TRIGGER update_guide_step_blocks_updated_at
    BEFORE UPDATE ON public.guide_step_blocks
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
