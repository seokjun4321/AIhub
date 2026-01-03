import { Preset } from "@/types/preset";

interface PresetCardProps {
    preset: Preset;
    onClick: () => void;
}

const PresetCard = ({ preset, onClick }: PresetCardProps) => {
    return (
        <div
            onClick={onClick}
            className="group bg-white border border-gray-200 rounded-xl p-6 hover:border-indigo-300 hover:shadow-lg transition-all duration-200 cursor-pointer"
        >
            <div className="flex items-start justify-between mb-4">
                <div className="flex items-center gap-2">
                    <span className="px-3 py-1 bg-emerald-50 text-emerald-600 text-xs font-medium rounded-full">
                        {preset.category}
                    </span>
                    <span className="px-3 py-1 bg-gray-100 text-gray-700 text-xs font-medium rounded-full">
                        {preset.tag}
                    </span>
                </div>
            </div>

            <h3 className="text-xl font-bold text-gray-900 mb-2 group-hover:text-indigo-600 transition-colors">
                {preset.title}
            </h3>

            <p className="text-gray-600 text-sm mb-4 line-clamp-2">
                {preset.description}
            </p>

            <div className="flex items-center justify-between pt-4 border-t border-gray-100">
                <div className="flex items-center gap-2">
                    {preset.isFree ? (
                        <span className="px-3 py-1 bg-green-100 text-green-700 text-sm font-semibold rounded-full">
                            무료
                        </span>
                    ) : (
                        <span className="px-3 py-1 bg-indigo-100 text-indigo-700 text-sm font-semibold rounded-full">
                            유료
                        </span>
                    )}
                </div>
                {!preset.isFree && (
                    <span className="text-lg font-bold text-indigo-600">
                        ₩{preset.price.toLocaleString()}
                    </span>
                )}
            </div>
        </div>
    );
};

export default PresetCard;
