defmodule MarketApi.Product do
  use MarketApi.Web, :model

  schema "products" do
    field :name, :string
    field :barcode, :string
    field :image, :string
    field :price, :decimal

    belongs_to :market, MarketApi.Market

    timestamps
  end

  @required_fields ~w(name barcode image price)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
