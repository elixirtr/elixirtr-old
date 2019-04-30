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
    field :avatar, :string
    field :oauth_uid, :string
    field :oauth_provider, :string

    has_many :profiles, Extr.People.Profile, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def insert_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :title, :email, :password, :avatar, :oauth_uid, :oauth_provider])
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/([\w-\.]+)@((?:[\w]+\.)+)([a-zA-Z]{2,4})/)
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
    |> put_password_digest()
    |> put_gravatar()
  end

  @doc false
  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :title, :email, :password, :avatar])
    |> cast_assoc(:profiles)
    |> validate_required([:email])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/([\w-\.]+)@((?:[\w]+\.)+)([a-zA-Z]{2,4})/)
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
    |> put_password_digest()
    |> put_gravatar()
  end

  defp put_password_digest(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password_digest: Bcrypt.hash_pwd_salt(password))
  end

  defp put_password_digest(changeset), do: changeset

  defp put_gravatar(%Ecto.Changeset{valid?: true, changes: %{email: email}} = changeset) do
    if is_nil(get_field(changeset, :avatar)) do
      change(changeset, avatar: get_gravatar_url(email))
    else
      changeset
    end
  end

  defp put_gravatar(changeset), do: changeset

  defp get_gravatar_url(email) do
    "https://gravatar.com/avatar/" <>
      Base.encode16(:crypto.hash(:md5, email), case: :lower) <> "?s=200"
  end
end
