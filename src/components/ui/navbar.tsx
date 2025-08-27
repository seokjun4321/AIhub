import { useState } from "react";
import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Brain, Menu, X, Search, BookOpen, Users, Zap, LogOut } from "lucide-react";
import { cn } from "@/lib/utils";
import { useAuth } from "@/hooks/useAuth";

const Navbar = () => {
  const [isOpen, setIsOpen] = useState(false);
  const { user, signOut } = useAuth();

  const navItems = [
    { name: "AI 추천", href: "#recommend", icon: Zap },
    { name: "가이드북", href: "#guides", icon: BookOpen },
    { name: "커뮤니티", href: "#community", icon: Users },
    { name: "AI 도구", href: "#tools", icon: Search },
  ];

  return (
    <header className="fixed top-0 w-full z-50 bg-card/90 backdrop-blur-lg border-b border-border/50">
      <nav className="container mx-auto px-6 py-4">
        <div className="flex items-center justify-between">
          {/* Logo */}
          <div className="flex items-center gap-2">
            <div className="p-2 bg-gradient-primary rounded-lg shadow-primary">
              <Brain className="w-6 h-6 text-primary-foreground" />
            </div>
            <span className="text-2xl font-bold bg-gradient-primary bg-clip-text text-transparent">
              AIHub
            </span>
          </div>

          {/* Desktop Navigation */}
          <div className="hidden md:flex items-center space-x-8">
            {navItems.map((item) => {
              const Icon = item.icon;
              return (
                <a
                  key={item.name}
                  href={item.href}
                  className="flex items-center gap-2 text-foreground hover:text-primary transition-colors group"
                >
                  <Icon className="w-4 h-4 group-hover:scale-110 transition-transform" />
                  {item.name}
                </a>
              );
            })}
          </div>

          {/* Desktop CTA */}
          <div className="hidden md:flex items-center gap-4">
            {user ? (
              <div className="flex items-center gap-4">
                <span className="text-sm text-muted-foreground">
                  Welcome back!
                </span>
                <Button 
                  variant="outline" 
                  size="sm"
                  onClick={signOut}
                  className="flex items-center gap-2"
                >
                  <LogOut className="w-4 h-4" />
                  로그아웃
                </Button>
              </div>
            ) : (
              <>
                <Button variant="outline" size="sm" asChild>
                  <Link to="/auth">로그인</Link>
                </Button>
                <Button size="sm" className="bg-gradient-primary hover:opacity-90" asChild>
                  <Link to="/auth">시작하기</Link>
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
                <Button 
                  variant="outline" 
                  className="w-full flex items-center gap-2"
                  onClick={signOut}
                >
                  <LogOut className="w-4 h-4" />
                  로그아웃
                </Button>
              ) : (
                <>
                  <Button variant="outline" className="w-full" asChild>
                    <Link to="/auth">로그인</Link>
                  </Button>
                  <Button className="w-full bg-gradient-primary hover:opacity-90" asChild>
                    <Link to="/auth">시작하기</Link>
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