 import { TextareaHTMLAttributes } from "react";

interface TextareaProps extends TextareaHTMLAttributes<HTMLTextAreaElement> {
  label?: string;
}

export const Textarea = ({ label, ...props }: TextareaProps) => {
  return (
    <div className="mb-4">
      {label && <label className="block mb-1 text-sm font-medium">{label}</label>}
      <textarea
        {...props}
        className="w-full px-3 py-2 border rounded focus:outline-none focus:ring focus:ring-blue-300"
      />
    </div>
  );
};
