import {
    CategoryDetails,
    MOCK_AGENTS,
    MOCK_WORKFLOWS,
    MOCK_TEMPLATES,
    MOCK_DESIGNS,
    PromptTemplate
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
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
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

    const { data: dbPrompts = [] } = useQuery({
        queryKey: ['preset_prompt_templates_category'],
        queryFn: async () => {
            const { data, error } = await supabase
                .from('preset_prompt_templates' as any)
                .select('*');

            if (error) throw error;

            return (data as any[]).map(item => ({
                id: item.id,
                title: item.title,
                author: item.author,
                date: new Date(item.created_at).toLocaleDateString(),
                description: item.description,
                badges: item.badges as any,
                tags: item.tags,
                oneLiner: item.one_liner,
                compatibleTools: item.compatible_tools,
                difficulty: item.difficulty,
                prompt: item.prompt,
                prompt_en: item.prompt_en,
                variables: item.variables as any,
                exampleIO: item.example_io as any,
                tips: item.tips
            })) as PromptTemplate[];
        }
    });

    const { data: dbAgents = [] } = useQuery({
        queryKey: ['preset_agents_category'],
        queryFn: async () => {
            const { data, error } = await supabase
                .from('preset_agents' as any)
                .select('*');

            if (error) throw error;

            return (data as any[]).map(item => ({
                id: item.id,
                title: item.title,
                author: item.author,
                date: new Date(item.created_at).toLocaleDateString(),
                description: item.description,
                description_en: item.description_en,
                platform: item.platform,
                oneLiner: item.one_liner,
                tags: item.tags,
                exampleQuestions: item.example_questions,
                url: item.url,
                instructions: item.instructions,
                instructions_en: item.instructions_en,
                requirements: item.requirements,
                exampleConversation: item.example_conversation,
                exampleConversation_en: item.example_conversation_en
            })) as unknown as typeof MOCK_AGENTS;
        }
    });

    const { data: dbWorkflows = [] } = useQuery({
        queryKey: ['preset_workflows'],
        queryFn: async () => {
            const { data, error } = await supabase
                .from('preset_workflows' as any)
                .select('*');

            if (error) throw error;

            return (data as any[]).map(item => ({
                id: item.id,
                title: item.title,
                author: item.author,
                date: new Date(item.created_at).toLocaleDateString(),
                description: item.description,
                complexity: item.complexity,
                duration: item.duration,
                apps: item.apps,
                oneLiner: item.one_liner,
                diagramUrl: item.diagram_url,
                download_url: item.download_url,
                steps: item.steps,
                requirements: item.requirements,
                credentials: item.credentials,
                warnings: item.warnings
            })) as unknown as typeof MOCK_WORKFLOWS;
        }
    });

    const renderContent = () => {
        switch (category.id) {
            case "prompt":
                return (
                    <>
                        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
                            {dbPrompts.map((item) => (
                                <div key={item.id} onClick={() => setSelectedItem(item)} className="cursor-pointer transition-transform hover:scale-[1.02] h-full">
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
                            {dbAgents.map((item: any) => (
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
                        {dbWorkflows.map((item: any) => (
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
