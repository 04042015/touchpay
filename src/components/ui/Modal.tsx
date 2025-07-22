import { Dialog } from "@headlessui/react";
import { ReactNode } from "react";

interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  title: string;
  children: ReactNode;
}

export const Modal = ({ isOpen, onClose, title, children }: ModalProps) => {
  return (
    <Dialog open={isOpen} onClose={onClose} className="fixed z-50 inset-0 flex items-center justify-center">
      <Dialog.Overlay className="fixed inset-0 bg-black opacity-40" />
      <div className="bg-white rounded-lg p-6 z-10 w-full max-w-lg">
        <Dialog.Title className="text-lg font-semibold mb-2">{title}</Dialog.Title>
        <div>{children}</div>
      </div>
    </Dialog>
  );
};
