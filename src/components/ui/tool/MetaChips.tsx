import React from 'react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'

interface MetaChipsProps {
	platforms?: string[] | null
	languages?: string[] | null
	tags?: string[] | null
}

export function MetaChips({ platforms, languages, tags }: MetaChipsProps) {
	return (
		<Card>
			<CardHeader>
				<CardTitle>메타 정보</CardTitle>
			</CardHeader>
			<CardContent className="space-y-6">
				{platforms && platforms.length > 0 && (
					<div>
						<div className="text-sm text-muted-foreground mb-2">지원 플랫폼</div>
						<div className="flex flex-wrap gap-2">
							{platforms.map((p, i) => (
								<Badge key={i} variant="secondary">{p}</Badge>
							))}
						</div>
					</div>
				)}
				{languages && languages.length > 0 && (
					<div>
						<div className="text-sm text-muted-foreground mb-2">지원 언어</div>
						<div className="flex flex-wrap gap-2">
							{languages.map((l, i) => (
								<Badge key={i} variant="outline">{l}</Badge>
							))}
						</div>
					</div>
				)}
				{tags && tags.length > 0 && (
					<div>
						<div className="text-sm text-muted-foreground mb-2">태그</div>
						<div className="flex flex-wrap gap-2">
							{tags.map((t, i) => (
								<Badge key={i}>{t}</Badge>
							))}
						</div>
					</div>
				)}
			</CardContent>
		</Card>
	)
}

export default MetaChips


