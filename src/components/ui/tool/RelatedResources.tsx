import React from 'react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'

interface ResourceItem {
	id: string
	title: string
	subtitle?: string
	href: string
}

interface RelatedResourcesProps {
	items: ResourceItem[]
}

export function RelatedResources({ items }: RelatedResourcesProps) {
	return (
		<Card>
			<CardHeader>
				<CardTitle>관련 리소스</CardTitle>
			</CardHeader>
			<CardContent className="space-y-4">
				{items.map((r) => (
					<a key={r.id} href={r.href} target="_blank" rel="noopener noreferrer" className="block p-3 rounded-md border hover:bg-muted/50 transition">
						<div className="font-medium">{r.title}</div>
						{r.subtitle && <div className="text-sm text-muted-foreground">{r.subtitle}</div>}
					</a>
				))}
			</CardContent>
		</Card>
	)
}

export default RelatedResources


