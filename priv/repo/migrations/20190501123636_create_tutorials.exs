defmodule Extr.Repo.Migrations.CreateTutorials do
  use Ecto.Migration

  def change do
    create table(:tutorials) do
      add :title, :string
      add :body, :text
      add :image, :string
      add :url, :string
      add :added_by, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:tutorials, [:added_by])
  end
end
