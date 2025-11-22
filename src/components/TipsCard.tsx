import { AlertCircle, CheckCircle2, XCircle } from "lucide-react";

interface Tip {
  type: "mistake" | "tip";
  text: string;
}

interface TipsCardProps {
  tips: Tip[];
}

export const TipsCard = ({ tips }: TipsCardProps) => {
  return (
    <div className="bg-yellow-50 border border-yellow-200 rounded-xl p-6 my-6">
      <div className="flex items-center gap-2 mb-4">
        <AlertCircle className="w-5 h-5 text-yellow-600" />
        <h3 className="font-semibold text-lg text-foreground">자주 하는 실수 & 팁</h3>
      </div>
      <ul className="space-y-3">
        {tips.map((tip, index) => (
          <li key={index} className="flex items-start gap-3">
            {tip.type === "mistake" ? (
              <XCircle className="w-5 h-5 text-destructive flex-shrink-0 mt-0.5" />
            ) : (
              <CheckCircle2 className="w-5 h-5 text-green-500 flex-shrink-0 mt-0.5" />
            )}
            <span className="text-foreground leading-relaxed">{tip.text}</span>
          </li>
        ))}
      </ul>
    </div>
  );
};

