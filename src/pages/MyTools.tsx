import { useState, useEffect } from "react";
import { Link, useNavigate } from "react-router-dom";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
    Dialog,
    DialogContent,
    DialogHeader,
    DialogTitle,
    DialogTrigger,
    DialogFooter,
} from "@/components/ui/dialog";
import {
    Card,
    CardContent,
    CardHeader,
    CardTitle,
    CardDescription,
} from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { toast } from "sonner";
import {
    Folder,
    Plus,
    Trash2,
    ExternalLink,
    Search,
    Grid,
    List,
    MoreVertical,
    FolderOpen,
    Settings
} from "lucide-react";
import { useAuth } from "@/hooks/useAuth";
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";

interface BookmarkFolder {
    id: number;
    name: string;
    created_at: string;
}

interface ToolBookmark {
    id: number;
    ai_model_id: number;
    folder_id: number | null;
    created_at: string;
    ai_models: {
        id: number;
        name: string;
        description: string;
        logo_url: string | null;
        website_url: string | null;
        provider: string | null;
    };
}

const MyTools = () => {
    const { user } = useAuth();
    const navigate = useNavigate();
    const queryClient = useQueryClient();
    const [selectedFolderId, setSelectedFolderId] = useState<number | null>(null);
    const [isCreateFolderOpen, setIsCreateFolderOpen] = useState(false);
    const [newFolderName, setNewFolderName] = useState("");
    const [viewMode, setViewMode] = useState<"grid" | "list">("grid");

    useEffect(() => {
        if (!user) {
            navigate("/auth");
        }
    }, [user, navigate]);

    // Fetch Folders
    const { data: folders } = useQuery({
        queryKey: ["bookmarkFolders", user?.id],
        queryFn: async () => {
            const { data, error } = await supabase
                .from("bookmark_folders" as any)
                .select("*")
                .order("created_at", { ascending: true });
            if (error) throw error;
            return data as unknown as BookmarkFolder[];
        },
        enabled: !!user,
    });

    // Fetch Bookmarks
    const { data: bookmarks, isLoading } = useQuery({
        queryKey: ["toolBookmarks", user?.id, selectedFolderId],
        queryFn: async () => {
            let query = supabase
                .from("tool_bookmarks" as any)
                .select(`
          *,
          ai_models (
            id,
            name,
            description,
            logo_url,
            website_url,
            provider
          )
        `)
                .order("created_at", { ascending: false });

            if (selectedFolderId) {
                query = query.eq("folder_id", selectedFolderId);
            }

            const { data, error } = await query;
            if (error) throw error;
            return data as unknown as ToolBookmark[];
        },
        enabled: !!user,
    });

    // Create Folder Mutation
    const createFolderMutation = useMutation({
        mutationFn: async (name: string) => {
            const { error } = await supabase
                .from("bookmark_folders" as any)
                .insert({ user_id: user?.id, name });
            if (error) throw error;
        },
        onSuccess: () => {
            queryClient.invalidateQueries({ queryKey: ["bookmarkFolders"] });
            setIsCreateFolderOpen(false);
            setNewFolderName("");
            toast.success("폴더가 생성되었습니다.");
        },
        onError: (error) => {
            toast.error(`폴더 생성 실패: ${error.message}`);
        },
    });

    // Delete Bookmark Mutation
    const deleteBookmarkMutation = useMutation({
        mutationFn: async (id: number) => {
            const { error } = await supabase
                .from("tool_bookmarks" as any)
                .delete()
                .eq("id", id);
            if (error) throw error;
        },
        onSuccess: () => {
            queryClient.invalidateQueries({ queryKey: ["toolBookmarks"] });
            toast.success("북마크가 삭제되었습니다.");
        },
    });

    // Delete Folder Mutation
    const deleteFolderMutation = useMutation({
        mutationFn: async (id: number) => {
            // First update bookmarks in this folder to have null folder_id (uncategorized)
            // Or cascade delete? The schema says 'on delete set null', so we just delete the folder.
            const { error } = await supabase
                .from("bookmark_folders" as any)
                .delete()
                .eq("id", id);
            if (error) throw error;
        },
        onSuccess: () => {
            queryClient.invalidateQueries({ queryKey: ["bookmarkFolders"] });
            if (selectedFolderId) setSelectedFolderId(null);
            toast.success("폴더가 삭제되었습니다.");
        },
    });

    const handleCreateFolder = () => {
        if (!newFolderName.trim()) return;
        createFolderMutation.mutate(newFolderName);
    };

    return (
        <div className="min-h-screen bg-background flex flex-col">
            <Navbar />
            <main className="flex-1 container mx-auto px-6 py-24">
                <div className="flex flex-col md:flex-row gap-8">
                    {/* Sidebar - Folders */}
                    <aside className="w-full md:w-64 shrink-0 space-y-6">
                        <div className="flex items-center justify-between">
                            <h2 className="text-lg font-semibold flex items-center gap-2">
                                <FolderOpen className="w-5 h-5" />
                                내 폴더
                            </h2>
                            <Dialog open={isCreateFolderOpen} onOpenChange={setIsCreateFolderOpen}>
                                <DialogTrigger asChild>
                                    <Button variant="ghost" size="icon" className="h-8 w-8">
                                        <Plus className="w-4 h-4" />
                                    </Button>
                                </DialogTrigger>
                                <DialogContent>
                                    <DialogHeader>
                                        <DialogTitle>새 폴더 만들기</DialogTitle>
                                    </DialogHeader>
                                    <div className="py-4">
                                        <Input
                                            placeholder="폴더 이름 (예: 업무용, 디자인)"
                                            value={newFolderName}
                                            onChange={(e) => setNewFolderName(e.target.value)}
                                            onKeyDown={(e) => e.key === "Enter" && handleCreateFolder()}
                                        />
                                    </div>
                                    <DialogFooter>
                                        <Button onClick={handleCreateFolder}>생성</Button>
                                    </DialogFooter>
                                </DialogContent>
                            </Dialog>
                        </div>

                        <div className="space-y-1">
                            <Button
                                variant={selectedFolderId === null ? "secondary" : "ghost"}
                                className="w-full justify-start"
                                onClick={() => setSelectedFolderId(null)}
                            >
                                <Grid className="w-4 h-4 mr-2" />
                                전체 보기
                            </Button>
                            {folders?.map((folder) => (
                                <div key={folder.id} className="group flex items-center">
                                    <Button
                                        variant={selectedFolderId === folder.id ? "secondary" : "ghost"}
                                        className="w-full justify-start truncate"
                                        onClick={() => setSelectedFolderId(folder.id)}
                                    >
                                        <Folder className="w-4 h-4 mr-2 shrink-0" />
                                        <span className="truncate">{folder.name}</span>
                                    </Button>
                                    <DropdownMenu>
                                        <DropdownMenuTrigger asChild>
                                            <Button
                                                variant="ghost"
                                                size="icon"
                                                className="h-8 w-8 opacity-0 group-hover:opacity-100 transition-opacity"
                                            >
                                                <MoreVertical className="w-3 h-3" />
                                            </Button>
                                        </DropdownMenuTrigger>
                                        <DropdownMenuContent align="end">
                                            <DropdownMenuItem
                                                className="text-red-600"
                                                onClick={() => deleteFolderMutation.mutate(folder.id)}
                                            >
                                                <Trash2 className="w-4 h-4 mr-2" />
                                                폴더 삭제
                                            </DropdownMenuItem>
                                        </DropdownMenuContent>
                                    </DropdownMenu>
                                </div>
                            ))}
                        </div>
                    </aside>

                    {/* Main Content - Bookmarks */}
                    <div className="flex-1">
                        <div className="flex items-center justify-between mb-6">
                            <h1 className="text-2xl font-bold">
                                {selectedFolderId
                                    ? folders?.find((f) => f.id === selectedFolderId)?.name
                                    : "전체 도구"}
                                <span className="ml-2 text-sm font-normal text-muted-foreground">
                                    ({bookmarks?.length || 0})
                                </span>
                            </h1>
                            <div className="flex items-center gap-2">
                                <Button
                                    variant={viewMode === "grid" ? "secondary" : "ghost"}
                                    size="icon"
                                    onClick={() => setViewMode("grid")}
                                >
                                    <Grid className="w-4 h-4" />
                                </Button>
                                <Button
                                    variant={viewMode === "list" ? "secondary" : "ghost"}
                                    size="icon"
                                    onClick={() => setViewMode("list")}
                                >
                                    <List className="w-4 h-4" />
                                </Button>
                            </div>
                        </div>

                        {isLoading ? (
                            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                                {[1, 2, 3].map((i) => (
                                    <div key={i} className="h-48 bg-muted rounded-xl animate-pulse" />
                                ))}
                            </div>
                        ) : bookmarks?.length === 0 ? (
                            <div className="text-center py-12 border rounded-xl bg-muted/20">
                                <FolderOpen className="w-12 h-12 mx-auto text-muted-foreground mb-4" />
                                <h3 className="text-lg font-medium mb-2">저장된 도구가 없습니다</h3>
                                <p className="text-muted-foreground mb-4">
                                    마음에 드는 AI 도구를 찾아보세요!
                                </p>
                                <Button asChild>
                                    <Link to="/tools">도구 둘러보기</Link>
                                </Button>
                            </div>
                        ) : (
                            <div
                                className={
                                    viewMode === "grid"
                                        ? "grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4"
                                        : "space-y-4"
                                }
                            >
                                {bookmarks?.map((bookmark) => (
                                    <Card key={bookmark.id} className="group hover:shadow-md transition-shadow">
                                        <CardHeader className="p-4 pb-2">
                                            <div className="flex items-start justify-between">
                                                <div className="flex items-center gap-3">
                                                    <div className="w-10 h-10 rounded-lg bg-muted flex items-center justify-center overflow-hidden">
                                                        {bookmark.ai_models.logo_url ? (
                                                            <img
                                                                src={bookmark.ai_models.logo_url}
                                                                alt={bookmark.ai_models.name}
                                                                className="w-full h-full object-cover"
                                                            />
                                                        ) : (
                                                            <div className="text-lg font-bold text-muted-foreground">
                                                                {bookmark.ai_models.name.charAt(0)}
                                                            </div>
                                                        )}
                                                    </div>
                                                    <div>
                                                        <CardTitle className="text-base">
                                                            <Link
                                                                to={`/tools/${bookmark.ai_models.id}`}
                                                                className="hover:underline"
                                                            >
                                                                {bookmark.ai_models.name}
                                                            </Link>
                                                        </CardTitle>
                                                        <CardDescription className="text-xs truncate max-w-[150px]">
                                                            {bookmark.ai_models.provider}
                                                        </CardDescription>
                                                    </div>
                                                </div>
                                                <DropdownMenu>
                                                    <DropdownMenuTrigger asChild>
                                                        <Button variant="ghost" size="icon" className="h-8 w-8">
                                                            <MoreVertical className="w-4 h-4" />
                                                        </Button>
                                                    </DropdownMenuTrigger>
                                                    <DropdownMenuContent align="end">
                                                        <DropdownMenuItem
                                                            className="text-red-600"
                                                            onClick={() => deleteBookmarkMutation.mutate(bookmark.id)}
                                                        >
                                                            <Trash2 className="w-4 h-4 mr-2" />
                                                            삭제
                                                        </DropdownMenuItem>
                                                    </DropdownMenuContent>
                                                </DropdownMenu>
                                            </div>
                                        </CardHeader>
                                        <CardContent className="p-4 pt-2">
                                            <p className="text-sm text-muted-foreground line-clamp-2 mb-4 h-10">
                                                {bookmark.ai_models.description}
                                            </p>
                                            <div className="flex items-center justify-between">
                                                {bookmark.folder_id ? (
                                                    <Badge variant="outline" className="text-xs">
                                                        {folders?.find(f => f.id === bookmark.folder_id)?.name}
                                                    </Badge>
                                                ) : (
                                                    <span className="text-xs text-muted-foreground">미분류</span>
                                                )}
                                                <Button variant="ghost" size="sm" asChild>
                                                    <Link to={`/tools/${bookmark.ai_models.id}`}>
                                                        자세히 <ExternalLink className="w-3 h-3 ml-1" />
                                                    </Link>
                                                </Button>
                                            </div>
                                        </CardContent>
                                    </Card>
                                ))}
                            </div>
                        )}
                    </div>
                </div>
            </main>
            <Footer />
        </div>
    );
};

export default MyTools;
