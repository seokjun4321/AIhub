-- Guide Submissions Table
-- Stores user-submitted guides pending admin approval

BEGIN;

-- 1. Create guide_submissions table
CREATE TABLE IF NOT EXISTS public.guide_submissions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    guide_data JSONB NOT NULL,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    reviewed_at TIMESTAMP WITH TIME ZONE,
    reviewed_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    rejection_reason TEXT,
    admin_notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Create indexes
CREATE INDEX IF NOT EXISTS idx_guide_submissions_user_id ON public.guide_submissions(user_id);
CREATE INDEX IF NOT EXISTS idx_guide_submissions_status ON public.guide_submissions(status);
CREATE INDEX IF NOT EXISTS idx_guide_submissions_submitted_at ON public.guide_submissions(submitted_at DESC);

-- 3. Enable RLS
ALTER TABLE public.guide_submissions ENABLE ROW LEVEL SECURITY;

-- 4. RLS Policies
-- Users can view their own submissions
CREATE POLICY "Users can view own submissions"
    ON public.guide_submissions
    FOR SELECT
    USING (auth.uid() = user_id);

-- Admins can view all submissions
CREATE POLICY "Admins can view all submissions"
    ON public.guide_submissions
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.admin_users
            WHERE admin_users.email = (
                SELECT email FROM auth.users WHERE id = auth.uid()
            )
        )
    );

-- Authenticated users can create submissions
CREATE POLICY "Authenticated users can submit guides"
    ON public.guide_submissions
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Users can update only pending submissions (before review)
CREATE POLICY "Users can update own pending submissions"
    ON public.guide_submissions
    FOR UPDATE
    USING (auth.uid() = user_id AND status = 'pending')
    WITH CHECK (auth.uid() = user_id AND status = 'pending');

-- Admins can update any submission
CREATE POLICY "Admins can update submissions"
    ON public.guide_submissions
    FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM public.admin_users
            WHERE admin_users.email = (
                SELECT email FROM auth.users WHERE id = auth.uid()
            )
        )
    );

-- 5. Create updated_at trigger
CREATE TRIGGER update_guide_submissions_updated_at
    BEFORE UPDATE ON public.guide_submissions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 6. Add comment  
COMMENT ON TABLE public.guide_submissions IS 'Stores user-submitted guidebooks pending admin approval. guide_data contains the full JSON structure: { metadata, blocks, prompts }';

COMMIT;
