import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { ArrowRight, Loader2 } from "lucide-react";
import { Link } from "react-router-dom";
import { useQuery } from "@tanstack/react-query"; // 1. React Query를 import 합니다.
import { supabase } from "@/integrations/supabase/client"; // 2. Supabase 클라이언트를 import 합니다.
import { Skeleton } from "@/components/ui/skeleton"; // 로딩 중 UI를 위한 스켈레톤

// 3. Supabase에서 데이터를 가져오는 비동기 함수를 정의합니다.
const fetchGuides = async () => {
  const { data, error } = await supabase.from('guides').select('*');
  if (error) {
    throw new Error(error.message);
  }

  return data;
};

const Guides = () => {
  // 4. useQuery 훅을 사용해 데이터를 가져옵니다.
  const { data: guides, isLoading, error } = useQuery({
    queryKey: ['guides'], // 이 데이터 쿼리의 고유한 키
    queryFn: fetchGuides, // 데이터를 가져올 때 실행할 함수
  });

  // 5. 로딩 중일 때 보여줄 UI
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
            <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
              {[...Array(3)].map((_, i) => (
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

  // 6. 에러가 발생했을 때 보여줄 UI
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
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            {/* 7. 이제 가짜 데이터 대신, Supabase에서 가져온 'guides' 데이터를 사용합니다. */}
            {guides?.map((guide) => (
              <Link to={`/guides/${guide.id}`} key={guide.id}>
                <Card className="group h-full flex flex-col hover:border-primary/50 hover:shadow-lg transition-all duration-300">
                  <CardHeader>
                    <div className="aspect-video w-full bg-muted rounded-md mb-4 overflow-hidden">
                       <img src={guide.imageUrl || "/placeholder.svg"} alt={guide.title} className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300" />
                    </div>
                    <Badge variant="outline">{guide.category}</Badge>
                    <CardTitle className="mt-2 group-hover:text-primary transition-colors">{guide.title}</CardTitle>
                    <CardDescription>{guide.description}</CardDescription>
                  </CardHeader>
                  <CardContent className="flex-grow flex items-end justify-between">
                    <span className="text-sm text-muted-foreground">by {guide.author}</span>
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