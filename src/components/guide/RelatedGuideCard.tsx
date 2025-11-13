import { Card } from "@/components/ui/card";
import { Star, Clock } from "lucide-react";
import { Link } from "react-router-dom";

interface RelatedGuideCardProps {
  id: number;
  title: string;
  tool?: string;
  readTime?: number;
}

export function RelatedGuideCard({ id, title, tool, readTime }: RelatedGuideCardProps) {
  return (
    <Link to={`/guides/${id}`}>
      <Card className="p-4 hover:border-accent/50 hover:shadow-md transition-all cursor-pointer border-border/50">
        <h4 className="font-semibold text-sm mb-2 line-clamp-2">{title}</h4>
        <div className="flex items-center gap-4 text-xs text-muted-foreground">
          {tool && <span>{tool}</span>}
          {readTime && (
            <div className="flex items-center gap-1">
              <Clock className="h-3 w-3" />
              <span>{readTime}분</span>
            </div>
          )}
        </div>
      </Card>
    </Link>
  );
}

