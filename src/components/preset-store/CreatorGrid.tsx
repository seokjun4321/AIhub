import { Card } from "@/components/ui/card";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { Star } from "lucide-react";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { Skeleton } from "@/components/ui/skeleton";

interface Creator {
    id: string;
    username: string | null;
    avatar_url: string | null;
    creator_rating: number | null;
    sales_count: number | null;
    creator_tags: string[] | null;
    representative_product: string | null;
}

const CreatorGrid = () => {
    const { data: creators, isLoading } = useQuery({
        queryKey: ['creators-popular'],
        queryFn: async () => {
            const { data, error } = await supabase
                .from('profiles')
                .select('*')
                .eq('is_creator', true)
                .order('sales_count', { ascending: false })
                .limit(3);

            if (error) throw error;
            return data as unknown as Creator[];
        }
    });

    if (isLoading) {
        return (
            <section className="py-12 bg-secondary/10">
                <div className="container mx-auto px-6">
                    <div className="text-center mb-8">
                        <h2 className="text-xl font-bold mb-1">인기 크리에이터</h2>
                        <p className="text-sm text-muted-foreground">검증된 크리에이터의 템플릿을 만나보세요</p>
                    </div>
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                        {[1, 2, 3].map((i) => (
                            <Skeleton key={i} className="h-40 w-full rounded-xl" />
                        ))}
                    </div>
                </div>
            </section>
        );
    }

    return (
        <section className="py-12 bg-secondary/10">
            <div className="container mx-auto px-6">
                <div className="text-center mb-8">
                    <h2 className="text-xl font-bold mb-1">인기 크리에이터</h2>
                    <p className="text-sm text-muted-foreground">검증된 크리에이터의 템플릿을 만나보세요</p>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                    {creators?.map((creator) => (
                        <Card key={creator.id} className="p-6 flex items-start gap-4 hover:shadow-md transition-all cursor-pointer">
                            <Avatar className="w-12 h-12">
                                <AvatarImage src={creator.avatar_url || `https://api.dicebear.com/7.x/avataaars/svg?seed=${creator.username}`} />
                                <AvatarFallback>{creator.username?.[0]}</AvatarFallback>
                            </Avatar>
                            <div className="flex-1">
                                <div className="flex justify-between items-start mb-1">
                                    <h3 className="font-bold text-sm">{creator.username || 'Unknown'}</h3>
                                </div>
                                <div className="flex items-center gap-2 text-xs text-muted-foreground mb-3">
                                    <div className="flex items-center gap-0.5">
                                        <Star className="w-3 h-3 text-yellow-400 fill-yellow-400" />
                                        <span className="font-medium text-foreground">{creator.creator_rating || 0}</span>
                                    </div>
                                    <span>•</span>
                                    <span>{creator.sales_count || 0}개 판매</span>
                                </div>
                                <div className="flex gap-1 mb-3">
                                    {creator.creator_tags?.map((tag) => (
                                        <Badge key={tag} variant="secondary" className="text-[10px] px-1.5 h-5 font-normal">
                                            {tag}
                                        </Badge>
                                    ))}
                                </div>
                                <div className="text-xs text-muted-foreground pt-3 border-t">
                                    <span className="block text-[10px] mb-0.5">대표 상품</span>
                                    <span className="font-medium text-foreground line-clamp-1">{creator.representative_product || '없음'}</span>
                                </div>
                            </div>
                        </Card>
                    ))}
                </div>
            </div>
        </section>
    );
};

export default CreatorGrid;
