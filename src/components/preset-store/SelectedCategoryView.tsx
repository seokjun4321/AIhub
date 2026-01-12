import {
    CategoryDetails,
    MOCK_PROMPTS,
    MOCK_AGENTS,
    MOCK_WORKFLOWS,
    MOCK_TEMPLATES,
    MOCK_DESIGNS
} from "@/data/mockData";
import { X } from "lucide-react";
import { Button } from "@/components/ui/button";
import PromptTemplateCard from "./cards/PromptTemplateCard";
import AgentCard from "./cards/AgentCard";
import WorkflowCard from "./cards/WorkflowCard";
import TemplateCard from "./cards/TemplateCard";
import DesignCard from "./cards/DesignCard";
import { useState } from "react";
import { Link } from "react-router-dom";
import PromptModal from "./modals/PromptModal";
import AgentModal from "./modals/AgentModal";
import DesignModal from "./modals/DesignModal";
import TemplateModal from "./modals/TemplateModal";

interface SelectedCategoryViewProps {
    category: CategoryDetails;
    onClose: () => void;
}

const SelectedCategoryView = ({ category, onClose }: SelectedCategoryViewProps) => {
    const [selectedItem, setSelectedItem] = useState<any>(null);

    const renderContent = () => {
        switch (category.id) {
            case "prompt":
                return (
                    <>
                        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
                            {MOCK_PROMPTS.map((item) => (
                                <div key={item.id} onClick={() => setSelectedItem(item)} className="cursor-pointer transition-transform hover:scale-[1.02]">
                                    <PromptTemplateCard item={item} />
                                </div>
                            ))}
                        </div>
                        {selectedItem && (
                            <PromptModal
                                item={selectedItem}
                                isOpen={!!selectedItem}
                                onClose={() => setSelectedItem(null)}
                            />
                        )}
                    </>
                );
            case "agent":
                return (
                    <>
                        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
                            {MOCK_AGENTS.map((item) => (
                                <div key={item.id} onClick={() => setSelectedItem(item)} className="cursor-pointer transition-transform hover:scale-[1.02]">
                                    <AgentCard item={item} />
                                </div>
                            ))}
                        </div>
                        {selectedItem && (
                            <AgentModal
                                item={selectedItem}
                                isOpen={!!selectedItem}
                                onClose={() => setSelectedItem(null)}
                            />
                        )}
                    </>
                );
            case "workflow":
                return (
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
                        {MOCK_WORKFLOWS.map((item) => (
                            <Link key={item.id} to={`/workflows/${item.id}`} className="block transition-transform hover:scale-[1.02]">
                                <WorkflowCard item={item} />
                            </Link>
                        ))}
                    </div>
                );
            case "template":
                return (
                    <>
                        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
                            {MOCK_TEMPLATES.map((item) => (
                                <div key={item.id} onClick={() => setSelectedItem(item)} className="cursor-pointer transition-transform hover:scale-[1.02]">
                                    <TemplateCard item={item} />
                                </div>
                            ))}
                        </div>
                        {selectedItem && (
                            <TemplateModal
                                item={selectedItem}
                                isOpen={!!selectedItem}
                                onClose={() => setSelectedItem(null)}
                            />
                        )}
                    </>
                );
            case "design":
                return (
                    <>
                        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
                            {MOCK_DESIGNS.map((item) => (
                                <div key={item.id} onClick={() => setSelectedItem(item)} className="cursor-pointer transition-transform hover:scale-[1.02]">
                                    <DesignCard item={item} />
                                </div>
                            ))}
                        </div>
                        {selectedItem && (
                            <DesignModal
                                item={selectedItem}
                                isOpen={!!selectedItem}
                                onClose={() => setSelectedItem(null)}
                            />
                        )}
                    </>
                );
            default:
                return <div>준비 중인 카테고리입니다.</div>;
        }
    };

    return (
        <section className="py-12 bg-background animate-in fade-in slide-in-from-bottom-2 duration-300">
            <div className="max-w-6xl mx-auto px-4">
                <div className="flex items-center justify-between mb-6">
                    <div className="flex items-center gap-3">
                        <category.icon className="w-6 h-6 text-primary" />
                        <h3 className="text-xl font-semibold text-foreground">{category.name}</h3>
                    </div>
                    <Button variant="ghost" size="sm" onClick={onClose} className="text-muted-foreground hover:text-foreground">
                        닫기
                    </Button>
                </div>

                {renderContent()}
            </div>
        </section>
    );
};

export default SelectedCategoryView;
