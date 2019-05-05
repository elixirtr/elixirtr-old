defmodule ExtrWeb.PageController do
  use ExtrWeb, :controller

  import Ecto.Query, only: [from: 2]

  alias Extr.Repo
  alias Extr.Resource.Tutorial

  def index(conn, _params) do
    tutorials =
      from(t in Tutorial, order_by: [desc: :inserted_at], limit: 5, preload: [:user])
      |> Repo.all()

    conn
    |> assign(:tutorials, tutorials)
    |> render("index.html")
  end
end
