defmodule ExtrWeb.TutorialControllerTest do
  use ExtrWeb.ConnCase

  alias Extr.Resource

  @create_attrs %{body: "some body", image: "some image", title: "some title", url: "some url"}
  @update_attrs %{
    body: "some updated body",
    image: "some updated image",
    title: "some updated title",
    url: "some updated url"
  }
  @invalid_attrs %{body: nil, image: nil, title: nil, url: nil}

  def fixture(:tutorial) do
    {:ok, tutorial} = Resource.create_tutorial(@create_attrs)
    tutorial
  end

  describe "index" do
    test "lists all tutorials", %{conn: conn} do
      conn = get(conn, Routes.tutorial_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Tutorials"
    end
  end

  describe "new tutorial" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.tutorial_path(conn, :new))
      assert html_response(conn, 200) =~ "New Tutorial"
    end
  end

  describe "create tutorial" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.tutorial_path(conn, :create), tutorial: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.tutorial_path(conn, :show, id)

      conn = get(conn, Routes.tutorial_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Tutorial"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.tutorial_path(conn, :create), tutorial: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Tutorial"
    end
  end

  describe "edit tutorial" do
    setup [:create_tutorial]

    test "renders form for editing chosen tutorial", %{conn: conn, tutorial: tutorial} do
      conn = get(conn, Routes.tutorial_path(conn, :edit, tutorial))
      assert html_response(conn, 200) =~ "Edit Tutorial"
    end
  end

  describe "update tutorial" do
    setup [:create_tutorial]

    test "redirects when data is valid", %{conn: conn, tutorial: tutorial} do
      conn = put(conn, Routes.tutorial_path(conn, :update, tutorial), tutorial: @update_attrs)
      assert redirected_to(conn) == Routes.tutorial_path(conn, :show, tutorial)

      conn = get(conn, Routes.tutorial_path(conn, :show, tutorial))
      assert html_response(conn, 200) =~ "some updated body"
    end

    test "renders errors when data is invalid", %{conn: conn, tutorial: tutorial} do
      conn = put(conn, Routes.tutorial_path(conn, :update, tutorial), tutorial: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Tutorial"
    end
  end

  describe "delete tutorial" do
    setup [:create_tutorial]

    test "deletes chosen tutorial", %{conn: conn, tutorial: tutorial} do
      conn = delete(conn, Routes.tutorial_path(conn, :delete, tutorial))
      assert redirected_to(conn) == Routes.tutorial_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.tutorial_path(conn, :show, tutorial))
      end
    end
  end

  defp create_tutorial(_) do
    tutorial = fixture(:tutorial)
    {:ok, tutorial: tutorial}
  end
end
