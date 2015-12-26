defmodule MarketApi.ProductTest do
  use MarketApi.ModelCase

  alias MarketApi.Product

  @valid_attrs %{barcode: "some content", image: "some content", name: "some content", price: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Product.changeset(%Product{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Product.changeset(%Product{}, @invalid_attrs)
    refute changeset.valid?
  end
end
