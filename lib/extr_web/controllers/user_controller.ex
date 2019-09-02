defmodule ExtrWeb.UserController do
  use ExtrWeb, :controller

  import Ecto.Query, only: [from: 2]

  alias Extr.Repo
  alias Extr.People
  alias Extr.People.User

  def index(conn, params) do
    users =
      from(
        u in User,
        order_by:
          fragment(
            "case when ? = ? then 0 else 1 end, ? asc",
            u.id,
            ^get_session(conn, :current_user_id),
            u.name
          ),
        preload: [:profiles]
      )
      |> Repo.paginate(params)

    render(conn, "index.html",
      users: users,
      page_number: users.page_number,
      page_size: users.page_size,
      total_pages: users.total_pages,
      total_entries: users.total_entries
    )
  end

  def new(conn, _params) do
    changeset = People.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case People.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = People.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, _params) do
    user =
      Repo.one(
        from u in User,
          where: u.id == ^Map.get(Map.get(conn.assigns, :current_user, %{}), :id),
          preload: [:profiles]
      )

    changeset = People.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"user" => user_params}) do
    user =
      Repo.one(
        from u in User,
          where: u.id == ^Map.get(Map.get(conn.assigns, :current_user, %{}), :id),
          preload: [:profiles]
      )

    case People.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, _params) do
    user = Map.get(Map.get(conn, :assigns), :current_user)

    case People.delete_user(user) do
      {:ok, _user} ->
        delete_session(conn, :current_user_id)
        Map.drop(conn.assigns, [:current_user, :user_signed_in?])

        conn
        |> put_flash(:info, "User deleted successfully.")
        |> configure_session(drop: true)
        |> redirect(to: Routes.user_path(conn, :index))

      _ ->
        conn
        |> put_flash(:notice, "User could not deleted.")
        |> redirect(to: Routes.user_path(conn, :index))
    end
  end
end
