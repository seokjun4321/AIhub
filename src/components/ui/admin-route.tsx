import { useEffect } from 'react';
import { useAuth } from '@/hooks/useAuth';
import { Loader2 } from 'lucide-react';
import { useLocation, useNavigate } from 'react-router-dom';
import { useToast } from '@/hooks/use-toast';
import { useAdmin } from '@/hooks/useAdmin';

interface AdminRouteProps {
    children: React.ReactNode;
}

const AdminRoute = ({ children }: AdminRouteProps) => {
    const { user } = useAuth();
    const { isAdmin, loading } = useAdmin();
    const location = useLocation();
    const navigate = useNavigate();
    const { toast } = useToast();

    // Handle redirects
    useEffect(() => {
        if (loading) return;

        if (!user) {
            // Not logged in -> Redirect to Auth
            const currentPath = location.pathname + (location.search || '');
            const url = new URL(window.location.origin + '/auth');
            url.searchParams.set('tab', 'signin');
            url.searchParams.set('returnTo', currentPath);
            window.location.replace(url.toString());
            return;
        }

        if (user && isAdmin === false) {
            // Logged in but not admin -> Redirect to Home
            toast({
                variant: "destructive",
                title: "접근 권한이 없습니다.",
                description: "관리자만 접근할 수 있는 페이지입니다.",
            });
            navigate('/', { replace: true });
        }
    }, [user, isAdmin, loading, location, navigate, toast]);

    if (loading) {
        return (
            <div className="min-h-screen flex items-center justify-center">
                <Loader2 className="w-8 h-8 animate-spin" />
            </div>
        );
    }

    if (!isAdmin) {
        return null;
    }

    return <>{children}</>;
};

export default AdminRoute;
