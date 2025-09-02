import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "./useAuth";
import { toast } from "sonner";

// 포인트 적립 함수
export const addPoints = async (
  userId: string,
  actionType: string,
  points: number,
  description?: string,
  targetType?: string,
  targetId?: number,
  targetUserId?: string
) => {
  console.log('🔄 addPoints RPC 호출:', { userId, actionType, points, description, targetType, targetId, targetUserId });
  
  // targetUserId가 있으면 해당 사용자에게 포인트 적립, 없으면 현재 사용자에게
  const actualUserId = targetUserId || userId;
  
  const { data, error } = await supabase.rpc('add_points_to_user', {
    p_user_id: actualUserId,
    p_action_type: actionType,
    p_points: points,
    p_description: description,
    p_target_type: targetType,
    p_target_id: targetId
  });

  if (error) {
    console.error('❌ addPoints RPC 오류:', error);
    throw error;
  }

  console.log('✅ addPoints RPC 성공:', data);
  return data;
};

// 포인트 이력 조회
export const fetchPointHistory = async (userId: string) => {
  const { data, error } = await supabase
    .from('point_history')
    .select('*')
    .eq('user_id', userId)
    .order('created_at', { ascending: false })
    .limit(50);

  if (error) {
    throw error;
  }

  return data;
};

// 레벨 설정 조회
export const fetchLevelConfig = async () => {
  const { data, error } = await supabase
    .from('level_config')
    .select('*')
    .order('level', { ascending: true });

  if (error) {
    throw error;
  }

  return data;
};

// 업적 조회
export const fetchAchievements = async (userId: string) => {
  // 모든 업적 조회
  const { data: allAchievements, error: achievementsError } = await supabase
    .from('achievements')
    .select('*')
    .order('requirement_value', { ascending: true });

  if (achievementsError) {
    throw achievementsError;
  }

  // 사용자가 달성한 업적 조회
  const { data: userAchievements, error: userAchievementsError } = await supabase
    .from('user_achievements')
    .select(`
      achievement_id,
      earned_at,
      achievements (*)
    `)
    .eq('user_id', userId);

  if (userAchievementsError) {
    throw userAchievementsError;
  }

  // 업적과 달성 여부 결합
  const achievementsWithEarned = allAchievements.map(achievement => {
    const userAchievement = userAchievements.find(ua => ua.achievement_id === achievement.id);
    return {
      ...achievement,
      earned: !!userAchievement,
      earned_at: userAchievement?.earned_at
    };
  });

  return achievementsWithEarned;
};

// 포인트 규칙 조회
export const fetchPointRules = async () => {
  const { data, error } = await supabase
    .from('point_rules')
    .select('*')
    .eq('is_active', true)
    .order('points', { ascending: false });

  if (error) {
    throw error;
  }

  return data;
};

