import { Copy, Check } from "lucide-react";
import { useState } from "react";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

interface ExamplePromptBlockProps {
  title?: string;
  prompt: string;
  variant?: "default" | "before" | "after";
}

export const ExamplePromptBlock = ({
  title,
  prompt,
  variant = "default",
}: ExamplePromptBlockProps) => {
  const [copied, setCopied] = useState(false);

  const handleCopy = () => {
    navigator.clipboard.writeText(prompt);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const variantStyles = {
    default: "border-l-4 border-l-primary",
    before: "border-l-4 border-l-destructive",
    after: "border-l-4 border-l-green-500",
  };

  return (
    <div className={cn("relative rounded-lg overflow-hidden my-4 bg-muted/50", variantStyles[variant])}>
      {title && (
        <div className="bg-muted text-foreground px-4 py-2 text-sm font-medium flex items-center justify-between">
          <span>{title}</span>
          <Button
            variant="ghost"
            size="sm"
            onClick={handleCopy}
            className="h-6 px-2 hover:bg-muted-foreground/10"
          >
            {copied ? (
              <Check className="w-3 h-3" />
            ) : (
              <Copy className="w-3 h-3" />
            )}
          </Button>
        </div>
      )}
      <pre className="bg-muted/50 text-foreground p-4 overflow-x-auto text-sm leading-relaxed">
        <code>{prompt}</code>
      </pre>
      {!title && (
        <Button
          variant="ghost"
          size="sm"
          onClick={handleCopy}
          className="absolute top-2 right-2 h-6 px-2 bg-muted/80 hover:bg-muted text-foreground"
        >
          {copied ? (
            <Check className="w-3 h-3" />
          ) : (
            <Copy className="w-3 h-3" />
          )}
        </Button>
      )}
    </div>
  );
};

