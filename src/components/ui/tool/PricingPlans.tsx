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
	return (
		<div className="grid grid-cols-1 md:grid-cols-3 gap-4">
			{plans.map((plan) => (
				<Card key={plan.id} className={plan.isPopular ? 'border-primary/60' : ''}>
					<CardHeader>
						<CardTitle className="flex items-center justify-between">
							<span>{plan.name}</span>
							<span className="text-xl font-bold">{plan.price}</span>
						</CardTitle>
					</CardHeader>
					<CardContent className="space-y-4">
						<ul className="space-y-2">
							{plan.features.map((f, i) => (
								<li key={i} className="text-sm">✓ {f}</li>
							))}
						</ul>
						{plan.ctaUrl && (
							<Button asChild className="w-full">
								<a href={plan.ctaUrl} target="_blank" rel="noopener noreferrer">Get Started</a>
							</Button>
						)}
					</CardContent>
				</Card>
			))}
		</div>
	)
}

export default PricingPlans



