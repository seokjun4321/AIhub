import { useState } from "react";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import PresetCard from "@/components/preset-store/PresetCard";
import PresetDetailModal from "@/components/preset-store/PresetDetailModal";
import { Preset } from "@/types/preset";

const MOCK_PRESETS: Preset[] = [
    {
        id: "1",
        title: "SEO 최적화 블로그 글 작성 프롬프트",
        description: "SEO에 최적화된 블로그 글을 빠르게 작성할 수 있는 프롬프트입니다.",
        category: "콘텐츠 작성",
        tag: "ChatGPT",
        price: 0,
        isFree: true,
        aiModel: "ChatGPT",
        overview: {
            summary: "SEO 최적 요소(제목, 메타 설명, 키워드 배치)를 자동으로 반영하여 검색 상위 노출에 유리한 블로그 글을 생성합니다.",
            whenToUse: [
                "블로그를 운영하며 검색 유입을 늘리고 싶은 분",
                "SEO 글쓰기 지식이 미흡한 마케터",
                "콘텐츠 작성 시간을 단축하고 싶은 1인 사업자"
            ],
            expectedResults: [
                "SEO 친화적인 제목과 소제목 자동 생성",
                "키워드 밀도 최적화된 본문",
                "메타 설명 및 숏리크 제안",
                "가독성 높은 문단 구조"
            ],
            promptMaster: "AI 콘텐츠 전문가"
        },
        examples: [
            {
                before: "제주도 여행 좋아요. 맛집도 많고 경치도 좋습니다.",
                after: "# 2024 제주도 여행 완벽 가이드: 현지인 추천 맛집 & 숨은 명소 TOP 10\n\n제주도 여행을 계획 중이신가요? 이 글에서는 현지인만 아는 숨겨진 맛집부터 인스타 감성 명소까지 완벽하게 정리했습니다..."
            }
        ],
        prompt: {
            content: `당신은 seo 전문 블로그 작가입니다. 다음 조건에 맞춰 블로그 글을 작성하세요.

## 기본 정보
- 주제: {주제}
- 타겟 키워드: {키워드}
- 글 톤앤매너: {톤}
- 예상 독자: {타겟}

## 작성 규칙
1. 제목은 60자 이내, 키워드 포함
2. 메타 설명 160자 이내 작성
3. H2, H3 소제목 활용하여 구조화
4. 문단 2,000자 이상
5. 키워드는 자연스럽게 3~5회 배치
6. CTA(행동 유도) 포함

## 출력 형식
- 제목
- 메타 설명
- 본문 (마크다운 형식)
- 추천 슬러그`
        },
        variables: {
            guide: [
                { name: "{주제}", description: "블로그 글의 메인 주제", example: "제주도 3박 4일 여행 코스" },
                { name: "{키워드}", description: "SEO 타겟 키워드", example: "제주도 여행" },
                { name: "{톤}", description: "글의 어조와 스타일", example: "친근하고 정보성 있는" },
                { name: "{타겟}", description: "예상 독자층", example: "20-30대 여행 초보자" }
            ],
            exampleInput: "{주제}: 제주도 3박 4일 여행 코스 {키워드}: 제주도 여행 {톤}: 친근하고 정보성 있는 {타겟}: 20-30대 여행 초보자",
            usageSteps: [
                "[ ] 앞의 변수를 실제 내용으로 채우기",
                "프롬프트 전체를 복사하기",
                "ChatGPT 새 채팅에 붙여넣고 실행"
            ]
        }
    },
    {
        id: "2",
        title: "고급 비즈니스 제안서 자동 생성 시스템",
        description: "설득력 있는 제안서를 자동 생성하는 고급 프롬프트 시스템입니다.",
        category: "비즈니스",
        tag: "고급",
        price: 15000,
        isFree: false,
        aiModel: "ChatGPT",
        overview: {
            summary: "전문적이고 설득력 있는 비즈니스 제안서를 자동으로 생성합니다.",
            whenToUse: [
                "투자 유치를 준비하는 스타트업",
                "기업 제안서를 작성하는 마케터",
                "시간을 절약하고 싶은 프리랜서"
            ],
            expectedResults: [
                "전문적인 제안서 구조 생성",
                "설득력 있는 논리 전개",
                "데이터 기반 근거 제시",
                "시각적 요소 제안"
            ],
            promptMaster: "비즈니스 전략가"
        },
        examples: [
            {
                before: "우리 회사 제품 좋아요. 투자해주세요.",
                after: "# 투자 제안서: [회사명]\n\n## 요약\n시장 기회: ...\n경쟁 우위: ...\n수익 모델: ...\n\n## 상세 분석\n..."
            }
        ],
        prompt: {
            content: `당신은 비즈니스 제안서 전문가입니다. 다음 조건에 맞춰 제안서를 작성하세요.

## 기본 정보
- 제안 대상: {대상}
- 제안 목적: {목적}
- 예산 규모: {예산}

## 작성 규칙
1. 요약은 1페이지 이내
2. 데이터 기반 근거 제시
3. 시각적 요소 활용 제안
4. ROI 명확히 제시

## 출력 형식
- 요약
- 배경
- 제안 내용
- 예상 효과
- 예산 및 일정`
        },
        variables: {
            guide: [
                { name: "{대상}", description: "제안 대상 조직/인물", example: "ABC 투자사" },
                { name: "{목적}", description: "제안의 목적", example: "시리즈 A 투자 유치" },
                { name: "{예산}", description: "요청 예산", example: "50억원" }
            ],
            exampleInput: "{대상}: ABC 투자사 {목적}: 시리즈 A 투자 유치 {예산}: 50억원",
            usageSteps: [
                "[ ] 변수를 실제 내용으로 교체",
                "프롬프트를 ChatGPT에 입력",
                "결과를 검토하고 수정"
            ]
        }
    }
];

