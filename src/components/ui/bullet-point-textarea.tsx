import * as React from "react"
import { Textarea } from "./textarea"

export interface BulletPointTextareaProps
    extends React.TextareaHTMLAttributes<HTMLTextAreaElement> { }

const BulletPointTextarea = React.forwardRef<HTMLTextAreaElement, BulletPointTextareaProps>(
    ({ className, onKeyDown, onChange, onClick, value, ...props }, ref) => {

        // Helper to ensure bullet at start if empty (optional, user might want to start typing first)
        // But request said "bullet points are good". Let's simply handle the Enter key logic primarily.

        const handleKeyDown = (e: React.KeyboardEvent<HTMLTextAreaElement>) => {
            if (e.key === "Enter") {
                e.preventDefault();

                const target = e.currentTarget;
                const start = target.selectionStart;
                const end = target.selectionEnd;
                const currentValue = target.value;

                // Insert \n• at cursor
                const newValue =
                    currentValue.substring(0, start) +
                    "\n• " +
                    currentValue.substring(end);

                const newSelectionStart = start + 3; // \n + • + space

                // Call synthetic onChange
                const nativeInputValueSetter = Object.getOwnPropertyDescriptor(window.HTMLTextAreaElement.prototype, "value")?.set;
                nativeInputValueSetter?.call(target, newValue);

                const event = new Event('input', { bubbles: true });
                target.dispatchEvent(event);

                // Restore cursor
                requestAnimationFrame(() => {
                    target.selectionStart = newSelectionStart;
                    target.selectionEnd = newSelectionStart;
                });

                onKeyDown?.(e);
            } else {
                onKeyDown?.(e);
            }
        };

        const handleFocus = (e: React.FocusEvent<HTMLTextAreaElement>) => {
            // Optional: Auto-insert bullet if completely empty on focus?
            // User request: "When I write content... it would be good to have bullet points"
            // Let's keep it simple: if empty, add "• "
            if (!e.target.value) {
                const target = e.target;
                const newValue = "• ";

                const nativeInputValueSetter = Object.getOwnPropertyDescriptor(window.HTMLTextAreaElement.prototype, "value")?.set;
                nativeInputValueSetter?.call(target, newValue);
                const event = new Event('input', { bubbles: true });
                target.dispatchEvent(event);
            }
            props.onFocus?.(e);
        }

        return (
            <Textarea
                ref={ref}
                onKeyDown={handleKeyDown}
                onFocus={handleFocus}
                value={value}
                onChange={onChange}
                className={className}
                {...props}
            />
        )
    }
)
BulletPointTextarea.displayName = "BulletPointTextarea"

export { BulletPointTextarea }
