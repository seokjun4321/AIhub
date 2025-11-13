import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Clock, Calendar, Play, Copy, Download, FileText, AlertCircle } from "lucide-react";
import { useToast } from "@/hooks/use-toast";

interface GuideHeroProps {
  title: string;
  description?: string | null;
  category?: string | null;
  toolName?: string;
  toolLogoUrl?: string | null;
  estimatedTime?: number | null;
  updatedAt?: string;
  content?: string | null;
  author?: {
    id: string;
    username?: string | null;
    avatar_url?: string | null;
  } | null;
  onStartGuide: () => void;
}

export function GuideHero({ 
  title, 
  description, 
  category, 
  toolName,
  toolLogoUrl,
  estimatedTime,
  updatedAt,
  content,
  author,
  onStartGuide 
}: GuideHeroProps) {
  const { toast } = useToast();

  const handleCopyAllContent = () => {
    if (!content) return;
    navigator.clipboard.writeText(content);
    toast({
      title: "내용 복사됨",
      description: "가이드 내용이 클립보드에 복사되었습니다",
    });
  };

  const handleCopyLink = () => {
    navigator.clipboard.writeText(window.location.href);
    toast({
      title: "링크 복사됨",
      description: "가이드 링크가 클립보드에 복사되었습니다",
    });
  };

  const formatDate = (dateString?: string) => {
    if (!dateString) return "";
    const date = new Date(dateString);
    return date.toLocaleDateString("ko-KR", { year: "numeric", month: "long", day: "numeric" });
  };

  return (
    <section className="border-b bg-gradient-to-br from-background to-muted/20 py-8 animate-fade-in">
      <div className="container mx-auto px-4 md:px-6 max-w-7xl">
        <div className="grid gap-8 lg:grid-cols-[2fr,1fr]">
          {/* Left: Guide Info */}
          <div className="space-y-3">
            <div className="space-y-3">
              <div className="flex items-center gap-4">
                {toolLogoUrl && (
                  <img 
                    src={toolLogoUrl} 
                    alt={toolName || "AI 로고"} 
                    className="w-12 h-12 lg:w-16 lg:h-16 object-contain flex-shrink-0"
                  />
                )}
                <h1 className="text-4xl font-bold tracking-tight lg:text-5xl text-foreground">
                  {title}
                </h1>
              </div>
              {description && (
                <p className="text-xl text-muted-foreground max-w-2xl">
                  {description}
                </p>
              )}
            </div>

            <div className="flex flex-wrap items-center gap-3">
              {category && (
                <Badge variant="secondary" className="bg-accent/10 text-accent hover:bg-accent/20">
                  {category}
                </Badge>
              )}
              {toolName && (
                <Badge variant="secondary" className="bg-accent/10 text-accent hover:bg-accent/20">
                  {toolName}
                </Badge>
              )}
            </div>

            {/* Author */}
            {author && (
              <div className="flex items-center gap-3">
                <Avatar>
                  <AvatarImage src={author.avatar_url || undefined} alt={author.username || "작성자"} />
                  <AvatarFallback>{(author.username || "U")[0]}</AvatarFallback>
                </Avatar>
                <div>
                  <div className="font-semibold text-sm">{author.username || "익명"}</div>
                  <div className="text-xs text-muted-foreground">작성자</div>
                </div>
              </div>
            )}

            <div className="flex flex-wrap items-center gap-6 text-sm text-muted-foreground">
              {estimatedTime && (
                <div className="flex items-center gap-2">
                  <Clock className="h-4 w-4" />
                  <span>{estimatedTime}분 소요</span>
                </div>
              )}
              {updatedAt && (
                <div className="flex items-center gap-2">
                  <Calendar className="h-4 w-4" />
                  <span>업데이트: {formatDate(updatedAt)}</span>
                </div>
              )}
            </div>
          </div>

          {/* Right: CTAs */}
          <div className="flex flex-col items-start lg:items-end justify-center space-y-4">
            <div className="flex flex-col gap-3 w-full lg:w-auto">
              <Button size="lg" onClick={onStartGuide} className="bg-foreground hover:bg-foreground/90 text-background shadow-lg">
                <Play className="mr-2 h-4 w-4" />
                가이드 시작하기
              </Button>
              <Button size="lg" variant="outline" onClick={handleCopyLink} className="border-accent/50 hover:bg-accent/10">
                <Copy className="mr-2 h-4 w-4" />
                링크 공유하기
              </Button>
              
              {/* Quick Actions */}
              <div className="flex flex-row flex-wrap gap-2 mt-2">
                <Button variant="outline" size="sm" className="border-border/50 hover:bg-muted/50">
                  <Download className="mr-2 h-4 w-4" />
                  PDF 다운로드
                </Button>
                {content && (
                  <Button 
                    variant="outline" 
                    size="sm"
                    className="border-border/50 hover:bg-muted/50" 
                    onClick={handleCopyAllContent}
                  >
                    <Copy className="mr-2 h-4 w-4" />
                    전체 내용 복사
                  </Button>
                )}
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

