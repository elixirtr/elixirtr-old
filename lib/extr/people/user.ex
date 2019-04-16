defmodule Extr.People.User do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_digest, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def insert_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :title, :email, :password])
    |> validate_required([:name, :title, :email, :password])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/([\w-\.]+)@((?:[\w]+\.)+)([a-zA-Z]{2,4})/)
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
    |> put_password_digest()
  end

  @doc false
  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :title, :email, :password])
    |> validate_required([:email])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/([\w-\.]+)@((?:[\w]+\.)+)([a-zA-Z]{2,4})/)
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
    |> put_password_digest()
  end

  defp put_password_digest(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password_digest: Bcrypt.hash_pwd_salt(password))
  end

  defp put_password_digest(changeset) do
    changeset
  end
end
