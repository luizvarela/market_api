# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     MarketApi.Repo.insert!(%MarketApi.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias MarketApi.Repo
alias MarketApi.Market
alias MarketApi.Product

[
  %Market{
    name: "Market 1",
    phone: 5555555
  },
  %Market{
    name: "Market 2",
    phone: 444444
  },
  %Market{
    name: "Market 3",
    phone: 333333
  }
] |> Enum.each(&Repo.insert!(&1))



products = [
  %{
    name: "Macbook Pro",
    barcode: "23123AAA",
    image: "http://www.image.foo/1.jpg",
    price: Decimal.new(6000)
  },
  %{
    name: "Headset",
    barcode: "TTTYY3AAA",
    image: "http://www.image.foo/2.jpg",
    price: Decimal.new(50)
  },
  %{
    name: "Printer",
    barcode: "7676763AAA",
    image: "http://www.image.foo/3.jpg",
    price: Decimal.new(200)
  },
  %{
    name: "Pendrive",
    barcode: "2FFAAA",
    image: "http://image.foo/4.jpg",
    price: Decimal.new(10)
  },
]

Repo.transaction fn ->
  Repo.all(Market) |> Enum.each(fn(market) ->
    Enum.each(products, fn(product) ->
      new_product = Ecto.build_assoc(market, :products, Map.put(product, :market_id, market.id))
      Repo.insert!(new_product)
    end)
  end)
end
