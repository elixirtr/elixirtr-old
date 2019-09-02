use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :extr, ExtrWeb.Endpoint,
  secret_key_base: "IlId3O++U4CFl8KoaCutd6wL7+YqtxjaT4OP5teWwD4t/onyVgjUQHut97YlCoYA",
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :extr, Extr.Repo,
  username: "postgres",
  password: "postgres",
  database: "extr_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :bcrypt_elixir, :log_rounds, 4