export function usePoints() {
  const { user } = useAuth();
  const queryClient = useQueryClient();

  // 포인트 적립 뮤테이션
  const addPointsMutation = useMutation({
    mutationFn: ({ actionType, points, description, targetType, targetId }: {
      actionType: string;
      points: number;
      description?: string;
      targetType?: string;
      targetId?: number;
    }) => {
      console.log('🔄 addPointsMutation 실행:', { actionType, points, description, targetType, targetId });
      if (!user?.id) throw new Error('사용자가 로그인되지 않았습니다.');
      return addPoints(user.id, actionType, points, description, targetType, targetId);
    },
    onSuccess: (data, variables) => {
      // 성공 시 관련 쿼리 무효화
      queryClient.invalidateQueries({ queryKey: ['profile', user?.id] });
      queryClient.invalidateQueries({ queryKey: ['pointHistory', user?.id] });
      queryClient.invalidateQueries({ queryKey: ['achievements', user?.id] });
      
      // 성공 메시지 표시
      if (variables.points > 0) {
        toast.success(`+${variables.points} 포인트 획득!`, {
          description: variables.description || '활동에 대한 보상입니다.'
        });
      }
    },
    onError: (error) => {
      console.error('포인트 적립 실패:', error);
      toast.error('포인트 적립에 실패했습니다.');
    }
  });

  // 포인트 이력 조회
  const pointHistoryQuery = useQuery({
    queryKey: ['pointHistory', user?.id],
    queryFn: () => {
      if (!user?.id) throw new Error('사용자가 로그인되지 않았습니다.');
      return fetchPointHistory(user.id);
    },
    enabled: !!user?.id
  });

  // 레벨 설정 조회
  const levelConfigQuery = useQuery({
    queryKey: ['levelConfig'],
    queryFn: fetchLevelConfig
  });

  // 업적 조회
  const achievementsQuery = useQuery({
    queryKey: ['achievements', user?.id],
    queryFn: () => {
      if (!user?.id) throw new Error('사용자가 로그인되지 않았습니다.');
      return fetchAchievements(user.id);
    },
    enabled: !!user?.id
  });

  // 포인트 규칙 조회
  const pointRulesQuery = useQuery({
    queryKey: ['pointRules'],
    queryFn: fetchPointRules
  });

  // 현재 레벨 정보 계산
  const getCurrentLevelInfo = () => {
    if (!levelConfigQuery.data || !user) return null;

    const userLevel = user.level || 1;
    const userExp = user.experience_points || 0;
    
    const currentLevelConfig = levelConfigQuery.data.find(lc => lc.level === userLevel);
    const nextLevelConfig = levelConfigQuery.data.find(lc => lc.level === userLevel + 1);

    return {
      currentLevel: userLevel,
      currentExp: userExp,
      currentLevelConfig,
      nextLevelConfig,
      nextLevelRequiredExp: nextLevelConfig?.min_experience || 0
    };
  };

  // 포인트 적립 헬퍼 함수들
  const addPointsForPost = (postId: number) => {
    addPointsMutation.mutate({
      actionType: 'post_created',
      points: 10,
      description: '게시글 작성',
      targetType: 'post',
      targetId: postId
    });
  };

  const addPointsForComment = (commentId: number) => {
    console.log('🔄 addPointsForComment 호출됨:', commentId);
    addPointsMutation.mutate({
      actionType: 'comment_added',
      points: 3,
      description: '댓글 작성',
      targetType: 'comment',
      targetId: commentId
    });
  };

  const addPointsForVote = (targetType: 'post' | 'comment', targetId: number) => {
    const points = targetType === 'post' ? 2 : 1;
    const description = targetType === 'post' ? '게시글 추천받음' : '댓글 추천받음';
    
    addPointsMutation.mutate({
      actionType: `${targetType}_upvoted`,
      points,
      description,
      targetType,
      targetId
    });
  };

  const addPointsForAcceptedAnswer = (commentId: number, answerAuthorId: string) => {
    addPointsMutation.mutate({
      actionType: 'answer_accepted',
      points: 15,
      description: '답변 채택됨',
      targetType: 'comment',
      targetId: commentId,
      targetUserId: answerAuthorId // 답변 작성자에게 포인트 적립
    });
  };

  const addPointsForDailyLogin = () => {
    addPointsMutation.mutate({
      actionType: 'daily_login',
      points: 1,
      description: '일일 로그인'
    });
  };

  return {
    // 뮤테이션
    addPointsMutation,
    
    // 쿼리들
    pointHistoryQuery,
    levelConfigQuery,
    achievementsQuery,
    pointRulesQuery,
    
    // 헬퍼 함수들
    getCurrentLevelInfo,
    addPointsForPost,
    addPointsForComment,
    addPointsForVote,
    addPointsForAcceptedAnswer,
    addPointsForDailyLogin,
    
    // 상태
    isLoading: addPointsMutation.isPending,
    isError: addPointsMutation.isError
  };
}
