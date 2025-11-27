import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import PresetHero from "@/components/preset-store/PresetHero";
import PresetCategories from "@/components/preset-store/PresetCategories";
import PresetGrid from "@/components/preset-store/PresetGrid";
import CreatorGrid from "@/components/preset-store/CreatorGrid";
import SellCTA from "@/components/preset-store/SellCTA";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";

interface Preset {
    id: string;
    title: string;
    description: string | null;
    price: number | null;
    image_url: string | null;
    category: string | null;
    tags: string[] | null;
    rating: number | null;
    review_count: number | null;
    profiles: {
        username: string | null;
    } | null;
}

const MOCK_PRESETS: Preset[] = [
    {
        id: "1",
        title: "블로그 포스팅 워크플로우",
        description: "주제 선정부터 SEO 최적화까지 자동화",
        price: 0,
        image_url: "https://images.unsplash.com/photo-1432888498266-38ffec3eaf0a?w=800&q=80",
        category: "비즈니스",
        tags: ["블로그", "SEO"],
        rating: 4.8,
        review_count: 120,
        profiles: { username: "AIHub_Official" }
    },
    {
        id: "2",
        title: "소셜미디어 콘텐츠 생성기",
        description: "여러 플랫폼용 콘텐츠를 한 번에 생성",
        price: 0,
        image_url: "https://images.unsplash.com/photo-1611162617474-5b21e879e113?w=800&q=80",
        category: "마케팅",
        tags: ["SNS", "콘텐츠"],
        rating: 4.6,
        review_count: 85,
        profiles: { username: "MarketingPro" }
    },
    {
        id: "3",
        title: "코드 리뷰 자동화",
        description: "Pull Request 자동 리뷰 및 개선 제안",
        price: 0,
        image_url: "https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=800&q=80",
        category: "개발",
        tags: ["Code", "Review"],
        rating: 4.9,
        review_count: 200,
        profiles: { username: "DevMaster" }
    },
    {
        id: "4",
        title: "고객 응대 챗봇 템플릿",
        description: "FAQ 자동 응답 및 티켓 분류",
        price: 0,
        image_url: "https://images.unsplash.com/photo-1531746790731-6c087fecd65a?w=800&q=80",
        category: "고객 서비스",
        tags: ["Chatbot", "CS"],
        rating: 4.7,
        review_count: 150,
        profiles: { username: "ServiceHero" }
    }
];

const PresetStore = () => {
    // 인기 템플릿 가져오기 (Mock Data)
    const { data: popularItems, isLoading: isPopularLoading } = useQuery({
        queryKey: ['presets-popular'],
        queryFn: async () => {
            // 실제 DB 연동 시 아래 주석 해제 및 'presets' 테이블 생성 필요
            /*
            const { data, error } = await supabase
                .from('presets' as any)
                .select(`
                    *,
                    profiles (username)
                `)
                .order('rating', { ascending: false })
                .limit(4);

            if (error) throw error;
            return data as unknown as Preset[];
            */
            return MOCK_PRESETS;
        }
    });

    // 신규 등록 템플릿 가져오기 (Mock Data)
    const { data: newItems, isLoading: isNewLoading } = useQuery({
        queryKey: ['presets-new'],
        queryFn: async () => {
            // 실제 DB 연동 시 아래 주석 해제 및 'presets' 테이블 생성 필요
            /*
            const { data, error } = await supabase
                .from('presets' as any)
                .select(`
                    *,
                    profiles (username)
                `)
                .order('created_at', { ascending: false })
                .limit(4);

            if (error) throw error;
            return data as unknown as Preset[];
            */
            return [...MOCK_PRESETS].reverse();
        }
    });

    const mapToPresetItem = (preset: Preset) => ({
        id: preset.id,
        image: preset.image_url || "https://via.placeholder.com/800x450?text=No+Image",
        title: preset.title,
        category: preset.category || "기타",
        tag: preset.tags?.[0] || "템플릿",
        rating: preset.rating || 0,
        reviews: preset.review_count || 0,
        price: preset.price || 0,
        author: preset.profiles?.username || "Unknown"
    });

    return (
        <div className="min-h-screen bg-background">
            <Navbar />
            <main>
                <PresetHero />
                <PresetCategories />
                <PresetGrid
                    title="인기 템플릿"
                    subtitle="가장 많이 선택받은 프리셋"
                    items={popularItems?.map(mapToPresetItem) || []}
                />
                <PresetGrid
                    title="신규 등록"
                    subtitle="최근에 추가된 템플릿"
                    items={newItems?.map(mapToPresetItem) || []}
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
