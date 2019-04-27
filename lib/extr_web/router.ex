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

  pipeline :ensure_authenticated do
  end

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  scope "/", ExtrWeb do
    pipe_through :browser

    get "/", PageController, :index

    resources "/users", UserController, except: [:edit, :update, :delete]
    resources "/companies", CompanyController
  end

  scope "/", ExtrWeb do
    pipe_through [:browser, :ensure_authenticated]

    get "/profile", UserController, :edit
    put "/profile", UserController, :update
    delete "/delete", UserController, :delete
    delete "/auth/logout", AuthController, :delete
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
