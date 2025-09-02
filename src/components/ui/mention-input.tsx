import { useState, useRef, useEffect } from 'react';
import { searchUsers } from '@/lib/mentions';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Textarea } from '@/components/ui/textarea';
import { cn } from '@/lib/utils';

interface MentionSuggestion {
  id: string;
  username: string;
  avatar_url?: string;
}

interface MentionInputProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  className?: string;
  disabled?: boolean;
  maxLength?: number;
}

export const MentionInput = ({
  value,
  onChange,
  placeholder = "내용을 입력하세요... (@사용자명으로 멘션 가능)",
  className,
  disabled,
  maxLength
}: MentionInputProps) => {
  const [suggestions, setSuggestions] = useState<MentionSuggestion[]>([]);
  const [showSuggestions, setShowSuggestions] = useState(false);
  const [selectedIndex, setSelectedIndex] = useState(0);
  const [cursorPosition, setCursorPosition] = useState(0);
  const [mentionStart, setMentionStart] = useState(-1);
  const [mentionQuery, setMentionQuery] = useState('');

  const textareaRef = useRef<HTMLTextAreaElement>(null);
  const suggestionsRef = useRef<HTMLDivElement>(null);

  // 멘션 입력 감지 및 자동완성 처리
  const checkForMention = () => {
    const textarea = textareaRef.current;
    if (!textarea) return;

    const text = textarea.value;
    const cursor = textarea.selectionStart;
    
    // 현재 커서 위치에서 역방향으로 @ 찾기
    let start = cursor - 1;
    while (start >= 0 && text[start] !== '@' && text[start] !== ' ' && text[start] !== '\n') {
      start--;
    }

    if (start >= 0 && text[start] === '@') {
      const query = text.slice(start + 1, cursor);
      if (query.length >= 0 && !query.includes(' ') && !query.includes('\n')) {
        setMentionStart(start);
        setMentionQuery(query);
        setCursorPosition(cursor);
        
        // 사용자 검색
        if (query.length >= 1) {
          searchUsers(query).then(users => {
            setSuggestions(users);
            setShowSuggestions(users.length > 0);
            setSelectedIndex(0);
          });
        } else {
          setSuggestions([]);
          setShowSuggestions(false);
        }
      } else {
        setShowSuggestions(false);
      }
    } else {
      setShowSuggestions(false);
    }
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    onChange(e.target.value);
    // 입력 후 멘션 체크
    setTimeout(checkForMention, 0);
  };

  const handleKeyDown = (e: React.KeyboardEvent<HTMLTextAreaElement>) => {
    if (!showSuggestions) return;

    switch (e.key) {
      case 'ArrowDown':
        e.preventDefault();
        setSelectedIndex(prev => (prev + 1) % suggestions.length);
        break;
      case 'ArrowUp':
        e.preventDefault();
        setSelectedIndex(prev => (prev - 1 + suggestions.length) % suggestions.length);
        break;
      case 'Enter':
      case 'Tab':
        if (suggestions.length > 0) {
          e.preventDefault();
          selectSuggestion(suggestions[selectedIndex]);
        }
        break;
      case 'Escape':
        e.preventDefault();
        setShowSuggestions(false);
        break;
    }
  };

  const selectSuggestion = (suggestion: MentionSuggestion) => {
    const textarea = textareaRef.current;
    if (!textarea || mentionStart === -1) return;

    const newText = 
      value.slice(0, mentionStart) + 
      `@${suggestion.username} ` + 
      value.slice(cursorPosition);
    
    onChange(newText);
    setShowSuggestions(false);
    
    // 커서를 멘션 뒤로 이동
    setTimeout(() => {
      const newCursorPosition = mentionStart + suggestion.username.length + 2;
      textarea.setSelectionRange(newCursorPosition, newCursorPosition);
      textarea.focus();
    }, 0);
  };

  return (
    <div className="relative">
      <Textarea
        ref={textareaRef}
        value={value}
        onChange={handleInputChange}
        onKeyDown={handleKeyDown}
        placeholder={placeholder}
        className={cn("min-h-[100px] resize-none", className)}
        disabled={disabled}
        maxLength={maxLength}
      />
      
      {showSuggestions && suggestions.length > 0 && (
        <div
          ref={suggestionsRef}
          className="absolute z-50 w-full mt-1 bg-background border rounded-md shadow-lg max-h-40 overflow-y-auto"
        >
          {suggestions.map((suggestion, index) => (
            <div
              key={suggestion.id}
              className={cn(
                "flex items-center gap-2 px-3 py-2 cursor-pointer transition-colors",
                index === selectedIndex ? "bg-accent" : "hover:bg-accent/50"
              )}
              onClick={() => selectSuggestion(suggestion)}
            >
              <Avatar className="h-6 w-6">
                <AvatarImage src={suggestion.avatar_url} alt={suggestion.username} />
                <AvatarFallback className="text-xs">
                  {suggestion.username.charAt(0).toUpperCase()}
                </AvatarFallback>
              </Avatar>
              <span className="text-sm font-medium">@{suggestion.username}</span>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};
