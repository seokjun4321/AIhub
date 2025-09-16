import { useQuery } from '@tanstack/react-query'
import { supabase } from '@/integrations/supabase/client'
import { Card, CardContent } from '@/components/ui/card'
import { Skeleton } from '@/components/ui/skeleton'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { ExternalLink } from 'lucide-react'

interface AIModel {
  id: number
  name: string
  description: string | null
  provider: string | null
  model_type: string | null
  pricing_info: string | null
  features: string[] | null
  website_url: string | null
  api_documentation_url: string | null
  average_rating: number
}

interface ComparisonTableProps {
  currentModel: AIModel
}

export function ComparisonTable({ currentModel }: ComparisonTableProps) {
  const { data: similarModels, isLoading } = useQuery({
    queryKey: ['similarModels', currentModel.id],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('ai_models')
        .select('*')
        .neq('id', currentModel.id)
        .eq('model_type', currentModel.model_type)
        .limit(3)

      if (error) throw error
      return (data || []) as AIModel[]
    },
    enabled: !!currentModel?.id,
  })

  const rows: AIModel[] = [currentModel, ...(similarModels || [])]

  return (
    <Card>
      <CardContent>
        {isLoading ? (
          <div className="space-y-3">
            <Skeleton className="h-6 w-48" />
            <Skeleton className="h-10 w-full" />
            <Skeleton className="h-10 w-full" />
            <Skeleton className="h-10 w-full" />
          </div>
        ) : rows.length === 0 ? (
          <div className="text-muted-foreground">비교할 항목이 없습니다.</div>
        ) : (
          <div className="w-full overflow-x-auto">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead className="w-32">이름 / 제공사</TableHead>
                  <TableHead className="w-24">모델 타입</TableHead>
                  <TableHead className="w-20">평균 평점</TableHead>
                  <TableHead className="w-40">가격</TableHead>
                  <TableHead className="w-48">주요 기능</TableHead>
                  <TableHead className="w-24">링크</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {rows.map((m) => (
                  <TableRow key={m.id}>
                    <TableCell>
                      <div className="font-medium">{m.name}</div>
                      <div className="text-xs text-muted-foreground">{m.provider || '—'}</div>
                    </TableCell>
                    <TableCell>
                      {m.model_type ? (
                        <span className="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-muted text-muted-foreground">
                          {m.model_type}
                        </span>
                      ) : (
                        <span className="text-muted-foreground">—</span>
                      )}
                    </TableCell>
                    <TableCell>
                      {typeof m.average_rating === 'number' ? (
                        <span className="font-medium">{m.average_rating.toFixed(1)}</span>
                      ) : (
                        <span className="text-muted-foreground">—</span>
                      )}
                    </TableCell>
                    <TableCell>
                      {m.pricing_info ? (
                        <div className="text-sm space-y-0.5">
                          {m.pricing_info.split(' / ').map((plan, index) => (
                            <div key={index}>
                              {plan.includes('무료') ? (
                                <span className="text-green-600 font-medium">{plan}</span>
                              ) : plan.includes('$') ? (
                                <span className="text-blue-600 font-medium">{plan}</span>
                              ) : (
                                <span>{plan}</span>
                              )}
                            </div>
                          ))}
                        </div>
                      ) : (
                        <span className="text-muted-foreground">—</span>
                      )}
                    </TableCell>
                    <TableCell className="w-48">
                      {m.features && m.features.length > 0 ? (
                        <div className="space-y-0.5">
                          {m.features.slice(0, 3).map((f, i) => (
                            <div key={i} className="flex items-center text-sm">
                              <span className="w-1.5 h-1.5 bg-primary rounded-full mr-2 flex-shrink-0"></span>
                              <span>{f}</span>
                            </div>
                          ))}
                          {m.features.length > 3 && (
                            <div className="text-xs text-muted-foreground">
                              +{m.features.length - 3}개 더
                            </div>
                          )}
                        </div>
                      ) : (
                        <span className="text-muted-foreground">—</span>
                      )}
                    </TableCell>
                    <TableCell>
                      <div className="flex flex-col gap-0.5">
                        {m.website_url && (
                          <a 
                            href={m.website_url} 
                            target="_blank" 
                            rel="noreferrer" 
                            className="inline-flex items-center text-primary hover:underline text-sm"
                          >
                            <span className="w-2 h-2 bg-primary rounded-full mr-2"></span>
                            공식 사이트
                            <ExternalLink className="w-3 h-3 ml-1" />
                          </a>
                        )}
                        {m.api_documentation_url && (
                          <a 
                            href={m.api_documentation_url} 
                            target="_blank" 
                            rel="noreferrer" 
                            className="inline-flex items-center text-primary hover:underline text-sm"
                          >
                            <span className="w-2 h-2 bg-blue-500 rounded-full mr-2"></span>
                            API 문서
                            <ExternalLink className="w-3 h-3 ml-1" />
                          </a>
                        )}
                        {!m.website_url && !m.api_documentation_url && (
                          <span className="text-muted-foreground text-sm">—</span>
                        )}
                      </div>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </div>
        )}
      </CardContent>
    </Card>
  )
}

export default ComparisonTable


