defmodule ExtrWeb.Router do
  use ExtrWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Ueberauth
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

  scope "/auth", ExtrWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExtrWeb do
  #   pipe_through :api
  # end
end
