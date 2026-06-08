import Config

config :les_poke_api, LesPokeApi.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "les_poke_api_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :les_poke_api, LesPokeApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "test-secret-key-base-for-local-skeleton-only",
  server: false

config :logger, level: :warning
config :phoenix, :plug_init_mode, :runtime
