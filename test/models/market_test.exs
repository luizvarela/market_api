defmodule MarketApi.MarketTest do
  use MarketApi.ModelCase

  alias MarketApi.Market

  @valid_attrs %{name: "some content", phone: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Market.changeset(%Market{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Market.changeset(%Market{}, @invalid_attrs)
    refute changeset.valid?
  end
end
