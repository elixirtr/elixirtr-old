defmodule Extr.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :name, :string
      add :title, :string
      add :logo, :string
      add :added_by, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:companies, [:added_by])
  end
end
