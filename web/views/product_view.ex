defmodule MarketApi.ProductView do
  use MarketApi.Web, :view

  attributes [:name, :barcode, :image, :price]

  def render("index.json", %{products: products}) do
    %{data: render_many(products, MarketApi.ProductView, "product.json")}
  end

  def render("show.json", %{product: product}) do
    %{data: render_one(product, MarketApi.ProductView, "product.json")}
  end

  def render("product.json", %{product: product}) do
    %{id: product.id,
      name: product.name,
      barcode: product.barcode,
      image: product.image,
      price: product.price,
      market_id: product.market_id}
  end
end
