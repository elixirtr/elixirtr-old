defmodule ExtrWeb.Router do
  use ExtrWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ExtrWeb.Plugs.PutCurrentUser
    plug Ueberauth
  end

  pipeline :ensure_authenticated do
    plug ExtrWeb.Plugs.EnsureAuthenticated
  end

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  scope "/", ExtrWeb do
    pipe_through :browser

    get "/", PageController, :index

    scope "/" do
      pipe_through [:ensure_authenticated]

      get "/profile", UserController, :edit
      put "/profile", UserController, :update
      delete "/delete", UserController, :delete
      delete "/auth/logout", AuthController, :delete

      resources "/companies", CompanyController
      resources "/tutorials", TutorialController
    end

    resources "/users", UserController, only: [:index, :show, :new, :create]
    resources "/companies", CompanyController, only: [:index, :show]
    resources "/tutorials", TutorialController, only: [:index, :show]
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
