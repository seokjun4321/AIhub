import { useState } from "react";
import { Link } from "react-router-dom";
import {
    MOCK_PROMPTS, MOCK_AGENTS, MOCK_WORKFLOWS, MOCK_TEMPLATES, MOCK_DESIGNS,
    PromptTemplate, AgentItem, TemplateItem, DesignItem
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

    const prompts = filterItems(MOCK_PROMPTS);
    const agents = filterItems(MOCK_AGENTS);
    const workflows = filterItems(MOCK_WORKFLOWS);
    const templates = filterItems(MOCK_TEMPLATES);
    const designs = filterItems(MOCK_DESIGNS);

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
                            <div key={item.id} onClick={() => setSelectedPrompt(item)} className="cursor-pointer transition-transform hover:scale-[1.02]">
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
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
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
