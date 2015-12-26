defmodule MarketApi.Repo.Migrations.CreateMarket do
  use Ecto.Migration

  def change do
    create table(:markets) do
      add :name, :string
      add :phone, :integer

      timestamps
    end

  end
end
