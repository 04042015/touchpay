import { Tabs } from "@/components/ui/Tabs";

interface TabLayoutProps {
  tabs: string[];
  activeTab: string;
  onTabChange: (tab: string) => void;
  children: React.ReactNode;
}

export const TabLayout = ({ tabs, activeTab, onTabChange, children }: TabLayoutProps) => {
  return (
    <div className="p-4">
      <Tabs tabs={tabs} activeTab={activeTab} onTabChange={onTabChange} />
      <div className="mt-4">{children}</div>
    </div>
  );
};
