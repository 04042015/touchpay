import { UserMenu } from "@/components/common/Header/UserMenu";

export const Header = () => {
  return (
    <header className="flex items-center justify-between bg-white px-4 py-3 shadow-md">
      <h1 className="text-xl font-bold">TouchPay POS</h1>
      <UserMenu />
    </header>
  );
};
