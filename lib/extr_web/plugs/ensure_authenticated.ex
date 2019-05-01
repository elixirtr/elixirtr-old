defmodule ExtrWeb.Plugs.EnsureAuthenticated do
  import Plug.Conn

  alias ExtrWeb.Router.Helpers, as: Routes

  def init(params), do: params

  def call(conn, _params) do
    case Map.get(Map.get(conn, :assigns), :user_signed_in?) do
      false ->
        conn
        |> Phoenix.Controller.put_flash(:info, "You must be logged in")
        |> Phoenix.Controller.redirect(to: Routes.user_path(conn, :new))
        |> halt()

      true ->
        conn
    end
  end
end
