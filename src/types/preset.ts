export interface Preset {
    id: string;
    title: string;
    description: string;
    category: string;
    tag: string;
    price: number;
    isFree: boolean;
    aiModel: string;
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
