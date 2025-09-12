import React from 'react'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { ExternalLink, BookOpen, Heart, Share2 } from 'lucide-react'

interface QuickActionsProps {
	websiteUrl?: string | null
	apiDocsUrl?: string | null
	onBookmark?: () => void
	onShare?: () => void
}

export function QuickActions({ websiteUrl, apiDocsUrl, onBookmark, onShare }: QuickActionsProps) {
	return (
		<Card>
			<CardHeader>
				<CardTitle>빠른 액션</CardTitle>
			</CardHeader>
			<CardContent className="space-y-3">
				{websiteUrl && (
					<Button asChild className="w-full" aria-label="공식 웹사이트 방문">
						<a href={websiteUrl} target="_blank" rel="noopener noreferrer">
							<ExternalLink className="w-4 h-4 mr-2" /> 공식 웹사이트 방문
						</a>
					</Button>
				)}
				{apiDocsUrl && (
					<Button asChild variant="outline" className="w-full" aria-label="API 문서 보기">
						<a href={apiDocsUrl} target="_blank" rel="noopener noreferrer">
							<BookOpen className="w-4 h-4 mr-2" /> API 문서 보기
						</a>
					</Button>
				)}
				<Button variant="outline" className="w-full" onClick={onBookmark} aria-label="북마크 추가">
					<Heart className="w-4 h-4 mr-2" /> 북마크 추가
				</Button>
				<Button variant="outline" className="w-full" onClick={onShare} aria-label="공유">
					<Share2 className="w-4 h-4 mr-2" /> 공유
				</Button>
			</CardContent>
		</Card>
	)
}

export default QuickActions


