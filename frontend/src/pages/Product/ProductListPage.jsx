import React from "react";
import ProductList from "../../components/product/ProductList";
import products from "../../data/product";

const ProductListPage = () => {
  return (
    <div className="">
      <h1>Sách nổi bật</h1>
      <p>Khám phá những cuốn sách</p>
      <ProductList products={products} />
    </div>
  );
};
export default ProductListPage;
