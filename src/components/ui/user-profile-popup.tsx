import { useQuery } from '@tanstack/react-query';
import { supabase } from '@/integrations/supabase/client';
import { Card, CardContent } from '@/components/ui/card';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Skeleton } from '@/components/ui/skeleton';
import { SimpleLevelProgress } from '@/components/ui/level-progress';
import { usePoints } from '@/hooks/usePoints';

interface UserProfilePopupProps {
  username: string;
  isOpen: boolean;
  onClose: () => void;
  position?: { x: number; y: number };
}

// 사용자 프로필 데이터 가져오기
const fetchUserProfile = async (username: string) => {
  const { data, error } = await supabase
    .from('profiles')
    .select(`
      *,
      posts:posts(count),
      comments:comments(count),
      post_votes:post_votes(count)
    `)
    .eq('username', username)
    .single();
  
  if (error) throw new Error(error.message);
  return data;
};

export const UserProfilePopup = ({ username, isOpen, onClose, position }: UserProfilePopupProps) => {
  const { levelConfigQuery } = usePoints();
  
  const { data: profile, isLoading, error } = useQuery({
    queryKey: ['userProfile', username],
    queryFn: () => fetchUserProfile(username),
    enabled: isOpen && !!username,
  });

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 bg-black/20" onClick={onClose}>
      <Card 
        className="w-80 max-h-64 overflow-y-auto shadow-xl border-2"
        onClick={(e) => e.stopPropagation()}
        style={{
          position: 'fixed',
          left: position?.x || '50%',
          top: position?.y || '50%',
          transform: position ? 'none' : 'translate(-50%, -50%)',
          zIndex: 51,
        }}
      >
        <CardContent className="p-4">
          {isLoading ? (
            <div className="space-y-3">
              <div className="flex items-center gap-3">
                <Skeleton className="h-12 w-12 rounded-full" />
                <div className="space-y-2">
                  <Skeleton className="h-4 w-24" />
                  <Skeleton className="h-3 w-16" />
                </div>
              </div>
              <Skeleton className="h-20 w-full" />
            </div>
          ) : error ? (
            <div className="text-center py-4">
              <p className="text-red-500">사용자를 찾을 수 없습니다.</p>
            </div>
          ) : profile ? (
            <div className="space-y-4">
              {/* 프로필 헤더 */}
              <div className="flex items-center gap-3">
                <Avatar className="h-12 w-12">
                  <AvatarImage src={profile.avatar_url || ''} alt={profile.username || ''} />
                  <AvatarFallback>{profile.username?.charAt(0).toUpperCase()}</AvatarFallback>
                </Avatar>
                <div className="flex-1">
                  <h3 className="font-bold text-lg">{profile.full_name || profile.username}</h3>
                  <p className="text-sm text-muted-foreground">@{profile.username}</p>
                </div>
              </div>

              {/* 레벨 정보 */}
              {profile && (() => {
                const currentLevel = profile.level || 1;
                const currentExp = profile.experience_points || 0;
                const nextLevelConfig = levelConfigQuery.data?.find(lc => lc.level === currentLevel + 1);
                const nextLevelExp = nextLevelConfig?.min_experience || (currentLevel * 100);
                
                return (
                  <SimpleLevelProgress
                    currentLevel={currentLevel}
                    currentExp={currentExp}
                    nextLevelExp={nextLevelExp}
                    className="mb-2"
                  />
                );
              })()}




            </div>
          ) : null}
        </CardContent>
      </Card>
    </div>
  );
};
