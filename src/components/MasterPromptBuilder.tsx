import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Label } from "@/components/ui/label";
import { Checkbox } from "@/components/ui/checkbox";
import { Copy, Check, ArrowRight } from "lucide-react";
import { ExamplePromptBlock } from "./ExamplePromptBlock";
import { Link } from "react-router-dom";

export const MasterPromptBuilder = () => {
  const [copied, setCopied] = useState(false);
  const [values, setValues] = useState({
    role: "",
    context: "",
    task: "",
    format: "",
    parameters: "",
    fewShot: false,
    cot: false,
  });

  const generateMasterPrompt = () => {
    let prompt = "";

    if (values.role) {
      prompt += `# 역할 (Role)\n${values.role}\n\n`;
    }

    if (values.context) {
      prompt += `# 맥락 (Context)\n${values.context}\n\n`;
    }

    if (values.task) {
      prompt += `# 주요 임무 (Task)\n${values.task}\n\n`;
    }

    if (values.fewShot) {
      prompt += `# 예시 (Few-shot Examples)\n[여기에 입력-출력 예시를 추가하세요]\n\n`;
    }

    if (values.format) {
      prompt += `# 출력 형식 (Output Format)\n${values.format}\n\n`;
    }

    if (values.parameters) {
      prompt += `# 제약사항 및 톤 (Parameters)\n${values.parameters}\n\n`;
    }

    if (values.cot) {
      prompt += `# 사고 과정 (Chain-of-Thought)\n단계별로 생각하면서 답변해주세요. 각 단계의 근거를 명확히 제시하세요.\n\n`;
    }

    return prompt.trim() || "위 항목을 채워 마스터 프롬프트를 생성하세요.";
  };

  const handleCopy = () => {
    navigator.clipboard.writeText(generateMasterPrompt());
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <section className="bg-gradient-to-br from-primary/5 to-accent rounded-2xl p-8 my-12">
      <div className="text-center mb-8">
        <h2 className="text-3xl font-bold text-foreground mb-3">
          나만의 마스터 프롬프트 만들기
        </h2>
        <p className="text-muted-foreground text-lg">
          아래 항목을 채우면, AIHub에서 반복해서 사용할 수 있는 나만의 마스터 프롬프트가 생성됩니다.
        </p>
      </div>

      <div className="grid lg:grid-cols-2 gap-8">
        {/* Left: Form */}
        <div className="space-y-6 bg-card rounded-xl p-6 shadow-lg">
          <div className="space-y-2">
            <Label htmlFor="role" className="text-foreground font-medium">
              AI에게 맡길 역할 (Role)
            </Label>
            <Textarea
              id="role"
              placeholder="예: 당신은 10년 경력의 마케팅 전문가입니다."
              value={values.role}
              onChange={(e) => setValues({ ...values, role: e.target.value })}
              className="min-h-[80px]"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="context" className="text-foreground font-medium">
              사용자/타깃 & 맥락 (Context)
            </Label>
            <Textarea
              id="context"
              placeholder="예: 스타트업 창업자를 위한 콘텐츠를 제작합니다."
              value={values.context}
              onChange={(e) => setValues({ ...values, context: e.target.value })}
              className="min-h-[80px]"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="task" className="text-foreground font-medium">
              주요 임무 (Task)
            </Label>
            <Textarea
              id="task"
              placeholder="예: 블로그 글의 초안을 작성해주세요."
              value={values.task}
              onChange={(e) => setValues({ ...values, task: e.target.value })}
              className="min-h-[80px]"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="format" className="text-foreground font-medium">
              출력 형식 (Format)
            </Label>
            <Textarea
              id="format"
              placeholder="예: 마크다운 형식으로, 제목-본문-결론 구조로 작성하세요."
              value={values.format}
              onChange={(e) => setValues({ ...values, format: e.target.value })}
              className="min-h-[80px]"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="parameters" className="text-foreground font-medium">
              톤/제약/금지사항 (Parameters)
            </Label>
            <Textarea
              id="parameters"
              placeholder="예: 친근하고 전문적인 톤으로, 전문 용어는 쉽게 풀어 설명하세요."
              value={values.parameters}
              onChange={(e) =>
                setValues({ ...values, parameters: e.target.value })
              }
              className="min-h-[80px]"
            />
          </div>

          <div className="space-y-3 pt-2">
            <div className="flex items-center space-x-2">
              <Checkbox
                id="fewshot"
                checked={values.fewShot}
                onCheckedChange={(checked) =>
                  setValues({ ...values, fewShot: checked as boolean })
                }
              />
              <label
                htmlFor="fewshot"
                className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 cursor-pointer"
              >
                Few-shot 예시 포함하기
              </label>
            </div>

            <div className="flex items-center space-x-2">
              <Checkbox
                id="cot"
                checked={values.cot}
                onCheckedChange={(checked) =>
                  setValues({ ...values, cot: checked as boolean })
                }
              />
              <label
                htmlFor="cot"
                className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 cursor-pointer"
              >
                Chain-of-Thought 지시 포함하기
              </label>
            </div>
          </div>
        </div>

        {/* Right: Output */}
        <div className="space-y-4">
          <div className="bg-card rounded-xl p-6 shadow-lg">
            <div className="flex items-center justify-between mb-4">
              <h3 className="font-semibold text-lg text-foreground">
                완성된 마스터 프롬프트
              </h3>
              <Button
                variant="outline"
                size="sm"
                onClick={handleCopy}
                className="gap-2"
              >
                {copied ? (
                  <>
                    <Check className="w-4 h-4" />
                    복사됨
                  </>
                ) : (
                  <>
                    <Copy className="w-4 h-4" />
                    복사하기
                  </>
                )}
              </Button>
            </div>

            <pre className="bg-muted/50 text-foreground p-4 rounded-lg text-sm leading-relaxed overflow-x-auto min-h-[400px] whitespace-pre-wrap">
              {generateMasterPrompt()}
            </pre>
          </div>

          <div className="bg-accent/50 rounded-xl p-6">
            <p className="text-sm text-foreground mb-4">
              이 프롬프트를 다른 가이드북에도 적용해보세요.
            </p>
            <div className="flex flex-col sm:flex-row gap-3">
              <Button variant="outline" className="gap-2" asChild>
                <Link to="/guides">
                  글쓰기 가이드북 보러가기
                  <ArrowRight className="w-4 h-4" />
                </Link>
              </Button>
              <Button variant="outline" className="gap-2" asChild>
                <Link to="/recommend">
                  취업 가이드북 보러가기
                  <ArrowRight className="w-4 h-4" />
                </Link>
              </Button>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

