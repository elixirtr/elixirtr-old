defmodule Extr.Resource.Tutorial do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tutorials" do
    field :title, :string
    field :body, :string
    field :url, :string
    field :image, :string

    belongs_to(:user, Extr.People.User, foreign_key: :added_by)

    timestamps()
  end

  @doc false
  def changeset(tutorial, attrs) do
    tutorial
    |> cast(attrs, [:title, :body, :image, :url, :added_by])
    |> validate_required([:title, :url, :added_by])
  end
end
