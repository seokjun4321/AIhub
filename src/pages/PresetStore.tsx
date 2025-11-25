import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import PresetHero from "@/components/preset-store/PresetHero";
import PresetCategories from "@/components/preset-store/PresetCategories";
import PresetGrid from "@/components/preset-store/PresetGrid";
import CreatorGrid from "@/components/preset-store/CreatorGrid";
import SellCTA from "@/components/preset-store/SellCTA";

const popularItems = [
    {
        id: "1",
        image: "https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=800&q=80",
        title: "사업계획서 자동 생성 프롬프트 세트",
        category: "비즈니스",
        tag: "프롬프트",
        rating: 4.8,
        reviews: 124,
        price: 29000,
        author: "비즈니스팀"
    },
    {
        id: "2",
        image: "https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800&q=80",
        title: "n8n 이메일 자동분류 워크플로우",
        category: "오토메이션",
        tag: "자동화",
        rating: 4.9,
        reviews: 89,
        price: 45000,
        author: "오토메이션랩"
    },
    {
        id: "3",
        image: "https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=800&q=80",
        title: "Gem - AI 학습코치",
        category: "에듀테크",
        tag: "Gem",
        rating: 4.7,
        reviews: 201,
        price: 19000,
        author: "에듀허브"
    },
    {
        id: "4",
        image: "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800&q=80",
        title: "Midjourney 캐릭터 프롬프트 팩",
        category: "크리에이티브",
        tag: "디자인",
        rating: 4.9,
        reviews: 312,
        price: 35000,
        author: "크리에이티브스튜디오"
    },
    {
        id: "5",
        image: "https://images.unsplash.com/photo-1555421689-491a97ff2040?w=800&q=80",
        title: "Notion AI 리서치 대시보드",
        category: "프로덕티비티",
        tag: "템플릿",
        rating: 4.8,
        reviews: 156,
        price: 25000,
        author: "노션프로"
    },
    {
        id: "6",
        image: "https://images.unsplash.com/photo-1552664730-d307ca884978?w=800&q=80",
        title: "GPT-4 마케팅 전략 도우미",
        category: "마케팅",
        tag: "GPT",
        rating: 4.6,
        reviews: 78,
        price: 39000,
        author: "마케팅랩"
    }
];

const newItems = [
    {
        id: "7",
        image: "https://images.unsplash.com/photo-1589829085413-56de8ae18c73?w=800&q=80",
        title: "Claude 3.5 법률 문서 검토 프롬프트",
        category: "리걸테크",
        tag: "프롬프트",
        rating: 4.9,
        reviews: 23,
        price: 49000,
        author: "법률AI"
    },
    {
        id: "8",
        image: "https://images.unsplash.com/photo-1512314889357-e157c22f938d?w=800&q=80",
        title: "AI 콘텐츠 캘린더 Notion 템플릿",
        category: "콘텐츠메이커",
        tag: "템플릿",
        rating: 4.7,
        reviews: 45,
        price: 15000,
        author: "콘텐츠랩"
    },
    {
        id: "9",
        image: "https://images.unsplash.com/photo-1553877615-30c730db910d?w=800&q=80",
        title: "Zapier 고객 관리 자동화 워크플로우",
        category: "세일즈부스터",
        tag: "자동화",
        rating: 4.8,
        reviews: 67,
        price: 55000,
        author: "세일즈팀"
    },
    {
        id: "10",
        image: "https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800&q=80",
        title: "Gemini 2.0 데이터 분석 Gem",
        category: "데이터사이언스",
        tag: "Gem",
        rating: 4.9,
        reviews: 12,
        price: 32000,
        author: "데이터랩"
    }
];

const PresetStore = () => {
    return (
        <div className="min-h-screen bg-background">
            <Navbar />
            <main>
                <PresetHero />
                <PresetCategories />
                <PresetGrid
                    title="인기 템플릿"
                    subtitle="가장 많이 선택받은 프리셋"
                    items={popularItems}
                />
                <PresetGrid
                    title="신규 등록"
                    subtitle="최근에 추가된 템플릿"
                    items={newItems}
                    showMore={false}
                />
                <CreatorGrid />
                <SellCTA />
            </main>
            <Footer />
        </div>
    );
};

export default PresetStore;
