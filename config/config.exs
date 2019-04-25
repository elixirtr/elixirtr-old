# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :extr,
  ecto_repos: [Extr.Repo]

# Configures the endpoint
config :extr, ExtrWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "IlId3O++U4CFl8KoaCutd6wL7+YqtxjaT4OP5teWwD4t/onyVgjUQHut97YlCoYA",
  render_errors: [view: ExtrWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Extr.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Use scrivener_html for generate pagination links
config :scrivener_html, routes_helper: ExtrWeb.Router.Helpers

config :oauth2,
  serializers: %{
    "application/vnd.api+json" => Jason,
    "application/json" => Jason
  }

config :ueberauth, Ueberauth,
  json_library: Jason,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user"]},
    gitlab: {Ueberauth.Strategy.Gitlab, [default_scope: "read_user"]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Gitlab.OAuth,
  client_id: System.get_env("GITLAB_CLIENT_ID"),
  client_secret: System.get_env("GITLAB_CLIENT_SECRET"),
  redirect_uri: System.get_env("GITLAB_REDIRECT_URI")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
