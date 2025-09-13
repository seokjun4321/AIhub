import React from 'react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Star } from 'lucide-react'

interface SimilarToolItem {
	id: number | string
	name: string
	rating?: number
	category?: string
	href?: string
}

interface SimilarToolsProps {
	items: SimilarToolItem[]
}

export function SimilarTools({ items }: SimilarToolsProps) {
	return (
		<Card>
			<CardHeader>
				<CardTitle>유사 도구</CardTitle>
			</CardHeader>
			<CardContent className="space-y-3">
				{items.map((t) => (
					<a key={t.id} href={t.href || `/tools/${t.id}`} className="flex items-center justify-between p-3 rounded-md border hover:bg-muted/50 transition">
						<div>
							<div className="font-medium">{t.name}</div>
							{t.category && <div className="text-xs text-muted-foreground">{t.category}</div>}
						</div>
						{typeof t.rating === 'number' && (
							<div className="flex items-center gap-1 text-sm">
								<Star className="w-4 h-4 fill-yellow-400 text-yellow-400" />
								<span>{t.rating.toFixed(1)}</span>
							</div>
						)}
					</a>
				))}
			</CardContent>
		</Card>
	)
}

export default SimilarTools




