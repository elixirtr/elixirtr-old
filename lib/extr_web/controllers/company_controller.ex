defmodule ExtrWeb.CompanyController do
  use ExtrWeb, :controller

  alias Extr.Repo
  alias Extr.Corporation
  alias Extr.Corporation.Company

  def index(conn, params) do
    companies =
      Company
      |> Repo.paginate(params)

    render(conn, "index.html",
      companies: companies,
      page_number: companies.page_number,
      page_size: companies.page_size,
      total_pages: companies.total_pages,
      total_entries: companies.total_entries
    )
  end

  def new(conn, _params) do
    changeset = Corporation.change_company(%Company{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"company" => company_params}) do
    case Corporation.create_company(company_params) do
      {:ok, company} ->
        conn
        |> put_flash(:info, "Company created successfully.")
        |> redirect(to: Routes.company_path(conn, :show, company))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    company = Corporation.get_company!(id)
    render(conn, "show.html", company: company)
  end

  def edit(conn, %{"id" => id}) do
    company = Corporation.get_company!(id)
    changeset = Corporation.change_company(company)
    render(conn, "edit.html", company: company, changeset: changeset)
  end

  def update(conn, %{"id" => id, "company" => company_params}) do
    company = Corporation.get_company!(id)

    case Corporation.update_company(company, company_params) do
      {:ok, company} ->
        conn
        |> put_flash(:info, "Company updated successfully.")
        |> redirect(to: Routes.company_path(conn, :show, company))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", company: company, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    company = Corporation.get_company!(id)
    {:ok, _company} = Corporation.delete_company(company)

    conn
    |> put_flash(:info, "Company deleted successfully.")
    |> redirect(to: Routes.company_path(conn, :index))
  end
end
