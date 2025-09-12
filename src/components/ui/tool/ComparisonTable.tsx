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
                  <TableHead>이름 / 제공사</TableHead>
                  <TableHead>모델 타입</TableHead>
                  <TableHead>평균 평점</TableHead>
                  <TableHead>가격</TableHead>
                  <TableHead>주요 기능</TableHead>
                  <TableHead>링크</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {rows.map((m) => (
                  <TableRow key={m.id}>
                    <TableCell>
                      <div className="font-medium">{m.name}</div>
                      <div className="text-xs text-muted-foreground">{m.provider || '—'}</div>
                    </TableCell>
                    <TableCell>{m.model_type || '—'}</TableCell>
                    <TableCell>{typeof m.average_rating === 'number' ? m.average_rating.toFixed(1) : '—'}</TableCell>
                    <TableCell>{m.pricing_info || '—'}</TableCell>
                    <TableCell>
                      {m.features && m.features.length > 0 ? (
                        <ul className="list-disc pl-4 space-y-1">
                          {m.features.slice(0, 3).map((f, i) => (
                            <li key={i} className="text-sm">{f}</li>
                          ))}
                        </ul>
                      ) : (
                        <span className="text-muted-foreground">—</span>
                      )}
                    </TableCell>
                    <TableCell>
                      <div className="flex items-center gap-2">
                        {m.website_url && (
                          <a href={m.website_url} target="_blank" rel="noreferrer" className="inline-flex items-center text-primary hover:underline">
                            사이트
                            <ExternalLink className="w-3 h-3 ml-1" />
                          </a>
                        )}
                        {m.api_documentation_url && (
                          <a href={m.api_documentation_url} target="_blank" rel="noreferrer" className="inline-flex items-center text-primary hover:underline">
                            문서
                            <ExternalLink className="w-3 h-3 ml-1" />
                          </a>
                        )}
                        {!m.website_url && !m.api_documentation_url && <span className="text-muted-foreground">—</span>}
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


