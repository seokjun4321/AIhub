export interface Preset {
    id: string;
    title: string;
    description: string;
    category: string;
    tag: string;
    price: number;
    isFree: boolean;
    aiModel: string;
    imageUrl?: string; // New: For card cover
    rating?: number;   // New: 4.8
    reviewCount?: number; // New: (124)
    creator?: string; // New: "비즈니스팀"
    productType?: string; // New: "프롬프트", "자동화", "Gem"
    overview: {
        summary: string;
        whenToUse: string[];
        expectedResults: string[];
        promptMaster: string;
    };
    examples: {
        before: string;
        after: string;
    }[];
    prompt: {
        content: string;
    };
    variables: {
        guide: Array<{
            name: string;
            description: string;
            example: string;
        }>;
        exampleInput: string;
        usageSteps: string[];
    };
}
