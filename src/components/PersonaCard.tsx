import { Card } from "@/components/ui/card";
import { cn } from "@/lib/utils";

interface PersonaCardProps {
  name: string;
  points: string[];
  prompt: string;
  isSelected: boolean;
  onClick: () => void;
}

export const PersonaCard = ({
  name,
  points,
  prompt,
  isSelected,
  onClick,
}: PersonaCardProps) => {
  return (
    <Card
      className={cn(
        "p-4 cursor-pointer transition-all duration-200 hover:shadow-lg",
        isSelected
          ? "ring-2 ring-primary shadow-md"
          : "hover:ring-1 hover:ring-border"
      )}
      onClick={onClick}
    >
      <h4 className="font-semibold text-foreground mb-3">{name}</h4>
      <ul className="space-y-2">
        {points.map((point, index) => (
          <li key={index} className="text-sm text-muted-foreground flex items-start gap-2">
            <span className="text-primary mt-1">•</span>
            <span>{point}</span>
          </li>
        ))}
      </ul>
    </Card>
  );
};

