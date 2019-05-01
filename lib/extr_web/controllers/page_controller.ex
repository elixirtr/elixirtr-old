defmodule ExtrWeb.PageController do
  use ExtrWeb, :controller

  alias Extr.Resource

  def index(conn, _params) do
    conn
    |> assign(:tutorials, Resource.list_tutorials())
    |> render("index.html")
  end
end
