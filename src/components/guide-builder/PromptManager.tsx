import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Label } from "@/components/ui/label";
import { Plus, Trash2, Lightbulb, TerminalSquare, AlertTriangle } from "lucide-react";
import { GuideBlock } from "./GuideBuilderLayout";
import { PromptItem } from "@/components/guidebook/PromptPack"; // Import interface
import { Checkbox } from "@/components/ui/checkbox";

interface PromptManagerProps {
    prompts: PromptItem[];
    onChange: (prompts: PromptItem[]) => void;
    blocks: GuideBlock[]; // Needed for step linking
}

export function PromptManager({ prompts, onChange, blocks }: PromptManagerProps) {
    // Filter only Step blocks for linking
    const stepBlocks = blocks.filter(b => b.type === 'step');

    const handleAddPrompt = () => {
        const newPrompt: PromptItem = {
            id: crypto.randomUUID(),
            title: "",
            prompt: "",
            description: "",
            failurePatterns: "",
            relatedStep: []
        };
        onChange([...prompts, newPrompt]);
    };

    const handleUpdatePrompt = (id: string, field: keyof PromptItem, value: any) => {
        onChange(prompts.map(p => p.id === id ? { ...p, [field]: value } : p));
    };

    const handleDeletePrompt = (id: string) => {
        onChange(prompts.filter(p => p.id !== id));
    };

    const toggleStepLink = (promptId: string, stepIndex: number) => {
        const prompt = prompts.find(p => p.id === promptId);
        if (!prompt) return;

        const currentSteps = prompt.relatedStep || [];
        const isLinked = currentSteps.includes(stepIndex);

        let newSteps;
        if (isLinked) {
            newSteps = currentSteps.filter(s => s !== stepIndex);
        } else {
            newSteps = [...currentSteps, stepIndex].sort((a, b) => a - b);
        }

        handleUpdatePrompt(promptId, 'relatedStep', newSteps);
    };

    return (
        <div className="max-w-3xl mx-auto py-8 px-4 space-y-8 animate-in fade-in duration-500">
            <div className="text-center space-y-2 mb-8">
                <h2 className="text-2xl font-bold text-slate-900">Prompt Pack Manager</h2>
                <p className="text-slate-500">
                    가이드북에서 제공할 프롬프트들을 관리하세요.<br />
                    각 프롬프트가 어떤 Step과 관련되어 있는지 지정할 수 있습니다.
                </p>
            </div>

            {prompts.length === 0 ? (
                <div className="text-center py-16 bg-slate-50/50 border-2 border-dashed border-slate-200 rounded-3xl">
                    <TerminalSquare className="w-12 h-12 text-slate-300 mx-auto mb-4" />
                    <p className="text-slate-500 mb-6">등록된 프롬프트가 없습니다.</p>
                    <Button onClick={handleAddPrompt} className="bg-emerald-600 hover:bg-emerald-700">
                        <Plus className="w-4 h-4 mr-2" />
                        첫 번째 프롬프트 추가하기
                    </Button>
                </div>
            ) : (
                <div className="space-y-6">
                    {prompts.map((prompt, index) => (
                        <div key={prompt.id} className="bg-white rounded-2xl border border-slate-200 shadow-sm p-6 group transition-all hover:shadow-md hover:border-emerald-200">
                            <div className="flex items-start justify-between mb-6">
                                <div className="flex items-center gap-3">
                                    <span className="flex items-center justify-center w-8 h-8 rounded-full bg-emerald-100 text-emerald-700 font-bold text-sm">
                                        {index + 1}
                                    </span>
                                    <h3 className="font-bold text-lg text-slate-800">
                                        {prompt.title || "제목 없는 프롬프트"}
                                    </h3>
                                </div>
                                <Button
                                    variant="ghost"
                                    size="icon"
                                    className="text-slate-400 hover:text-red-500 hover:bg-red-50"
                                    onClick={() => handleDeletePrompt(prompt.id)}
                                >
                                    <Trash2 className="w-4 h-4" />
                                </Button>
                            </div>

                            <div className="space-y-6">
                                {/* Title Input */}
                                <div className="space-y-2">
                                    <Label>프롬프트 제목</Label>
                                    <Input
                                        placeholder="예: 시장 조사 프롬프트"
                                        value={prompt.title}
                                        onChange={(e) => handleUpdatePrompt(prompt.id, 'title', e.target.value)}
                                        className="bg-slate-50 border-slate-200 focus:bg-white transition-colors"
                                    />
                                </div>

                                {/* Main Prompt Code */}
                                <div className="space-y-2">
                                    <Label className="flex items-center gap-2">
                                        <TerminalSquare className="w-4 h-4 text-emerald-600" />
                                        프롬프트 내용
                                    </Label>
                                    <Textarea
                                        placeholder="AI에게 전달할 프롬프트 내용을 입력하세요..."
                                        className="font-mono text-sm min-h-[150px] bg-slate-900 text-slate-50 border-slate-800 focus:ring-emerald-500 placeholder:text-slate-500"
                                        value={prompt.prompt}
                                        onChange={(e) => handleUpdatePrompt(prompt.id, 'prompt', e.target.value)}
                                    />
                                </div>

                                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                                    {/* When to use */}
                                    <div className="space-y-2">
                                        <Label className="flex items-center gap-2">
                                            <Lightbulb className="w-4 h-4 text-amber-500" />
                                            언제 쓰나요? (선택)
                                        </Label>
                                        <Textarea
                                            placeholder="이 프롬프트의 사용 시점이나 목적을 설명해주세요."
                                            className="min-h-[100px] resize-none bg-amber-50/30 border-amber-100 focus:border-amber-300"
                                            value={prompt.description || ''}
                                            onChange={(e) => handleUpdatePrompt(prompt.id, 'description', e.target.value)}
                                        />
                                    </div>

                                    {/* Failure Patterns */}
                                    <div className="space-y-2">
                                        <Label className="flex items-center gap-2">
                                            <AlertTriangle className="w-4 h-4 text-red-500" />
                                            실패 패턴 & 수정 가이드 (선택)
                                        </Label>
                                        <Textarea
                                            placeholder="자주 발생하는 오류나 주의사항을 적어주세요."
                                            className="min-h-[100px] resize-none bg-red-50/30 border-red-100 focus:border-red-300"
                                            value={prompt.failurePatterns || ''}
                                            onChange={(e) => handleUpdatePrompt(prompt.id, 'failurePatterns', e.target.value)}
                                        />
                                    </div>
                                </div>

                                {/* Related Steps Linker */}
                                <div className="space-y-3 pt-4 border-t border-slate-100">
                                    <Label>관련된 Step 연결</Label>
                                    <div className="p-4 bg-slate-50 rounded-xl border border-slate-200">
                                        {stepBlocks.length === 0 ? (
                                            <p className="text-sm text-slate-400">아직 생성된 Step이 없습니다.</p>
                                        ) : (
                                            <div className="flex flex-wrap gap-4">
                                                {stepBlocks.map((step, idx) => {
                                                    const stepNum = idx + 1;
                                                    const isChecked = (prompt.relatedStep || []).includes(stepNum);
                                                    return (
                                                        <div key={step.id} className="flex items-center space-x-2">
                                                            <Checkbox
                                                                id={`p-${prompt.id}-s-${step.id}`}
                                                                checked={isChecked}
                                                                onCheckedChange={() => toggleStepLink(prompt.id, stepNum)}
                                                            />
                                                            <label
                                                                htmlFor={`p-${prompt.id}-s-${step.id}`}
                                                                className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 cursor-pointer"
                                                            >
                                                                Step {stepNum}
                                                            </label>
                                                        </div>
                                                    )
                                                })}
                                            </div>
                                        )}
                                    </div>
                                    <p className="text-xs text-slate-500">
                                        * 체크하면 해당 Step 완료 후 사용자가 이 프롬프트를 쉽게 찾을 수 있습니다.
                                    </p>
                                </div>
                            </div>
                        </div>
                    ))}

                    <Button onClick={handleAddPrompt} variant="outline" className="w-full border-dashed border-2 py-8 text-slate-400 hover:text-emerald-600 hover:border-emerald-200 hover:bg-emerald-50">
                        <Plus className="w-4 h-4 mr-2" />
                        프롬프트 추가하기
                    </Button>
                </div>
            )}
        </div>
    );
}
