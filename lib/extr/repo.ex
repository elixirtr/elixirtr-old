defmodule Extr.Repo do
  use Ecto.Repo,
    otp_app: :extr,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: String.to_integer(System.get_env("SCRIVENER_DEFAULT_PAGE_SIZE")) || 50
end
