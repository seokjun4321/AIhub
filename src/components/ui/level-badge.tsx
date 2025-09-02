import { Badge } from "@/components/ui/badge";
import { cn } from "@/lib/utils";
import { 
  Baby, 
  BookOpen, 
  Compass, 
  Award, 
  Crown, 
  Zap, 
  Star, 
  Moon, 
  Gem, 
  Trophy 
} from "lucide-react";

interface LevelBadgeProps {
  level: number;
  title?: string;
  className?: string;
  size?: "sm" | "md" | "lg";
}

const levelIcons = {
  1: Baby,
  2: BookOpen,
  3: Compass,
  4: Award,
  5: Crown,
  6: Zap,
  7: Star,
  8: Moon,
  9: Gem,
  10: Trophy,
};

const levelColors = {
  1: "bg-gray-500 hover:bg-gray-600",
  2: "bg-green-500 hover:bg-green-600",
  3: "bg-blue-500 hover:bg-blue-600",
  4: "bg-purple-500 hover:bg-purple-600",
  5: "bg-yellow-500 hover:bg-yellow-600",
  6: "bg-red-500 hover:bg-red-600",
  7: "bg-pink-500 hover:bg-pink-600",
  8: "bg-cyan-500 hover:bg-cyan-600",
  9: "bg-purple-500 hover:bg-purple-600",
  10: "bg-yellow-500 hover:bg-yellow-600",
};

const levelSizes = {
  sm: "text-xs px-2 py-1",
  md: "text-sm px-3 py-1",
  lg: "text-base px-4 py-2",
};

export function LevelBadge({ level, title, className, size = "md" }: LevelBadgeProps) {
  const Icon = levelIcons[level as keyof typeof levelIcons] || Baby;
  const colorClass = levelColors[level as keyof typeof levelColors] || "bg-gray-500 hover:bg-gray-600";
  const sizeClass = levelSizes[size];

  return (
    <Badge 
      className={cn(
        "flex items-center gap-1 font-semibold text-white",
        colorClass,
        sizeClass,
        className
      )}
    >
      <Icon className="w-3 h-3" />
      <span>Lv.{level}</span>
      {title && <span className="ml-1">({title})</span>}
    </Badge>
  );
}

