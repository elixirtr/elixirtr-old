defmodule ExtrWeb.Router do
  use ExtrWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExtrWeb do
    pipe_through :browser

    get "/", PageController, :index

    resources "/users", UserController
    resources "/companies", CompanyController
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExtrWeb do
  #   pipe_through :api
  # end
end
