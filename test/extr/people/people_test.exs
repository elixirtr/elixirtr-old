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

  describe "profiles" do
    alias Extr.People.Profile

    @valid_attrs %{name: "some name", url: "some url"}
    @update_attrs %{name: "some updated name", url: "some updated url"}
    @invalid_attrs %{name: nil, url: nil}

    def profile_fixture(attrs \\ %{}) do
      {:ok, profile} =
        attrs
        |> Enum.into(@valid_attrs)
        |> People.create_profile()

      profile
    end

    test "list_profiles/0 returns all profiles" do
      profile = profile_fixture()
      assert People.list_profiles() == [profile]
    end

    test "get_profile!/1 returns the profile with given id" do
      profile = profile_fixture()
      assert People.get_profile!(profile.id) == profile
    end

    test "create_profile/1 with valid data creates a profile" do
      assert {:ok, %Profile{} = profile} = People.create_profile(@valid_attrs)
      assert profile.name == "some name"
      assert profile.url == "some url"
    end

    test "create_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = People.create_profile(@invalid_attrs)
    end

    test "update_profile/2 with valid data updates the profile" do
      profile = profile_fixture()
      assert {:ok, %Profile{} = profile} = People.update_profile(profile, @update_attrs)
      assert profile.name == "some updated name"
      assert profile.url == "some updated url"
    end

    test "update_profile/2 with invalid data returns error changeset" do
      profile = profile_fixture()
      assert {:error, %Ecto.Changeset{}} = People.update_profile(profile, @invalid_attrs)
      assert profile == People.get_profile!(profile.id)
    end

    test "delete_profile/1 deletes the profile" do
      profile = profile_fixture()
      assert {:ok, %Profile{}} = People.delete_profile(profile)
      assert_raise Ecto.NoResultsError, fn -> People.get_profile!(profile.id) end
    end

    test "change_profile/1 returns a profile changeset" do
      profile = profile_fixture()
      assert %Ecto.Changeset{} = People.change_profile(profile)
    end
  end
end
