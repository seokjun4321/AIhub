import { useState } from "react";
import { Link } from "react-router-dom";
import {
    PromptTemplate, AgentItem, TemplateItem, DesignItem, WorkflowItem
} from "@/data/mockData";
import PromptTemplateCard from "./cards/PromptTemplateCard";
import AgentCard from "./cards/AgentCard";
import WorkflowCard from "./cards/WorkflowCard";
import TemplateCard from "./cards/TemplateCard";
import DesignCard from "./cards/DesignCard";
import PromptModal from "./modals/PromptModal";
import AgentModal from "./modals/AgentModal";
import TemplateModal from "./modals/TemplateModal";
import DesignModal from "./modals/DesignModal";
import { FileText, Sparkles, Link as LinkIcon, LayoutGrid, Image as ImageIcon } from "lucide-react";
import { useQuery } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";

interface SearchResultsProps {
    query: string;
    selectedCategory: string | null;
}

const SearchResults = ({ query, selectedCategory }: SearchResultsProps) => {
    // State for modals
    const [selectedPrompt, setSelectedPrompt] = useState<PromptTemplate | null>(null);
    const [selectedAgent, setSelectedAgent] = useState<AgentItem | null>(null);
    const [selectedTemplate, setSelectedTemplate] = useState<TemplateItem | null>(null);
    const [selectedDesign, setSelectedDesign] = useState<DesignItem | null>(null);

    const lowerQuery = query.toLowerCase();

    // Filter Functions
    const filterItems = <T extends { title: string, oneLiner: string, tags?: string[] }>(items: T[]) => {
        return items.filter(item =>
            item.title.toLowerCase().includes(lowerQuery) ||
            item.oneLiner.toLowerCase().includes(lowerQuery) ||
            item.tags?.some(tag => tag.toLowerCase().includes(lowerQuery))
        );
    };

    const { data: dbPrompts = [] } = useQuery({
        queryKey: ['preset_prompt_templates'],
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
        queryKey: ['preset_agents'],
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
            })) as AgentItem[];
        }
    });

    const { data: dbWorkflows = [] } = useQuery({
        queryKey: ['preset_workflows'],
        queryFn: async () => {
            const { data, error } = await supabase.from('preset_workflows' as any).select('*');
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
            })) as WorkflowItem[];
        }
    });

    const { data: dbTemplates = [] } = useQuery({
        queryKey: ['preset_templates'],
        queryFn: async () => {
            const { data, error } = await supabase.from('preset_templates' as any).select('*');
            if (error) throw error;
            return (data as any[]).map(item => ({
                id: item.id,
                title: item.title,
                oneLiner: item.one_liner,
                category: item.category,
                price: item.price,
                includes: item.includes,
                imageUrl: item.image_url,
                previewImages: item.preview_images,
                tags: item.tags,
                author: item.author,
                previewUrl: item.preview_url,
                duplicateUrl: item.duplicate_url,
                setupSteps: item.setup_steps,
                date: new Date(item.created_at).toLocaleDateString()
            })) as TemplateItem[];
        }
    });

    const { data: dbDesigns = [] } = useQuery({
        queryKey: ['preset_designs'],
        queryFn: async () => {
            const { data, error } = await supabase.from('preset_designs' as any).select('*');
            if (error) throw error;
            return (data as any[]).map(item => ({
                id: item.id,
                title: item.title,
                oneLiner: item.one_liner,
                tags: item.tags,
                beforeImage: item.image_url,
                afterImage: item.after_image_url || undefined,
                author: item.author,
                promptText: item.prompt_text,
                params: item.params,
                inputTips: item.input_tips
            })) as DesignItem[];
        }
    });

    const prompts = filterItems(dbPrompts);
    const agents = filterItems(dbAgents);
    const workflows = filterItems(dbWorkflows);
    const templates = filterItems(dbTemplates);
    const designs = filterItems(dbDesigns);

    const hasResults = prompts.length > 0 || agents.length > 0 || workflows.length > 0 || templates.length > 0 || designs.length > 0;

    if (!hasResults) {
        return (
            <div className="text-center py-24">
                <h3 className="text-xl font-semibold text-slate-800 mb-2">검색 결과가 없습니다</h3>
                <p className="text-slate-500">다른 키워드로 검색해보세요.</p>
            </div>
        );
    }

    return (
        <div className="max-w-6xl mx-auto px-4 py-8 space-y-12">
            {/* Prompts Section */}
            {prompts.length > 0 && (!selectedCategory || selectedCategory === 'prompt') && (
                <div className="space-y-4">
                    <h3 className="text-xl font-bold flex items-center gap-2 text-slate-800">
                        <FileText className="w-5 h-5 text-slate-500" /> 프롬프트 템플릿 ({prompts.length})
                    </h3>
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
                        {prompts.map(item => (
                            <div key={item.id} onClick={() => setSelectedPrompt(item)} className="cursor-pointer transition-transform hover:scale-[1.02] h-full">
                                <PromptTemplateCard item={item} />
                            </div>
                        ))}
                    </div>
                </div>
            )}

            {/* Agents Section */}
            {agents.length > 0 && (!selectedCategory || selectedCategory === 'agent') && (
                <div className="space-y-4">
                    <h3 className="text-xl font-bold flex items-center gap-2 text-slate-800">
                        <Sparkles className="w-5 h-5 text-slate-500" /> AI 에이전트 ({agents.length})
                    </h3>
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
                        {agents.map(item => (
                            <div key={item.id} onClick={() => setSelectedAgent(item)} className="cursor-pointer transition-transform hover:scale-[1.02]">
                                <AgentCard item={item} />
                            </div>
                        ))}
                    </div>
                </div>
            )}

            {/* Workflows Section */}
            {workflows.length > 0 && (!selectedCategory || selectedCategory === 'workflow') && (
                <div className="space-y-4">
                    <h3 className="text-xl font-bold flex items-center gap-2 text-slate-800">
                        <LinkIcon className="w-5 h-5 text-slate-500" /> 자동화 워크플로우 ({workflows.length})
                    </h3>
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
                        {workflows.map(item => (
                            <Link key={item.id} to={`/workflows/${item.id}`} className="transition-transform hover:scale-[1.02] block">
                                <WorkflowCard item={item} />
                            </Link>
                        ))}
                    </div>
                </div>
            )}

            {/* Templates Section */}
            {templates.length > 0 && (!selectedCategory || selectedCategory === 'template') && (
                <div className="space-y-4">
                    <h3 className="text-xl font-bold flex items-center gap-2 text-slate-800">
                        <LayoutGrid className="w-5 h-5 text-slate-500" /> Notion / Sheets 템플릿 ({templates.length})
                    </h3>
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
                        {templates.map(item => (
                            <div key={item.id} onClick={() => setSelectedTemplate(item)} className="cursor-pointer transition-transform hover:scale-[1.02]">
                                <TemplateCard item={item} />
                            </div>
                        ))}
                    </div>
                </div>
            )}

            {/* Designs Section */}
            {designs.length > 0 && (!selectedCategory || selectedCategory === 'design') && (
                <div className="space-y-4">
                    <h3 className="text-xl font-bold flex items-center gap-2 text-slate-800">
                        <ImageIcon className="w-5 h-5 text-slate-500" /> AI 생성 디자인 ({designs.length})
                    </h3>
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        {designs.map(item => (
                            <div key={item.id} onClick={() => setSelectedDesign(item)} className="cursor-pointer transition-transform hover:scale-[1.02]">
                                <DesignCard item={item} />
                            </div>
                        ))}
                    </div>
                </div>
            )}

            {/* Modals */}
            {selectedPrompt && <PromptModal item={selectedPrompt} isOpen={!!selectedPrompt} onClose={() => setSelectedPrompt(null)} />}
            {selectedAgent && <AgentModal item={selectedAgent} isOpen={!!selectedAgent} onClose={() => setSelectedAgent(null)} />}
            {selectedTemplate && <TemplateModal item={selectedTemplate} isOpen={!!selectedTemplate} onClose={() => setSelectedTemplate(null)} />}
            {selectedDesign && <DesignModal item={selectedDesign} isOpen={!!selectedDesign} onClose={() => setSelectedDesign(null)} />}
        </div>
    );
};

export default SearchResults;
