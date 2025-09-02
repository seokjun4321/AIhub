import { supabase } from '@/integrations/supabase/client';

// 멘션 패턴 정규식 (@username 형태)
const MENTION_REGEX = /@([a-zA-Z0-9_]+)/g;

// 텍스트에서 멘션 추출
export function extractMentions(text: string): string[] {
  const mentions = text.match(MENTION_REGEX);
  return mentions ? mentions.map(mention => mention.slice(1)) : []; // @ 제거
}

// 멘션된 사용자들의 ID 조회
export async function getMentionedUserIds(usernames: string[]): Promise<{ username: string; id: string }[]> {
  if (usernames.length === 0) return [];

  const { data, error } = await supabase
    .from('profiles')
    .select('id, username')
    .in('username', usernames);

  if (error) {
    console.error('Error fetching mentioned users:', error);
    return [];
  }

  return data || [];
}

// 멘션 데이터 저장
export async function saveMentions(
  mentionerUserId: string,
  mentionedUserIds: string[],
  postId?: number,
  commentId?: number
): Promise<void> {
  if (mentionedUserIds.length === 0) return;

  const mentionsData = mentionedUserIds.map(mentionedId => ({
    mentioner_id: mentionerUserId,
    mentioned_id: mentionedId,
    post_id: postId || null,
    comment_id: commentId || null,
  }));

  const { error } = await supabase
    .from('mentions')
    .insert(mentionsData);

  if (error) {
    console.error('Error saving mentions:', error);
  }
}

// 사용자명 검색 (자동완성용)
export async function searchUsers(query: string, limit: number = 5): Promise<{ id: string; username: string; avatar_url?: string }[]> {
  if (query.length < 2) return [];

  const { data, error } = await supabase
    .from('profiles')
    .select('id, username, avatar_url')
    .ilike('username', `%${query}%`)
    .limit(limit)
    .order('username');

  if (error) {
    console.error('Error searching users:', error);
    return [];
  }

  return data || [];
}

// 텍스트에서 멘션을 HTML 링크로 변환
export function renderMentionsAsLinks(text: string): string {
  return text.replace(MENTION_REGEX, (match, username) => {
    return `<span class="mention-link text-primary font-medium hover:underline cursor-pointer" data-username="${username}">@${username}</span>`;
  });
}

// 멘션 처리 통합 함수
export async function processMentions(
  text: string,
  mentionerUserId: string,
  postId?: number,
  commentId?: number
): Promise<void> {
  const mentionedUsernames = extractMentions(text);
  if (mentionedUsernames.length === 0) return;

  const mentionedUsers = await getMentionedUserIds(mentionedUsernames);
  const mentionedUserIds = mentionedUsers.map(user => user.id);

  await saveMentions(mentionerUserId, mentionedUserIds, postId, commentId);
}

