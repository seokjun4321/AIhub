import { Check } from "lucide-react";
import { cn } from "@/lib/utils";

interface Chapter {
  id: string;
  title: string;
  completed: boolean;
}

interface ChapterNavProps {
  chapters: Chapter[];
  activeChapter: string;
  onChapterClick: (id: string) => void;
}

export const ChapterNav = ({ chapters, activeChapter, onChapterClick, onToggleComplete }: ChapterNavProps & { onToggleComplete: (id: number) => void }) => {
  return (
    <nav className="bg-card rounded-xl shadow-lg p-4 space-y-2">
      <h2 className="font-semibold text-lg mb-4 text-foreground px-2">학습 목차</h2>
      <div className="space-y-1">
        {chapters.map((chapter) => {
          const chapterNum = parseInt(chapter.id.split("-")[1]);
          return (
            <div
              key={chapter.id}
              className={cn(
                "w-full text-left px-3 py-3 rounded-lg transition-all duration-200 flex items-start gap-3 group cursor-pointer",
                activeChapter === chapter.id
                  ? "bg-primary text-primary-foreground font-medium shadow-sm"
                  : "hover:bg-muted text-muted-foreground hover:text-foreground"
              )}
              onClick={() => onChapterClick(chapter.id)}
            >
              <button
                onClick={(e) => {
                  e.stopPropagation();
                  onToggleComplete(chapterNum);
                }}
                className={cn(
                  "w-5 h-5 rounded-full flex items-center justify-center flex-shrink-0 transition-colors mt-0.5",
                  chapter.completed
                    ? "bg-green-500 text-white border-green-500"
                    : activeChapter === chapter.id
                      ? "border-2 border-primary-foreground/30 hover:border-primary-foreground"
                      : "border-2 border-border hover:border-primary"
                )}
              >
                {chapter.completed && <Check className="w-3 h-3" />}
              </button>
              <span className="text-sm pt-0.5 break-keep">{chapter.title}</span>
            </div>
          );
        })}
      </div>
    </nav>
  );
};

