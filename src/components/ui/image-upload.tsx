import { useState, useRef } from 'react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Card, CardContent } from '@/components/ui/card';
import { toast } from 'sonner';
import { supabase } from '@/integrations/supabase/client';
import { Upload, X, Image as ImageIcon, Link, Loader2 } from 'lucide-react';

interface ImageUploadProps {
  images: string[];
  onImagesChange: (images: string[]) => void;
  maxImages?: number;
  allowUrls?: boolean;
}

export const ImageUpload = ({ 
  images, 
  onImagesChange, 
  maxImages = 5, 
  allowUrls = true 
}: ImageUploadProps) => {
  const [uploading, setUploading] = useState(false);
  const [urlInput, setUrlInput] = useState('');
  const fileInputRef = useRef<HTMLInputElement>(null);

  const uploadFile = async (file: File): Promise<string | null> => {
    try {
      setUploading(true);
      
      // 파일 크기 체크 (5MB 제한)
      if (file.size > 5 * 1024 * 1024) {
        toast.error('파일 크기는 5MB 이하여야 합니다.');
        return null;
      }

      // 이미지 파일 형식 체크
      if (!file.type.startsWith('image/')) {
        toast.error('이미지 파일만 업로드할 수 있습니다.');
        return null;
      }

      const fileExt = file.name.split('.').pop();
      const fileName = `${Math.random()}.${fileExt}`;
      const filePath = `community/${fileName}`;

      const { error: uploadError } = await supabase.storage
        .from('images')
        .upload(filePath, file);

      if (uploadError) {
        throw uploadError;
      }

      const { data } = supabase.storage
        .from('images')
        .getPublicUrl(filePath);

      return data.publicUrl;
    } catch (error) {
      console.error('Upload error:', error);
      toast.error('이미지 업로드에 실패했습니다.');
      return null;
    } finally {
      setUploading(false);
    }
  };

  const handleFileUpload = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const files = event.target.files;
    if (!files) return;

    const newImages: string[] = [];
    
    for (let i = 0; i < files.length; i++) {
      if (images.length + newImages.length >= maxImages) {
        toast.error(`최대 ${maxImages}개의 이미지만 업로드할 수 있습니다.`);
        break;
      }

      const file = files[i];
      const url = await uploadFile(file);
      if (url) {
        newImages.push(url);
      }
    }

    if (newImages.length > 0) {
      onImagesChange([...images, ...newImages]);
      toast.success(`${newImages.length}개의 이미지가 업로드되었습니다.`);
    }

    // 파일 입력 초기화
    if (fileInputRef.current) {
      fileInputRef.current.value = '';
    }
  };

  const handleUrlAdd = () => {
    if (!urlInput.trim()) return;

    // URL 유효성 검사
    try {
      new URL(urlInput);
      if (!urlInput.match(/\.(jpg|jpeg|png|gif|webp)(\?.*)?$/i)) {
        toast.error('유효한 이미지 URL을 입력해주세요.');
        return;
      }
    } catch {
      toast.error('유효한 URL을 입력해주세요.');
      return;
    }

    if (images.length >= maxImages) {
      toast.error(`최대 ${maxImages}개의 이미지만 추가할 수 있습니다.`);
      return;
    }

    if (images.includes(urlInput)) {
      toast.error('이미 추가된 이미지입니다.');
      return;
    }

    onImagesChange([...images, urlInput]);
    setUrlInput('');
    toast.success('이미지 URL이 추가되었습니다.');
  };

  const removeImage = (index: number) => {
    const newImages = images.filter((_, i) => i !== index);
    onImagesChange(newImages);
    toast.success('이미지가 제거되었습니다.');
  };

  return (
    <div className="space-y-4">
      {/* 업로드 섹션 */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        {/* 파일 업로드 */}
        <Card>
          <CardContent className="p-4">
            <Label className="block text-sm font-medium mb-2">
              <ImageIcon className="w-4 h-4 inline mr-1" />
              파일 업로드
            </Label>
            <div className="flex gap-2">
              <Input
                ref={fileInputRef}
                type="file"
                accept="image/*"
                multiple
                onChange={handleFileUpload}
                disabled={uploading || images.length >= maxImages}
                className="flex-1"
              />
              <Button 
                type="button"
                onClick={() => fileInputRef.current?.click()}
                disabled={uploading || images.length >= maxImages}
                size="sm"
              >
                {uploading ? <Loader2 className="w-4 h-4 animate-spin" /> : <Upload className="w-4 h-4" />}
              </Button>
            </div>
          </CardContent>
        </Card>

        {/* URL 입력 */}
        {allowUrls && (
          <Card>
            <CardContent className="p-4">
              <Label className="block text-sm font-medium mb-2">
                <Link className="w-4 h-4 inline mr-1" />
                이미지 URL
              </Label>
              <div className="flex gap-2">
                <Input
                  type="url"
                  placeholder="https://example.com/image.jpg"
                  value={urlInput}
                  onChange={(e) => setUrlInput(e.target.value)}
                  disabled={images.length >= maxImages}
                  onKeyPress={(e) => e.key === 'Enter' && handleUrlAdd()}
                />
                <Button 
                  type="button"
                  onClick={handleUrlAdd}
                  disabled={!urlInput.trim() || images.length >= maxImages}
                  size="sm"
                >
                  추가
                </Button>
              </div>
            </CardContent>
          </Card>
        )}
      </div>

      {/* 업로드된 이미지 미리보기 */}
      {images.length > 0 && (
        <div className="space-y-2">
          <Label className="text-sm font-medium">
            업로드된 이미지 ({images.length}/{maxImages})
          </Label>
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-3">
            {images.map((url, index) => (
              <div key={index} className="relative group">
                <img
                  src={url}
                  alt={`업로드된 이미지 ${index + 1}`}
                  className="w-full h-24 object-cover rounded-md border"
                  onError={(e) => {
                    e.currentTarget.src = '/placeholder.svg';
                  }}
                />
                <Button
                  type="button"
                  variant="destructive"
                  size="sm"
                  className="absolute top-1 right-1 w-6 h-6 p-0 opacity-0 group-hover:opacity-100 transition-opacity"
                  onClick={() => removeImage(index)}
                >
                  <X className="w-3 h-3" />
                </Button>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* 업로드 가이드 */}
      <div className="text-xs text-muted-foreground space-y-1">
        <p>• 최대 {maxImages}개의 이미지를 업로드할 수 있습니다.</p>
        <p>• 지원 형식: JPG, PNG, GIF, WebP</p>
        <p>• 최대 파일 크기: 5MB</p>
      </div>
    </div>
  );
};
