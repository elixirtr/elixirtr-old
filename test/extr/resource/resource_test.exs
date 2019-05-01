defmodule Extr.ResourceTest do
  use Extr.DataCase

  alias Extr.Resource

  describe "tutorials" do
    alias Extr.Resource.Tutorial

    @valid_attrs %{body: "some body", image: "some image", title: "some title", url: "some url"}
    @update_attrs %{
      body: "some updated body",
      image: "some updated image",
      title: "some updated title",
      url: "some updated url"
    }
    @invalid_attrs %{body: nil, image: nil, title: nil, url: nil}

    def tutorial_fixture(attrs \\ %{}) do
      {:ok, tutorial} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Resource.create_tutorial()

      tutorial
    end

    test "list_tutorials/0 returns all tutorials" do
      tutorial = tutorial_fixture()
      assert Resource.list_tutorials() == [tutorial]
    end

    test "get_tutorial!/1 returns the tutorial with given id" do
      tutorial = tutorial_fixture()
      assert Resource.get_tutorial!(tutorial.id) == tutorial
    end

    test "create_tutorial/1 with valid data creates a tutorial" do
      assert {:ok, %Tutorial{} = tutorial} = Resource.create_tutorial(@valid_attrs)
      assert tutorial.body == "some body"
      assert tutorial.image == "some image"
      assert tutorial.title == "some title"
      assert tutorial.url == "some url"
    end

    test "create_tutorial/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Resource.create_tutorial(@invalid_attrs)
    end

    test "update_tutorial/2 with valid data updates the tutorial" do
      tutorial = tutorial_fixture()
      assert {:ok, %Tutorial{} = tutorial} = Resource.update_tutorial(tutorial, @update_attrs)
      assert tutorial.body == "some updated body"
      assert tutorial.image == "some updated image"
      assert tutorial.title == "some updated title"
      assert tutorial.url == "some updated url"
    end

    test "update_tutorial/2 with invalid data returns error changeset" do
      tutorial = tutorial_fixture()
      assert {:error, %Ecto.Changeset{}} = Resource.update_tutorial(tutorial, @invalid_attrs)
      assert tutorial == Resource.get_tutorial!(tutorial.id)
    end

    test "delete_tutorial/1 deletes the tutorial" do
      tutorial = tutorial_fixture()
      assert {:ok, %Tutorial{}} = Resource.delete_tutorial(tutorial)
      assert_raise Ecto.NoResultsError, fn -> Resource.get_tutorial!(tutorial.id) end
    end

    test "change_tutorial/1 returns a tutorial changeset" do
      tutorial = tutorial_fixture()
      assert %Ecto.Changeset{} = Resource.change_tutorial(tutorial)
    end
  end
end
