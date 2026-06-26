-- =====================================================================================
-- ESCROW SYSTEM SCHEMA
-- Manages payments, holding funds in escrow, and disputes
-- =====================================================================================

-- Helper function to auto-update the updated_at column
CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- ENUMS
CREATE TYPE payment_status AS ENUM ('PENDING_FUNDS', 'IN_ESCROW', 'RELEASED', 'REFUNDED', 'IN_DISPUTE');

-- ESCROW PAYMENTS TABLE
CREATE TABLE public.escrow_payments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    order_id UUID REFERENCES public.orders(id) ON DELETE CASCADE NOT NULL,
    client_id UUID REFERENCES public.user_profiles(id) NOT NULL,
    tailor_id UUID REFERENCES public.user_profiles(id) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    platform_fee DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    currency VARCHAR(3) DEFAULT 'KES',
    status payment_status DEFAULT 'PENDING_FUNDS',
    paystack_reference VARCHAR(255) UNIQUE,
    paystack_authorization_code VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    released_at TIMESTAMP WITH TIME ZONE
);

-- DISPUTES TABLE
CREATE TABLE public.disputes (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    escrow_payment_id UUID REFERENCES public.escrow_payments(id) ON DELETE CASCADE NOT NULL,
    raised_by UUID REFERENCES public.user_profiles(id) NOT NULL,
    reason TEXT NOT NULL,
    evidence_urls TEXT[],
    status VARCHAR(50) DEFAULT 'OPEN', -- OPEN, RESOLVED_CLIENT, RESOLVED_TAILOR
    resolution_notes TEXT,
    resolved_by UUID REFERENCES public.user_profiles(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- TRIGGERS FOR UPDATED_AT
CREATE TRIGGER set_escrow_payments_updated_at
    BEFORE UPDATE ON public.escrow_payments
    FOR EACH ROW
    EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER set_disputes_updated_at
    BEFORE UPDATE ON public.disputes
    FOR EACH ROW
    EXECUTE FUNCTION update_modified_column();

-- RLS POLICIES FOR ESCROW PAYMENTS
ALTER TABLE public.escrow_payments ENABLE ROW LEVEL SECURITY;

-- Clients can see their own payments
CREATE POLICY "Clients can view their escrow payments"
    ON public.escrow_payments FOR SELECT
    USING (auth.uid() = client_id);

-- Tailors can see payments intended for them
CREATE POLICY "Tailors can view payments intended for them"
    ON public.escrow_payments FOR SELECT
    USING (auth.uid() = tailor_id);

-- Superadmins can view all payments
CREATE POLICY "Superadmins can view all payments"
    ON public.escrow_payments FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.user_profiles
            WHERE id = auth.uid() AND role = 'superadmin'
        )
    );

-- RLS POLICIES FOR DISPUTES
ALTER TABLE public.disputes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own disputes"
    ON public.disputes FOR SELECT
    USING (
        auth.uid() IN (
            SELECT client_id FROM public.escrow_payments WHERE id = escrow_payment_id
            UNION
            SELECT tailor_id FROM public.escrow_payments WHERE id = escrow_payment_id
        )
    );

CREATE POLICY "Superadmins can manage disputes"
    ON public.disputes FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM public.user_profiles
            WHERE id = auth.uid() AND role = 'superadmin'
        )
    );
