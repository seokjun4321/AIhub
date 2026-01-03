import { Button } from "@/components/ui/button";
import { Copy, ExternalLink } from "lucide-react";
import { useToast } from "@/hooks/use-toast";

interface Prompt {
  id: number;
  label: string;
  text: string;
  provider: string | null;
}

interface PromptBlockProps {
  prompt: Prompt;
  fallbackToolName?: string;
  fallbackToolUrl?: string;
}

export function PromptBlock({ prompt, fallbackToolName, fallbackToolUrl }: PromptBlockProps) {
  const { toast } = useToast();

  const handleCopy = () => {
    navigator.clipboard.writeText(prompt.text);
    toast({
      title: "프롬프트 복사됨!",
      description: prompt.provider ? `${prompt.provider}에 붙여넣으세요` : "클립보드에 복사되었습니다",
    });
  };

  const handleTryInTool = () => {
    let url = "";
    const providerToCheck = prompt.provider || fallbackToolName || "";

    // 1. Try prompt provider or fallback name
    if (providerToCheck) {
      const provider = providerToCheck.toLowerCase();
      if (provider.includes("chatgpt") || provider.includes("openai")) {
        url = "https://chat.openai.com";
      } else if (provider.includes("gemini") || provider.includes("google")) {
        url = "https://gemini.google.com";
      } else if (provider.includes("claude") || provider.includes("anthropic")) {
        url = "https://claude.ai";
      } else if (provider.includes("midjourney")) {
        url = "https://discord.com/invite/midjourney";
      } else if (provider.includes("notion")) {
        url = "https://www.notion.so";
      } else if (provider.includes("wrtn") || provider.includes("뤼튼")) {
        url = "https://wrtn.ai";
      }
    }

    // 2. Use specific fallback URL if available and no URL found yet
    if (!url && fallbackToolUrl) {
      url = fallbackToolUrl;
    }

    if (url) {
      window.open(url, "_blank");
    } else {
      toast({
        title: "도구 링크를 찾을 수 없습니다",
        description: "수동으로 AI 도구에 접속해주세요",
      });
    }
  };

  return (
    <div className="group relative rounded-2xl border bg-muted/50 p-6 transition-all hover:shadow-md">
      <div className="flex items-start justify-between gap-4 mb-4">
        <div className="space-y-1">
          <h4 className="font-semibold text-sm text-accent">{prompt.label}</h4>
          {prompt.provider && (
            <div className="text-xs text-muted-foreground">For {prompt.provider}</div>
          )}
        </div>
        <div className="flex gap-2">
          <Button
            size="sm"
            variant="ghost"
            onClick={handleCopy}
            className="hover:bg-accent/10 hover:text-accent"
          >
            <Copy className="h-4 w-4" />
          </Button>
          {prompt.provider && (
            <Button
              size="sm"
              variant="ghost"
              onClick={handleTryInTool}
              className="hover:bg-accent/10 hover:text-accent"
            >
              <ExternalLink className="h-4 w-4" />
            </Button>
          )}
        </div>
      </div>

      <pre className="font-mono text-sm whitespace-pre-wrap break-words leading-relaxed text-foreground">
        {prompt.text}
      </pre>

      <div className="mt-4 pt-4 border-t text-xs text-muted-foreground">
        💡 팁: 대괄호 [안의 내용]을 본인의 정보로 커스터마이즈하세요
      </div>
    </div>
  );
}

