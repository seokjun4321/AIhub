import { ReactNode, useState } from "react";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Label } from "@/components/ui/label";
import { Lightbulb } from "lucide-react";

interface PracticeField {
  id: string;
  label: string;
  placeholder: string;
}

interface PracticeCardProps {
  title?: string;
  fields: PracticeField[];
  onGenerate?: (values: Record<string, string>) => string;
  children?: ReactNode;
}

export const PracticeCard = ({
  title = "내 프롬프트 설계해보기",
  fields,
  onGenerate,
  children,
}: PracticeCardProps) => {
  const [values, setValues] = useState<Record<string, string>>({});
  const [showPreview, setShowPreview] = useState(false);

  const handleGenerate = () => {
    setShowPreview(true);
  };

  const generatedPrompt = onGenerate ? onGenerate(values) : Object.values(values).filter(Boolean).join("\n\n");

  return (
    <div className="bg-blue-50 border-2 border-blue-200 rounded-xl p-6 my-6">
      <div className="flex items-center gap-2 mb-4">
        <Lightbulb className="w-5 h-5 text-blue-600" />
        <h3 className="font-semibold text-lg text-foreground">{title}</h3>
      </div>

      {children || (
        <div className="space-y-4">
          {fields.map((field) => (
            <div key={field.id} className="space-y-2">
              <Label htmlFor={field.id} className="text-foreground font-medium">
                {field.label}
              </Label>
              <Textarea
                id={field.id}
                placeholder={field.placeholder}
                value={values[field.id] || ""}
                onChange={(e) =>
                  setValues({ ...values, [field.id]: e.target.value })
                }
                className="min-h-[80px] bg-white border-border focus:border-blue-500"
              />
            </div>
          ))}

          <Button
            onClick={handleGenerate}
            className="w-full bg-blue-600 text-white hover:bg-blue-700"
          >
            프롬프트 미리보기
          </Button>

          {showPreview && generatedPrompt && (
            <div className="mt-4 p-4 bg-white rounded-lg border border-blue-200">
              <h4 className="font-semibold mb-2 text-sm text-foreground">생성된 프롬프트:</h4>
              <pre className="text-sm whitespace-pre-wrap text-foreground leading-relaxed">
                {generatedPrompt}
              </pre>
            </div>
          )}
        </div>
      )}
    </div>
  );
};

