import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Checkbox } from "@/components/ui/checkbox";
import { Label } from "@/components/ui/label";
import { CheckCircle2 } from "lucide-react";
import { useState, useEffect } from "react";
import { useToast } from "@/hooks/use-toast";
import { useAuth } from "@/hooks/useAuth";
import { supabase } from "@/integrations/supabase/client";

interface WorkbookField {
  id: number;
  field_key: string;
  field_type: string;
  label: string;
  placeholder: string | null;
}

interface WorkbookPanelProps {
  fields: WorkbookField[];
  stepId: number;
  guideId: number;
}

export function WorkbookPanel({ fields, stepId, guideId }: WorkbookPanelProps) {
  const { toast } = useToast();
  const { user } = useAuth();
  const [formData, setFormData] = useState<Record<string, any>>({});
  const [isComplete, setIsComplete] = useState(false);

  // Supabase에서 데이터 로드
  useEffect(() => {
    if (user) {
      supabase
        .from('guide_progress')
        .select('workbook_data, completed')
        .eq('user_id', user.id)
        .eq('step_id', stepId)
        .single()
        .then(({ data }) => {
          if (data) {
            setFormData(data.workbook_data || {});
            setIsComplete(data.completed || false);
          }
        });
    }
  }, [user, stepId]);

  // Supabase에 저장
  const saveData = async (data: Record<string, any>, complete: boolean) => {
    if (!user) {
      toast({
        title: "로그인이 필요합니다",
        description: "워크북을 저장하려면 로그인해주세요",
      });
      return;
    }

    const { error } = await supabase
      .from('guide_progress')
      .upsert({
        user_id: user.id,
        guide_id: guideId,
        step_id: stepId,
        workbook_data: data,
        completed: complete,
        completed_at: complete ? new Date().toISOString() : null,
      }, {
        onConflict: 'user_id,step_id'
      });

    if (error) {
      toast({
        title: "저장 실패",
        description: error.message,
        variant: "destructive",
      });
    }
  };

  const handleChange = (key: string, value: any) => {
    const newData = { ...formData, [key]: value };
    setFormData(newData);
    saveData(newData, isComplete);
  };

  const handleMarkDone = async () => {
    const newComplete = !isComplete;
    setIsComplete(newComplete);
    await saveData(formData, newComplete);
    
    if (newComplete) {
      toast({
        title: "작업 완료! 🎉",
        description: "진행률이 저장되었습니다",
      });
    }
  };

  return (
    <div className="rounded-2xl border bg-card p-6 space-y-6 shadow-sm">
      <div className="flex items-center justify-between">
        <h3 className="font-semibold text-lg">📝 워크북 작업</h3>
        <Button
          variant={isComplete ? "default" : "outline"}
          size="sm"
          onClick={handleMarkDone}
          className={isComplete ? "bg-gradient-to-r from-primary to-accent" : "border-accent/50"}
        >
          {isComplete && <CheckCircle2 className="mr-2 h-4 w-4" />}
          {isComplete ? "완료됨" : "완료로 표시"}
        </Button>
      </div>

      <div className="space-y-4">
        {fields.map((field) => (
          <div key={field.id} className="space-y-2">
            <Label htmlFor={field.field_key} className="text-sm font-medium">
              {field.label}
            </Label>
            {field.field_type === "textarea" ? (
              <Textarea
                id={field.field_key}
                placeholder={field.placeholder || ""}
                value={formData[field.field_key] || ""}
                onChange={(e) => handleChange(field.field_key, e.target.value)}
                rows={4}
                className="resize-none focus-visible:ring-accent"
              />
            ) : field.field_type === "checkbox" ? (
              <div className="flex items-center space-x-2">
                <Checkbox
                  id={field.field_key}
                  checked={formData[field.field_key] || false}
                  onCheckedChange={(checked) => handleChange(field.field_key, checked)}
                  className="data-[state=checked]:bg-accent data-[state=checked]:border-accent"
                />
                <label htmlFor={field.field_key} className="text-sm text-muted-foreground cursor-pointer">
                  {field.label}
                </label>
              </div>
            ) : (
              <Input
                id={field.field_key}
                type="text"
                placeholder={field.placeholder || ""}
                value={formData[field.field_key] || ""}
                onChange={(e) => handleChange(field.field_key, e.target.value)}
                className="focus-visible:ring-accent"
              />
            )}
          </div>
        ))}
      </div>

      {isComplete && (
        <div className="rounded-lg bg-accent/10 border border-accent/20 p-4 text-sm text-accent">
          ✓ 잘하셨어요! 진행률이 자동으로 저장되었습니다.
        </div>
      )}
    </div>
  );
}

