import { useState, useCallback, useRef, useEffect } from "react";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Input } from "@/components/ui/input";
import { Link } from "react-router-dom";
import { useInfiniteQuery, useMutation, useQueryClient, useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { Skeleton } from "@/components/ui/skeleton";
import { SocialShare } from "@/components/ui/social-share";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { 
  MessageSquare, 
  UserCircle, 
  PlusCircle, 
  ThumbsUp, 
  ThumbsDown, 
  TrendingUp, 
  Clock, 
  MessageCircle,
  Search,
  Bookmark,
  Flag,
  Eye,
  Pin,
  Filter,
  MoreHorizontal,
  Loader2,
  X,
  Edit,
  Trash2,
  Settings,
  Calendar,
  ThumbsUp as ThumbsUpIcon,
  MessageSquare as MessageSquareIcon
} from "lucide-react";
import { useAuth } from "@/hooks/useAuth";
import { useIsMobile } from "@/hooks/use-mobile";
import { toast } from "sonner";

// 페이지당 게시글 수
const POSTS_PER_PAGE = 10;

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

// 무한 스크롤을 위한 posts 데이터 가져오기 함수
const fetchPostsPage = async ({ 
  pageParam = 0, 
  sectionId, 
  categoryId, 
  sortBy = 'latest', 
  searchQuery 
}: {
  pageParam?: number;
  sectionId?: number;
  categoryId?: number;
  sortBy?: string;
  searchQuery?: string;
}) => {
  let query = supabase
    .from('posts')
    .select(`
      id,
      title,
      content,
      created_at,
      upvotes_count,
      downvotes_count,
      view_count,
      comment_count,
      is_pinned,
      is_locked,
      images,
      author_id,
      profiles ( username ),
      community_sections ( name, color, icon ),
      post_categories ( name, color, icon )
    `)
    .range(pageParam * POSTS_PER_PAGE, (pageParam + 1) * POSTS_PER_PAGE - 1);

  if (sectionId) {
    query = query.eq('community_section_id', sectionId);
  }

  if (categoryId) {
    query = query.eq('category_id', categoryId);
  }

  if (searchQuery) {
    query = query.or(`title.ilike.%${searchQuery}%,content.ilike.%${searchQuery}%`);
  }

  // 정렬 옵션
  switch (sortBy) {
    case 'popular':
      query = query.order('upvotes_count', { ascending: false });
      break;
    case 'trending':
      // 최근 7일 내 게시글을 추천수로 정렬
      const weekAgo = new Date();
      weekAgo.setDate(weekAgo.getDate() - 7);
      query = query.gte('created_at', weekAgo.toISOString()).order('upvotes_count', { ascending: false });
      break;
    case 'views':
      query = query.order('view_count', { ascending: false });
      break;
    case 'comments':
      query = query.order('comment_count', { ascending: false });
      break;
    case 'latest':
    default:
      // 고정 게시글을 먼저 보여주고, 그 다음 최신순
      query = query.order('is_pinned', { ascending: false }).order('created_at', { ascending: false });
      break;
  }

  const { data, error } = await query;
  if (error) throw new Error(error.message);
  
  return {
    data: data || [],
    nextCursor: data && data.length === POSTS_PER_PAGE ? pageParam + 1 : null,
  };
};

// 사용자의 투표 상태를 가져오는 함수
const fetchUserVote = async (postId: number, userId: string) => {
  const { data, error } = await supabase
    .from('post_votes')
    .select('vote_type')
    .eq('post_id', postId)
    .eq('user_id', userId)
    .single();
  
  if (error && error.code !== 'PGRST116') throw new Error(error.message);
  return data;
};

// 사용자 프로필 데이터를 가져오는 함수
const fetchUserProfile = async (userId: string) => {
  const { data, error } = await supabase
    .from('profiles')
    .select('*')
    .eq('id', userId)
    .single();
  
  if (error) throw new Error(error.message);
  return data;
};

// 사용자의 게시글 통계를 가져오는 함수
const fetchUserStats = async (userId: string) => {
  const [postsResult, commentsResult, votesResult] = await Promise.all([
    supabase.from('posts').select('id').eq('author_id', userId),
    supabase.from('comments').select('id').eq('author_id', userId),
    supabase.from('post_votes').select('id').eq('user_id', userId)
  ]);

  return {
    postsCount: postsResult.data?.length || 0,
    commentsCount: commentsResult.data?.length || 0,
    votesCount: votesResult.data?.length || 0
  };
};

const Community = () => {
  const [selectedSection, setSelectedSection] = useState<number | undefined>();
  const [selectedCategory, setSelectedCategory] = useState<number | undefined>();
  const [sortBy, setSortBy] = useState('latest');
  const [searchQuery, setSearchQuery] = useState('');
  const [isScrolled, setIsScrolled] = useState(false);
  const [showMobileFilters, setShowMobileFilters] = useState(false);
  const { user } = useAuth();
  const queryClient = useQueryClient();
  const loadMoreRef = useRef<HTMLDivElement>(null);
  const isMobile = useIsMobile();

  // 🔧 NEW: Supabase Realtime 구독 - posts 테이블 업데이트를 실시간으로 반영
  useEffect(() => {
    const channel = supabase
      .channel('community-posts')
      .on(
        'postgres_changes',
        { event: 'UPDATE', schema: 'public', table: 'posts' },
        (payload) => {
          const updatedPost = payload.new as { 
            id: number;
            upvotes_count?: number; 
            downvotes_count?: number; 
            view_count?: number;
            comment_count?: number;
          };
          
          // posts-infinite 쿼리 데이터 업데이트
          queryClient.setQueriesData({ queryKey: ['posts-infinite'] }, (oldData: any) => {
            if (!oldData) return oldData;
            
            return {
              ...oldData,
              pages: oldData.pages.map((page: any) => ({
                ...page,
                data: page.data.map((post: any) => 
                  post.id === updatedPost.id 
                    ? {
                        ...post,
                        upvotes_count: updatedPost.upvotes_count ?? post.upvotes_count,
                        downvotes_count: updatedPost.downvotes_count ?? post.downvotes_count,
                        view_count: updatedPost.view_count ?? post.view_count,
                        comment_count: updatedPost.comment_count ?? post.comment_count,
                      }
                    : post
                )
              }))
            };
          });
        }
      )
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, [queryClient]);

  // 스크롤 감지
  useEffect(() => {
    const handleScroll = () => {
      const scrollTop = window.scrollY;
      setIsScrolled(scrollTop > 100);
    };

    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

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

  // 무한 스크롤 게시글 데이터
  const {
    data: postsData,
    fetchNextPage,
    hasNextPage,
    isFetchingNextPage,
    isLoading,
    error,
    refetch
  } = useInfiniteQuery({
    queryKey: ['posts-infinite', selectedSection, selectedCategory, sortBy, searchQuery],
    queryFn: ({ pageParam }) => fetchPostsPage({ 
      pageParam, 
      sectionId: selectedSection, 
      categoryId: selectedCategory, 
      sortBy, 
      searchQuery 
    }),
    getNextPageParam: (lastPage) => lastPage.nextCursor,
    initialPageParam: 0,
  });

  // 무한 스크롤 감지를 위한 Intersection Observer
  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        if (entries[0].isIntersecting && hasNextPage && !isFetchingNextPage) {
          fetchNextPage();
        }
      },
      { threshold: 0.1 }
    );

    if (loadMoreRef.current) {
      observer.observe(loadMoreRef.current);
    }

    return () => observer.disconnect();
  }, [fetchNextPage, hasNextPage, isFetchingNextPage]);

  // 전체 게시글 데이터를 평면화
  const posts = postsData?.pages.flatMap(page => page.data) || [];

  // 사용자의 모든 투표 상태를 한 번에 가져오기
  const { data: userVotes } = useQuery({
    queryKey: ['userVotes', user?.id],
    queryFn: async () => {
      if (!user?.id) return [];
      const { data, error } = await supabase
        .from('post_votes')
        .select('post_id, vote_type')
        .eq('user_id', user.id);
      
      if (error) throw new Error(error.message);
      return data || [];
    },
    enabled: !!user,
  });

  // 사용자의 북마크 상태를 가져오기
  const { data: userBookmarks } = useQuery({
    queryKey: ['userBookmarks', user?.id],
    queryFn: async () => {
      if (!user?.id) return [];
      const { data, error } = await supabase
        .from('post_bookmarks')
        .select('post_id')
        .eq('user_id', user.id);
      
      if (error) throw new Error(error.message);
      return data || [];
    },
    enabled: !!user,
  });

  // 특정 게시글의 사용자 투표 상태를 확인하는 함수
  const getUserVote = (postId: number) => {
    return userVotes?.find(vote => vote.post_id === postId)?.vote_type;
  };

  // 특정 게시글의 북마크 상태를 확인하는 함수
  const isBookmarked = (postId: number) => {
    return userBookmarks?.some(bookmark => bookmark.post_id === postId);
  };

  // 투표 뮤테이션
  const voteMutation = useMutation({
    mutationFn: async ({ postId, voteType }: { postId: number; voteType: number }) => {
      if (!user) throw new Error("로그인이 필요합니다.");
      
      // 현재 사용자의 투표 상태 확인
      const { data: currentVote } = await supabase
        .from('post_votes')
        .select('vote_type')
        .eq('post_id', postId)
        .eq('user_id', user.id)
        .single();
      
      // 같은 투표를 다시 누르면 취소
      if (currentVote && currentVote.vote_type === voteType) {
        const { error } = await supabase
          .from('post_votes')
          .delete()
          .eq('post_id', postId)
          .eq('user_id', user.id);
        
        if (error) throw new Error(error.message);
        return { action: 'removed' };
      }
      
      // 다른 투표로 변경하거나 새로 투표
      if (currentVote) {
        // 기존 투표가 있으면 업데이트
        const { error } = await supabase
          .from('post_votes')
          .update({ vote_type: voteType })
          .eq('post_id', postId)
          .eq('user_id', user.id);
        
        if (error) throw new Error(error.message);
        return { action: 'changed' };
      } else {
        // 새 투표 삽입
        const { error } = await supabase
          .from('post_votes')
          .insert({
            post_id: postId,
            user_id: user.id,
            vote_type: voteType,
          });
        
        if (error) throw new Error(error.message);
        return { action: 'voted' };
      }
    },
    onSuccess: (result) => {
      refetch();
      queryClient.invalidateQueries({ queryKey: ['userVotes'] });
      if (result.action === 'removed') {
        toast.success("투표가 취소되었습니다!");
      } else if (result.action === 'changed') {
        toast.success("투표가 변경되었습니다!");
      } else {
        toast.success("투표가 반영되었습니다!");
      }
    },
    onError: (error) => {
      toast.error(`오류가 발생했습니다: ${error.message}`);
    },
  });

  // 북마크 뮤테이션
  const bookmarkMutation = useMutation({
    mutationFn: async ({ postId, isBookmarked }: { postId: number; isBookmarked: boolean }) => {
      if (!user) throw new Error("로그인이 필요합니다.");
      
      if (isBookmarked) {
        // 북마크 제거
        const { error } = await supabase
          .from('post_bookmarks')
          .delete()
          .eq('post_id', postId)
          .eq('user_id', user.id);
        
        if (error) throw new Error(error.message);
        return { action: 'removed' };
      } else {
        // 북마크 추가
        const { error } = await supabase
          .from('post_bookmarks')
          .insert({
            post_id: postId,
            user_id: user.id,
          });
        
        if (error) throw new Error(error.message);
        return { action: 'added' };
      }
    },
    onSuccess: (result) => {
      queryClient.invalidateQueries({ queryKey: ['userBookmarks'] });
      if (result.action === 'removed') {
        toast.success("북마크가 제거되었습니다!");
      } else {
        toast.success("북마크에 추가되었습니다!");
      }
    },
    onError: (error) => {
      toast.error(`오류가 발생했습니다: ${error.message}`);
    },
  });

  // 게시글 삭제 뮤테이션
  const deletePostMutation = useMutation({
    mutationFn: async (postId: number) => {
      if (!user) throw new Error("로그인이 필요합니다.");
      
      // 게시글 작성자 확인
      const { data: post, error: fetchError } = await supabase
        .from('posts')
        .select('author_id')
        .eq('id', postId)
        .single();
      
      if (fetchError) throw new Error(fetchError.message);
      if (post.author_id !== user.id) throw new Error("삭제 권한이 없습니다.");
      
      const { error } = await supabase
        .from('posts')
        .delete()
        .eq('id', postId);
      
      if (error) throw new Error(error.message);
    },
    onSuccess: () => {
      refetch();
      toast.success("게시글이 삭제되었습니다!");
    },
    onError: (error) => {
      toast.error(`삭제 실패: ${error.message}`);
    },
  });

  const handleDeletePost = (postId: number) => {
    if (confirm("정말로 이 게시글을 삭제하시겠습니까?")) {
      deletePostMutation.mutate(postId);
    }
  };

  const handleVote = (postId: number, voteType: number) => {
    voteMutation.mutate({ postId, voteType });
  };

  const handleBookmark = (postId: number) => {
    const bookmarked = isBookmarked(postId);
    bookmarkMutation.mutate({ postId, isBookmarked: bookmarked });
  };

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    // 검색 쿼리가 이미 상태에 있으므로 자동으로 다시 쿼리됩니다
  };

  // 사용자 프로필 데이터
  const { data: userProfile } = useQuery({
    queryKey: ['userProfile', user?.id],
    queryFn: () => fetchUserProfile(user!.id),
    enabled: !!user,
  });

  // 사용자 통계 데이터
  const { data: userStats } = useQuery({
    queryKey: ['userStats', user?.id],
    queryFn: () => fetchUserStats(user!.id),
    enabled: !!user,
  });

  return (
    <div className="min-h-screen bg-background">
      <Navbar />
      <main className="pt-24 pb-12">
        <div className="container mx-auto px-6">
                     <div className="text-center md:text-left mb-8">
             <h1 className="text-4xl md:text-5xl font-bold">커뮤니티</h1>
             <p className="text-xl text-muted-foreground mt-4">
               AI에 대해 궁금한 점을 질문하고 지식을 나눠보세요.
             </p>
           </div>

          {/* 검색창 - 스크롤 시 숨김 */}
          <div className={`transition-all duration-300 ${isScrolled ? 'opacity-0 h-0 overflow-hidden' : 'opacity-100 h-auto mb-6'}`}>
            <form onSubmit={handleSearch}>
              <div className="relative max-w-md">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground w-4 h-4" />
                <Input
                  placeholder="게시글 검색..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="pl-10"
                />
              </div>
            </form>
          </div>

                     {/* 필터 및 정렬 - 스크롤 시 sticky */}
           <div className={`bg-background/95 backdrop-blur-sm border-b transition-all duration-300 ${
             isScrolled ? 'sticky top-16 z-40 py-4 -mx-6 px-6 shadow-sm' : 'mb-8 py-6'
           }`}>
            {/* 모바일 필터 토글 버튼 */}
            {isMobile && (
              <div className="flex items-center justify-between mb-4">
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => setShowMobileFilters(!showMobileFilters)}
                  className="flex items-center gap-2"
                >
                  <Filter className="w-4 h-4" />
                  필터
                  {showMobileFilters && <X className="w-4 h-4" />}
                </Button>
                
                {/* 모바일 정렬 옵션 */}
                <Select value={sortBy} onValueChange={setSortBy}>
                  <SelectTrigger className="w-[120px]">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="latest">
                      <div className="flex items-center gap-2">
                        <Clock className="w-4 h-4" />
                        최신순
                      </div>
                    </SelectItem>
                    <SelectItem value="popular">
                      <div className="flex items-center gap-2">
                        <ThumbsUp className="w-4 h-4" />
                        인기순
                      </div>
                    </SelectItem>
                    <SelectItem value="trending">
                      <div className="flex items-center gap-2">
                        <TrendingUp className="w-4 h-4" />
                        트렌딩
                      </div>
                    </SelectItem>
                    <SelectItem value="views">
                      <div className="flex items-center gap-2">
                        <Eye className="w-4 h-4" />
                        조회순
                      </div>
                    </SelectItem>
                    <SelectItem value="comments">
                      <div className="flex items-center gap-2">
                        <MessageCircle className="w-4 h-4" />
                        댓글순
                      </div>
                    </SelectItem>
                  </SelectContent>
                </Select>
              </div>
            )}

            {/* 필터 컨테이너 - 모바일에서는 토글 */}
                         <div className={`transition-all duration-300 ${
               isMobile 
                 ? showMobileFilters 
                   ? 'opacity-100 max-h-96 overflow-visible' 
                   : 'opacity-0 max-h-0 overflow-hidden'
                 : 'opacity-100'
             }`}>
               <div className="flex flex-col lg:flex-row gap-6">
                {/* 커뮤니티 섹션 필터 */}
                <div className="flex gap-2 flex-wrap">
                  <Button
                    variant={selectedSection === undefined ? "default" : "outline"}
                    onClick={() => setSelectedSection(undefined)}
                    className="text-sm"
                  >
                    전체
                  </Button>
                  {sections?.map((section) => (
                    <Button
                      key={section.id}
                      variant={selectedSection === section.id ? "default" : "outline"}
                      onClick={() => setSelectedSection(section.id)}
                      className="text-sm"
                      style={{ 
                        backgroundColor: selectedSection === section.id ? section.color : undefined,
                        borderColor: section.color
                      }}
                    >
                      {section.name}
                    </Button>
                  ))}
                </div>

                {/* 카테고리 필터 (중요도 순으로 표시) */}
                <div className="flex gap-2 flex-wrap">
                  <Select value={selectedCategory?.toString() || "all"} onValueChange={(value) => {
                    if (value === "all") {
                      setSelectedCategory(undefined);
                    } else {
                      setSelectedCategory(parseInt(value));
                    }
                  }}>
                    <SelectTrigger className="w-[180px]">
                      <SelectValue placeholder="카테고리 선택" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="all">
                        전체 카테고리
                      </SelectItem>
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
                
                {/* 정렬 옵션 - 데스크톱에서만 표시 */}
                {!isMobile && (
                  <div className="flex gap-2 ml-auto">
                    <Select value={sortBy} onValueChange={setSortBy}>
                      <SelectTrigger className="w-[140px]">
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="latest">
                          <div className="flex items-center gap-2">
                            <Clock className="w-4 h-4" />
                            최신순
                          </div>
                        </SelectItem>
                        <SelectItem value="popular">
                          <div className="flex items-center gap-2">
                            <ThumbsUp className="w-4 h-4" />
                            인기순
                          </div>
                        </SelectItem>
                        <SelectItem value="trending">
                          <div className="flex items-center gap-2">
                            <TrendingUp className="w-4 h-4" />
                            트렌딩
                          </div>
                        </SelectItem>
                        <SelectItem value="views">
                          <div className="flex items-center gap-2">
                            <Eye className="w-4 h-4" />
                            조회순
                          </div>
                        </SelectItem>
                        <SelectItem value="comments">
                          <div className="flex items-center gap-2">
                            <MessageCircle className="w-4 h-4" />
                            댓글순
                          </div>
                        </SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                )}
              </div>
            </div>
          </div>

          {/* 검색창이 숨겨진 상태에서 검색 결과 표시 */}
          {isScrolled && searchQuery && (
            <div className="mb-4 p-3 bg-muted/50 rounded-lg">
              <div className="flex items-center gap-2 text-sm">
                <Search className="w-4 h-4 text-muted-foreground" />
                <span className="text-muted-foreground">검색어:</span>
                <span className="font-medium">"{searchQuery}"</span>
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={() => setSearchQuery('')}
                  className="ml-auto h-6 w-6 p-0"
                >
                  <X className="w-3 h-3" />
                </Button>
              </div>
            </div>
          )}

          <div className="flex gap-6">
            {/* 메인 콘텐츠 */}
            <div className="flex-1">
              {isLoading ? (
                <div className="space-y-4">
                  {[...Array(5)].map((_, i) => <Skeleton key={i} className="h-32 w-full" />)}
                </div>
              ) : error ? (
                <div>에러가 발생했습니다: {error.message}</div>
              ) : (
                <div className="space-y-4">
                  {posts?.map((post) => (
                    <Card key={post.id} className={`hover:shadow-md transition-shadow ${post.is_pinned ? 'border-l-4 border-l-yellow-500' : ''}`}>
                      <CardHeader>
                        <div className="flex items-start justify-between">
                          <div className="flex-1">
                            <div className="flex items-center gap-2 mb-2">
                              {post.is_pinned && (
                                <Badge variant="secondary" className="bg-yellow-100 text-yellow-800">
                                  <Pin className="w-3 h-3 mr-1" />
                                  고정
                                </Badge>
                              )}
                              {post.community_sections && (
                                <Badge 
                                  variant="secondary"
                                  style={{ backgroundColor: post.community_sections.color + '20', color: post.community_sections.color }}
                                >
                                  {post.community_sections.name}
                                </Badge>
                              )}
                              {post.post_categories && (
                                <Badge 
                                  variant="outline"
                                  style={{ borderColor: post.post_categories.color, color: post.post_categories.color }}
                                >
                                  {post.post_categories.name}
                                </Badge>
                              )}
                            </div>
                            <Link to={`/community/${post.id}`}>
                              <CardTitle className="text-lg hover:text-primary transition-colors">
                                {post.title}
                              </CardTitle>
                            </Link>
                            <CardDescription className="mt-2 line-clamp-2">
                              {post.content?.replace(/<[^>]*>/g, '').substring(0, 150)}...
                            </CardDescription>
                            
                            {/* 이미지 미리보기 */}
                            {post.images && post.images.length > 0 && (
                              <div className="mt-3 flex gap-2 overflow-x-auto">
                                {post.images.slice(0, 3).map((imageUrl, index) => (
                                  <img
                                    key={index}
                                    src={imageUrl}
                                    alt={`게시글 이미지 ${index + 1}`}
                                    className="w-16 h-16 object-cover rounded-md border flex-shrink-0"
                                    onError={(e) => {
                                      e.currentTarget.src = '/placeholder.svg';
                                    }}
                                  />
                                ))}
                                {post.images.length > 3 && (
                                  <div className="w-16 h-16 bg-muted rounded-md border flex items-center justify-center flex-shrink-0">
                                    <span className="text-xs text-muted-foreground">
                                      +{post.images.length - 3}
                                    </span>
                                  </div>
                                )}
                              </div>
                            )}
                          </div>
                          
                          {/* 게시글 작성자만 보이는 수정/삭제 버튼 */}
                          {user && post.author_id === user.id && (
                            <div className="flex items-center gap-1 ml-4">
                              <Button
                                variant="ghost"
                                size="sm"
                                asChild
                                className="h-8 w-8 p-0"
                              >
                                <Link to={`/community/edit/${post.id}`}>
                                  <Edit className="w-4 h-4" />
                                </Link>
                              </Button>
                              <Button
                                variant="ghost"
                                size="sm"
                                onClick={() => handleDeletePost(post.id)}
                                disabled={deletePostMutation.isPending}
                                className="h-8 w-8 p-0 text-red-600 hover:text-red-700 hover:bg-red-50"
                              >
                                <Trash2 className="w-4 h-4" />
                              </Button>
                            </div>
                          )}
                        </div>
                        
                        <div className="flex items-center justify-between pt-4">
                          <div className="flex items-center gap-4 text-sm text-muted-foreground">
                            <div className="flex items-center gap-1">
                              <UserCircle className="w-4 h-4" />
                              <span>{post.profiles?.username || '익명'}</span>
                            </div>
                            <span>{new Date(post.created_at).toLocaleDateString()}</span>
                            <div className="flex items-center gap-1">
                              <Eye className="w-4 h-4" />
                              <span>{post.view_count || 0}</span>
                            </div>
                            <div className="flex items-center gap-1">
                              <MessageCircle className="w-4 h-4" />
                              <span>{post.comment_count || 0}</span>
                            </div>
                          </div>
                          
                          <div className="flex items-center gap-2">
                            <Button
                              variant="ghost"
                              size="sm"
                              onClick={(e) => {
                                e.preventDefault();
                                e.stopPropagation();
                                handleVote(post.id, 1);
                              }}
                              disabled={!user || voteMutation.isPending}
                              className={`${
                                getUserVote(post.id) === 1
                                  ? "bg-blue-100 text-blue-700 hover:bg-blue-200" 
                                  : "hover:bg-green-100 hover:text-green-700"
                              }`}
                            >
                              <ThumbsUp className="w-4 h-4 mr-1" />
                              {post.upvotes_count || 0}
                            </Button>
                            <Button
                              variant="ghost"
                              size="sm"
                              onClick={(e) => {
                                e.preventDefault();
                                e.stopPropagation();
                                handleVote(post.id, -1);
                              }}
                              disabled={!user || voteMutation.isPending}
                              className={`${
                                getUserVote(post.id) === -1
                                  ? "bg-red-100 text-red-700 hover:bg-red-200" 
                                  : "hover:bg-red-100 hover:text-red-700"
                              }`}
                            >
                              <ThumbsDown className="w-4 h-4 mr-1" />
                              {post.downvotes_count || 0}
                            </Button>
                            <Button
                              variant="ghost"
                              size="sm"
                              onClick={(e) => {
                                e.preventDefault();
                                e.stopPropagation();
                                handleBookmark(post.id);
                              }}
                              disabled={!user || bookmarkMutation.isPending}
                              className={`${
                                isBookmarked(post.id)
                                  ? "bg-yellow-100 text-yellow-700 hover:bg-yellow-200" 
                                  : "hover:bg-gray-100"
                              }`}
                            >
                              <Bookmark className="w-4 h-4" />
                            </Button>
                            
                            {/* SNS 공유 버튼 */}
                            <div onClick={(e) => e.stopPropagation()}>
                              <SocialShare
                                url={`${window.location.origin}/community/${post.id}`}
                                title={post.title}
                                description={post.content?.replace(/<[^>]*>/g, '').substring(0, 100)}
                                hashtags={['AIHub', '커뮤니티', post.post_categories?.name || '']}
                              />
                            </div>
                            
                            <Button
                              variant="ghost"
                              size="sm"
                              onClick={(e) => {
                                e.preventDefault();
                                e.stopPropagation();
                                // 신고 기능 구현 예정
                                toast.info("신고 기능은 곧 추가될 예정입니다!");
                              }}
                              className="hover:bg-red-50 hover:text-red-600"
                            >
                              <Flag className="w-4 h-4" />
                            </Button>
                          </div>
                        </div>
                      </CardHeader>
                    </Card>
                  ))}
                  
                  {/* 무한 스크롤 로딩 인디케이터 */}
                  <div ref={loadMoreRef} className="flex justify-center py-8">
                    {isFetchingNextPage && (
                      <div className="flex items-center gap-2 text-muted-foreground">
                        <Loader2 className="w-4 h-4 animate-spin" />
                        더 많은 게시글을 불러오는 중...
                      </div>
                    )}
                    {!hasNextPage && posts.length > 0 && (
                      <div className="text-muted-foreground text-sm">
                        모든 게시글을 확인했습니다.
                      </div>
                    )}
                  </div>
                  
                  {posts?.length === 0 && (
                    <div className="text-center py-12">
                      <MessageSquare className="w-12 h-12 text-muted-foreground mx-auto mb-4" />
                      <h3 className="text-lg font-medium text-muted-foreground mb-2">
                        {searchQuery ? '검색 결과가 없습니다' : '아직 게시글이 없습니다'}
                      </h3>
                      <p className="text-muted-foreground mb-4">
                        {searchQuery ? '다른 검색어를 시도해보세요.' : '첫 번째 게시글을 작성해보세요!'}
                      </p>
                      <Button asChild>
                        <Link to="/community/new">
                          <PlusCircle className="mr-2 h-4 w-4" />
                          새 질문 올리기
                        </Link>
                      </Button>
                    </div>
                  )}
                </div>
              )}
            </div>

            {/* 오른쪽 사이드바 - 프로필 미리보기 (데스크톱에서만 표시) */}
            {!isMobile && user && (
              <div className="w-80 flex-shrink-0">
                <Card className="sticky top-32">
                  <CardHeader>
                    <CardTitle className="flex items-center gap-2">
                      <Settings className="w-4 h-4" />
                      내 프로필
                    </CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <div className="flex items-center gap-3">
                      <Avatar className="h-12 w-12">
                        <AvatarImage src={userProfile?.avatar_url || ''} alt={userProfile?.username || ''} />
                        <AvatarFallback>{userProfile?.username?.charAt(0).toUpperCase()}</AvatarFallback>
                      </Avatar>
                      <div>
                        <p className="font-medium">{userProfile?.full_name || '사용자'}</p>
                        <p className="text-sm text-muted-foreground">@{userProfile?.username || 'username'}</p>
                      </div>
                    </div>
                    
                    <div className="grid grid-cols-3 gap-4 text-center">
                      <div>
                        <p className="text-2xl font-bold">{userStats?.postsCount || 0}</p>
                        <p className="text-xs text-muted-foreground">게시글</p>
                      </div>
                      <div>
                        <p className="text-2xl font-bold">{userStats?.commentsCount || 0}</p>
                        <p className="text-xs text-muted-foreground">댓글</p>
                      </div>
                      <div>
                        <p className="text-2xl font-bold">{userStats?.votesCount || 0}</p>
                        <p className="text-xs text-muted-foreground">투표</p>
                      </div>
                    </div>
                    
                    <div className="space-y-2">
                      <Button asChild variant="outline" className="w-full">
                        <Link to="/profile">
                          <Settings className="w-4 h-4 mr-2" />
                          프로필 설정
                        </Link>
                      </Button>
                      <Button asChild className="w-full">
                        <Link to="/community/new">
                          <PlusCircle className="w-4 h-4 mr-2" />
                          새 게시글 작성
                        </Link>
                      </Button>
                    </div>
                  </CardContent>
                </Card>
              </div>
            )}
          </div>
        </div>
      </main>
      <Footer />
    </div>
  );
};

export default Community;
