-- ==========================================================
-- 🔒 RE-ENABLE STRICT ROW LEVEL SECURITY (RLS)
-- ==========================================================
-- This script locks the database back down to ensure complete
-- tenant isolation and security.

ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.shops ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;

SELECT '✅ Row Level Security Fully Restored & Secured!' as status;
