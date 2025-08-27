import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { supabase } from '@/integrations/supabase/client';
import { useAuth } from '@/hooks/useAuth';
import Navbar from '@/components/ui/navbar';
import Footer from '@/components/ui/footer';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
import { Button } from '@/components/ui/button';
import { Label } from '@/components/ui/label';
import { Loader2 } from 'lucide-react';
import { toast } from 'sonner';

const NewPost = () => {
  const [title, setTitle] = useState('');
  const [content, setContent] = useState('');
  const [loading, setLoading] = useState(false);
  const { user } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!user) {
      toast.error("로그인이 필요합니다.");
      return;
    }

    setLoading(true);

    const { data, error } = await supabase
      .from('posts')
      .insert({
        title,
        content,
        author_id: user.id,
      })
      .select()
      .single();

    setLoading(false);

    if (error) {
      toast.error(`글 작성에 실패했습니다: ${error.message}`);
    } else {
      toast.success("질문이 성공적으로 등록되었습니다!");
      navigate(`/community/${data.id}`);
    }
  };

  return (
    <div className="min-h-screen">
      <Navbar />
      <main className="pt-24 pb-12">
        <div className="container mx-auto px-6 max-w-2xl">
          <Card>
            <CardHeader>
              <CardTitle>새 질문 올리기</CardTitle>
              <CardDescription>
                AI와 관련된 궁금한 점을 자유롭게 질문하고 다른 사용자들과 지식을 나눠보세요.
              </CardDescription>
            </CardHeader>
            <CardContent>
              <form onSubmit={handleSubmit} className="space-y-6">
                <div className="space-y-2">
                  <Label htmlFor="title">제목</Label>
                  <Input
                    id="title"
                    placeholder="질문의 핵심 내용을 제목으로 적어주세요."
                    value={title}
                    onChange={(e) => setTitle(e.target.value)}
                    required
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="content">내용</Label>
                  <Textarea
                    id="content"
                    placeholder="궁금한 점에 대해 자세하게 작성해주세요."
                    value={content}
                    onChange={(e) => setContent(e.target.value)}
                    required
                    rows={10}
                  />
                </div>
                <Button type="submit" className="w-full" disabled={loading}>
                  {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                  질문 등록하기
                </Button>
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