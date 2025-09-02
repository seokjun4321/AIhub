import { Badge } from "@/components/ui/badge";
import { cn } from "@/lib/utils";
import { 
  Footprints, 
  MessageCircle, 
  Flame, 
  MessagesSquare, 
  ThumbsUp, 
  Heart, 
  Calendar, 
  Building2, 
  Award, 
  Crown,
  Star,
  Gem,
  Trophy,
  Zap,
  Moon
} from "lucide-react";

interface AchievementBadgeProps {
  name: string;
  description?: string;
  icon?: string;
  badgeColor?: string;
  pointsReward?: number;
  earned?: boolean;
  className?: string;
  size?: "sm" | "md" | "lg";
  onClick?: () => void;
}

const achievementIcons: Record<string, any> = {
  'footprints': Footprints,
  'message-circle': MessageCircle,
  'flame': Flame,
  'messages-square': MessagesSquare,
  'thumbs-up': ThumbsUp,
  'hand-heart': Heart,
  'calendar': Calendar,
  'pillar': Building2,
  'award': Award,
  'crown': Crown,
  'star': Star,
  'gem': Gem,
  'trophy': Trophy,
  'zap': Zap,
  'moon': Moon,
};

const badgeSizes = {
  sm: "text-xs px-2 py-1",
  md: "text-sm px-3 py-1",
  lg: "text-base px-4 py-2",
};

export function AchievementBadge({ 
  name, 
  description, 
  icon = "award", 
  badgeColor = "#F59E0B", 
  pointsReward = 0,
  earned = false,
  className, 
  size = "md",
  onClick 
}: AchievementBadgeProps) {
  const Icon = achievementIcons[icon] || Award;
  const sizeClass = badgeSizes[size];

  return (
    <Badge 
      className={cn(
        "flex items-center gap-1 font-semibold text-white cursor-pointer transition-all",
        earned ? "opacity-100" : "opacity-50",
        sizeClass,
        className
      )}
      style={{ backgroundColor: badgeColor }}
      onClick={onClick}
    >
      <Icon className="w-3 h-3" />
      <span>{name}</span>
      {pointsReward > 0 && <span className="ml-1">(+{pointsReward}P)</span>}
    </Badge>
  );
}

// 업적 목록 컴포넌트
interface AchievementListProps {
  achievements: Array<{
    id: number;
    name: string;
    description?: string;
    icon?: string;
    badge_color?: string;
    points_reward?: number;
    earned?: boolean;
    earned_at?: string;
  }>;
  className?: string;
}

export function AchievementList({ achievements, className }: AchievementListProps) {
  return (
    <div className={cn("grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3", className)}>
      {achievements.map((achievement) => (
        <div 
          key={achievement.id}
          className={cn(
            "p-3 rounded-lg border transition-all",
            achievement.earned 
              ? "bg-green-50 border-green-200" 
              : "bg-gray-50 border-gray-200"
          )}
        >
          <div className="flex items-center gap-2 mb-2">
            <AchievementBadge
              name={achievement.name}
              icon={achievement.icon}
              badgeColor={achievement.badge_color}
              pointsReward={achievement.points_reward}
              earned={achievement.earned}
              size="sm"
            />
          </div>
          {achievement.description && (
            <p className="text-sm text-gray-600 mb-2">{achievement.description}</p>
          )}
          {achievement.earned && achievement.earned_at && (
            <p className="text-xs text-green-600">
              달성일: {new Date(achievement.earned_at).toLocaleDateString()}
            </p>
          )}
        </div>
      ))}
    </div>
  );
}
