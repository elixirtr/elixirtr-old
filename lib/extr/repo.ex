defmodule Extr.Repo do
  use Ecto.Repo,
    otp_app: :extr,
    adapter: Ecto.Adapters.Postgres
end
