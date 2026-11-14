import React from "react";
import { Link } from "react-router-dom";
export function Header() {
  return (
    <div className="flex justify-between  pt-2 bg-amber-200 pb-2 ">
      {/* LOGO */}
      <Link to="/" className="font-bold">
        BookStore
      </Link>
      {/* SEARCH BAR */}
      <div className="">
        <input
          type="text"
          placeholder="Tìm kiếm sách..."
          className="bg-gray-200 rounded-2xl p-2 mr-2"
        />
        <button className="p-2 bg-red-400 rounded-2xl">Tìm kiếm</button>
      </div>
      <div className="mt-2">
        <Link
          to="/login"
          className="p-3 text-blue-800 cursor-pointer bg-blue-100 rounded-full font-bold mr-2 "
        >
          Đăng nhập
        </Link>
        <Link
          to="/cart"
          className="p-3 text-red-800 font-bold cursor-pointer rounded-full bg-red-100"
        >
          Giỏ hàng
        </Link>
      </div>
    </div>
  );
}
