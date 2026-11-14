import { Outlet } from "react-router-dom";
import { Header } from "./Header";
import { Footer } from "./Footer";
import { Navbar } from "./Navbar";
export function MainLayout() {
  return (
    <div className="">
      {/* Phần header */}
      <Header />
      <Navbar />
      <main className="">
        <Outlet />
      </main>
      {/* Phần footer */}
      <Footer />
    </div>
  );
}
