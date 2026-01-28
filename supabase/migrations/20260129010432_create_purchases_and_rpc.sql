-- Create purchases table
CREATE TABLE IF NOT EXISTS public.purchases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    order_id TEXT NOT NULL UNIQUE,
    item_type TEXT CHECK (item_type IN ('preset', 'guide')) NOT NULL,
    item_id UUID NOT NULL,
    amount INTEGER NOT NULL,
    currency TEXT DEFAULT 'KRW',
    payment_method TEXT,
    payment_key TEXT NOT NULL,
    status TEXT CHECK (status IN ('COMPLETED', 'CANCELED', 'PARTIAL_CANCELED')) NOT NULL,
    raw_response JSONB,
    is_viewed BOOLEAN DEFAULT FALSE,
    paid_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.purchases ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view their own purchases"
    ON public.purchases FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Service role can insert purchases"
    ON public.purchases FOR INSERT
    WITH CHECK (true); -- Service role driven

CREATE POLICY "Service role can update purchases"
    ON public.purchases FOR UPDATE
    USING (true); -- Service role driven

-- Function to handle new purchase atomically
CREATE OR REPLACE FUNCTION handle_new_purchase(
    p_user_id UUID,
    p_order_id TEXT,
    p_item_type TEXT,
    p_item_id UUID,
    p_amount INTEGER,
    p_payment_key TEXT,
    p_payment_method TEXT,
    p_receipt_url TEXT,
    p_raw_response JSONB
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    existing_purchase JSONB;
    new_purchase_id UUID;
BEGIN
    -- 1. Idempotency Check: Check if order_id already exists
    SELECT to_jsonb(p) INTO existing_purchase
    FROM purchases p
    WHERE p.order_id = p_order_id;

    IF existing_purchase IS NOT NULL THEN
        -- Return existing purchase data if it exists (Idempotent success)
        RETURN jsonb_build_object(
            'status', 'success',
            'message', 'Purchase already exists (Idempotent)',
            'data', existing_purchase
        );
    END IF;

    -- 2. Insert new purchase record
    INSERT INTO purchases (
        user_id,
        order_id,
        item_type,
        item_id,
        amount,
        payment_key,
        payment_method,
        status,
        raw_response,
        paid_at
    ) VALUES (
        p_user_id,
        p_order_id,
        p_item_type,
        p_item_id,
        p_amount,
        p_payment_key,
        p_payment_method,
        'COMPLETED',
        p_raw_response,
        NOW()
    ) RETURNING id INTO new_purchase_id;

    -- 3. Grant Permissions (Placeholder for future logic)
    -- In Phase 2: Insert into user_library or update credits table here.
    -- Example:
    -- IF p_item_type = 'preset' THEN
    --    INSERT INTO user_presets (user_id, preset_id) VALUES (p_user_id, p_item_id);
    -- END IF;

    RETURN jsonb_build_object(
        'status', 'success',
        'message', 'Purchase recorded successfully',
        'purchase_id', new_purchase_id
    );

EXCEPTION WHEN OTHERS THEN
    -- Transaction will automatically rollback on exception
    RAISE;
END;
$$;
