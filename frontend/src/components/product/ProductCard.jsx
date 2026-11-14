import product from "../../data/product";

const ProductCard = ({ product }) => {
  const formatPrice = (price) => {
    return price.toLocaleString("vi-VN") + "đ";
  };
  return (
    <div className="p-2 bg-pink-100 rounded-2xl ">
      <img src={product.image} alt={product.name} />
      {/* PRODUCT INFO */}
      <div className="">
        <h3 className="font-bold">{product.name}</h3>
        <p>{product.author}</p>
        <p>{product.category}</p>
        <p className="text-yellow-500">{product.rating}</p>
        <p className="font-bold text-red-600">{formatPrice(product.price)}</p>
      </div>
    </div>
  );
};
export default ProductCard;
