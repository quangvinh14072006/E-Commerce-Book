import { useState } from "react";
import { MainLayout } from "./components/layouts/MainLayout";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import "./App.css";
import { HomePage } from "./pages/Home/HomePage";
import { LoginPage } from "./pages/Auth/LoginPage";
import { CartPage } from "./pages/Cart/CartPage";
import ProductListPage from "./pages/Product/ProductListPage";

function App() {
  const [count, setCount] = useState(0);

  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<MainLayout />}>
          <Route index element={<HomePage />} />
          <Route path="/login" element={<LoginPage />} />
          <Route path="/cart" element={<CartPage />} />
          <Route path="/product" element={<ProductListPage />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;
