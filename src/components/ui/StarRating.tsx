import { useState } from 'react';
import { Star } from 'lucide-react';
import { cn } from '@/lib/utils';

interface StarRatingProps {
  rating: number;
  totalStars?: number;
  size?: number;
  className?: string;
  onRate?: (rating: number) => void;
  readOnly?: boolean;
}

const StarRating = ({
  rating,
  totalStars = 5,
  size = 20,
  className,
  onRate,
  readOnly = false,
}: StarRatingProps) => {
  const [hoverRating, setHoverRating] = useState(0);

  const handleMouseEnter = (rate: number) => {
    if (readOnly) return;
    setHoverRating(rate);
  };

  const handleMouseLeave = () => {
    if (readOnly) return;
    setHoverRating(0);
  };

  const handleClick = (rate: number) => {
    if (readOnly || !onRate) return;
    onRate(rate);
  };

  const currentRating = hoverRating > 0 ? hoverRating : rating;

  return (
    <div className={cn('flex items-center gap-1', className, { 'cursor-pointer': !readOnly })}>
      {[...Array(totalStars)].map((_, index) => {
        const starValue = index + 1;
        return (
          <Star
            key={starValue}
            size={size}
            className={cn('transition-colors', {
              'text-yellow-400 fill-yellow-400': starValue <= currentRating,
              'text-gray-300': starValue > currentRating,
              'hover:text-yellow-400 hover:fill-yellow-400': !readOnly
            })}
            onMouseEnter={() => handleMouseEnter(starValue)}
            onMouseLeave={handleMouseLeave}
            onClick={() => handleClick(starValue)}
          />
        );
      })}
    </div>
  );
};

export default StarRating;