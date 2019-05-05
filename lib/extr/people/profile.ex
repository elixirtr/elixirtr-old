defmodule Extr.People.Profile do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles" do
    field :name, :string
    field :url, :string

    belongs_to :user, Extr.People.User

    timestamps()
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:name, :url, :user_id])
    |> cast_assoc(:user)
    |> validate_required([:name, :url])
  end
end
