defmodule ExtrWeb.TutorialController do
  use ExtrWeb, :controller

  plug ExtrWeb.Plugs.EnsureAuthenticated when action in ~w(new create edit update delete)a

  import Ecto.Query, only: [from: 2]
  alias Extr.Repo
  alias Extr.Resource
  alias Extr.Resource.Tutorial

  def index(conn, params) do
    tutorials =
      from(t in Tutorial, order_by: [desc: :inserted_at], preload: [:user])
      |> Repo.paginate(params)

    render(conn, "index.html", tutorials: tutorials)
  end

  def new(conn, _params) do
    changeset = Resource.change_tutorial(%Tutorial{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tutorial" => tutorial_params}) do
    case Resource.create_tutorial(
           Map.merge(tutorial_params, %{"added_by" => get_session(conn, :current_user_id)})
         ) do
      {:ok, tutorial} ->
        conn
        |> put_flash(:info, "Tutorial created successfully.")
        |> redirect(to: Routes.tutorial_path(conn, :show, tutorial))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    tutorial = Resource.get_tutorial!(id)
    render(conn, "show.html", tutorial: tutorial)
  end

  def edit(conn, %{"id" => id}) do
    tutorial = Resource.get_tutorial!(id)
    changeset = Resource.change_tutorial(tutorial)
    render(conn, "edit.html", tutorial: tutorial, changeset: changeset)
  end

  def update(conn, %{"id" => id, "tutorial" => tutorial_params}) do
    tutorial = Resource.get_tutorial!(id)

    case Resource.update_tutorial(tutorial, tutorial_params) do
      {:ok, tutorial} ->
        conn
        |> put_flash(:info, "Tutorial updated successfully.")
        |> redirect(to: Routes.tutorial_path(conn, :show, tutorial))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", tutorial: tutorial, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tutorial = Resource.get_tutorial!(id)
    {:ok, _tutorial} = Resource.delete_tutorial(tutorial)

    conn
    |> put_flash(:info, "Tutorial deleted successfully.")
    |> redirect(to: Routes.tutorial_path(conn, :index))
  end
end
