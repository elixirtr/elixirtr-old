defmodule Extr.Corporation.Company do
  use Ecto.Schema
  import Ecto.Changeset

  schema "companies" do
    field :name, :string
    field :title, :string
    field :logo, :string
    field :url, :string

    belongs_to(:user, Extr.People.User, foreign_key: :added_by)

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :title, :logo, :url, :added_by])
    |> cast_assoc(:user)
    |> validate_required([:name, :title, :logo, :url, :added_by])
  end
end
