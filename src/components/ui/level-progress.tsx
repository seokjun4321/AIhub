import { Progress } from "@/components/ui/progress";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { LevelBadge } from "@/components/ui/level-badge";
import { PointDisplay } from "@/components/ui/point-display";
import { cn } from "@/lib/utils";
import { TrendingUp, Star, Zap, Crown } from "lucide-react";

interface LevelProgressProps {
  currentLevel: number;
  currentExp: number;
  nextLevelExp?: number;
  levelTitle?: string;
  className?: string;
}

export function LevelProgress({ 
  currentLevel, 
  currentExp, 
  nextLevelExp, 
  levelTitle,
  className 
}: LevelProgressProps) {
  // 현재 레벨의 최소 경험치 계산 (레벨 1: 0, 레벨 2: 100, 레벨 3: 200, ...)
  const currentLevelMinExp = (currentLevel - 1) * 100;
  const nextLevelRequiredExp = nextLevelExp || currentLevel * 100;
  
  // 현재 레벨에서의 진행률 계산
  const progress = nextLevelRequiredExp > currentLevelMinExp 
    ? ((currentExp - currentLevelMinExp) / (nextLevelRequiredExp - currentLevelMinExp)) * 100
    : 100;
  
  // progress가 100을 초과하지 않도록 제한
  const clampedProgress = Math.min(progress, 100);

  // 레벨에 따른 스타일 결정
  const getLevelStyle = (level: number) => {
    if (level >= 10) {
      return {
        gradient: "from-yellow-500 to-orange-600",
        icon: Crown,
        iconColor: "text-yellow-300"
      };
    } else if (level >= 5) {
      return {
        gradient: "from-purple-500 to-pink-600",
        icon: Zap,
        iconColor: "text-purple-300"
      };
    } else {
      return {
        gradient: "from-blue-500 to-purple-600",
        icon: Star,
        iconColor: "text-blue-300"
      };
    }
  };

  const levelStyle = getLevelStyle(currentLevel);
  const IconComponent = levelStyle.icon;

  return (
    <Card className={className}>
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <TrendingUp className="w-5 h-5 text-blue-500" />
          레벨 진행률
        </CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="flex items-center justify-between">
          <div className={`bg-gradient-to-r ${levelStyle.gradient} text-white px-4 py-2 rounded-full text-lg font-semibold shadow-lg flex items-center gap-2 border border-white/20`}>
            <IconComponent className={`w-5 h-5 ${levelStyle.iconColor}`} />
            <span>Lv.{currentLevel}</span>
            {levelTitle && <span className="text-sm opacity-90">({levelTitle})</span>}
          </div>
          <div className="text-right">
            <p className="text-sm text-gray-600">다음 레벨까지</p>
            <p className="text-lg font-bold text-blue-600">
              {Math.max(0, nextLevelRequiredExp - currentExp)} EXP
            </p>
          </div>
        </div>
        
        <div className="space-y-2">
          <div className="flex justify-between text-sm">
            <span className="text-gray-600">경험치</span>
            <span className="font-medium">
              {currentExp.toLocaleString()} / {nextLevelRequiredExp.toLocaleString()}
            </span>
          </div>
          <Progress value={clampedProgress} className="h-3" />
        </div>

        <div className="flex items-center gap-4 text-sm">
          <PointDisplay 
            points={currentExp} 
            type="experience" 
            size="sm" 
            showIcon={false}
          />
          <div className="flex items-center gap-1 text-gray-600">
            <Star className="w-4 h-4 text-yellow-500" />
            <span>진행률: {Math.round(clampedProgress)}%</span>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

// 간단한 레벨 진행률 (작은 크기)
interface SimpleLevelProgressProps {
  currentLevel: number;
  currentExp: number;
  nextLevelExp?: number;
  className?: string;
}

export function SimpleLevelProgress({ 
  currentLevel, 
  currentExp, 
  nextLevelExp,
  className 
}: SimpleLevelProgressProps) {
  // 현재 레벨의 최소 경험치 계산 (레벨 1: 0, 레벨 2: 100, 레벨 3: 200, ...)
  const currentLevelMinExp = (currentLevel - 1) * 100;
  const nextLevelRequiredExp = nextLevelExp || currentLevel * 100;
  
  // 현재 레벨에서의 진행률 계산
  const progress = nextLevelRequiredExp > currentLevelMinExp 
    ? ((currentExp - currentLevelMinExp) / (nextLevelRequiredExp - currentLevelMinExp)) * 100
    : 100;
  
  // progress가 100을 초과하지 않도록 제한
  const clampedProgress = Math.min(progress, 100);
  


  // 레벨에 따른 스타일 결정
  const getLevelStyle = (level: number) => {
    if (level >= 10) {
      return {
        gradient: "from-yellow-500 to-orange-600",
        icon: Crown,
        iconColor: "text-yellow-300"
      };
    } else if (level >= 5) {
      return {
        gradient: "from-purple-500 to-pink-600",
        icon: Zap,
        iconColor: "text-purple-300"
      };
    } else {
      return {
        gradient: "from-blue-500 to-purple-600",
        icon: Star,
        iconColor: "text-blue-300"
      };
    }
  };

  const levelStyle = getLevelStyle(currentLevel);
  const IconComponent = levelStyle.icon;

  return (
    <div className={cn("space-y-2", className)}>
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <div className={`bg-gradient-to-r ${levelStyle.gradient} text-white px-3 py-1 rounded-full text-sm font-semibold shadow-lg flex items-center gap-1.5 border border-white/20`}>
            <IconComponent className={`w-3 h-3 ${levelStyle.iconColor}`} />
            <span>Lv.{currentLevel}</span>
          </div>
        </div>
        <span className="text-sm text-gray-600">
          {currentExp.toLocaleString()} / {nextLevelRequiredExp.toLocaleString()} EXP
        </span>
      </div>
      {/* Progress 컴포넌트 대신 직접 div로 구현 */}
      <div className="w-full bg-gray-200 rounded-full h-2">
        <div 
          className="bg-blue-600 h-2 rounded-full transition-all duration-300"
          style={{ width: `${clampedProgress}%` }}
        />
      </div>
    </div>
  );
}
