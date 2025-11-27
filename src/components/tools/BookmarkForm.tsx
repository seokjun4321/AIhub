import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { toast } from "sonner";
import { useAuth } from "@/hooks/useAuth";
import { Loader2, Plus } from "lucide-react";

interface BookmarkFormProps {
    aiModelId: number;
    onSuccess?: () => void;
}

const BookmarkForm = ({ aiModelId, onSuccess }: BookmarkFormProps) => {
    const { user } = useAuth();
    const queryClient = useQueryClient();
    const [selectedFolderId, setSelectedFolderId] = useState<string>("uncategorized");
    const [newFolderName, setNewFolderName] = useState("");
    const [isCreatingFolder, setIsCreatingFolder] = useState(false);

    // Fetch Folders
    const { data: folders, isLoading: isFoldersLoading } = useQuery({
        queryKey: ["bookmarkFolders", user?.id],
        queryFn: async () => {
            const { data, error } = await supabase
                .from("bookmark_folders" as any)
                .select("*")
                .order("created_at", { ascending: true });
            if (error) throw error;
            return data as unknown as { id: number; name: string }[];
        },
        enabled: !!user,
    });

    // Create Folder Mutation
    const createFolderMutation = useMutation({
        mutationFn: async (name: string) => {
            const { data, error } = await supabase
                .from("bookmark_folders" as any)
                .insert({ user_id: user?.id, name })
                .select()
                .single();
            if (error) throw error;
            return data as any;
        },
        onSuccess: (data) => {
            queryClient.invalidateQueries({ queryKey: ["bookmarkFolders"] });
            setNewFolderName("");
            setIsCreatingFolder(false);
            setSelectedFolderId(data.id.toString());
            toast.success("폴더가 생성되었습니다.");
        },
        onError: (error) => {
            toast.error(`폴더 생성 실패: ${error.message}`);
        },
    });

    // Add Bookmark Mutation
    const addBookmarkMutation = useMutation({
        mutationFn: async () => {
            if (!user) throw new Error("로그인이 필요합니다.");

            const folderId = selectedFolderId === "uncategorized" ? null : parseInt(selectedFolderId);

            const { error } = await supabase.from("tool_bookmarks" as any).insert({
                user_id: user.id,
                ai_model_id: aiModelId,
                folder_id: folderId,
            });

            if (error) {
                if (error.code === "23505") {
                    throw new Error("이미 저장된 도구입니다.");
                }
                throw error;
            }
        },
        onSuccess: () => {
            queryClient.invalidateQueries({ queryKey: ["toolBookmarks"] });
            toast.success("도구가 저장되었습니다!");
            if (onSuccess) onSuccess();
        },
        onError: (error) => {
            toast.error(error.message);
        },
    });

    const handleCreateFolder = () => {
        if (!newFolderName.trim()) return;
        createFolderMutation.mutate(newFolderName);
    };

    const handleSubmit = () => {
        addBookmarkMutation.mutate();
    };

    if (!user) {
        return <div className="text-center py-4">로그인이 필요합니다.</div>;
    }

    return (
        <div className="space-y-6 py-4">
            <div className="space-y-4">
                <Label>폴더 선택</Label>
                {isFoldersLoading ? (
                    <div className="flex justify-center py-4">
                        <Loader2 className="animate-spin h-6 w-6 text-muted-foreground" />
                    </div>
                ) : (
                    <RadioGroup value={selectedFolderId} onValueChange={setSelectedFolderId}>
                        <div className="flex items-center space-x-2">
                            <RadioGroupItem value="uncategorized" id="uncategorized" />
                            <Label htmlFor="uncategorized">미분류 (기본)</Label>
                        </div>
                        {folders?.map((folder) => (
                            <div key={folder.id} className="flex items-center space-x-2">
                                <RadioGroupItem value={folder.id.toString()} id={`folder-${folder.id}`} />
                                <Label htmlFor={`folder-${folder.id}`}>{folder.name}</Label>
                            </div>
                        ))}
                    </RadioGroup>
                )}
            </div>

            <div className="pt-2 border-t">
                {isCreatingFolder ? (
                    <div className="flex gap-2">
                        <Input
                            placeholder="새 폴더 이름"
                            value={newFolderName}
                            onChange={(e) => setNewFolderName(e.target.value)}
                            onKeyDown={(e) => e.key === "Enter" && handleCreateFolder()}
                        />
                        <Button size="sm" onClick={handleCreateFolder} disabled={createFolderMutation.isPending}>
                            생성
                        </Button>
                        <Button size="sm" variant="ghost" onClick={() => setIsCreatingFolder(false)}>
                            취소
                        </Button>
                    </div>
                ) : (
                    <Button
                        variant="ghost"
                        size="sm"
                        className="w-full justify-start text-muted-foreground"
                        onClick={() => setIsCreatingFolder(true)}
                    >
                        <Plus className="w-4 h-4 mr-2" />새 폴더 만들기
                    </Button>
                )}
            </div>

            <Button className="w-full" onClick={handleSubmit} disabled={addBookmarkMutation.isPending}>
                {addBookmarkMutation.isPending ? (
                    <>
                        <Loader2 className="w-4 h-4 mr-2 animate-spin" /> 저장 중...
                    </>
                ) : (
                    "저장하기"
                )}
            </Button>
        </div>
    );
};

export default BookmarkForm;
