import { useState } from "react";
import Navbar from "@/components/ui/navbar";
import Footer from "@/components/ui/footer";
import PresetHero from "@/components/preset-store/PresetHero";
import CategorySelector from "@/components/preset-store/CategorySelector";
import SelectedCategoryView from "@/components/preset-store/SelectedCategoryView";
import { CATEGORIES } from "@/data/mockData";
import SearchResults from "@/components/preset-store/SearchResults";

const PresetStore = () => {
    const [selectedCategoryId, setSelectedCategoryId] = useState<string | null>(null);
    const [searchQuery, setSearchQuery] = useState("");

    const handleCategorySelect = (id: string) => {
        // If searching, selecting a category acts as a filter on search results
        // If not searching, it toggles the view
        setSelectedCategoryId(id === selectedCategoryId ? null : id);
    };

    const selectedCategory = CATEGORIES.find(c => c.id === selectedCategoryId);

    return (
        <div className="min-h-screen bg-background font-sans">
            <Navbar />

            <main className="pb-24">
                <PresetHero searchQuery={searchQuery} onSearchChange={setSearchQuery} />

                <CategorySelector
                    selectedCategory={selectedCategoryId}
                    onSelectCategory={handleCategorySelect}
                />

                {searchQuery ? (
                    <SearchResults query={searchQuery} selectedCategory={selectedCategoryId} />
                ) : (
                    selectedCategory && (
                        <SelectedCategoryView
                            category={selectedCategory}
                            onClose={() => setSelectedCategoryId(null)}
                        />
                    )
                )}
            </main>

            <Footer />
        </div>
    );
};

export default PresetStore;
