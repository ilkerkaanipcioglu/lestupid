import Config

config :les_match_api,
  ecto_repos: [LesMatchApi.Repo],
  generators: [timestamp_type: :utc_datetime]

config :les_match_api, LesMatchApiWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: LesMatchApiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: LesMatchApi.PubSub,
  live_view: [signing_salt: "les-match"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
