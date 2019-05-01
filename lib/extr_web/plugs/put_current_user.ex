defmodule ExtrWeb.Plugs.PutCurrentUser do
  import Plug.Conn

  alias Extr.People

  def init(params), do: params

  def call(conn, _params) do
    case get_session(conn, :current_user_id) do
      nil ->
        conn
        |> assign(:current_user, nil)
        |> assign(:user_signed_in?, false)

      id ->
        user = People.get_user!(id)

        conn
        |> assign(:current_user, user)
        |> assign(:user_signed_in?, true)
    end
  end
end
