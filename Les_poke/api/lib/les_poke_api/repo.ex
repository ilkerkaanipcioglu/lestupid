defmodule LesPokeApi.Repo do
  use Ecto.Repo,
    otp_app: :les_poke_api,
    adapter: Ecto.Adapters.Postgres
end
