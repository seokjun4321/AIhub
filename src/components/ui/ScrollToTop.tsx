import { useEffect, useState } from 'react';
import { useLocation } from 'react-router-dom';
import { ArrowUp } from 'lucide-react';

const ScrollToTop = () => {
  // 현재 경로 정보를 가져옵니다.
  const { pathname } = useLocation();
  const [visible, setVisible] = useState(false);

  // pathname이 바뀔 때마다 (즉, 페이지가 이동할 때마다) 실행됩니다.
  useEffect(() => {
    // 커뮤니티로 복귀하는 경우 스크롤 복원을 위해 자동 스크롤을 하지 않음
    const hasScrollRestore = sessionStorage.getItem('communityScrollY');
    if (pathname === '/community' && hasScrollRestore) {
      // console.log('ScrollToTop: 커뮤니티 복귀 감지, 자동 스크롤 생략');
      return;
    }
    
    window.scrollTo(0, 0);
  }, [pathname]);

  // 스크롤 위치에 따라 버튼 표시
  useEffect(() => {
    const onScroll = () => {
      const y = window.scrollY || document.documentElement.scrollTop;
      setVisible(y > 200);
    };
    window.addEventListener('scroll', onScroll, { passive: true });
    onScroll();
    return () => window.removeEventListener('scroll', onScroll);
  }, []);

  const handleClick = () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  return (
    <>
      {/* 페이지 이동 시 최상단 이동 */}
      {/* Floating "Back to Top" button */}
      {visible && (
        <button
          onClick={handleClick}
          aria-label="맨 위로"
          className="fixed bottom-6 right-6 z-50 rounded-full bg-primary text-primary-foreground shadow-lg hover:bg-primary/90 focus:outline-none focus:ring-2 focus:ring-primary/50 transition-colors w-12 h-12 flex items-center justify-center"
        >
          <ArrowUp className="w-5 h-5" />
        </button>
      )}
    </>
  );
};

export default ScrollToTop;