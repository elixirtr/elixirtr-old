defmodule Extr.Repo do
  use Ecto.Repo,
    otp_app: :extr,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 20
end
