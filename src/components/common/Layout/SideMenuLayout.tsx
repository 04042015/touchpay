import { ReactNode } from "react";
import { SideMenu } from "@/components/common/Layout/SideMenu";

interface SideMenuLayoutProps {
  children: ReactNode;
}

export const SideMenuLayout = ({ children }: SideMenuLayoutProps) => {
  return (
    <div className="flex h-screen">
      <SideMenu />
      <main className="flex-1 overflow-auto p-4">{children}</main>
    </div>
  );
};
