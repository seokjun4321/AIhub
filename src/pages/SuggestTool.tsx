import { useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import { useNavigate } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import {
    Form,
    FormControl,
    FormDescription,
    FormField,
    FormItem,
    FormLabel,
    FormMessage,
} from "@/components/ui/form";
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from "@/components/ui/select";
import { toast } from "sonner";
import { useAuth } from "@/hooks/useAuth";
import { Loader2, Send } from "lucide-react";

const formSchema = z.object({
    name: z.string().min(2, "도구 이름은 최소 2글자 이상이어야 합니다."),
    website_url: z.string().url("올바른 URL 형식이 아닙니다."),
    description: z.string().min(10, "설명은 최소 10글자 이상이어야 합니다."),
    category_id: z.string().min(1, "카테고리를 선택해주세요."),
});

const SuggestTool = () => {
    const { user } = useAuth();
    const navigate = useNavigate();
    const [isSubmitting, setIsSubmitting] = useState(false);

    // 카테고리 목록 가져오기
    const { data: categories } = useQuery({
        queryKey: ["categories"],
        queryFn: async () => {
            const { data, error } = await supabase
                .from("categories")
                .select("id, name")
                .order("name");
            if (error) throw error;
            return data;
        },
    });

    const form = useForm<z.infer<typeof formSchema>>({
        resolver: zodResolver(formSchema),
        defaultValues: {
            name: "",
            website_url: "",
            description: "",
            category_id: "",
        },
    });

    const onSubmit = async (values: z.infer<typeof formSchema>) => {
        if (!user) {
            toast.error("로그인이 필요합니다.");
            return;
        }

        setIsSubmitting(true);
        try {
            const { error } = await supabase.from("tool_proposals" as any).insert({
                user_id: user.id,
                name: values.name,
                website_url: values.website_url,
                description: values.description,
                category_id: parseInt(values.category_id),
            });

            if (error) throw error;

            toast.success("도구 제안이 성공적으로 접수되었습니다!");
            navigate("/tools");
        } catch (error: any) {
            toast.error(`제안 제출 실패: ${error.message}`);
        } finally {
            setIsSubmitting(false);
        }
    };

    return (
        <div className="min-h-screen bg-background flex flex-col">
            <Navbar />
            <main className="flex-1 container mx-auto px-6 py-24 max-w-2xl">
                <div className="mb-8 text-center">
                    <h1 className="text-3xl font-bold mb-2">AI 도구 제안하기</h1>
                    <p className="text-muted-foreground">
                        유용한 AI 도구를 알고 계신가요? AIHub 커뮤니티와 공유해주세요.
                    </p>
                </div>

                <div className="bg-card border rounded-xl p-6 shadow-sm">
                    <Form {...form}>
                        <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
                            <FormField
                                control={form.control}
                                name="name"
                                render={({ field }) => (
                                    <FormItem>
                                        <FormLabel>도구 이름</FormLabel>
                                        <FormControl>
                                            <Input placeholder="예: ChatGPT" {...field} />
                                        </FormControl>
                                        <FormMessage />
                                    </FormItem>
                                )}
                            />

                            <FormField
                                control={form.control}
                                name="website_url"
                                render={({ field }) => (
                                    <FormItem>
                                        <FormLabel>웹사이트 URL</FormLabel>
                                        <FormControl>
                                            <Input placeholder="https://example.com" {...field} />
                                        </FormControl>
                                        <FormMessage />
                                    </FormItem>
                                )}
                            />

                            <FormField
                                control={form.control}
                                name="category_id"
                                render={({ field }) => (
                                    <FormItem>
                                        <FormLabel>카테고리</FormLabel>
                                        <Select
                                            onValueChange={field.onChange}
                                            defaultValue={field.value}
                                        >
                                            <FormControl>
                                                <SelectTrigger>
                                                    <SelectValue placeholder="카테고리 선택" />
                                                </SelectTrigger>
                                            </FormControl>
                                            <SelectContent>
                                                {categories?.map((category) => (
                                                    <SelectItem
                                                        key={category.id}
                                                        value={category.id.toString()}
                                                    >
                                                        {category.name}
                                                    </SelectItem>
                                                ))}
                                            </SelectContent>
                                        </Select>
                                        <FormMessage />
                                    </FormItem>
                                )}
                            />

                            <FormField
                                control={form.control}
                                name="description"
                                render={({ field }) => (
                                    <FormItem>
                                        <FormLabel>설명</FormLabel>
                                        <FormControl>
                                            <Textarea
                                                placeholder="이 도구에 대한 간단한 설명을 적어주세요."
                                                className="resize-none h-32"
                                                {...field}
                                            />
                                        </FormControl>
                                        <FormDescription>
                                            도구의 주요 기능이나 특징을 설명해주시면 좋습니다.
                                        </FormDescription>
                                        <FormMessage />
                                    </FormItem>
                                )}
                            />

                            <Button
                                type="submit"
                                className="w-full"
                                size="lg"
                                disabled={isSubmitting}
                            >
                                {isSubmitting ? (
                                    <>
                                        <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                                        제출 중...
                                    </>
                                ) : (
                                    <>
                                        <Send className="mr-2 h-4 w-4" />
                                        제안하기
                                    </>
                                )}
                            </Button>
                        </form>
                    </Form>
                </div>
            </main>
            <Footer />
        </div>
    );
};

export default SuggestTool;
