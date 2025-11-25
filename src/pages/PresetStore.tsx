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

const PresetStore = () => {
    // 인기 템플릿 가져오기
    const { data: popularItems, isLoading: isPopularLoading } = useQuery({
        queryKey: ['presets-popular'],
        queryFn: async () => {
            const { data, error } = await supabase
                .from('presets')
                .select(`
                    *,
                    profiles (username)
                `)
                .order('rating', { ascending: false })
                .limit(4);

            if (error) throw error;
            return data as unknown as Preset[];
        }
    });

    // 신규 등록 템플릿 가져오기
    const { data: newItems, isLoading: isNewLoading } = useQuery({
        queryKey: ['presets-new'],
        queryFn: async () => {
            const { data, error } = await supabase
                .from('presets')
                .select(`
                    *,
                    profiles (username)
                `)
                .order('created_at', { ascending: false })
                .limit(4);

            if (error) throw error;
            return data as unknown as Preset[];
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
