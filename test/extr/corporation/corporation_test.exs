defmodule Extr.CorporationTest do
  use Extr.DataCase

  alias Extr.Corporation

  describe "companies" do
    alias Extr.Corporation.Company

    @valid_attrs %{logo: "some logo", name: "some name", title: "some title"}
    @update_attrs %{logo: "some updated logo", name: "some updated name", title: "some updated title"}
    @invalid_attrs %{logo: nil, name: nil, title: nil}

    def company_fixture(attrs \\ %{}) do
      {:ok, company} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Corporation.create_company()

      company
    end

    test "list_companies/0 returns all companies" do
      company = company_fixture()
      assert Corporation.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Corporation.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      assert {:ok, %Company{} = company} = Corporation.create_company(@valid_attrs)
      assert company.logo == "some logo"
      assert company.name == "some name"
      assert company.title == "some title"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Corporation.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      assert {:ok, %Company{} = company} = Corporation.update_company(company, @update_attrs)
      assert company.logo == "some updated logo"
      assert company.name == "some updated name"
      assert company.title == "some updated title"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Corporation.update_company(company, @invalid_attrs)
      assert company == Corporation.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Corporation.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Corporation.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Corporation.change_company(company)
    end
  end
end
