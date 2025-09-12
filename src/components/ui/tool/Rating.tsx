import React from 'react'
import { Star } from 'lucide-react'

interface RatingProps {
	score: number
	count: number
	size?: 'sm' | 'md' | 'lg'
}

const sizeToClass: Record<NonNullable<RatingProps['size']>, string> = {
	sm: 'w-4 h-4',
	md: 'w-5 h-5',
	lg: 'w-6 h-6',
}

export function Rating({ score, count, size = 'md' }: RatingProps) {
	return (
		<div className="flex items-center gap-2" aria-label={`평점 ${score.toFixed(1)} / 5, 리뷰 ${count}개`}>
			<div className="flex items-center gap-0.5" aria-hidden>
				{Array.from({ length: 5 }).map((_, i) => (
					<Star
						key={i}
						className={`${sizeToClass[size]} ${i < Math.round(score) ? 'fill-yellow-400 text-yellow-400' : 'text-gray-300'}`}
					/>
				))}
			</div>
			<span className="font-semibold">{score.toFixed(1)}</span>
			<span className="text-sm text-muted-foreground">({count.toLocaleString()}개 리뷰)</span>
		</div>
	)
}

export default Rating


