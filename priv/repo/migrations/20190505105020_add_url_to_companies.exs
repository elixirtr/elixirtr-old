defmodule Extr.Repo.Migrations.AddUrlToCompanies do
  use Ecto.Migration

  def change do
    alter table(:companies) do
      add :url, :string
    end
  end
end
