import { ReactNode } from "react";

interface ChapterSectionProps {
  id: string;
  number: number;
  title: string;
  description: string;
  children: ReactNode;
}

export const ChapterSection = ({
  id,
  number,
  title,
  description,
  children,
}: ChapterSectionProps) => {
  return (
    <section id={id} className="scroll-mt-24 bg-card rounded-xl shadow-lg p-8 mb-6">
      <div className="mb-6">
        <div className="flex items-center gap-3 mb-2">
          <span className="bg-primary text-primary-foreground w-8 h-8 rounded-lg flex items-center justify-center text-sm font-bold">
            {number}
          </span>
          <h2 className="text-2xl font-bold text-foreground">{title}</h2>
        </div>
        <p className="text-muted-foreground ml-11">{description}</p>
      </div>
      {children}
    </section>
  );
};

