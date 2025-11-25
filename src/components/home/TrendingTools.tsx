import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { TrendingUp, ArrowUpRight } from "lucide-react";
import { Link } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { Skeleton } from "@/components/ui/skeleton";

interface AIModel {
    id: number;
    name: string;
    description: string | null;
    logo_url: string | null;
    model_type: string | null;
    growth_rate: number | null;
}

const TrendingTools = () => {
    const { data: trendingTools, isLoading } = useQuery({
        queryKey: ['trending-tools'],
        queryFn: async () => {
            const { data, error } = await supabase
                .from('ai_models')
                .select('*')
                .order('growth_rate', { ascending: false })
                .limit(4);

            if (error) throw error;
            return data as unknown as AIModel[];
        }
    });

    if (isLoading) {
        return (
            <section className="py-12 bg-secondary/20">
                <div className="container mx-auto px-6">
                    <div className="flex items-center gap-2 mb-8">
                        <TrendingUp className="w-6 h-6 text-green-500" />
                        <h2 className="text-2xl font-bold">트렌딩 도구</h2>
                    </div>
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                        {[1, 2, 3, 4].map((i) => (
                            <Skeleton key={i} className="h-32 w-full rounded-xl" />
                        ))}
                    </div>
                </div>
            </section>
        );
    }

    return (
        <section className="py-12 bg-secondary/20">
            <div className="container mx-auto px-6">
                <div className="flex items-center gap-2 mb-8">
                    <TrendingUp className="w-6 h-6 text-green-500" />
                    <h2 className="text-2xl font-bold">트렌딩 도구</h2>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    {trendingTools?.map((tool) => (
                        <Link key={tool.id} to={`/tools/${tool.id}`}>
                            <Card className="hover:shadow-lg transition-all duration-300 cursor-pointer group h-full">
                                <CardContent className="p-6">
                                    <div className="flex items-start justify-between mb-4">
                                        <div className="flex items-center gap-4">
                                            <div className="w-12 h-12 bg-white rounded-xl shadow-sm flex items-center justify-center p-2 overflow-hidden">
                                                {tool.logo_url ? (
                                                    <img src={tool.logo_url} alt={tool.name} className="w-full h-full object-contain" />
                                                ) : (
                                                    <div className="text-xl font-bold text-primary">{tool.name[0]}</div>
                                                )}
                                            </div>
                                            <div>
                                                <h3 className="font-bold text-lg group-hover:text-primary transition-colors">{tool.name}</h3>
                                                <Badge variant="secondary" className="mt-1 font-normal text-xs">
                                                    {tool.model_type || 'AI Model'}
                                                </Badge>
                                            </div>
                                        </div>
                                        <Badge className="bg-green-100 text-green-700 hover:bg-green-200 border-none flex items-center gap-1">
                                            <ArrowUpRight className="w-3 h-3" />
                                            +{tool.growth_rate || 0}%
                                        </Badge>
                                    </div>
                                    <p className="text-muted-foreground text-sm line-clamp-2">{tool.description}</p>
                                </CardContent>
                            </Card>
                        </Link>
                    ))}
                </div>
            </div>
        </section>
    );
};

export default TrendingTools;
