import { Card, CardContent, CardFooter } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Star, Heart } from "lucide-react";
import { Button } from "@/components/ui/button";

interface PresetItem {
    id: string;
    image: string;
    title: string;
    category: string;
    tag?: string;
    rating: number;
    reviews: number;
    price: number;
    author: string;
}

interface PresetGridProps {
    title: string;
    subtitle: string;
    items: PresetItem[];
    showMore?: boolean;
}

const PresetGrid = ({ title, subtitle, items, showMore = true }: PresetGridProps) => {
    return (
        <section className="py-12">
            <div className="container mx-auto px-6">
                <div className="flex justify-between items-end mb-6">
                    <div>
                        <h2 className="text-xl font-bold mb-1">{title}</h2>
                        <p className="text-sm text-muted-foreground">{subtitle}</p>
                    </div>
                    {showMore && (
                        <Button variant="ghost" size="sm" className="text-muted-foreground hover:text-foreground">
                            전체 보기
                        </Button>
                    )}
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    {items.map((item) => (
                        <Card key={item.id} className="overflow-hidden hover:shadow-lg transition-all group cursor-pointer">
                            <div className="relative aspect-video bg-muted overflow-hidden">
                                <img
                                    src={item.image}
                                    alt={item.title}
                                    className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                                    onError={(e) => {
                                        (e.target as HTMLImageElement).src = "https://via.placeholder.com/400x225?text=" + encodeURIComponent(item.title);
                                    }}
                                />
                                <Button size="icon" variant="secondary" className="absolute top-2 right-2 w-8 h-8 rounded-full opacity-0 group-hover:opacity-100 transition-opacity bg-white/80 hover:bg-white">
                                    <Heart className="w-4 h-4" />
                                </Button>
                            </div>
                            <CardContent className="p-4">
                                <div className="flex justify-between items-start mb-2">
                                    <h3 className="font-bold text-sm line-clamp-2 min-h-[2.5rem]">{item.title}</h3>
                                    {item.tag && (
                                        <Badge variant="secondary" className="text-[10px] h-5 px-1.5 shrink-0 ml-2">
                                            {item.tag}
                                        </Badge>
                                    )}
                                </div>
                                <p className="text-xs text-muted-foreground mb-2">{item.category}</p>
                                <div className="flex items-center gap-1 text-xs mb-3">
                                    <Star className="w-3 h-3 text-yellow-400 fill-yellow-400" />
                                    <span className="font-medium">{item.rating}</span>
                                    <span className="text-muted-foreground">({item.reviews})</span>
                                </div>
                            </CardContent>
                            <CardFooter className="p-4 pt-0">
                                <div className="font-bold text-sm">
                                    ₩{item.price.toLocaleString()}
                                </div>
                            </CardFooter>
                        </Card>
                    ))}
                </div>
            </div>
        </section>
    );
};

export default PresetGrid;
