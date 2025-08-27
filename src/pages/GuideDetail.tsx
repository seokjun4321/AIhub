import { useParams } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { Skeleton } from "@/components/ui/skeleton";
import { Badge } from "@/components/ui/badge";
import { UserCircle, Calendar } from "lucide-react";

// URL의 ID를 기반으로 Supabase에서 특정 가이드 1개를 가져오는 함수
const fetchGuideById = async (id: string) => {
  // URL에서 받아온 문자열 id를 정수(숫자)로 변환합니다.
  const numericId = parseInt(id, 10);

  // 만약 변환에 실패하면 (id가 숫자가 아니면) 에러를 발생시킵니다.
  if (isNaN(numericId)) {
    throw new Error("Invalid ID provided");
  }

  const { data, error } = await supabase
    .from('guides')
    .select('*')
    .eq('id', numericId)
    .single(); // .single()은 결과가 1개일 때 사용합니다.

  if (error) {
    throw new Error(error.message);
  }
  return data;
};

const GuideDetail = () => {
  // 1. URL 파라미터에서 id 값을 가져옵니다. (예: /guides/7 -> id는 "7")
  const { id } = useParams<{ id: string }>();

  // 2. useQuery를 사용해 id에 해당하는 가이드 데이터를 가져옵니다.
  const { data: guide, isLoading, error } = useQuery({
    // queryKey에 id를 포함시켜서, id가 바뀔 때마다 데이터를 새로 가져오게 합니다.
    queryKey: ['guide', id],
    queryFn: () => {
      if (!id) throw new Error("Guide ID is required");
      return fetchGuideById(id);
    },
    enabled: !!id, // id가 존재할 때만 쿼리를 실행합니다.
  });

  // 로딩 중일 때 보여줄 UI
  if (isLoading) {
    return (
      <div className="min-h-screen">
        <Navbar />
        <main className="pt-24 container mx-auto px-6 max-w-4xl">
          <Skeleton className="h-12 w-3/4 mb-4" />
          <Skeleton className="h-6 w-1/2 mb-8" />
          <div className="flex items-center gap-8 mb-8 text-sm text-muted-foreground">
            <Skeleton className="h-5 w-24" />
            <Skeleton className="h-5 w-32" />
          </div>
          <Skeleton className="aspect-video w-full mb-8" />
          <div className="space-y-4">
            <Skeleton className="h-4 w-full" />
            <Skeleton className="h-4 w-full" />
            <Skeleton className="h-4 w-5/6" />
          </div>
        </main>
        <Footer />
      </div>
    );
  }

  // 에러 발생 시 UI
  if (error) {
    return <div>Error loading guide: {error.message}</div>;
  }
  
  // 데이터가 없을 경우 UI
  if (!guide) {
    return <div>Guide not found.</div>
  }

  return (
    <div className="min-h-screen">
      <Navbar />
      <main className="pt-24 pb-12">
        <article className="container mx-auto px-6 max-w-4xl">
          <header className="mb-8">
            <Badge variant="outline" className="mb-4">{guide.category}</Badge>
            <h1 className="text-4xl md:text-5xl font-bold tracking-tight">{guide.title}</h1>
            <p className="text-xl text-muted-foreground mt-4">{guide.description}</p>
            <div className="flex items-center gap-8 mt-6 text-sm text-muted-foreground">
              <div className="flex items-center gap-2">
                <UserCircle className="w-4 h-4" />
                <span>by {guide.author}</span>
              </div>
              <div className="flex items-center gap-2">
                <Calendar className="w-4 h-4" />
                <span>{new Date(guide.created_at).toLocaleString()}</span>
              </div>
            </div>
          </header>
          
          <div className="aspect-video w-full bg-muted rounded-lg mb-8 overflow-hidden">
            <img src={guide.imageUrl || "/placeholder.svg"} alt={guide.title} className="w-full h-full object-cover" />
          </div>
          
          {/* 실제 가이드 본문 내용 */}
          <div className="prose dark:prose-invert max-w-none">
            <p>{guide.content}</p>
            {/* Supabase의 content 컬럼에 Markdown 형식으로 글을 작성했다면, 
                react-markdown 같은 라이브러리를 사용해서 더 예쁘게 렌더링할 수도 있습니다. */}
          </div>
        </article>
      </main>
      <Footer />
    </div>
  );
};

export default GuideDetail;