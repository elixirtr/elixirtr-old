defmodule Extr.Corporation.Company do
  use Ecto.Schema
  import Ecto.Changeset

  schema "companies" do
    field :logo, :string
    field :name, :string
    field :title, :string

    belongs_to(:user, Extr.People.User, foreign_key: :added_by)

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :title, :added_by])
    |> validate_required([:name, :title, :added_by])
  end
end
