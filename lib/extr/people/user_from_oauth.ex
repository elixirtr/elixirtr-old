defmodule Extr.People.UserFromOAuth do
  @moduledoc false

  alias Ueberauth.Auth

  alias Extr.Repo
  alias Extr.People
  alias Extr.People.User

  def insert_or_update(%Auth{provider: :identity} = auth) do
    case validate_pass(auth.credentials) do
      :ok ->
        create_or_update(auth)

      {:error, reason} ->
        {:error, reason}
    end
  end

  def insert_or_update(%Auth{} = auth) do
    create_or_update(auth)
  end

  def create_or_update(%Auth{} = auth) do
    info = basic_info(auth)

    exist_user = Repo.get_by(User, email: info[:email])

    if exist_user do
      People.create_user(info)
    else
      People.update_user(exist_user, info)
    end

    exist_user
  end

  defp basic_info(auth) do
    %User{
      name: name_from_auth(auth),
      title: description_from_auth(auth),
      email: email_from_auth(auth),
      avatar: avatar_from_auth(auth),
      oauth_uid: auth.uid,
      oauth_provider: auth.provider
    }
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name =
        [auth.info.first_name, auth.info.last_name]
        |> Enum.filter(&(&1 != nil and &1 != ""))

      cond do
        length(name) == 0 -> auth.info.nickname
        true -> Enum.join(name, " ")
      end
    end
  end

  defp email_from_auth(%{info: %{email: email}}), do: email

  defp description_from_auth(%{info: %{description: description}}), do: description

  # github
  defp avatar_from_auth(%{info: %{urls: %{avatar_url: image}}}), do: image

  # gitlab
  defp avatar_from_auth(%{info: %{image: image}}), do: image

  # default case if nothing matches
  defp avatar_from_auth(_auth), do: nil

  defp validate_pass(%{other: %{password: ""}}) do
    {:error, "Password required"}
  end

  defp validate_pass(%{other: %{password: pw, password_confirmation: pw}}) do
    :ok
  end

  defp validate_pass(%{other: %{password: _}}) do
    {:error, "Passwords do not match"}
  end

  defp validate_pass(_), do: {:error, "Password Required"}
end
