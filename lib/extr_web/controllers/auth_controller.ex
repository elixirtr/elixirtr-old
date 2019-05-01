defmodule ExtrWeb.AuthController do
  @moduledoc false

  use ExtrWeb, :controller

  alias Ueberauth.Strategy.Helpers
  alias Extr.People.UserFromOAuth

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: Routes.user_path(conn, :index))
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case UserFromOAuth.insert_or_update(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, reason} ->
        conn
        |> put_view(ExtrWeb.UserView)
        |> render(:new, changeset: reason)
    end
  end
end
