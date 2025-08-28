import { useEffect } from 'react';
import { useLocation } from 'react-router-dom';

const ScrollToTop = () => {
  // 현재 경로 정보를 가져옵니다.
  const { pathname } = useLocation();

  // pathname이 바뀔 때마다 (즉, 페이지가 이동할 때마다) 실행됩니다.
  useEffect(() => {
    window.scrollTo(0, 0); // 화면 스크롤을 (x: 0, y: 0) 위치로 이동시킵니다.
  }, [pathname]);

  return null; // 이 컴포넌트는 화면에 아무것도 그리지 않습니다.
};

export default ScrollToTop;