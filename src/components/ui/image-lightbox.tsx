import { Dialog, DialogContent, DialogOverlay, DialogClose } from "@/components/ui/dialog";
import { X } from "lucide-react";

type ImageLightboxProps = {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  src: string | null;
  alt?: string;
};

export function ImageLightbox({ open, onOpenChange, src, alt }: ImageLightboxProps) {
  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogOverlay />
      <DialogContent
        className="fixed inset-0 left-0 top-0 translate-x-0 translate-y-0 z-50 m-0 max-w-none rounded-md border-0 p-2 sm:p-3 bg-black/92 flex items-center justify-center"
      >
        {src && (
          <img
            src={src}
            alt={alt || "image"}
            className="block max-w-[98vw] sm:max-w-[97vw] max-h-[96vh] sm:max-h-[95vh] object-contain"
            onError={(e) => {
              (e.currentTarget as HTMLImageElement).src = "/placeholder.svg";
            }}
          />
        )}
        <DialogClose
          className="absolute right-4 top-4 inline-flex h-9 w-9 items-center justify-center rounded-full bg-white/15 text-white hover:bg-white/25 focus:outline-none"
          onClick={(e) => e.stopPropagation()}
        >
          <X className="h-5 w-5" />
          <span className="sr-only">Close</span>
        </DialogClose>
      </DialogContent>
    </Dialog>
  );
}