const PresetStore = () => {
    const [selectedPreset, setSelectedPreset] = useState<Preset | null>(null);

    return (
        <div className="min-h-screen bg-background">
            <Navbar />
            <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
                {/* Header */}
                <div className="text-center mb-12">
                    <div className="inline-flex items-center gap-2 px-4 py-2 bg-indigo-50 text-indigo-600 rounded-full text-sm font-medium mb-4">
                        ⚡ AI 프롬프트 모음
                    </div>
                    <h1 className="text-4xl font-bold text-gray-900 mb-4">
                        프리셋 미리보기 데모
                    </h1>
                    <p className="text-lg text-gray-600">
                        무료/유료 프리셋의 미리보기 모달을 쉽게 체험할 수 있습니다.
                        <br />
                        아래 카드를 클릭하면 모달이 열립니다.
                    </p>
                </div>

                {/* Preset Grid */}
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6 max-w-5xl mx-auto">
                    {MOCK_PRESETS.map((preset) => (
                        <PresetCard
                            key={preset.id}
                            preset={preset}
                            onClick={() => setSelectedPreset(preset)}
                        />
                    ))}
                </div>

                {/* Feature Info */}
                <div className="mt-16 p-8 bg-gray-50 rounded-2xl max-w-3xl mx-auto">
                    <h2 className="text-2xl font-bold text-gray-900 mb-4">
                        프리셋 미리보기 기능
                    </h2>
                    <ul className="space-y-3 text-gray-700">
                        <li className="flex items-start gap-2">
                            <span className="text-indigo-600 mt-1">●</span>
                            <span><strong>4개 탭:</strong> 개요, 예시, 프롬프트/지침(복사), 변수 & 사용법</span>
                        </li>
                        <li className="flex items-start gap-2">
                            <span className="text-indigo-600 mt-1">●</span>
                            <span><strong>좌측 드로워:</strong> 선택 내역 탭 이동 및 출처 확인 가능</span>
                        </li>
                        <li className="flex items-start gap-2">
                            <span className="text-indigo-600 mt-1">●</span>
                            <span><strong>유용한 도구:</strong> ChatGPT, Gemini 등으로 바로 이동</span>
                        </li>
                        <li className="flex items-start gap-2">
                            <span className="text-indigo-600 mt-1">●</span>
                            <span><strong>포맷 복사:</strong> 프롬프트 내용을 클릭 한 번에 복사</span>
                        </li>
                    </ul>
                </div>
            </main>

            {/* Detail Modal */}
            {selectedPreset && (
                <PresetDetailModal
                    preset={selectedPreset}
                    onClose={() => setSelectedPreset(null)}
                />
            )}

            <Footer />
        </div>
    );
};

export default PresetStore;
