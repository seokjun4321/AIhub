import { useState, useMemo } from 'react';
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { ArrowRight } from "lucide-react";
import { Link } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { Skeleton } from "@/components/ui/skeleton";
import { Button } from '@/components/ui/button';

// --- 🔧 FIX 1: Fetch query updated ---
// We now join with `categories` and `profiles` to get their names.
const fetchGuides = async () => {
  const { data, error } = await supabase
    .from('guides')
    .select('id, title, description, image_url, profiles(username), categories(name)')
    .order('id');
    
  if (error) {
    throw new Error(error.message);
  }
  return data;
};

const Guides = () => {
  const { data: guides, isLoading, error } = useQuery({
    queryKey: ['guides'],
    queryFn: fetchGuides,
  });

  const [selectedCategory, setSelectedCategory] = useState('All');

  // --- 🔧 FIX 2: Category filtering logic updated ---
  // The logic now correctly extracts category names from the joined `categories` table.
  const categories = useMemo(() => {
    if (!guides) return [];
    // The category object can be null, so we filter those out.
    const allCategories = guides
      .map(guide => guide.categories?.name)
      .filter((name): name is string => !!name);
    return ['All', ...Array.from(new Set(allCategories))];
  }, [guides]);

  const filteredGuides = useMemo(() => {
    if (!guides) return [];
    if (selectedCategory === 'All') {
      return guides;
    }
    return guides.filter(guide => guide.categories?.name === selectedCategory);
  }, [guides, selectedCategory]);

  if (isLoading) {
    return (
      <div className="min-h-screen bg-background">
        <Navbar />
        <main className="pt-24 pb-12">
          <div className="container mx-auto px-6">
            <div className="text-center mb-12">
              <h1 className="text-4xl md:text-5xl font-bold">AI 활용 가이드북</h1>
              <p className="text-xl text-muted-foreground mt-4 max-w-2xl mx-auto">
                전문가들이 검증한 AI 활용법을 단계별로 배워보세요.
              </p>
            </div>
             <div className="flex justify-center flex-wrap gap-2 mb-12">
               {[...Array(5)].map((_, i) => <Skeleton key={i} className="h-10 w-24" />)}
             </div>
            <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
              {[...Array(6)].map((_, i) => (
                <Card key={i} className="flex flex-col">
                  <CardHeader>
                    <Skeleton className="aspect-video w-full rounded-md" />
                    <Skeleton className="h-4 w-20 mt-4" />
                    <Skeleton className="h-6 w-full mt-2" />
                    <Skeleton className="h-10 w-full mt-1" />
                  </CardHeader>
                  <CardContent className="flex-grow flex items-end justify-between">
                    <Skeleton className="h-4 w-24" />
                  </CardContent>
                </Card>
              ))}
            </div>
          </div>
        </main>
        <Footer />
      </div>
    );
  }

  if (error) {
    return <div>에러가 발생했습니다: {error.message}</div>;
  }

  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      <main className="pt-24 pb-12">
        <div className="container mx-auto px-6">
          <div className="text-center mb-12">
            <h1 className="text-4xl md:text-5xl font-bold">AI 활용 가이드북</h1>
            <p className="text-xl text-muted-foreground mt-4 max-w-2xl mx-auto">
              전문가들이 검증한 AI 활용법을 단계별로 배워보세요.
            </p>
          </div>

          <div className="flex justify-center flex-wrap gap-2 mb-12">
            {categories.map((category) => (
              <Button
                key={category}
                variant={selectedCategory === category ? "default" : "outline"}
                onClick={() => setSelectedCategory(category)}
              >
                {category}
              </Button>
            ))}
          </div>
          
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            {filteredGuides?.map((guide) => (
              <Link to={`/guides/${guide.id}`} key={guide.id}>
                <Card className="group h-full flex flex-col hover:border-primary/50 hover:shadow-lg transition-all duration-300">
                  <CardHeader>
                    <Badge variant="outline">{guide.categories?.name || 'Uncategorized'}</Badge>
                    <CardTitle className="mt-2 group-hover:text-primary transition-colors">{guide.title}</CardTitle>
                    <CardDescription>{guide.description}</CardDescription>
                  </CardHeader>
                  <CardContent className="flex-grow flex items-end justify-between">
                    <span className="text-sm text-muted-foreground">by {guide.profiles?.username || 'Unknown Author'}</span>
                    <ArrowRight className="w-4 h-4 text-muted-foreground group-hover:translate-x-1 transition-transform" />
                  </CardContent>
                </Card>
              </Link>
            ))}
          </div>
        </div>
      </main>
      <Footer />
    </div>
  );
};

export default Guides;