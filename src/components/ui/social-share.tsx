import { useState } from 'react';
import { Button } from '@/components/ui/button';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { toast } from 'sonner';
import { 
  Share2, 
  Copy, 
  MessageCircle, 
  Send,
  Facebook,
  Twitter,
  Linkedin,
  Mail,
  QrCode,
  Download
} from 'lucide-react';

interface SocialShareProps {
  url: string;
  title: string;
  description?: string;
  hashtags?: string[];
  via?: string;
}

export const SocialShare = ({ 
  url, 
  title, 
  description = '', 
  hashtags = [],
  via = 'AIHub'
}: SocialShareProps) => {
  const [isOpen, setIsOpen] = useState(false);

  const encodedUrl = encodeURIComponent(url);
  const encodedTitle = encodeURIComponent(title);
  const encodedDescription = encodeURIComponent(description);
  const encodedHashtags = hashtags.map(tag => encodeURIComponent(tag)).join(',');

  const shareUrls = {
    facebook: `https://www.facebook.com/sharer/sharer.php?u=${encodedUrl}&quote=${encodedTitle}`,
    twitter: `https://twitter.com/intent/tweet?url=${encodedUrl}&text=${encodedTitle}&hashtags=${encodedHashtags}&via=${via}`,
    linkedin: `https://www.linkedin.com/sharing/share-offsite/?url=${encodedUrl}&title=${encodedTitle}&summary=${encodedDescription}`,
    kakao: `https://sharer.kakao.com/talk/friends/?url=${encodedUrl}&text=${encodedTitle}`,
    line: `https://social-plugins.line.me/lineit/share?url=${encodedUrl}&text=${encodedTitle}`,
    telegram: `https://t.me/share/url?url=${encodedUrl}&text=${encodedTitle}`,
    email: `mailto:?subject=${encodedTitle}&body=${encodedDescription}%0A%0A${encodedUrl}`,
    whatsapp: `https://wa.me/?text=${encodedTitle}%0A${encodedUrl}`,
  };

  const copyToClipboard = async (text: string) => {
    try {
      await navigator.clipboard.writeText(text);
      toast.success('클립보드에 복사되었습니다!');
    } catch (error) {
      // 폴백: 텍스트 선택 방식
      const textArea = document.createElement('textarea');
      textArea.value = text;
      document.body.appendChild(textArea);
      textArea.select();
      document.execCommand('copy');
      document.body.removeChild(textArea);
      toast.success('클립보드에 복사되었습니다!');
    }
  };

  const shareViaWebShare = async () => {
    if (navigator.share) {
      try {
        await navigator.share({
          title,
          text: description,
          url,
        });
        toast.success('공유되었습니다!');
      } catch (error) {
        if (error instanceof Error && error.name !== 'AbortError') {
          toast.error('공유에 실패했습니다.');
        }
      }
    } else {
      copyToClipboard(url);
    }
  };

  const openShareWindow = (shareUrl: string) => {
    window.open(
      shareUrl,
      'share-window',
      'width=600,height=400,scrollbars=yes,resizable=yes'
    );
  };

  const generateQRCode = () => {
    const qrUrl = `https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${encodedUrl}`;
    const link = document.createElement('a');
    link.href = qrUrl;
    link.download = 'qr-code.png';
    link.click();
  };

  return (
    <DropdownMenu open={isOpen} onOpenChange={setIsOpen}>
      <DropdownMenuTrigger asChild>
        <Button variant="ghost" size="sm">
          <Share2 className="w-4 h-4 mr-1" />
          공유
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end" className="w-56">
        {/* 네이티브 공유 (모바일) */}
        {navigator.share && (
          <DropdownMenuItem onClick={shareViaWebShare}>
            <Share2 className="w-4 h-4 mr-2" />
            시스템 공유
          </DropdownMenuItem>
        )}

        {/* 링크 복사 */}
        <DropdownMenuItem onClick={() => copyToClipboard(url)}>
          <Copy className="w-4 h-4 mr-2" />
          링크 복사
        </DropdownMenuItem>

        {/* 소셜 미디어 공유 */}
        <DropdownMenuItem onClick={() => openShareWindow(shareUrls.facebook)}>
          <Facebook className="w-4 h-4 mr-2 text-blue-600" />
          Facebook
        </DropdownMenuItem>

        <DropdownMenuItem onClick={() => openShareWindow(shareUrls.twitter)}>
          <Twitter className="w-4 h-4 mr-2 text-blue-400" />
          Twitter
        </DropdownMenuItem>

        <DropdownMenuItem onClick={() => openShareWindow(shareUrls.linkedin)}>
          <Linkedin className="w-4 h-4 mr-2 text-blue-700" />
          LinkedIn
        </DropdownMenuItem>

        {/* 한국 메신저 */}
        <DropdownMenuItem onClick={() => openShareWindow(shareUrls.kakao)}>
          <MessageCircle className="w-4 h-4 mr-2 text-yellow-500" />
          카카오톡
        </DropdownMenuItem>

        <DropdownMenuItem onClick={() => openShareWindow(shareUrls.line)}>
          <MessageCircle className="w-4 h-4 mr-2 text-green-500" />
          라인
        </DropdownMenuItem>

        {/* 기타 메신저 */}
        <DropdownMenuItem onClick={() => openShareWindow(shareUrls.telegram)}>
          <Send className="w-4 h-4 mr-2 text-blue-500" />
          텔레그램
        </DropdownMenuItem>

        <DropdownMenuItem onClick={() => openShareWindow(shareUrls.whatsapp)}>
          <MessageCircle className="w-4 h-4 mr-2 text-green-600" />
          WhatsApp
        </DropdownMenuItem>

        {/* 이메일 */}
        <DropdownMenuItem onClick={() => window.location.href = shareUrls.email}>
          <Mail className="w-4 h-4 mr-2" />
          이메일
        </DropdownMenuItem>

        {/* QR 코드 */}
        <DropdownMenuItem onClick={generateQRCode}>
          <QrCode className="w-4 h-4 mr-2" />
          QR 코드 다운로드
        </DropdownMenuItem>

        {/* 상세 공유 옵션 */}
        <Dialog>
          <DialogTrigger asChild>
            <DropdownMenuItem onSelect={(e) => e.preventDefault()}>
              <Share2 className="w-4 h-4 mr-2" />
              더 많은 옵션
            </DropdownMenuItem>
          </DialogTrigger>
          <DialogContent className="sm:max-w-md">
            <DialogHeader>
              <DialogTitle>공유하기</DialogTitle>
            </DialogHeader>
            <div className="space-y-4">
              {/* URL 복사 */}
              <div className="space-y-2">
                <Label>링크</Label>
                <div className="flex gap-2">
                  <Input value={url} readOnly className="flex-1" />
                  <Button onClick={() => copyToClipboard(url)} size="sm">
                    <Copy className="w-4 h-4" />
                  </Button>
                </div>
              </div>

              {/* 제목 복사 */}
              <div className="space-y-2">
                <Label>제목</Label>
                <div className="flex gap-2">
                  <Input value={title} readOnly className="flex-1" />
                  <Button onClick={() => copyToClipboard(title)} size="sm">
                    <Copy className="w-4 h-4" />
                  </Button>
                </div>
              </div>

              {/* 설명 복사 */}
              {description && (
                <div className="space-y-2">
                  <Label>설명</Label>
                  <div className="flex gap-2">
                    <Input value={description} readOnly className="flex-1" />
                    <Button onClick={() => copyToClipboard(description)} size="sm">
                      <Copy className="w-4 h-4" />
                    </Button>
                  </div>
                </div>
              )}

              {/* QR 코드 미리보기 */}
              <div className="space-y-2">
                <Label>QR 코드</Label>
                <div className="flex items-center justify-center p-4 border rounded-md">
                  <img
                    src={`https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=${encodedUrl}`}
                    alt="QR Code"
                    className="w-32 h-32"
                  />
                </div>
                <Button onClick={generateQRCode} className="w-full" variant="outline">
                  <Download className="w-4 h-4 mr-2" />
                  QR 코드 다운로드
                </Button>
              </div>
            </div>
          </DialogContent>
        </Dialog>
      </DropdownMenuContent>
    </DropdownMenu>
  );
};
