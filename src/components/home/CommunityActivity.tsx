import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { MessageSquare, CheckCircle2 } from "lucide-react";
import { Link } from "react-router-dom";

const recentQuestions = [
    {
        user: "김민수",
        tag: "마케팅",
        title: "마케팅 자동화를 위한 최적의 AI 조합이 궁금합니다",
        time: "10분 전",
        comments: 5,
        likes: 12,
        avatar: "M"
    },
    {
        user: "이지은",
        tag: "개발",
        title: "ChatGPT API를 활용한 챗봇 구축 방법",
        time: "1시간 전",
        comments: 8,
        likes: 23,
        avatar: "L"
    },
    {
        user: "박준호",
        tag: "이미지 생성",
        title: "이미지 생성 AI 비교 - Midjourney vs DALL-E",
        time: "2시간 전",
        comments: 15,
        likes: 34,
        avatar: "P"
    }
];

const solvedProblems = [
    {
        user: "최서연",
        title: "Notion과 ChatGPT 연동 자동화",
        solution: "Zapier를 활용한 워크플로우 구축",
        time: "어제",
        avatar: "C"
    },
    {
        user: "강동현",
        title: "대용량 문서 요약 자동화",
        solution: "Claude API + Python 스크립트",
        time: "2일 전",
        avatar: "K"
    }
];

const CommunityActivity = () => {
    return (
        <section className="py-20">
            <div className="container mx-auto px-6">
                <div className="text-center mb-12">
                    <h2 className="text-3xl font-bold mb-4">커뮤니티 활동</h2>
                    <p className="text-muted-foreground">다른 사용자들과 지식을 공유하고 함께 성장하세요</p>
                </div>

                <div className="grid grid-cols-1 lg:grid-cols-2 gap-12">
                    {/* 최근 질문 */}
                    <div>
                        <div className="flex items-center gap-2 mb-6">
                            <MessageSquare className="w-5 h-5 text-green-500" />
                            <h3 className="text-xl font-bold">최근 질문</h3>
                        </div>
                        <div className="space-y-4">
                            {recentQuestions.map((q, i) => (
                                <Card key={i} className="p-4 hover:shadow-md transition-all cursor-pointer">
                                    <div className="flex gap-4">
                                        <Avatar className="w-10 h-10 bg-green-100 text-green-600">
                                            <AvatarFallback>{q.avatar}</AvatarFallback>
                                        </Avatar>
                                        <div className="flex-1">
                                            <div className="flex items-center gap-2 mb-1">
                                                <span className="font-semibold text-sm">{q.user}</span>
                                                <Badge variant="secondary" className="text-xs font-normal">
                                                    {q.tag}
                                                </Badge>
                                            </div>
                                            <h4 className="font-medium mb-2">{q.title}</h4>
                                            <div className="flex items-center gap-4 text-xs text-muted-foreground">
                                                <span>{q.time}</span>
                                                <div className="flex items-center gap-1">
                                                    <MessageSquare className="w-3 h-3" />
                                                    {q.comments}
                                                </div>
                                                <div className="flex items-center gap-1">
                                                    <span>👍</span>
                                                    {q.likes}
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </Card>
                            ))}
                        </div>
                    </div>

                    {/* 최근 해결된 문제 */}
                    <div>
                        <div className="flex items-center gap-2 mb-6">
                            <CheckCircle2 className="w-5 h-5 text-green-500" />
                            <h3 className="text-xl font-bold">최근 해결된 문제</h3>
                        </div>
                        <div className="space-y-4">
                            {solvedProblems.map((p, i) => (
                                <Card key={i} className="p-4 hover:shadow-md transition-all cursor-pointer border-green-500/20 bg-green-50/30">
                                    <div className="flex gap-4">
                                        <Avatar className="w-10 h-10 bg-green-600 text-white">
                                            <AvatarFallback>{p.avatar}</AvatarFallback>
                                        </Avatar>
                                        <div className="flex-1">
                                            <div className="flex items-center gap-2 mb-1">
                                                <span className="font-semibold text-sm">{p.user}</span>
                                                <Badge className="bg-green-500 hover:bg-green-600 text-xs">
                                                    해결됨
                                                </Badge>
                                            </div>
                                            <h4 className="font-medium mb-2">{p.title}</h4>
                                            <div className="bg-white/50 p-2 rounded-md text-sm text-muted-foreground mb-2">
                                                <span className="font-semibold text-green-700 mr-2">해결:</span>
                                                {p.solution}
                                            </div>
                                            <span className="text-xs text-muted-foreground">{p.time}</span>
                                        </div>
                                    </div>
                                </Card>
                            ))}
                        </div>
                    </div>
                </div>

                <div className="text-center mt-12">
                    <Button size="lg" className="bg-green-600 hover:bg-green-700 text-white px-8" asChild>
                        <Link to="/community">커뮤니티 참여하기</Link>
                    </Button>
                </div>
            </div>
        </section>
    );
};

export default CommunityActivity;
