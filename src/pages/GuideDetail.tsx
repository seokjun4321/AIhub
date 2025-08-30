import { useState, useEffect } from "react";
import { useParams, Link } from "react-router-dom";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { Skeleton } from "@/components/ui/skeleton";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogFooter } from "@/components/ui/dialog";
import StarRating from "@/components/ui/StarRating";
import { useAuth } from "@/hooks/useAuth";
import { toast } from "sonner";
import { UserCircle, Calendar, Star } from "lucide-react";
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import { cn } from "@/lib/utils";

const fetchGuideById = async (id: string) => {
  const numericId = parseInt(id, 10);
  if (isNaN(numericId)) throw new Error("Invalid ID provided");
  const { data, error } = await supabase
    .from('guides')
    .select(`*, ai_models(*), profiles(username), categories(name)`)
    .eq('id', numericId)
    .single();
  if (error) throw new Error(error.message);
  return data;
};

const fetchUserRating = async (aiModelId: number, userId: string) => {
  const { data, error } = await supabase
    .from('ratings')
    .select('rating')
    .eq('ai_model_id', aiModelId)
    .eq('user_id', userId)
    .single();
  if (error && error.code !== 'PGRST116') throw new Error(error.message);
  return data;
};

const GuideDetail = () => {
  const { id } = useParams<{ id: string }>();
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [currentRating, setCurrentRating] = useState(0);
  const queryClient = useQueryClient();
  const { user } = useAuth();

  // --- 🔧 FIX 1: Destructure the `refetch` function ---
  // We get the `refetch` function from useQuery to call it directly.
  const { data: guide, isLoading, error, refetch: refetchGuide } = useQuery({
    queryKey: ['guide', id],
    queryFn: () => fetchGuideById(id!),
    enabled: !!id,
  });

  const aiModel = guide?.ai_models;

  const userRatingQuery = useQuery({
    queryKey: ['userRating', aiModel?.id, user?.id],
    queryFn: () => {
      if (!user?.id || !aiModel?.id) return null;
      return fetchUserRating(aiModel.id, user.id);
    },
    enabled: !!aiModel && !!user,
  });

  useEffect(() => {
    if (userRatingQuery.data) {
      setCurrentRating(userRatingQuery.data.rating || 0);
    } else {
      setCurrentRating(0);
    }
  }, [userRatingQuery.data]);

  // --- 🔧 FIX 2: Simplified and more robust mutation logic ---
  const rateMutation = useMutation({
    mutationFn: async ({ rating }: { rating: number }) => {
      if (!user || !aiModel) throw new Error("You must be logged in to rate.");
      
      const { error } = await supabase.from('ratings').upsert({
        user_id: user.id,
        ai_model_id: aiModel.id,
        rating: rating,
      });
      
      if (error) throw new Error(error.message);
    },
    // This function will run after the mutation is finished, whether it succeeded or failed.
    onSettled: () => {
      // This is the most reliable way to ensure all related data is updated.
      // It marks all queries starting with 'guide', 'guides', etc., as stale.
      queryClient.invalidateQueries({ queryKey: ['guide'] });
      queryClient.invalidateQueries({ queryKey: ['guides'] });
      queryClient.invalidateQueries({ queryKey: ['userRating'] });
      queryClient.invalidateQueries({ queryKey: ['recommendations'] });
    },
    onSuccess: () => {
      toast.success("Rating submitted successfully!");
    },
    onError: (error) => {
      toast.error(`Error submitting rating: ${error.message}`);
    }
  });

  const handleRate = (rating: number) => {
    setCurrentRating(rating);
    rateMutation.mutate({ rating });
  };

  // --- The rest of the component (JSX) is correct and remains unchanged ---
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
  if (error) { return <div>Error loading guide: {error.message}</div>; }
  if (!guide) { return <div>Guide not found.</div> }

  return (
    <div className="min-h-screen">
      <Navbar />
      <main className="pt-24 pb-12">
        <article className="container mx-auto px-6 max-w-4xl">
          <header className="mb-8">
            <Badge variant="outline" className="mb-4">{guide.categories?.name || 'Uncategorized'}</Badge>
            <h1 className="text-4xl md:text-5xl font-bold tracking-tight">{guide.title}</h1>
            <p className="text-xl text-muted-foreground mt-4">{guide.description}</p>
            <div className="flex flex-wrap items-center justify-between gap-4 mt-6">
              <div className="flex items-center gap-8 text-sm text-muted-foreground">
                <div className="flex items-center gap-2"><UserCircle className="w-4 h-4" /><span>by {guide.profiles?.username || 'Unknown Author'}</span></div>
                <div className="flex items-center gap-2"><Calendar className="w-4 h-4" /><span>{new Date(guide.created_at).toLocaleString()}</span></div>
              </div>
              {aiModel && (
                <div className="flex items-center gap-4">
                  <div className="flex items-center gap-2">
                    <StarRating rating={Number(aiModel.average_rating) || 0} size={16} readOnly />
                      <span className="font-semibold text-sm text-foreground">
                          {(Number(aiModel.average_rating) || 0).toFixed(1)}
                      </span>
                      <span className="text-sm text-muted-foreground">
                          ({aiModel.rating_count || 0} ratings)
                      </span>
                  </div>
                  <Button variant="outline" size="sm" onClick={() => setIsModalOpen(true)}>
                    <Star className="w-4 h-4 mr-2" />Rate this AI
                  </Button>
                </div>
              )}
            </div>
          </header>
          
          <div className="aspect-video w-full bg-muted rounded-lg mb-8 overflow-hidden">
            <img src={guide.image_url || "/placeholder.svg"} alt={guide.title} className="w-full h-full object-cover" />
          </div>
          
          <div className={cn("prose dark:prose-invert max-w-none")}>
            <ReactMarkdown remarkPlugins={[remarkGfm]}>{guide.content || ""}</ReactMarkdown>
          </div>
        </article>
      </main>
      <Footer />

      <Dialog open={isModalOpen} onOpenChange={setIsModalOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{aiModel?.name}</DialogTitle>
            <DialogDescription>Please leave a rating for this AI tool!</DialogDescription>
          </DialogHeader>
          <div className="py-4">
            <h3 className="text-lg font-medium mb-2 text-center">My Rating</h3>
            <div className="flex justify-center">
              <StarRating rating={currentRating} size={32} onRate={handleRate} readOnly={!user || rateMutation.isPending} />
            </div>
            {rateMutation.isPending && <p className="text-center text-sm text-muted-foreground mt-2">Submitting rating...</p>}
            {!user && (
              <p className="text-center text-sm text-muted-foreground mt-4">
                <Link to="/auth" className="text-primary underline">Log in</Link> to leave a rating.
              </p>
            )}
          </div>
          <DialogFooter><Button onClick={() => setIsModalOpen(false)}>Close</Button></DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
};

export default GuideDetail;