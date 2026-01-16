import { useEffect, useState } from 'react';
import { useAuth } from '@/hooks/useAuth';
import { supabase } from '@/integrations/supabase/client';

export const useAdmin = () => {
    const { user, loading: authLoading } = useAuth();
    const [isAdmin, setIsAdmin] = useState<boolean | null>(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const checkAdmin = async () => {
            if (!user) {
                setIsAdmin(false);
                setLoading(false);
                return;
            }

            try {
                const { data, error } = await supabase
                    .from('admin_users' as any)
                    .select('email')
                    .eq('email', user.email)
                    .maybeSingle();

                if (error || !data) {
                    setIsAdmin(false);
                } else {
                    setIsAdmin(true);
                }
            } catch (error) {
                console.error('Error checking admin status:', error);
                setIsAdmin(false);
            } finally {
                setLoading(false);
            }
        };

        if (!authLoading) {
            checkAdmin();
        }
    }, [user, authLoading]);

    return { isAdmin, loading: loading || authLoading };
};
