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
import { toast } from 'sonner';
import { useNavigate } from 'react-router-dom';
import { Upload, Trash2, Loader2 } from 'lucide-react';
import ReactCrop, { type Crop } from 'react-image-crop';
import 'react-image-crop/dist/ReactCrop.css';

// ... (fetchProfile 함수는 기존과 동일)
const fetchProfile = async (userId: string) => {
  const { data, error } = await supabase.from('profiles').select('*').eq('id', userId).single();
  if (error) throw new Error(error.message);
  return data;
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

  // ... (useQuery, useEffect 등 기존 로직)

    const { data: profile, isLoading: isProfileLoading, error } = useQuery({
    queryKey: ['profile', user?.id],
    queryFn: () => fetchProfile(user!.id),
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

      const { error: uploadError } = await supabase.storage
        .from('avatars')
        .upload(filePath, croppedImageFile, { upsert: true });

      if (uploadError) throw uploadError;

      const { data } = supabase.storage
        .from('avatars')
        .getPublicUrl(filePath);
      
      const publicUrl = data.publicUrl;
      const newAvatarUrl = `${publicUrl}?t=${new Date().getTime()}`;

      const { error: updateError } = await supabase
        .from('profiles')
        .update({ avatar_url: newAvatarUrl })
        .eq('id', user.id);

      if (updateError) throw updateError;
      
      toast.success("프로필 사진이 성공적으로 변경되었습니다!");
      queryClient.invalidateQueries({ queryKey: ['profile', user?.id] });
      setImgSrc(''); // 모달 닫기
    } catch (error: any) {
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
        .update({ avatar_url: null })
        .eq('id', user.id);

      if (updateError) throw updateError;

      toast.success("프로필 사진이 삭제되었습니다.");
      queryClient.invalidateQueries({ queryKey: ['profile', user?.id] });
    } catch (error: any) {
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
        .update({ full_name: fullName, username: username })
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
        <div className="container mx-auto px-6 max-w-2xl">
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
                    {/* --- ▼▼▼ 파일 선택 로직 변경 ▼▼▼ --- */}
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
                {/* ▼▼▼ 삭제 버튼 추가 ▼▼▼ */}
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
                {/* ... (이메일, 성명, 아이디 입력 폼은 동일) ... */}
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