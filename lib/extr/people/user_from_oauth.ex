defmodule Extr.People.UserFromOAuth do
  @moduledoc false

  import Ecto.Query, only: [from: 2]

  alias Ueberauth.Auth

  alias Extr.Repo
  alias Extr.People
  alias Extr.People.User
  alias Extr.People.Profile

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

    case Repo.one(
           from(
             u in User,
             where:
               u.email == ^info.email and u.oauth_provider == ^to_string(auth.provider) and
                 u.oauth_uid == ^to_string(auth.uid)
           )
         ) do
      nil ->
        case People.create_user(info) do
          {:ok, user} ->
            People.create_profile(%{
              name: to_string(auth.provider),
              url: html_url_from_auth(auth),
              user_id: user.id
            })

            {:ok, user}

          {:error, reason} ->
            {:error, reason}
        end

      user ->
        q = from(p in Profile, where: p.user_id == ^user.id, select: fragment("count(?)", p.id))

        if Repo.one(q) == 0 do
          People.create_profile(%{
            name: to_string(auth.provider),
            url: html_url_from_auth(auth),
            user_id: user.id
          })
        end

        {:ok, user}
    end
  end

  defp basic_info(auth) do
    %{
      name: name_from_auth(auth),
      title: description_from_auth(auth),
      email: email_from_auth(auth),
      avatar: avatar_from_auth(auth),
      oauth_uid: to_string(auth.uid),
      oauth_provider: to_string(auth.provider)
    }
  end

  defp name_from_auth(%{info: %{name: name}}) when not is_nil(name), do: name

  defp name_from_auth(auth) do
    name =
      [auth.info.first_name, auth.info.last_name]
      |> Enum.filter(&(&1 != nil and &1 != ""))

    case length(name) do
      0 -> auth.info.nickname
      _ -> Enum.join(name, " ")
    end
  end

  defp email_from_auth(%{info: %{email: email}}), do: email

  defp description_from_auth(%{info: %{description: description}}), do: description

  # github
  defp html_url_from_auth(%{info: %{urls: %{html_url: html_url}}}), do: html_url

  # gitlab
  defp html_url_from_auth(%{info: %{urls: %{web_url: web_url}}}), do: web_url

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
