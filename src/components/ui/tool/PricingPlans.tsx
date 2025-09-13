import React from 'react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'

export interface PricingPlan {
	id: string
	name: string
	price: string
	features: string[]
	isPopular?: boolean
	ctaUrl?: string
}

interface PricingPlansProps {
	plans: PricingPlan[]
}

export function PricingPlans({ plans }: PricingPlansProps) {
	// 플랜 개수에 따라 동적으로 그리드 클래스 결정
	const getGridClass = (planCount: number) => {
		if (planCount === 1) return "grid-cols-1 max-w-sm mx-auto";
		if (planCount === 2) return "grid-cols-1 md:grid-cols-2 max-w-4xl mx-auto";
		if (planCount === 3) return "grid-cols-1 md:grid-cols-3 max-w-6xl mx-auto";
		if (planCount === 4) return "grid-cols-1 md:grid-cols-2 lg:grid-cols-4";
		if (planCount >= 5) return "grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4";
		return "grid-cols-1 md:grid-cols-2 lg:grid-cols-4";
	};

	return (
		<div className={`grid ${getGridClass(plans.length)} gap-6`}>
			{plans.map((plan) => (
				<Card key={plan.id} className={`relative ${plan.isPopular ? 'border-primary/60 ring-2 ring-primary/20' : ''}`}>
					{plan.isPopular && (
						<div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
							<span className="bg-primary text-primary-foreground text-xs font-medium px-3 py-1 rounded-full">
								인기
							</span>
						</div>
					)}
					<CardHeader className="text-center pb-4">
						<CardTitle className="text-lg font-semibold mb-2">{plan.name}</CardTitle>
						<div className="text-2xl font-bold text-primary">{plan.price}</div>
					</CardHeader>
					<CardContent className="space-y-4">
						<ul className="space-y-3">
							{plan.features.map((f, i) => (
								<li key={i} className="flex items-start gap-2 text-sm text-muted-foreground">
									<span className="text-green-500 mt-0.5">✓</span>
									<span>{f}</span>
								</li>
							))}
						</ul>
						{plan.ctaUrl && (
							<Button asChild className="w-full" variant={plan.isPopular ? "default" : "outline"}>
								<a href={plan.ctaUrl} target="_blank" rel="noopener noreferrer">
									시작하기
								</a>
							</Button>
						)}
					</CardContent>
				</Card>
			))}
		</div>
	)
}

export default PricingPlans




