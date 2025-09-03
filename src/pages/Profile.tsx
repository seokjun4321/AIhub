import { useState, useEffect, useRef } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { supabase } from '@/integrations/supabase/client';
import { useAuth } from '@/hooks/useAuth';
import { usePoints } from '@/hooks/usePoints';
import Navbar from '@/components/ui/navbar';
import Footer from '@/components/ui/footer';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { Label } from '@/components/ui/label';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from '@/components/ui/dialog';
import { Badge } from '@/components/ui/badge';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Skeleton } from '@/components/ui/skeleton';
import { toast } from 'sonner';
import { useNavigate, Link } from 'react-router-dom';
import { Upload, Trash2, Loader2, MessageSquare, ThumbsUp, Bookmark, Eye, Calendar, User, Star, Trophy, TrendingUp } from 'lucide-react';
import ReactCrop, { type Crop } from 'react-image-crop';
import 'react-image-crop/dist/ReactCrop.css';
import { PointDisplay } from '@/components/ui/point-display';
import { LevelProgress } from '@/components/ui/level-progress';
import { AchievementList } from '@/components/ui/achievement-badge';
import { PointHistory } from '@/components/ui/point-history';

// 프로필 데이터를 가져오는 함수
const fetchProfile = async (userId: string) => {
  const { data, error } = await supabase.from('profiles').select('*').eq('id', userId).single();
  if (error) throw new Error(error.message);
  return data;
};

// 사용자의 게시글을 가져오는 함수
const fetchUserPosts = async (userId: string) => {
  const { data, error } = await supabase
    .from('posts')
    .select(`
      id,
      title,
      content,
      created_at,
      upvotes_count,
      downvotes_count,
      view_count,
      comment_count,
      is_pinned,
      images,
      community_sections ( name, color, icon ),
      post_categories ( name, color, icon )
    `)
    .eq('author_id', userId)
    .order('created_at', { ascending: false });
  
  if (error) throw new Error(error.message);
  return data || [];
};

// 사용자의 댓글을 가져오는 함수 (단순 조회로 변경: 조인 이슈 회피)
const fetchUserComments = async (userId: string) => {
  const { data, error } = await supabase
    .from('comments')
    .select(`
      id,
      post_id,
      content,
      created_at,
      upvotes_count,
      downvotes_count
    `)
    .eq('author_id', userId)
    .order('created_at', { ascending: false });
  
  if (error) throw new Error(error.message);
  return data || [];
};

// 사용자가 추천한 게시글을 가져오는 함수
const fetchUserVotedPosts = async (userId: string) => {
  const { data, error } = await supabase
    .from('post_votes')
    .select(`
      vote_type,
      created_at,
      posts (
        id,
        title,
        content,
        created_at,
        upvotes_count,
        downvotes_count,
        view_count,
        comment_count,
        is_pinned,
        images,
        profiles ( username ),
        community_sections ( name, color, icon ),
        post_categories ( name, color, icon )
      )
    `)
    .eq('user_id', userId)
    .order('created_at', { ascending: false });
  
  if (error) throw new Error(error.message);
  return data || [];
};

// 사용자가 북마크한 게시글을 가져오는 함수
const fetchUserBookmarkedPosts = async (userId: string) => {
  const { data, error } = await supabase
    .from('post_bookmarks')
    .select(`
      created_at,
      posts (
        id,
        title,
        content,
        created_at,
        upvotes_count,
        downvotes_count,
        view_count,
        comment_count,
        is_pinned,
        images,
        profiles ( username ),
        community_sections ( name, color, icon ),
        post_categories ( name, color, icon )
      )
    `)
    .eq('user_id', userId)
    .order('created_at', { ascending: false });
  
  if (error) throw new Error(error.message);
  return data?.map(item => item.posts).filter(Boolean) || [];
};

// --- ▼▼▼ 이미지 크롭을 위한 헬퍼 함수 ▼▼▼ ---
function getCroppedImg(
  image: HTMLImageElement,
  crop: Crop,
  fileName: string
): Promise<File> {
  const canvas = document.createElement('canvas');
  const scaleX = image.naturalWidth / image.width;
  const scaleY = image.naturalHeight / image.height;
  canvas.width = crop.width;
  canvas.height = crop.height;
  const ctx = canvas.getContext('2d');

  if (!ctx) {
    return Promise.reject(new Error('Canvas context is not available'));
  }

  ctx.drawImage(
    image,
    crop.x * scaleX,
    crop.y * scaleY,
    crop.width * scaleX,
    crop.height * scaleY,
    0,
    0,
    crop.width,
    crop.height
  );

  return new Promise((resolve, reject) => {
    canvas.toBlob((blob) => {
      if (!blob) {
        reject(new Error('Canvas is empty'));
        return;
      }
      resolve(new File([blob], fileName, { type: 'image/png' }));
    }, 'image/png');
  });
}

