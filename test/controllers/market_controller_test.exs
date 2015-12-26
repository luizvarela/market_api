defmodule MarketApi.MarketControllerTest do
  use MarketApi.ConnCase

  alias MarketApi.Market
  @valid_attrs %{name: "some content", phone: 42}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, market_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    market = Repo.insert! %Market{}
    conn = get conn, market_path(conn, :show, market)
    assert json_response(conn, 200)["data"] == %{"id" => market.id,
      "name" => market.name,
      "phone" => market.phone}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, market_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, market_path(conn, :create), market: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Market, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, market_path(conn, :create), market: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    market = Repo.insert! %Market{}
    conn = put conn, market_path(conn, :update, market), market: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Market, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    market = Repo.insert! %Market{}
    conn = put conn, market_path(conn, :update, market), market: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    market = Repo.insert! %Market{}
    conn = delete conn, market_path(conn, :delete, market)
    assert response(conn, 204)
    refute Repo.get(Market, market.id)
  end
end
