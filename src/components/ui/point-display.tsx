import { Badge } from "@/components/ui/badge";
import { cn } from "@/lib/utils";
import { Coins, TrendingUp, Calendar, Flame } from "lucide-react";

interface PointDisplayProps {
  points: number;
  type?: "total" | "experience" | "weekly" | "monthly" | "streak";
  className?: string;
  size?: "sm" | "md" | "lg";
  showIcon?: boolean;
}

const pointTypes = {
  total: {
    icon: Coins,
    label: "총 포인트",
    color: "bg-yellow-500 hover:bg-yellow-600",
  },
  experience: {
    icon: TrendingUp,
    label: "경험치",
    color: "bg-blue-500 hover:bg-blue-600",
  },
  weekly: {
    icon: Calendar,
    label: "이번 주",
    color: "bg-green-500 hover:bg-green-600",
  },
  monthly: {
    icon: Calendar,
    label: "이번 달",
    color: "bg-purple-500 hover:bg-purple-600",
  },
  streak: {
    icon: Flame,
    label: "연속",
    color: "bg-red-500 hover:bg-red-600",
  },
};

const pointSizes = {
  sm: "text-xs px-2 py-1",
  md: "text-sm px-3 py-1",
  lg: "text-base px-4 py-2",
};

export function PointDisplay({ 
  points, 
  type = "total", 
  className, 
  size = "md",
  showIcon = true 
}: PointDisplayProps) {
  const pointType = pointTypes[type];
  const Icon = pointType.icon;
  const sizeClass = pointSizes[size];

  return (
    <Badge 
      className={cn(
        "flex items-center gap-1 font-semibold text-white",
        pointType.color,
        sizeClass,
        className
      )}
    >
      {showIcon && <Icon className="w-3 h-3" />}
      <span>{pointType.label}: {points.toLocaleString()}</span>
    </Badge>
  );
}

// 간단한 포인트 표시 (아이콘 없이)
export function SimplePointDisplay({ 
  points, 
  className, 
  size = "sm" 
}: { 
  points: number; 
  className?: string; 
  size?: "sm" | "md" | "lg"; 
}) {
  const sizeClass = pointSizes[size];

  return (
    <Badge 
      className={cn(
        "bg-yellow-500 hover:bg-yellow-600 text-white font-semibold",
        sizeClass,
        className
      )}
    >
      {points.toLocaleString()}P
    </Badge>
  );
}