const Profile = () => {
  const { user, loading: authLoading } = useAuth();
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const { 
    pointHistoryQuery, 
    levelConfigQuery, 
    achievementsQuery, 
    getCurrentLevelInfo 
  } = usePoints();

  // --- 기존 상태 ---
  const [activeTab, setActiveTab] = useState('profile');
  const [fullName, setFullName] = useState('');
  const [username, setUsername] = useState('');
  const [uploading, setUploading] = useState(false);
  const [removing, setRemoving] = useState(false);

  // --- ▼▼▼ 크롭 기능을 위한 상태 추가 ▼▼▼ ---
  const [imgSrc, setImgSrc] = useState('');
  const [crop, setCrop] = useState<Crop>();
  const [completedCrop, setCompletedCrop] = useState<Crop>();
  const [imageDimensions, setImageDimensions] = useState<{width: number, height: number} | null>(null);
  const [showCrop, setShowCrop] = useState(false);
  const imgRef = useRef<HTMLImageElement>(null);
  
  // 이미지 로드 후 크롭 영역 자동 설정
  const setInitialCrop = () => {
    if (!imgRef.current) return;
    
    const img = imgRef.current;
    const imgWidth = img.naturalWidth;
    const imgHeight = img.naturalHeight;
    
    // 이미지 크기 저장
    setImageDimensions({ width: imgWidth, height: imgHeight });
    
    const displayWidth = img.offsetWidth;
    const displayHeight = img.offsetHeight;
    
    // 이미지 비율에 따라 최적의 크롭 영역 계산
    const imageAspectRatio = imgWidth / imgHeight;
    
    let cropWidth, cropHeight, cropX, cropY;
    
    if (imageAspectRatio > 1) {
      // 가로가 더 긴 이미지 - 세로 기준으로 정사각형 크롭
      cropHeight = displayHeight;
      cropWidth = displayHeight; // 정사각형
      cropX = (displayWidth - cropWidth) / 2; // 가운데 정렬
      cropY = 0;
    } else if (imageAspectRatio < 1) {
      // 세로가 더 긴 이미지 - 가로 기준으로 정사각형 크롭
      cropWidth = displayWidth;
      cropHeight = displayWidth; // 정사각형
      cropX = 0;
      cropY = (displayHeight - cropHeight) / 2; // 가운데 정렬
    } else {
      // 정사각형 이미지 - 전체 사용
      cropWidth = displayWidth;
      cropHeight = displayHeight;
      cropX = 0;
      cropY = 0;
    }
    
    // 표시 크기에 대한 픽셀 단위로 설정
    const pixelCrop = {
      x: cropX,
      y: cropY,
      width: cropWidth,
      height: cropHeight,
      unit: 'px' as const
    };
    
    setCrop(pixelCrop);
  };

  // 이미지 클릭 시 크롭 영역 표시
  const handleImageClick = () => {
    if (!showCrop) {
      setShowCrop(true);
      setInitialCrop();
    }
  };

  // 이미지 비율에 따른 모달 크기 계산
  const getModalSize = () => {
    if (!imageDimensions) return { width: 'max-w-4xl', height: 'max-h-[95vh]' };
    
    const { width, height } = imageDimensions;
    const aspectRatio = width / height;
    
    // 화면 크기 제한
    const maxWidth = Math.min(width, 800);
    const maxHeight = Math.min(height, 700);
    
    if (aspectRatio > 1.5) {
      // 매우 가로가 긴 이미지
      return { 
        width: `max-w-[${maxWidth}px]`, 
        height: `max-h-[${Math.min(maxHeight, 500)}px]` 
      };
    } else if (aspectRatio > 1) {
      // 가로가 긴 이미지
      return { 
        width: `max-w-[${maxWidth}px]`, 
        height: `max-h-[${Math.min(maxHeight, 600)}px]` 
      };
    } else if (aspectRatio < 0.7) {
      // 매우 세로가 긴 이미지
      return { 
        width: `max-w-[${Math.min(maxWidth, 500)}px]`, 
        height: `max-h-[${maxHeight}px]` 
      };
    } else if (aspectRatio < 1) {
      // 세로가 긴 이미지
      return { 
        width: `max-w-[${Math.min(maxWidth, 600)}px]`, 
        height: `max-h-[${maxHeight}px]` 
      };
    } else {
      // 정사각형 이미지
      return { 
        width: `max-w-[${Math.min(maxWidth, 600)}px]`, 
        height: `max-h-[${Math.min(maxHeight, 600)}px]` 
      };
    }
  };

  // 프로필 데이터
  const { data: profile, isLoading: isProfileLoading, error } = useQuery({
    queryKey: ['profile', user?.id],
    queryFn: () => fetchProfile(user!.id),
    enabled: !!user,
  });

  // 사용자 활동 내역 데이터
  const { data: userPosts, isLoading: isPostsLoading } = useQuery({
    queryKey: ['userPosts', user?.id],
    queryFn: () => fetchUserPosts(user!.id),
    enabled: !!user,
    refetchOnMount: 'always',
    refetchOnWindowFocus: true,
    staleTime: 0,
  });

  const { data: userComments, isLoading: isCommentsLoading } = useQuery({
    queryKey: ['userComments', user?.id],
    queryFn: () => fetchUserComments(user!.id),
    enabled: !!user,
    refetchOnMount: 'always',
    refetchOnWindowFocus: true,
    staleTime: 0,
  });

  const { data: userVotedPosts, isLoading: isVotedPostsLoading } = useQuery({
    queryKey: ['userVotedPosts', user?.id],
    queryFn: () => fetchUserVotedPosts(user!.id),
    enabled: !!user,
    refetchOnMount: 'always',
    refetchOnWindowFocus: true,
    staleTime: 0,
  });

  const { data: userBookmarkedPosts, isLoading: isBookmarkedPostsLoading } = useQuery({
    queryKey: ['userBookmarkedPosts', user?.id],
    queryFn: () => fetchUserBookmarkedPosts(user!.id),
    enabled: !!user,
    refetchOnMount: 'always',
    refetchOnWindowFocus: true,
    staleTime: 0,
  });

  useEffect(() => {
    if (profile) {
      setFullName(profile.full_name || '');
      setUsername(profile.username || '');
    }
  }, [profile]);

  // --- ▼▼▼ 파일 선택 및 크롭 핸들러 수정 ▼▼▼ ---
  const onSelectFile = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files.length > 0) {
      setCrop(undefined); // Reset crop state
      setImageDimensions(null); // Reset image dimensions
      setShowCrop(false); // Reset crop visibility
      
      const reader = new FileReader();
      reader.addEventListener('load', () => {
        const result = reader.result?.toString() || '';
        setImgSrc(result);
        
        // 이미지 크기를 미리 가져와서 모달 크기 조정
        const img = new Image();
        img.onload = () => {
          setImageDimensions({ width: img.width, height: img.height });
        };
        img.src = result;
      });
      reader.readAsDataURL(e.target.files[0]);
    }
  };

  const handleCropAndUpload = async () => {
    if (!completedCrop || !imgRef.current || !user) {
      toast.error("이미지를 먼저 선택하고 영역을 지정해주세요.");
      return;
    }

    try {
      setUploading(true);
      const croppedImageFile = await getCroppedImg(
        imgRef.current,
        completedCrop,
        `${user.id}.png`
      );
      
      const filePath = `${user.id}.png`;

      // Storage에 업로드 (RLS 정책이 설정되어 있지 않으면 실패할 수 있음)
      const { error: uploadError } = await supabase.storage
        .from('avatars')
        .upload(filePath, croppedImageFile, { 
          upsert: true,
          cacheControl: '3600'
        });

      if (uploadError) {
        console.error('Upload error:', uploadError);
        // RLS 정책 에러인 경우 더 자세한 에러 메시지 제공
        if (uploadError.message.includes('row-level security')) {
          throw new Error('Storage 정책이 설정되지 않았습니다. 관리자에게 문의하세요.');
        }
        throw uploadError;
      }

      const { data } = supabase.storage
        .from('avatars')
        .getPublicUrl(filePath);
      
      const publicUrl = data.publicUrl;
      const newAvatarUrl = `${publicUrl}?t=${new Date().getTime()}`;

      // 프로필 테이블 업데이트
      const { error: updateError } = await supabase
        .from('profiles')
        .update({ 
          avatar_url: newAvatarUrl,
          updated_at: new Date().toISOString()
        })
        .eq('id', user.id)
        .select();

      if (updateError) throw updateError;
      
      toast.success("프로필 사진이 성공적으로 변경되었습니다!");
      queryClient.invalidateQueries({ queryKey: ['profile', user?.id] });
      setImgSrc(''); // 모달 닫기
    } catch (error: any) {
      console.error('Image upload error:', error);
      toast.error(`업로드 실패: ${error.message}`);
    } finally {
      setUploading(false);
    }
  };

  // --- ▼▼▼ 아바타 삭제 함수 추가 ▼▼▼ ---
  const handleAvatarRemove = async () => {
    if (!user || !profile?.avatar_url) {
      toast.error("삭제할 이미지가 없습니다.");
      return;
    }

    setRemoving(true);
    try {
      // 1. avatar_url에서 파일 경로 추출
      const url = new URL(profile.avatar_url);
      const filePath = url.pathname.split('/avatars/')[1];

      // 2. Storage에서 이미지 파일 삭제
      const { error: removeError } = await supabase.storage
        .from('avatars')
        .remove([filePath]);

      if (removeError) throw removeError;

      // 3. profiles 테이블에서 avatar_url을 null로 업데이트
      const { error: updateError } = await supabase
        .from('profiles')
        .update({ 
          avatar_url: null,
          updated_at: new Date().toISOString()
        })
        .eq('id', user.id)
        .select();

      if (updateError) throw updateError;

      toast.success("프로필 사진이 삭제되었습니다.");
      queryClient.invalidateQueries({ queryKey: ['profile', user?.id] });
    } catch (error: any) {
      console.error('Avatar remove error:', error);
      toast.error(`삭제 실패: ${error.message}`);
    } finally {
      setRemoving(false);
    }
  };
  
  // ... (updateProfileMutation, handleUpdateProfile, useEffect 등 나머지 로직은 동일)
    const updateProfileMutation = useMutation({
    mutationFn: async ({ fullName, username }: { fullName: string; username: string }) => {
      if (!user) throw new Error("User not found");
      const { data, error } = await supabase
        .from('profiles')
        .update({ 
          full_name: fullName, 
          username: username,
          updated_at: new Date().toISOString()
        })
        .eq('id', user.id)
        .select()
        .single();
      if (error) throw new Error(error.message);
      return data;
    },
    onSuccess: () => {
      toast.success("프로필이 성공적으로 업데이트되었습니다.");
      queryClient.invalidateQueries({ queryKey: ['profile', user?.id] });
    },
    onError: (error) => {
      console.error('Profile update error:', error);
      toast.error(`업데이트 실패: ${error.message}`);
    }
  });

  const handleUpdateProfile = (e: React.FormEvent) => {
    e.preventDefault();
    updateProfileMutation.mutate({ fullName, username });
  };
  
  useEffect(() => {
    if (!authLoading && !user) {
      navigate('/auth');
    }
  }, [user, authLoading, navigate]);

  if (authLoading || isProfileLoading) {
    return <div>Loading...</div>; // 간단한 로딩
  }

  if (error) return <div>Error: {error.message}</div>;
  if (!profile) return <div>Profile not found.</div>;


  return (
    <div className="min-h-screen">
      <Navbar />
      <main className="pt-24 pb-12">
        <div className="container mx-auto px-6 max-w-4xl">
          <Tabs value={activeTab} onValueChange={(v) => {
            setActiveTab(v);
            if (v === 'comments' && user?.id) {
              // 프로필의 내 댓글 탭으로 전환 시 즉시 최신 데이터로 새로고침
              queryClient.invalidateQueries({ queryKey: ['userComments', user.id] });
              queryClient.refetchQueries({ queryKey: ['userComments', user.id] });
            }
          }} className="space-y-6">
            <TabsList className="grid w-full grid-cols-8">
              <TabsTrigger value="profile">프로필</TabsTrigger>
              <TabsTrigger value="level">레벨</TabsTrigger>
              <TabsTrigger value="achievements">업적</TabsTrigger>
              <TabsTrigger value="points">포인트</TabsTrigger>
              <TabsTrigger value="posts">게시글</TabsTrigger>
              <TabsTrigger value="comments">댓글</TabsTrigger>
              <TabsTrigger value="votes">추천</TabsTrigger>
              <TabsTrigger value="bookmarks">북마크</TabsTrigger>
            </TabsList>

            {/* 프로필 설정 탭 */}
            <TabsContent value="profile">
              <Card>
                <CardHeader>
                  <CardTitle>프로필 설정</CardTitle>
                  <CardDescription>회원님의 정보를 관리하세요.</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="flex items-center gap-4 mb-12">
                    <div className="relative">
                      <Avatar className="h-24 w-24">
                        <AvatarImage src={profile.avatar_url || ''} alt={profile.username || ''} />
                        <AvatarFallback>{profile.username?.charAt(0).toUpperCase()}</AvatarFallback>
                      </Avatar>
                      <Label 
                        htmlFor="avatar-upload"
                        className="absolute bottom-0 right-0 p-2 bg-primary text-primary-foreground rounded-full cursor-pointer hover:bg-primary/90 transition-colors"
                      >
                        <Upload className="h-4 w-4" />
                        <input 
                          id="avatar-upload" 
                          type="file" 
                          accept="image/png, image/jpeg"
                          className="hidden"
                          onChange={onSelectFile}
                          disabled={uploading}
                        />
                      </Label>
                      {/* 사진 제거 버튼 - 프로필 사진 바로 아래에 배치 */}
                      {profile.avatar_url && (
                        <div className="absolute top-full left-1/2 transform -translate-x-1/2 mt-2">
                          <Button
                            variant="ghost"
                            size="sm"
                            className="text-xs text-muted-foreground hover:text-destructive"
                            onClick={handleAvatarRemove}
                            disabled={removing || uploading}
                          >
                            {removing ? <Loader2 className="mr-2 h-3 w-3 animate-spin" /> : <Trash2 className="mr-2 h-3 w-3" />}
                            사진 제거
                          </Button>
                        </div>
                      )}
                    </div>
                    <div className="text-center">
                      <h2 className="text-2xl font-bold">{profile.full_name}</h2>
                      <p className="text-muted-foreground">@{profile.username}</p>
                      <div className="flex items-center justify-center gap-2 mt-2">
                        <div className="flex items-center gap-2">
                          {(() => {
                            const level = profile.level || 1;
                            const getLevelStyle = (level: number) => {
                              if (level >= 10) {
                                return {
                                  gradient: "from-yellow-500 to-orange-600",
                                  icon: "👑"
                                };
                              } else if (level >= 5) {
                                return {
                                  gradient: "from-purple-500 to-pink-600",
                                  icon: "⚡"
                                };
                              } else {
                                return {
                                  gradient: "from-blue-500 to-purple-600",
                                  icon: "⭐"
                                };
                              }
                            };
                            const levelStyle = getLevelStyle(level);
                            return (
                              <div className={`bg-gradient-to-r ${levelStyle.gradient} text-white px-3 py-1 rounded-full text-sm font-semibold shadow-lg flex items-center gap-1.5 border border-white/20`}>
                                <span className="text-xs">{levelStyle.icon}</span>
                                <span>Lv.{level}</span>
                              </div>
                            );
                          })()}
                        </div>
                        <PointDisplay 
                          points={profile.total_points || 0} 
                          type="total" 
                          size="sm"
                        />
                      </div>
                    </div>
                  </div>
                  
                  <form onSubmit={handleUpdateProfile} className="space-y-6">
                    <div className="space-y-2">
                      <Label htmlFor="email">이메일</Label>
                      <Input id="email" type="email" value={user?.email || ''} disabled />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="fullName">성명</Label>
                      <Input id="fullName" value={fullName} onChange={(e) => setFullName(e.target.value)} />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="username">아이디</Label>
                      <Input id="username" value={username} onChange={(e) => setUsername(e.target.value)} />
                    </div>
                    <Button type="submit" disabled={updateProfileMutation.isPending || uploading}>
                      {updateProfileMutation.isPending || uploading ? "저장 중..." : "변경사항 저장"}
                    </Button>
                  </form>
                </CardContent>
              </Card>
            </TabsContent>

            {/* 레벨 탭 */}
            <TabsContent value="level">
              <div className="grid gap-6 md:grid-cols-2">
                <LevelProgress 
                  currentLevel={profile.level || 1}
                  currentExp={profile.experience_points || 0}
                  levelTitle={levelConfigQuery.data?.find(lc => lc.level === (profile.level || 1))?.title}
                  nextLevelExp={levelConfigQuery.data?.find(lc => lc.level === (profile.level || 1) + 1)?.min_experience}
                />
                
                <Card>
                  <CardHeader>
                    <CardTitle className="flex items-center gap-2">
                      <TrendingUp className="w-5 h-5 text-blue-500" />
                      활동 통계
                    </CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <div className="grid grid-cols-2 gap-4">
                      <div className="text-center p-4 bg-blue-50 rounded-lg">
                        <div className="text-2xl font-bold text-blue-600">{profile.post_count || 0}</div>
                        <div className="text-sm text-gray-600">게시글</div>
                      </div>
                      <div className="text-center p-4 bg-green-50 rounded-lg">
                        <div className="text-2xl font-bold text-green-600">{profile.comment_count || 0}</div>
                        <div className="text-sm text-gray-600">댓글</div>
                      </div>
                    </div>
                    
                    <div className="space-y-3">
                      <div className="flex items-center justify-between">
                        <span className="text-sm text-gray-600">총 포인트</span>
                        <PointDisplay points={profile.total_points || 0} type="total" size="sm" />
                      </div>
                      <div className="flex items-center justify-between">
                        <span className="text-sm text-gray-600">이번 주 포인트</span>
                        <PointDisplay points={profile.points_this_week || 0} type="weekly" size="sm" />
                      </div>
                      <div className="flex items-center justify-between">
                        <span className="text-sm text-gray-600">이번 달 포인트</span>
                        <PointDisplay points={profile.points_this_month || 0} type="monthly" size="sm" />
                      </div>
                      <div className="flex items-center justify-between">
                        <span className="text-sm text-gray-600">연속 활동</span>
                        <PointDisplay points={profile.streak_days || 0} type="streak" size="sm" />
                      </div>
                    </div>
                  </CardContent>
                </Card>
              </div>
            </TabsContent>

            {/* 업적 탭 */}
            <TabsContent value="achievements">
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Trophy className="w-5 h-5 text-yellow-500" />
                    업적 ({achievementsQuery.data?.filter(a => a.earned).length || 0} / {achievementsQuery.data?.length || 0})
                  </CardTitle>
                  <CardDescription>
                    다양한 활동을 통해 업적을 달성해보세요!
                  </CardDescription>
                </CardHeader>
                <CardContent>
                  {achievementsQuery.isLoading ? (
                    <div className="space-y-4">
                      {[...Array(6)].map((_, i) => <Skeleton key={i} className="h-24 w-full" />)}
                    </div>
                  ) : achievementsQuery.data ? (
                    <AchievementList achievements={achievementsQuery.data} />
                  ) : (
                    <div className="text-center py-8">
                      <Trophy className="w-12 h-12 text-muted-foreground mx-auto mb-4" />
                      <p className="text-muted-foreground">업적을 불러올 수 없습니다.</p>
                    </div>
                  )}
                </CardContent>
              </Card>
            </TabsContent>

            {/* 포인트 탭 */}
            <TabsContent value="points">
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Star className="w-5 h-5 text-yellow-500" />
                    포인트 이력
                  </CardTitle>
                  <CardDescription>
                    포인트 획득 및 사용 내역을 확인하세요.
                  </CardDescription>
                </CardHeader>
                <CardContent>
                  {pointHistoryQuery.isLoading ? (
                    <div className="space-y-4">
                      {[...Array(5)].map((_, i) => <Skeleton key={i} className="h-16 w-full" />)}
                    </div>
                  ) : pointHistoryQuery.data ? (
                    <PointHistory history={pointHistoryQuery.data} />
                  ) : (
                    <div className="text-center py-8">
                      <Star className="w-12 h-12 text-muted-foreground mx-auto mb-4" />
                      <p className="text-muted-foreground">포인트 이력을 불러올 수 없습니다.</p>
                    </div>
                  )}
                </CardContent>
              </Card>
            </TabsContent>

            {/* 게시글 탭 */}
            <TabsContent value="posts">
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <MessageSquare className="w-5 h-5" />
                    내 게시글 ({userPosts?.length || 0})
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  {isPostsLoading ? (
                    <div className="space-y-4">
                      {[...Array(3)].map((_, i) => <Skeleton key={i} className="h-20 w-full" />)}
                    </div>
                  ) : userPosts && userPosts.length > 0 ? (
                    <div className="space-y-4">
                      {userPosts.map((post) => (
                        <div key={post.id} className="flex items-center justify-between p-4 border rounded-lg">
                          <div className="flex-1">
                            <div className="flex items-center gap-2 mb-2">
                              {post.is_pinned && (
                                <Badge variant="secondary" className="bg-yellow-100 text-yellow-800 text-xs">
                                  고정
                                </Badge>
                              )}
                              {post.community_sections && (
                                <Badge 
                                  variant="secondary"
                                  style={{ backgroundColor: post.community_sections.color + '20', color: post.community_sections.color }}
                                  className="text-xs"
                                >
                                  {post.community_sections.name}
                                </Badge>
                              )}
                              {post.post_categories && (
                                <Badge 
                                  variant="outline"
                                  style={{ borderColor: post.post_categories.color, color: post.post_categories.color }}
                                  className="text-xs"
                                >
                                  {post.post_categories.name}
                                </Badge>
                              )}
                            </div>
                            <Link to={`/community/${post.id}`} className="block">
                              <h3 className="font-medium hover:text-primary transition-colors">
                                {post.title}
                              </h3>
                            </Link>
                            <div className="flex items-center gap-4 text-sm text-muted-foreground mt-2">
                              <span>{new Date(post.created_at).toLocaleDateString()}</span>
                              <div className="flex items-center gap-1">
                                <Eye className="w-3 h-3" />
                                <span>{post.view_count || 0}</span>
                              </div>
                              <div className="flex items-center gap-1">
                                <MessageSquare className="w-3 h-3" />
                                <span>{post.comment_count || 0}</span>
                              </div>
                              <div className="flex items-center gap-1">
                                <ThumbsUp className="w-3 h-3" />
                                <span>{post.upvotes_count || 0}</span>
                              </div>
                            </div>
                          </div>
                        </div>
                      ))}
                    </div>
                  ) : (
                    <div className="text-center py-8">
                      <MessageSquare className="w-12 h-12 text-muted-foreground mx-auto mb-4" />
                      <p className="text-muted-foreground">아직 작성한 게시글이 없습니다.</p>
                    </div>
                  )}
                </CardContent>
              </Card>
            </TabsContent>

            {/* 댓글 탭 */}
            <TabsContent value="comments">
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <MessageSquare className="w-5 h-5" />
                    내 댓글 ({userComments?.length || 0})
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  {isCommentsLoading ? (
                    <div className="space-y-4">
                      {[...Array(3)].map((_, i) => <Skeleton key={i} className="h-20 w-full" />)}
                    </div>
                  ) : userComments && userComments.length > 0 ? (
                    <div className="space-y-2">
                      {userComments.map((comment) => (
                        <Link
                          key={comment.id}
                          to={`/community/${comment.post_id}`}
                          className="block p-3 border rounded-md hover:bg-muted/40 transition-colors"
                        >
                          <div className="flex items-center gap-2 mb-1">
                            <span className="text-xs text-muted-foreground">{new Date(comment.created_at).toLocaleDateString()}</span>
                          </div>
                          <p className="text-sm text-muted-foreground line-clamp-2">{comment.content}</p>
                          <div className="mt-2 flex items-center gap-3 text-xs text-muted-foreground">
                            <div className="flex items-center gap-1">
                              <ThumbsUp className="w-3 h-3" />
                              <span>{comment.upvotes_count || 0}</span>
                            </div>
                            <div className="flex items-center gap-1">
                              <ThumbsUp className="w-3 h-3 rotate-180" />
                              <span>{comment.downvotes_count || 0}</span>
                            </div>
                          </div>
                        </Link>
                      ))}
                    </div>
                  ) : (
                    <div className="text-center py-8">
                      <MessageSquare className="w-12 h-12 text-muted-foreground mx-auto mb-4" />
                      <p className="text-muted-foreground">아직 작성한 댓글이 없습니다.</p>
                    </div>
                  )}
                </CardContent>
              </Card>
            </TabsContent>

            {/* 추천 탭 */}
            <TabsContent value="votes">
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <ThumbsUp className="w-5 h-5" />
                    추천한 게시글 ({userVotedPosts?.length || 0})
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  {isVotedPostsLoading ? (
                    <div className="space-y-4">
                      {[...Array(3)].map((_, i) => <Skeleton key={i} className="h-20 w-full" />)}
                    </div>
                  ) : userVotedPosts && userVotedPosts.length > 0 ? (
                    <div className="space-y-4">
                      {userVotedPosts.map((vote) => (
                        <div key={vote.posts.id} className="flex items-center justify-between p-4 border rounded-lg">
                          <div className="flex-1">
                            <div className="flex items-center gap-2 mb-2">
                              <Badge variant={vote.vote_type === 1 ? "default" : "destructive"} className="text-xs">
                                {vote.vote_type === 1 ? "추천" : "비추천"}
                              </Badge>
                              {vote.posts.is_pinned && (
                                <Badge variant="secondary" className="bg-yellow-100 text-yellow-800 text-xs">
                                  고정
                                </Badge>
                              )}
                              {vote.posts.community_sections && (
                                <Badge 
                                  variant="secondary"
                                  style={{ backgroundColor: vote.posts.community_sections.color + '20', color: vote.posts.community_sections.color }}
                                  className="text-xs"
                                >
                                  {vote.posts.community_sections.name}
                                </Badge>
                              )}
                            </div>
                            <Link to={`/community/${vote.posts.id}`} className="block">
                              <h3 className="font-medium hover:text-primary transition-colors">
                                {vote.posts.title}
                              </h3>
                            </Link>
                            <div className="flex items-center gap-4 text-sm text-muted-foreground mt-2">
                              <span>{new Date(vote.created_at).toLocaleDateString()}</span>
                              <div className="flex items-center gap-1">
                                <User className="w-3 h-3" />
                                <span>{vote.posts.profiles?.username || '익명'}</span>
                              </div>
                              <div className="flex items-center gap-1">
                                <Eye className="w-3 h-3" />
                                <span>{vote.posts.view_count || 0}</span>
                              </div>
                              <div className="flex items-center gap-1">
                                <MessageSquare className="w-3 h-3" />
                                <span>{vote.posts.comment_count || 0}</span>
                              </div>
                            </div>
                          </div>
                        </div>
                      ))}
                    </div>
                  ) : (
                    <div className="text-center py-8">
                      <ThumbsUp className="w-12 h-12 text-muted-foreground mx-auto mb-4" />
                      <p className="text-muted-foreground">아직 추천한 게시글이 없습니다.</p>
                    </div>
                  )}
                </CardContent>
              </Card>
            </TabsContent>

            {/* 북마크 탭 */}
            <TabsContent value="bookmarks">
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Bookmark className="w-5 h-5" />
                    북마크한 게시글 ({userBookmarkedPosts?.length || 0})
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  {isBookmarkedPostsLoading ? (
                    <div className="space-y-4">
                      {[...Array(3)].map((_, i) => <Skeleton key={i} className="h-20 w-full" />)}
                    </div>
                  ) : userBookmarkedPosts && userBookmarkedPosts.length > 0 ? (
                    <div className="space-y-4">
                      {userBookmarkedPosts.map((post) => (
                        <div key={post.id} className="flex items-center justify-between p-4 border rounded-lg">
                          <div className="flex-1">
                            <div className="flex items-center gap-2 mb-2">
                              {post.is_pinned && (
                                <Badge variant="secondary" className="bg-yellow-100 text-yellow-800 text-xs">
                                  고정
                                </Badge>
                              )}
                              {post.community_sections && (
                                <Badge 
                                  variant="secondary"
                                  style={{ backgroundColor: post.community_sections.color + '20', color: post.community_sections.color }}
                                  className="text-xs"
                                >
                                  {post.community_sections.name}
                                </Badge>
                              )}
                              {post.post_categories && (
                                <Badge 
                                  variant="outline"
                                  style={{ borderColor: post.post_categories.color, color: post.post_categories.color }}
                                  className="text-xs"
                                >
                                  {post.post_categories.name}
                                </Badge>
                              )}
                            </div>
                            <Link to={`/community/${post.id}`} className="block">
                              <h3 className="font-medium hover:text-primary transition-colors">
                                {post.title}
                              </h3>
                            </Link>
                            <div className="flex items-center gap-4 text-sm text-muted-foreground mt-2">
                              <span>{new Date(post.created_at).toLocaleDateString()}</span>
                              <div className="flex items-center gap-1">
                                <User className="w-3 h-3" />
                                <span>{post.profiles?.username || '익명'}</span>
                              </div>
                              <div className="flex items-center gap-1">
                                <Eye className="w-3 h-3" />
                                <span>{post.view_count || 0}</span>
                              </div>
                              <div className="flex items-center gap-1">
                                <MessageSquare className="w-3 h-3" />
                                <span>{post.comment_count || 0}</span>
                              </div>
                            </div>
                          </div>
                        </div>
                      ))}
                    </div>
                  ) : (
                    <div className="text-center py-8">
                      <Bookmark className="w-12 h-12 text-muted-foreground mx-auto mb-4" />
                      <p className="text-muted-foreground">아직 북마크한 게시글이 없습니다.</p>
                    </div>
                  )}
                </CardContent>
              </Card>
            </TabsContent>
          </Tabs>
        </div>
      </main>
      <Footer />

      {/* --- ▼▼▼ 이미지 크롭 모달 추가 ▼▼▼ --- */}
      <Dialog open={!!imgSrc} onOpenChange={(isOpen) => !isOpen && setImgSrc('')}>
        <DialogContent 
          className="overflow-hidden p-4"
          style={{
            width: imageDimensions ? `${Math.min(imageDimensions.width + 120, 900)}px` : '600px',
            height: imageDimensions ? `${Math.min(imageDimensions.height + 200, 800)}px` : '600px',
            maxWidth: '90vw',
            maxHeight: '90vh'
          }}
        >
          <DialogHeader className="pb-4">
            <DialogTitle className="text-lg font-semibold">프로필 사진 자르기</DialogTitle>
            <p className="text-sm text-muted-foreground">
              {!showCrop ? "이미지를 클릭하여 크롭 영역을 설정하세요" : "크롭 영역을 조정하고 저장하세요"}
            </p>
          </DialogHeader>
          {imgSrc && (
            <div className="flex justify-center items-center overflow-hidden" style={{
              minHeight: imageDimensions ? `${Math.min(imageDimensions.height, 400)}px` : '400px',
              maxHeight: imageDimensions ? `${Math.min(imageDimensions.height + 100, 500)}px` : '500px'
            }}>
              {showCrop ? (
                <ReactCrop
                  crop={crop}
                  onChange={(_, percentCrop) => setCrop(percentCrop)}
                  onComplete={(c) => setCompletedCrop(c)}
                  aspect={1}
                  circularCrop
                  className="w-full h-full"
                >
                  <img
                    ref={imgRef}
                    alt="Crop me"
                    src={imgSrc}
                    style={{ 
                      maxHeight: imageDimensions ? `${Math.min(imageDimensions.height, 400)}px` : '400px',
                      width: '100%',
                      height: 'auto',
                      objectFit: 'contain',
                      display: 'block',
                      cursor: 'pointer'
                    }}
                  />
                </ReactCrop>
              ) : (
                <img
                  ref={imgRef}
                  alt="Click to crop"
                  src={imgSrc}
                  onClick={handleImageClick}
                  style={{ 
                    maxHeight: imageDimensions ? `${Math.min(imageDimensions.height, 400)}px` : '400px',
                    width: '100%',
                    height: 'auto',
                    objectFit: 'contain',
                    display: 'block',
                    cursor: 'pointer'
                  }}
                />
              )}
            </div>
          )}
          <DialogFooter>
            <Button variant="outline" onClick={() => setImgSrc('')}>취소</Button>
            <Button 
              onClick={handleCropAndUpload} 
              disabled={uploading || !showCrop || !completedCrop}
            >
              {uploading ? '업로드 중...' : '저장하기'}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
};

export default Profile;