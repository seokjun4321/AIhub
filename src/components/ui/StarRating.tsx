import { useState, useEffect } from 'react';
import { Star } from 'lucide-react';
import { cn } from '@/lib/utils';

interface StarRatingProps {
  rating: number;              // 외부에서 내려오는 표시용/초기값
  totalStars?: number;
  size?: number;
  className?: string;
  onRate?: (rating: number) => void;
  readOnly?: boolean;          // 평균 표시용일 때 true
}

const StarRating = ({
  rating,
  totalStars = 5,
  size = 20,
  className,
  onRate,
  readOnly = false,
}: StarRatingProps) => {
  // 외부 rating 변화에 즉시 따라가도록 내부 상태 유지
  const [value, setValue] = useState<number>(Number(rating) || 0);
  const [hover, setHover] = useState<number>(0);

  // ✅ 외부 prop 변경 시 동기화 (중요)
  useEffect(() => {
    setValue(Number(rating) || 0);
  }, [rating]);

  const display = hover > 0 ? hover : value;

  const handleMouseEnter = (n: number) => {
    if (readOnly) return;
    setHover(n);
  };

  const handleMouseLeave = () => {
    if (readOnly) return;
    setHover(0);
  };

  const handleClick = (n: number) => {
    if (readOnly) return;
    setValue(n);
    onRate?.(n);
  };

  return (
    <div
      className={cn(
        'flex items-center gap-1',
        className,
        readOnly ? 'pointer-events-none select-none' : 'cursor-pointer'
      )}
      role={readOnly ? 'img' : 'slider'}
      aria-label="star rating"
      aria-valuemin={1}
      aria-valuemax={totalStars}
      aria-valuenow={display}
    >
      {Array.from({ length: totalStars }).map((_, i) => {
        const starValue = i + 1;
        const isActive = starValue <= display;
        return (
          <Star
            key={starValue}
            size={size}
            // ✅ fill을 직접 제어해야 실제로 채워짐
            fill={isActive ? 'currentColor' : 'none'}
            // stroke 색은 text-*, fill은 fill-*를 따름
            className={cn(
              'transition-colors',
              isActive ? 'text-yellow-400' : 'text-gray-300',
              !readOnly && 'hover:text-yellow-400'
            )}
            onMouseEnter={!readOnly ? () => handleMouseEnter(starValue) : undefined}
            onMouseLeave={!readOnly ? handleMouseLeave : undefined}
            onClick={!readOnly ? () => handleClick(starValue) : undefined}
          />
        );
      })}
    </div>
  );
};

export default StarRating;
