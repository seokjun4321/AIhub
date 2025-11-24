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

export const ChapterNav = ({ chapters, activeChapter, onChapterClick }: ChapterNavProps) => {
  return (
    <nav className="bg-card rounded-xl shadow-lg p-6 space-y-2">
      <h2 className="font-semibold text-lg mb-4 text-foreground">학습 목차</h2>
      <div className="space-y-1">
        {chapters.map((chapter) => (
          <button
            key={chapter.id}
            onClick={() => onChapterClick(chapter.id)}
            className={cn(
              "w-full text-left px-4 py-3 rounded-lg transition-all duration-200 flex items-center gap-3 group",
              activeChapter === chapter.id
                ? "bg-primary text-primary-foreground font-medium shadow-sm"
                : "hover:bg-muted text-muted-foreground hover:text-foreground"
            )}
          >
            <div
              className={cn(
                "w-5 h-5 rounded-full flex items-center justify-center flex-shrink-0 transition-colors",
                chapter.completed
                  ? "bg-green-500 text-white"
                  : "border-2 border-border group-hover:border-primary"
              )}
            >
              {chapter.completed && <Check className="w-3 h-3" />}
            </div>
            <span className="text-sm leading-tight">{chapter.title}</span>
          </button>
        ))}
      </div>
    </nav>
  );
};

