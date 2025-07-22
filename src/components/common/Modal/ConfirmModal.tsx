import { Dialog } from "@headlessui/react";

interface ConfirmModalProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: () => void;
  message: string;
}

export const ConfirmModal = ({ isOpen, onClose, onConfirm, message }: ConfirmModalProps) => {
  return (
    <Dialog open={isOpen} onClose={onClose} className="fixed z-50 inset-0 flex items-center justify-center">
      <Dialog.Overlay className="fixed inset-0 bg-black opacity-30" />
      <div className="bg-white p-6 rounded-lg z-10 w-full max-w-sm shadow-xl">
        <Dialog.Title className="text-lg font-bold mb-4">Konfirmasi</Dialog.Title>
        <p className="mb-4">{message}</p>
        <div className="flex justify-end gap-3">
          <button onClick={onClose} className="px-4 py-2 rounded bg-gray-300">Batal</button>
          <button onClick={onConfirm} className="px-4 py-2 rounded bg-red-500 text-white">Ya</button>
        </div>
      </div>
    </Dialog>
  );
};
