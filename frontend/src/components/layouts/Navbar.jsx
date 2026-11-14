import React from "react";
import { Link } from "react-router-dom";
export function Navbar() {
  return (
    <div className="">
      <div className="flex justify-center pt-3 bg-amber-200">
        <Link
          to="/nav1"
          className="font-bold mr-5 hover:bg-yellow-200 rounded-3xl p-2"
        >
          Industry & Innvovation
        </Link>
        <Link
          to="/nav2"
          className="font-bold mr-5 hover:bg-yellow-200 rounded-3xl p-2"
        >
          Culture
        </Link>
        <Link
          to="/nav3"
          className="font-bold mr-5 hover:bg-yellow-200 rounded-3xl p-2"
        >
          Travel
        </Link>
        <Link
          to="/nav4"
          className="font-bold mr-5 hover:bg-yellow-200 rounded-3xl p-2"
        >
          Food and Drink
        </Link>
        <Link
          to="/nav5"
          className="font-bold mr-5 hover:bg-yellow-200 rounded-3xl p-2"
        >
          Lifestyle
        </Link>
      </div>
    </div>
  );
}
