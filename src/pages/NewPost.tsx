import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useMutation, useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { MentionInput } from "@/components/ui/mention-input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Label } from "@/components/ui/label";
import { ImageUpload } from "@/components/ui/image-upload";

import { useAuth } from "@/hooks/useAuth";
import { usePoints } from "@/hooks/usePoints";
import { processMentions } from "@/lib/mentions";
import { toast } from "sonner";

// 커뮤니티 섹션 데이터를 가져오는 함수
const fetchCommunitySections = async () => {
  const { data, error } = await supabase
    .from('community_sections')
    .select('*')
    .order('name');
  
  if (error) throw new Error(error.message);
  return data;
};

// 게시글 카테고리 데이터를 가져오는 함수 (중요도 순으로 정렬)
const fetchPostCategories = async () => {
  const { data, error } = await supabase
    .from('post_categories')
    .select('*')
    .order('name');
  
  if (error) throw new Error(error.message);
  
  // 중요도 순으로 재정렬 (기타는 맨 마지막에)
  const categoryOrder = ['질문', '정보공유', '토론', '리뷰', '뉴스', '프로젝트', '유머', '기타'];
  const sortedData = data?.sort((a, b) => {
    const indexA = categoryOrder.indexOf(a.name);
    const indexB = categoryOrder.indexOf(b.name);
    
    // 찾지 못한 항목은 맨 뒤로
    if (indexA === -1) return 1;
    if (indexB === -1) return -1;
    
    return indexA - indexB;
  });
  
  return sortedData;
};

const NewPost = () => {
  const navigate = useNavigate();
  const { user } = useAuth();
  const { addPointsForPost } = usePoints();
  const [title, setTitle] = useState("");
  const [content, setContent] = useState("");
  const [selectedSection, setSelectedSection] = useState<string>("");
  const [selectedCategory, setSelectedCategory] = useState<string>("");
  const [images, setImages] = useState<string[]>([]);


  // 커뮤니티 섹션 데이터
  const { data: sections } = useQuery({
    queryKey: ['community-sections'],
    queryFn: fetchCommunitySections,
  });

  // 게시글 카테고리 데이터
  const { data: categories } = useQuery({
    queryKey: ['post-categories'],
    queryFn: fetchPostCategories,
  });

  const createPostMutation = useMutation({
    mutationFn: async (newPost: {
      title: string;
      content: string;
      community_section_id: number;
      category_id: number;
      images: string[];
    }) => {
      if (!user) throw new Error("로그인이 필요합니다.");

                   const { data, error } = await supabase
        .from('posts')
        .insert({
          title: newPost.title,
          content: newPost.content,
          author_id: user.id,
          community_section_id: newPost.community_section_id,
          category_id: newPost.category_id,
          images: newPost.images,
        })
       .select()
       .single();

      if (error) throw new Error(error.message);
      
      // 멘션 처리
      await processMentions(newPost.content, user.id, data.id, undefined);
      
      return data;
    },
    onSuccess: (data) => {
      toast.success("게시글이 성공적으로 작성되었습니다!");
      // 포인트 적립
      addPointsForPost(data.id);
      navigate(`/community/${data.id}`);
    },
    onError: (error) => {
      toast.error(`오류가 발생했습니다: ${error.message}`);
    },
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!title.trim()) {
      toast.error("제목을 입력해주세요.");
      return;
    }
    
    if (!content.trim()) {
      toast.error("내용을 입력해주세요.");
      return;
    }

    if (!selectedSection) {
      toast.error("커뮤니티 섹션을 선택해주세요.");
      return;
    }

    if (!selectedCategory) {
      toast.error("카테고리를 선택해주세요.");
      return;
    }

         createPostMutation.mutate({
       title: title.trim(),
       content: content.trim(),
       community_section_id: parseInt(selectedSection),
       category_id: parseInt(selectedCategory),
       images: images,
     });
  };

  if (!user) {
    return (
      <div className="min-h-screen bg-background">
        <Navbar />
        <main className="pt-24 pb-12">
          <div className="container mx-auto px-6 max-w-2xl">
            <Card>
              <CardContent className="p-6">
                <p className="text-center text-muted-foreground">
                  게시글을 작성하려면 로그인이 필요합니다.
                </p>
              </CardContent>
            </Card>
          </div>
        </main>
        <Footer />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      <main className="pt-24 pb-12">
        <div className="container mx-auto px-6 max-w-4xl">
          <Card>
            <CardHeader>
              <CardTitle>새 게시글 작성</CardTitle>
            </CardHeader>
            <CardContent>
              <form onSubmit={handleSubmit} className="space-y-6">
                <div className="space-y-2">
                  <Label htmlFor="title">제목</Label>
                  <Input
                    id="title"
                    value={title}
                    onChange={(e) => setTitle(e.target.value)}
                    placeholder="게시글 제목을 입력하세요"
                    disabled={createPostMutation.isPending}
                  />
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="section">커뮤니티 섹션</Label>
                    <Select value={selectedSection} onValueChange={setSelectedSection}>
                      <SelectTrigger>
                        <SelectValue placeholder="섹션을 선택하세요" />
                      </SelectTrigger>
                      <SelectContent>
                        {sections?.map((section) => (
                          <SelectItem key={section.id} value={section.id.toString()}>
                            <div className="flex items-center gap-2">
                              <div 
                                className="w-3 h-3 rounded-full" 
                                style={{ backgroundColor: section.color }}
                              />
                              {section.name}
                            </div>
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="category">카테고리</Label>
                    <Select value={selectedCategory} onValueChange={setSelectedCategory}>
                      <SelectTrigger>
                        <SelectValue placeholder="카테고리를 선택하세요" />
                      </SelectTrigger>
                      <SelectContent>
                        {categories?.map((category) => (
                          <SelectItem key={category.id} value={category.id.toString()}>
                            <div className="flex items-center gap-2">
                              <div 
                                className="w-3 h-3 rounded-full" 
                                style={{ backgroundColor: category.color }}
                              />
                              {category.name}
                            </div>
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </div>
                </div>

                                                 <div className="space-y-2">
                  <Label htmlFor="content">내용</Label>
                  <MentionInput
                    value={content}
                    onChange={setContent}
                    placeholder="게시글 내용을 입력하세요... (@사용자명으로 멘션 가능)"
                    disabled={createPostMutation.isPending}
                    className="min-h-[250px]"
                  />
                </div>

                 {/* 이미지 업로드 */}
                 <div className="space-y-2">
                   <Label>이미지 첨부</Label>
                   <ImageUpload
                     images={images}
                     onImagesChange={setImages}
                     maxImages={5}
                     allowUrls={true}
                   />
                 </div>



                <div className="flex justify-end gap-4">
                  <Button
                    type="button"
                    variant="outline"
                    onClick={() => navigate('/community')}
                    disabled={createPostMutation.isPending}
                  >
                    취소
                  </Button>
                  <Button
                    type="submit"
                    disabled={createPostMutation.isPending}
                  >
                    {createPostMutation.isPending ? "작성 중..." : "게시글 작성"}
                  </Button>
                </div>
              </form>
            </CardContent>
          </Card>
        </div>
      </main>
      <Footer />
    </div>
  );
};

export default NewPost;