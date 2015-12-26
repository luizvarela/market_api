defmodule MarketApi.Repo.Migrations.CreateProduct do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :barcode, :string
      add :image, :string
      add :price, :decimal
      add :market_id, references(:markets)

      timestamps
    end
    create index(:products, [:market_id])

  end
end
