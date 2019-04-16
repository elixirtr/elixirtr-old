defmodule Extr.PeopleTest do
  use Extr.DataCase

  alias Extr.People

  describe "users" do
    alias Extr.People.User

    @valid_attrs %{
      email: "some@email.com",
      name: "some name",
      password: "some password",
      password_confirmation: "some password",
      title: "some title"
    }
    @update_attrs %{
      email: "some.updated@email.com",
      name: "some updated name",
      password: "some updated password",
      password_confirmation: "some updated password",
      title: "some updated title"
    }
    @invalid_attrs %{email: "foo", name: nil, password: "bar", title: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> People.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert People.list_users() == [%{user | password: nil}]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert People.get_user!(user.id) == %{user | password: nil}
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = People.create_user(@valid_attrs)
      assert user.email == "some@email.com"
      assert user.name == "some name"
      assert Bcrypt.verify_pass("some password", user.password_digest)
      assert user.title == "some title"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = People.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = People.update_user(user, @update_attrs)
      assert user.email == "some.updated@email.com"
      assert user.name == "some updated name"
      assert Bcrypt.verify_pass("some updated password", user.password_digest)
      assert user.title == "some updated title"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = People.update_user(user, @invalid_attrs)
      assert %{user | password: nil} == People.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = People.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> People.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = People.change_user(user)
    end
  end
end
