import { useState, useEffect, useRef } from "react";
import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Brain, Menu, X, Search, Users, Zap, LogOut, User, UserCog, Bookmark, ShoppingBag, FolderOpen, Shield } from "lucide-react";
import { cn } from "@/lib/utils";
import { useAuth } from "@/hooks/useAuth";
import { useAdmin } from "@/hooks/useAdmin";
import { NotificationDropdown } from "@/components/ui/notifications";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";

// 사용자 프로필을 가져오는 함수
const fetchUserProfile = async (userId: string) => {
  const { data, error } = await supabase.from('profiles').select('*').eq('id', userId).single();
  if (error) throw new Error(error.message);
  return data;
};

const Navbar = () => {
  const [isOpen, setIsOpen] = useState(false);
  const { user, signOut } = useAuth();
  const { isAdmin } = useAdmin();
  const headerRef = useRef<HTMLElement>(null);

  // 사용자 프로필 데이터
  const { data: userProfile } = useQuery({
    queryKey: ['userProfile', user?.id],
    queryFn: () => fetchUserProfile(user!.id),
    enabled: !!user,
  });

  // Navbar 높이 측정 및 CSS 변수 설정
  useEffect(() => {
    const updateHeight = () => {
      if (headerRef.current) {
        const height = headerRef.current.offsetHeight;
        document.documentElement.style.setProperty('--navbar-height', `${height}px`);
      }
    };

    // 초기 높이 설정
    updateHeight();

    // ResizeObserver로 크기 변경 감지
    const resizeObserver = new ResizeObserver(() => {
      updateHeight();
    });

    if (headerRef.current) {
      resizeObserver.observe(headerRef.current);
    }

    window.addEventListener('resize', updateHeight);

    return () => {
      resizeObserver.disconnect();
      window.removeEventListener('resize', updateHeight);
    };
  }, []);

  const navItems = [
    { name: "가이드북", href: "/guides", icon: Zap },
    { name: "AI 도구", href: "/guidebook", icon: Search },
    { name: "프리셋 스토어", href: "/presets", icon: ShoppingBag },
    { name: "커뮤니티", href: "/community", icon: Users }
  ];

  return (
    <header ref={headerRef} className="fixed top-0 w-full z-50 bg-card border-b border-border/50">
      <nav className="container mx-auto px-6 py-4">
        <div className="flex items-center justify-between">
          {/* Logo */}
          <Link to="/" className="flex items-center gap-2">
            <div className="p-2 bg-gradient-primary rounded-lg shadow-primary">
              <Brain className="w-6 h-6 text-primary-foreground" />
            </div>
            <span className="text-2xl font-bold bg-gradient-primary bg-clip-text text-transparent">
              AIHub
            </span>
          </Link>

          {/* Desktop Navigation */}
          <div className="hidden md:flex items-center space-x-8">
            {navItems.map((item) => {
              const Icon = item.icon;
              return (
                <Link
                  key={item.name}
                  to={item.href}
                  className="flex items-center gap-2 text-foreground hover:text-primary transition-colors group"
                >
                  <Icon className="w-4 h-4 group-hover:scale-110 transition-transform" />
                  {item.name}
                </Link>
              );
            })}
            <Link
              to="/tools/suggest"
              className="flex items-center gap-2 text-sm font-medium text-muted-foreground hover:text-primary transition-colors"
            >
              <Zap className="w-4 h-4" />
              도구 제안
            </Link>
            {isAdmin && (
              <Link
                to="/admin"
                className="flex items-center gap-2 text-sm font-medium text-muted-foreground hover:text-primary transition-colors"
              >
                <Shield className="w-4 h-4" />
                Admin
              </Link>
            )}
          </div>

          {/* Desktop CTA */}
          <div className="hidden md:flex items-center gap-4">
            {user ? (
              <>
                <NotificationDropdown />
                <DropdownMenu modal={false}>
                  <DropdownMenuTrigger asChild>
                    <Button variant="outline" size="icon" className="rounded-full p-0 h-8 w-8">
                      <Avatar className="h-8 w-8">
                        <AvatarImage
                          src={userProfile?.avatar_url || ''}
                          alt={userProfile?.username || 'User'}
                        />
                        <AvatarFallback>
                          {userProfile?.username?.charAt(0).toUpperCase() || 'U'}
                        </AvatarFallback>
                      </Avatar>
                      <span className="sr-only">Open user menu</span>
                    </Button>
                  </DropdownMenuTrigger>
                  <DropdownMenuContent align="end">
                    <DropdownMenuLabel>
                      <div>
                        <div>내 계정</div>
                        <div className="text-xs text-muted-foreground font-normal mt-1">
                          @{userProfile?.username || 'user'}
                        </div>
                      </div>
                    </DropdownMenuLabel>
                    <DropdownMenuSeparator />
                    <DropdownMenuItem asChild className="cursor-pointer">
                      <Link to="/profile" className="flex items-center gap-2">
                        <UserCog className="w-4 h-4" />
                        <span>프로필 설정</span>
                      </Link>
                    </DropdownMenuItem>
                    <DropdownMenuItem asChild className="cursor-pointer">
                      <Link to="/my-tools" className="flex items-center gap-2">
                        <FolderOpen className="w-4 h-4" />
                        <span>나만의 도구함</span>
                      </Link>
                    </DropdownMenuItem>
                    <DropdownMenuItem asChild className="cursor-pointer">
                      <Link to="/bookmarks" className="flex items-center gap-2">
                        <Bookmark className="w-4 h-4" />
                        <span>게시글 북마크</span>
                      </Link>
                    </DropdownMenuItem>
                    <DropdownMenuItem onClick={signOut} className="cursor-pointer flex items-center gap-2 text-red-500 focus:text-red-500">
                      <LogOut className="w-4 h-4" />
                      <span>로그아웃</span>
                    </DropdownMenuItem>
                  </DropdownMenuContent>
                </DropdownMenu>
              </>
            ) : (
              <>
                <Button variant="outline" size="sm" asChild>
                  <Link to="/auth?tab=signin">로그인</Link>
                </Button>
                <Button size="sm" className="bg-gradient-primary hover:opacity-90" asChild>
                  <Link to="/auth?tab=signup">회원가입</Link>
                </Button>
              </>
            )}
          </div>

          {/* Mobile Menu Button */}
          <button
            onClick={() => setIsOpen(!isOpen)}
            className="md:hidden p-2 rounded-lg hover:bg-accent transition-colors"
          >
            {isOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
          </button>
        </div>

        {/* Mobile Navigation */}
        <div
          className={cn(
            "md:hidden overflow-hidden transition-all duration-300 ease-in-out",
            isOpen ? "max-h-96 mt-6" : "max-h-0"
          )}
        >
          <div className="space-y-4 py-4 border-t border-border/50">
            {navItems.map((item) => {
              const Icon = item.icon;
              return (
                <a
                  key={item.name}
                  href={item.href}
                  className="flex items-center gap-3 p-3 rounded-lg hover:bg-accent transition-colors"
                  onClick={() => setIsOpen(false)}
                >
                  <Icon className="w-5 h-5 text-primary" />
                  <span className="text-foreground">{item.name}</span>
                </a>
              );
            })}
            <div className="flex flex-col gap-3 pt-4 border-t border-border/50">
              {user ? (
                <>
                  <Link to="/profile" className="w-full" onClick={() => setIsOpen(false)}>
                    <Button variant="ghost" className="w-full justify-start gap-2">
                      <UserCog className="w-4 h-4" />
                      프로필 설정
                    </Button>
                  </Link>
                  <Link to="/bookmarks" className="w-full" onClick={() => setIsOpen(false)}>
                    <Button variant="ghost" className="w-full justify-start gap-2">
                      <Bookmark className="w-4 h-4" />
                      북마크
                    </Button>
                  </Link>
                  <Button variant="ghost" className="w-full justify-start gap-2 text-red-500 hover:text-red-500" onClick={signOut}>
                    <LogOut className="w-4 h-4" />
                    로그아웃
                  </Button>
                </>
              ) : (
                <>
                  <Button variant="outline" className="w-full" asChild>
                    <Link to="/auth?tab=signin">로그인</Link>
                  </Button>
                  <Button className="w-full bg-gradient-primary hover:opacity-90" asChild>
                    <Link to="/auth?tab=signup">회원가입</Link>
                  </Button>
                </>
              )}
            </div>
          </div>
        </div>
      </nav>
    </header>
  );
};

export default Navbar;