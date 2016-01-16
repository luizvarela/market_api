defmodule MarketApi.ProductControllerTest do
  use MarketApi.ConnCase

  alias MarketApi.Product
  alias MarketApi.Market

  @valid_attrs %{barcode: "some content", image: "some content", name: "some content", price: "120.5"}
  @invalid_attrs %{name: ""}

  setup %{conn: conn} do
    {:ok, market} = create_market

    {:ok, conn: conn |> put_req_header("accept", "application/vnd.api+json") |> put_req_header("content-type", "application/vnd.api+json"), market: market}
  end

  test "list all entries on index", %{conn: conn, market: market} do
    conn = get conn, market_product_path(conn, :index, market)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn, market: market} do
    product = build_product market
    conn = get conn, market_product_path(conn, :show, market, product)
    assert json_response(conn, 200)["data"] == %{ "attributes" => %{
      "id" => product.id,
      "name" => product.name,
      "barcode" => product.barcode,
      "image" => product.image,
      "price" => Decimal.to_string(product.price),
      "market-id" => product.market_id},
      "id" => Integer.to_string(product.id), "type" => "product"}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn, market: market} do
    assert_error_sent 404, fn ->
      get conn, market_product_path(conn, :show, market, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, market: market} do
    conn = conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")
      |> post market_product_path(conn, :create, market), product: @valid_attrs

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Product, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, market: market} do
    conn = post conn, market_product_path(conn, :create, market), product: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, market: market} do
    product = build_product market
    conn = put conn, market_product_path(conn, :update, market, product), product: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Product, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, market: market} do
    product = build_product market
    conn = put conn, market_product_path(conn, :update, market, product), product: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, market: market} do
    product = build_product market
    conn = delete conn, market_product_path(conn, :delete, market, product)
    assert response(conn, 204)
    refute Repo.get(Product, product.id)
  end

  defp create_market do
    Market.changeset(%Market{}, %{name: "Market Foo", phone: 123})
    |> Repo.insert
  end

  defp build_product(market) do
    changeset =
      market
      |> build(:products)
      |> Product.changeset(@valid_attrs)
    Repo.insert!(changeset)
  end
end
