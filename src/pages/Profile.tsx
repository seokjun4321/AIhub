import { useState, useEffect, useRef } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { supabase } from '@/integrations/supabase/client';
import { useAuth } from '@/hooks/useAuth';
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
import { Upload, Trash2, Loader2, MessageSquare, ThumbsUp, Bookmark, Eye, Calendar, User } from 'lucide-react';
import ReactCrop, { type Crop } from 'react-image-crop';
import 'react-image-crop/dist/ReactCrop.css';

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

// 사용자의 댓글을 가져오는 함수
const fetchUserComments = async (userId: string) => {
  const { data, error } = await supabase
    .from('comments')
    .select(`
      id,
      content,
      created_at,
      upvotes_count,
      downvotes_count,
      posts (
        id,
        title,
        community_sections ( name, color, icon ),
        post_categories ( name, color, icon )
      )
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

  // --- 기존 상태 ---
  const [fullName, setFullName] = useState('');
  const [username, setUsername] = useState('');
  const [uploading, setUploading] = useState(false);
  const [removing, setRemoving] = useState(false);

  // --- ▼▼▼ 크롭 기능을 위한 상태 추가 ▼▼▼ ---
  const [imgSrc, setImgSrc] = useState('');
  const [crop, setCrop] = useState<Crop>();
  const [completedCrop, setCompletedCrop] = useState<Crop>();
  const imgRef = useRef<HTMLImageElement>(null);

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
  });

  const { data: userComments, isLoading: isCommentsLoading } = useQuery({
    queryKey: ['userComments', user?.id],
    queryFn: () => fetchUserComments(user!.id),
    enabled: !!user,
  });

  const { data: userVotedPosts, isLoading: isVotedPostsLoading } = useQuery({
    queryKey: ['userVotedPosts', user?.id],
    queryFn: () => fetchUserVotedPosts(user!.id),
    enabled: !!user,
  });

  const { data: userBookmarkedPosts, isLoading: isBookmarkedPostsLoading } = useQuery({
    queryKey: ['userBookmarkedPosts', user?.id],
    queryFn: () => fetchUserBookmarkedPosts(user!.id),
    enabled: !!user,
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
      const reader = new FileReader();
      reader.addEventListener('load', () => setImgSrc(reader.result?.toString() || ''));
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
          <Tabs defaultValue="profile" className="space-y-6">
            <TabsList className="grid w-full grid-cols-5">
              <TabsTrigger value="profile">프로필</TabsTrigger>
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
                  <div className="flex items-center gap-4 mb-8">
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
                    </div>
                    {profile.avatar_url && (
                      <Button
                        variant="ghost"
                        size="sm"
                        className="text-xs text-muted-foreground"
                        onClick={handleAvatarRemove}
                        disabled={removing || uploading}
                      >
                        {removing ? <Loader2 className="mr-2 h-3 w-3 animate-spin" /> : <Trash2 className="mr-2 h-3 w-3" />}
                        사진 제거
                      </Button>
                    )}
                    <div className="text-center">
                      <h2 className="text-2xl font-bold">{profile.full_name}</h2>
                      <p className="text-muted-foreground">@{profile.username}</p>
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
                    <div className="space-y-4">
                      {userComments.map((comment) => (
                        <div key={comment.id} className="p-4 border rounded-lg">
                          <div className="flex items-center gap-2 mb-2">
                            {comment.posts?.community_sections && (
                              <Badge 
                                variant="secondary"
                                style={{ backgroundColor: comment.posts.community_sections.color + '20', color: comment.posts.community_sections.color }}
                                className="text-xs"
                              >
                                {comment.posts.community_sections.name}
                              </Badge>
                            )}
                            {comment.posts?.post_categories && (
                              <Badge 
                                variant="outline"
                                style={{ borderColor: comment.posts.post_categories.color, color: comment.posts.post_categories.color }}
                                className="text-xs"
                              >
                                {comment.posts.post_categories.name}
                              </Badge>
                            )}
                          </div>
                          <Link to={`/community/${comment.posts?.id}`} className="block mb-2">
                            <h3 className="font-medium hover:text-primary transition-colors">
                              {comment.posts?.title}
                            </h3>
                          </Link>
                          <p className="text-sm text-muted-foreground mb-2">{comment.content}</p>
                          <div className="flex items-center gap-4 text-sm text-muted-foreground">
                            <span>{new Date(comment.created_at).toLocaleDateString()}</span>
                            <div className="flex items-center gap-1">
                              <ThumbsUp className="w-3 h-3" />
                              <span>{comment.upvotes_count || 0}</span>
                            </div>
                            <div className="flex items-center gap-1">
                              <ThumbsUp className="w-3 h-3 rotate-180" />
                              <span>{comment.downvotes_count || 0}</span>
                            </div>
                          </div>
                        </div>
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
        <DialogContent>
          <DialogHeader>
            <DialogTitle>프로필 사진 자르기</DialogTitle>
          </DialogHeader>
          {imgSrc && (
            <ReactCrop
              crop={crop}
              onChange={(_, percentCrop) => setCrop(percentCrop)}
              onComplete={(c) => setCompletedCrop(c)}
              aspect={1}
              circularCrop
            >
              <img
                ref={imgRef}
                alt="Crop me"
                src={imgSrc}
                style={{ maxHeight: '70vh' }}
              />
            </ReactCrop>
          )}
          <DialogFooter>
            <Button variant="outline" onClick={() => setImgSrc('')}>취소</Button>
            <Button onClick={handleCropAndUpload} disabled={uploading}>
              {uploading ? '업로드 중...' : '저장하기'}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
};

export default Profile;