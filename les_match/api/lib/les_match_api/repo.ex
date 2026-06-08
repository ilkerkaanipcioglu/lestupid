defmodule LesMatchApi.Repo do
  use Ecto.Repo,
    otp_app: :les_match_api,
    adapter: Ecto.Adapters.Postgres
end
