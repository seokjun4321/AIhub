import { useState, useEffect } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { supabase } from '@/integrations/supabase/client';
import { useAuth } from '@/hooks/useAuth';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { 
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { ScrollArea } from '@/components/ui/scroll-area';
import { Bell, BellRing, MessageSquare, AtSign, CheckCircle } from 'lucide-react';
import { Link, useNavigate } from 'react-router-dom';
import { formatDistanceToNow } from 'date-fns';
import { ko } from 'date-fns/locale';
import { cn } from '@/lib/utils';

interface Notification {
  id: number;
  type: string;
  title: string;
  message: string;
  target_type: string;
  target_id: number;
  is_read: boolean;
  created_at: string;
  mention_id?: number;
}

// 알림 조회
const fetchNotifications = async (userId: string) => {
  const { data, error } = await supabase
    .from('notifications')
    .select('*')
    .eq('user_id', userId)
    .order('created_at', { ascending: false })
    .limit(20);

  if (error) throw new Error(error.message);
  return data as Notification[];
};

// 알림 읽음 처리
const markAsRead = async (notificationId: number) => {
  const { error } = await supabase
    .from('notifications')
    .update({ is_read: true })
    .eq('id', notificationId);

  if (error) throw new Error(error.message);
};

// 모든 알림 읽음 처리
const markAllAsRead = async (userId: string) => {
  const { error } = await supabase
    .from('notifications')
    .update({ is_read: true })
    .eq('user_id', userId)
    .eq('is_read', false);

  if (error) throw new Error(error.message);
};

export const NotificationDropdown = () => {
  const { user } = useAuth();
  const queryClient = useQueryClient();
  const navigate = useNavigate();
  const [isOpen, setIsOpen] = useState(false);

  const { data: notifications = [], isLoading } = useQuery({
    queryKey: ['notifications', user?.id],
    queryFn: () => fetchNotifications(user!.id),
    enabled: !!user,
    refetchInterval: 30000, // 30초마다 새로고침
  });

  const markAsReadMutation = useMutation({
    mutationFn: markAsRead,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['notifications', user?.id] });
    },
  });

  const markAllAsReadMutation = useMutation({
    mutationFn: () => markAllAsRead(user!.id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['notifications', user?.id] });
    },
  });

  // 실시간 알림 구독
  useEffect(() => {
    if (!user) return;

    const channel = supabase
      .channel(`notifications-${user.id}`)
      .on(
        'postgres_changes',
        {
          event: 'INSERT',
          schema: 'public',
          table: 'notifications',
          filter: `user_id=eq.${user.id}`,
        },
        () => {
          queryClient.invalidateQueries({ queryKey: ['notifications', user.id] });
        }
      )
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, [user, queryClient]);

  const unreadCount = notifications.filter(n => !n.is_read).length;

  const getNotificationIcon = (type: string) => {
    switch (type) {
      case 'mention':
        return <AtSign className="w-4 h-4 text-blue-500" />;
      case 'comment':
        return <MessageSquare className="w-4 h-4 text-green-500" />;
      case 'vote':
        return <CheckCircle className="w-4 h-4 text-purple-500" />;
      case 'accepted_answer':
        return <CheckCircle className="w-4 h-4 text-yellow-500" />;
      default:
        return <Bell className="w-4 h-4 text-gray-500" />;
    }
  };

  // 유튜브/인스타그램 스타일의 간결한 알림 텍스트 생성
  const getFormattedNotificationText = (notification: Notification) => {
    switch (notification.type) {
      case 'mention':
        // "@username님이 회원님을 언급했습니다"
        return `${extractUsernameFromMessage(notification.message)}님이 회원님을 언급했습니다`;
      
      case 'comment':
        // "username님이 댓글을 남겼습니다"
        return `${extractUsernameFromMessage(notification.message)}님이 댓글을 남겼습니다`;
      
      case 'vote':
        // "username님이 회원님의 게시물을 좋아합니다"
        return `${extractUsernameFromMessage(notification.message)}님이 회원님의 게시물을 좋아합니다`;
      
      case 'accepted_answer':
        // "회원님의 답변이 채택되었습니다"
        return "회원님의 답변이 채택되었습니다";
      
      default:
        // 기본적으로 title 사용, 길면 축약
        return notification.title.length > 30 
          ? `${notification.title.substring(0, 30)}...`
          : notification.title;
    }
  };

  // 메시지에서 사용자명 추출 (임시 함수, 실제로는 알림 생성 시 사용자명을 별도로 저장하는 것이 좋음)
  const extractUsernameFromMessage = (message: string): string => {
    // 메시지에서 사용자명을 추출하는 로직
    // 예: "mark0618님의 게시글 'AIhub 어떻게 생각?' 에 새로운 댓글이 달렸습니다. adadadadadsd"
    const usernameMatch = message.match(/^([^님]+)님/);
    return usernameMatch ? usernameMatch[1] : "알 수 없는 사용자";
  };

  const handleNotificationClick = async (notification: Notification) => {
    console.log('🔔 Notification clicked:', notification); // 디버깅용
    console.log('🔔 Notification type:', notification.type);
    console.log('🔔 Target ID:', notification.target_id);
    console.log('🔔 Mention ID:', notification.mention_id);
    
    if (!notification.is_read) {
      markAsReadMutation.mutate(notification.id);
    }
    setIsOpen(false);
    
    try {
      // 멘션 알림의 경우 mention_id로 댓글/게시글을 찾아 정확히 이동
      if (notification.mention_id) {
        console.log('🔍 Processing mention notification...');
        const { data: mention, error } = await supabase
          .from('mentions')
          .select('comment_id, post_id')
          .eq('id', notification.mention_id)
          .single();
        console.log('🔍 Mention data:', mention, 'Error:', error);
        if (!error && mention?.post_id) {
          const postId = Number(mention.post_id);
          const commentId = mention.comment_id ? Number(mention.comment_id) : undefined;
          console.log('🔍 Navigating to post:', postId, 'comment:', commentId);
          if (commentId) {
            navigate(`/community/${postId}?highlightComment=${commentId}`);
            return;
          }
          navigate(`/community/${postId}`);
          return;
        }
      }

      // 일반 댓글 알림: target_id가 게시글 ID라고 가정하고 이동
      const targetId = notification.target_id;
      console.log('🔍 Processing regular notification, target_id:', targetId);
      if (targetId) {
        const postId = Number(targetId);
        console.log('🔍 Parsed post ID:', postId);
        if (!isNaN(postId) && postId > 0) {
          console.log('✅ Navigating to post:', postId);
          navigate(`/community/${postId}`);
          return;
        }
      }
      console.log('❌ No valid navigation target found');
    } catch (err) {
      console.error('Notification navigation error:', err);
    }
  };

  if (!user) return null;

  return (
    <DropdownMenu open={isOpen} onOpenChange={setIsOpen} modal={false}>
      <DropdownMenuTrigger asChild>
        <Button variant="ghost" size="icon" className="relative">
          {unreadCount > 0 ? (
            <BellRing className="w-5 h-5" />
          ) : (
            <Bell className="w-5 h-5" />
          )}
          {unreadCount > 0 && (
            <Badge 
              variant="destructive" 
              className="absolute -top-1 -right-1 h-5 w-5 flex items-center justify-center p-0 text-xs"
            >
              {unreadCount > 99 ? '99+' : unreadCount}
            </Badge>
          )}
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent 
        align="end" 
        className="w-80" 
        side="bottom" 
        sideOffset={5}
        avoidCollisions={true}
      >
        <DropdownMenuLabel className="flex items-center justify-between">
          <span>알림</span>
          {unreadCount > 0 && (
            <Button
              variant="ghost"
              size="sm"
              onClick={() => markAllAsReadMutation.mutate()}
              className="h-auto p-1 text-xs"
            >
              모두 읽음
            </Button>
          )}
        </DropdownMenuLabel>
        <DropdownMenuSeparator />
        
        <ScrollArea className="h-96">
          {isLoading ? (
            <div className="p-4 text-center text-muted-foreground">
              로딩 중...
            </div>
          ) : notifications.length === 0 ? (
            <div className="p-4 text-center text-muted-foreground">
              새로운 알림이 없습니다
            </div>
          ) : (
            notifications.map((notification) => (
              <DropdownMenuItem 
                key={notification.id}
                className={cn(
                  "flex items-start gap-3 p-3 cursor-pointer transition-colors",
                  !notification.is_read && "bg-blue-50 dark:bg-blue-950/50"
                )}
                onClick={() => handleNotificationClick(notification)}
              >
                <div className="flex-shrink-0 mt-1">
                  {getNotificationIcon(notification.type)}
                </div>
                <div className="flex-1 min-w-0">
                  <p className={cn(
                    "text-sm line-clamp-2",
                    !notification.is_read ? "font-semibold text-foreground" : "font-medium text-muted-foreground"
                  )}>
                    {getFormattedNotificationText(notification)}
                  </p>
                  <p className="text-xs text-muted-foreground mt-1">
                    {formatDistanceToNow(new Date(notification.created_at), { 
                      addSuffix: true, 
                      locale: ko 
                    })}
                  </p>
                </div>
                {!notification.is_read && (
                  <div className="w-2 h-2 bg-blue-500 rounded-full flex-shrink-0 mt-2" />
                )}
              </DropdownMenuItem>
            ))
          )}
        </ScrollArea>
      </DropdownMenuContent>
    </DropdownMenu>
  );
};
