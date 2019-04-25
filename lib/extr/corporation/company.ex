defmodule Extr.Corporation.Company do
  use Ecto.Schema
  import Ecto.Changeset

  schema "companies" do
    field :logo, :string
    field :name, :string
    field :title, :string
    field :added_by, :id

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :title, :logo])
    |> validate_required([:name, :title, :logo])
  end
end
