defmodule Extr.Repo.Migrations.AddOuathAttributesToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :avatar, :string
      add :oauth_provider, :string
      add :oauth_uid, :string
    end
  end
end
