import Config

config :les_poke_api, LesPokeApi.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "les_poke_api_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :les_poke_api, LesPokeApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "dev-secret-key-base-for-local-skeleton-only"

config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime
