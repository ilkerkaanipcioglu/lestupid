import Config

config :les_poke_api,
  ecto_repos: [LesPokeApi.Repo],
  generators: [timestamp_type: :utc_datetime]

config :les_poke_api, LesPokeApiWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: LesPokeApiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: LesPokeApi.PubSub,
  live_view: [signing_salt: "les-poke"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
