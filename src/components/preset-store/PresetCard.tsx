import { Heart, Star } from "lucide-react";
import { Preset } from "@/types/preset";

interface PresetCardProps {
    preset: Preset;
    onClick: () => void;
}

const PresetCard = ({ preset, onClick }: PresetCardProps) => {
    return (
        <div
            onClick={onClick}
            className="group bg-white rounded-xl border border-gray-100 overflow-hidden hover:shadow-xl hover:-translate-y-1 transition-all duration-300 cursor-pointer"
        >
            {/* Image Section */}
            <div className="relative aspect-[1.6/1] bg-gray-100 overflow-hidden">
                <img
                    src={preset.imageUrl || "https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&q=80&w=800"}
                    alt={preset.title}
                    className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
                />
                <button className="absolute top-3 right-3 p-1.5 bg-white/80 backdrop-blur-sm rounded-full hover:bg-white text-gray-400 hover:text-red-500 transition-colors">
                    <Heart className="w-4 h-4" />
                </button>
            </div>

            {/* Content Section */}
            <div className="p-4">
                <div className="flex justify-between items-start mb-2 gap-2">
                    <h3 className="font-bold text-gray-900 line-clamp-2 leading-tight flex-1">
                        {preset.title}
                    </h3>
                    {preset.productType && (
                        <span className="shrink-0 px-2 py-0.5 bg-gray-100 text-gray-600 text-[10px] font-medium rounded-sm border border-gray-200">
                            {preset.productType}
                        </span>
                    )}
                </div>

                <div className="text-xs text-gray-500 mb-2">
                    {preset.creator || "AIHub Creator"}
                </div>

                <div className="flex items-center gap-1 mb-3">
                    <Star className="w-3.5 h-3.5 fill-amber-400 text-amber-400" />
                    <span className="text-sm font-bold text-gray-900">{preset.rating || "0.0"}</span>
                    <span className="text-xs text-gray-400">({preset.reviewCount || 0})</span>
                </div>

                <div className="font-bold text-gray-900">
                    {preset.isFree ? "무료" : `₩${preset.price.toLocaleString()}`}
                </div>
            </div>
        </div>
    );
};

export default PresetCard;
