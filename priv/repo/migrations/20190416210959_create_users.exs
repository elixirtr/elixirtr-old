defmodule Extr.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :title, :string
      add :email, :string
      add :password_digest, :string

      timestamps()
    end

  end
end
