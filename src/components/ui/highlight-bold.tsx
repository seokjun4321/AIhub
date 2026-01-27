import React from 'react';

interface HighlightBoldProps {
    text: string | null | undefined;
    className?: string;
}

export const HighlightBold: React.FC<HighlightBoldProps> = ({ text, className = "" }) => {
    if (!text) return null;

    // Split by **...**
    const parts = text.split(/(\*\*.*?\*\*)/g);

    return (
        <span className={className}>
            {parts.map((part, index) => {
                if (part.startsWith('**') && part.endsWith('**')) {
                    // Remove the ** and render as bold
                    return <strong key={index} className="font-bold text-inherit">{part.slice(2, -2)}</strong>;
                }
                return <span key={index}>{part}</span>;
            })}
        </span>
    );
};
