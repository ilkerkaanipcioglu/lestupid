defmodule Dukkadee.Repo do
  use Ecto.Repo,
    otp_app: :dukkadee,
    adapter: if(System.get_env("USE_POSTGRES") == "true" or Mix.env() == :prod, do: Ecto.Adapters.Postgres, else: Ecto.Adapters.SQLite3)

  use Scrivener, page_size: 12
end
