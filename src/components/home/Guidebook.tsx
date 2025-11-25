import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Book, ArrowRight, Eye } from "lucide-react";
import { Link } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { Skeleton } from "@/components/ui/skeleton";

interface Guide {
    id: number;
    title: string;
    description: string | null;
    level: string | null;
    view_count: number | null;
    key_points: string[] | null;
}

const Guidebook = () => {
    const { data: guides, isLoading } = useQuery({
        queryKey: ['home-guides'],
        queryFn: async () => {
            const { data, error } = await supabase
                .from('guides')
                .select('*')
                .limit(3);

            if (error) throw error;
            return data as unknown as Guide[];
        }
    });

    const getLevelColor = (level: string | null) => {
        switch (level) {
            case '초급': return "bg-green-100 text-green-700";
            case '중급': return "bg-blue-100 text-blue-700";
            case '고급': return "bg-purple-100 text-purple-700";
            default: return "bg-gray-100 text-gray-700";
        }
    };

    if (isLoading) {
        return (
            <section className="py-20">
                <div className="container mx-auto px-6">
                    <div className="flex items-center justify-between mb-10">
                        <div>
                            <h2 className="text-3xl font-bold mb-2">가이드북</h2>
                            <p className="text-muted-foreground">실전에서 바로 사용할 수 있는 프롬프트와 활용법</p>
                        </div>
                    </div>
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
                        {[1, 2, 3].map((i) => (
                            <Skeleton key={i} className="h-64 w-full rounded-xl" />
                        ))}
                    </div>
                </div>
            </section>
        );
    }

    return (
        <section className="py-20">
            <div className="container mx-auto px-6">
                <div className="flex items-center justify-between mb-10">
                    <div>
                        <h2 className="text-3xl font-bold mb-2">가이드북</h2>
                        <p className="text-muted-foreground">실전에서 바로 사용할 수 있는 프롬프트와 활용법</p>
                    </div>
                    <Button variant="outline" asChild>
                        <Link to="/guidebook" className="flex items-center gap-2">
                            가이드 전체 보기
                            <ArrowRight className="w-4 h-4" />
                        </Link>
                    </Button>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
                    {guides?.map((guide) => (
                        <Link to={`/guidebook/tool/${guide.id}`} key={guide.id}>
                            <Card className="hover:shadow-lg transition-all duration-300 hover:-translate-y-1 h-full flex flex-col cursor-pointer">
                                <CardContent className="p-6 flex-1 flex flex-col">
                                    <div className="flex justify-between items-start mb-4">
                                        <div className="w-10 h-10 rounded-lg bg-secondary flex items-center justify-center text-primary">
                                            <Book className="w-5 h-5" />
                                        </div>
                                        <Badge variant="secondary" className={getLevelColor(guide.level)}>
                                            {guide.level || '초급'}
                                        </Badge>
                                    </div>

                                    <h3 className="text-xl font-bold mb-2 line-clamp-2">{guide.title}</h3>
                                    <p className="text-muted-foreground text-sm mb-6 line-clamp-2">{guide.description}</p>

                                    <div className="mt-auto">
                                        <div className="space-y-2 mb-6">
                                            {guide.key_points?.slice(0, 2).map((point, i) => (
                                                <div key={i} className="flex items-center gap-2 text-sm text-muted-foreground">
                                                    <div className="w-1 h-1 rounded-full bg-primary/50" />
                                                    <span className="line-clamp-1">{point}</span>
                                                </div>
                                            ))}
                                        </div>

                                        <div className="flex items-center text-xs text-muted-foreground pt-4 border-t">
                                            <Eye className="w-3 h-3 mr-1" />
                                            {guide.view_count || 0}명이 읽었어요
                                        </div>
                                    </div>
                                </CardContent>
                            </Card>
                        </Link>
                    ))}
                </div>
            </div>
        </section>
    );
};

export default Guidebook;
