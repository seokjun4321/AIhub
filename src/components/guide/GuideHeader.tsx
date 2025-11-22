import { Search, Bookmark, Share2, Flag, Home, ChevronRight } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { useState } from "react";
import { useToast } from "@/hooks/use-toast";
import { Link } from "react-router-dom";

interface GuideHeaderProps {
  breadcrumbs: string[];
  toolName?: string;
}

export function GuideHeader({ breadcrumbs, toolName }: GuideHeaderProps) {
  const { toast } = useToast();

  const handleSave = () => {
    toast({
      title: "가이드 저장됨",
      description: "저장된 가이드에 추가되었습니다",
    });
  };

  const handleShare = () => {
    navigator.clipboard.writeText(window.location.href);
    toast({
      title: "링크 복사됨",
      description: "가이드 링크가 클립보드에 복사되었습니다",
    });
  };

  const handleReport = () => {
    toast({
      title: "신고 제출됨",
      description: "피드백 감사합니다",
    });
  };

  return (
    <header className="sticky top-16 z-40 w-full border-b bg-background">
      <div className="container mx-auto flex h-16 items-center justify-between px-4 md:px-6 max-w-7xl">
        {/* Breadcrumbs */}
        <nav className="flex items-center space-x-2 text-sm text-muted-foreground">
          <Link to="/" className="hover:text-foreground transition-colors">
            <Home className="h-4 w-4" />
          </Link>
          {breadcrumbs.map((crumb, index) => (
            <div key={index} className="flex items-center space-x-2">
              <ChevronRight className="h-4 w-4" />
              <span className={index === breadcrumbs.length - 1 ? "text-foreground font-medium" : "hover:text-foreground transition-colors"}>
                {crumb}
              </span>
            </div>
          ))}
        </nav>

        {/* Search */}
        <div className="hidden md:flex flex-1 max-w-md mx-8">
          <div className="relative w-full">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
            <Input
              placeholder="가이드, 프롬프트 검색..."
              className="pl-10 bg-muted/50 border-0 focus-visible:ring-accent"
            />
          </div>
        </div>

        {/* Actions */}
        <div className="flex items-center space-x-2">
          <Button variant="ghost" size="icon" onClick={handleSave} className="hover:bg-accent/10 hover:text-accent">
            <Bookmark className="h-4 w-4" />
          </Button>
          <Button variant="ghost" size="icon" onClick={handleShare} className="hover:bg-accent/10 hover:text-accent">
            <Share2 className="h-4 w-4" />
          </Button>
          <Button variant="ghost" size="icon" onClick={handleReport} className="hover:bg-accent/10 hover:text-accent">
            <Flag className="h-4 w-4" />
          </Button>
        </div>
      </div>
    </header>
  );
}

