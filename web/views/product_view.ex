defmodule MarketApi.ProductView do
  use MarketApi.Web, :view

  attributes [:id, :name, :barcode, :image, :price, :market_id]

  def render("index.json", %{products: products}) do
    %{data: render_many(products, MarketApi.ProductView, "product.json")}
  end

  def render("show.json", %{product: product}) do
    %{data: render_one(product, MarketApi.ProductView, "product.json")}
  end
end
