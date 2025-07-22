 import { Dialog } from "@headlessui/react";

interface FormModalProps {
  isOpen: boolean;
  onClose: () => void;
  title: string;
  children: React.ReactNode;
}

export const FormModal = ({ isOpen, onClose, title, children }: FormModalProps) => {
  return (
    <Dialog open={isOpen} onClose={onClose} className="fixed z-50 inset-0 flex items-center justify-center">
      <Dialog.Overlay className="fixed inset-0 bg-black opacity-30" />
      <div className="bg-white p-6 rounded-lg z-10 w-full max-w-lg shadow-xl">
        <Dialog.Title className="text-xl font-semibold mb-4">{title}</Dialog.Title>
        <div>{children}</div>
      </div>
    </Dialog>
  );
};
