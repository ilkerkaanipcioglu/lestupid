import Config

# Configure your database
config :dukkadee, Dukkadee.Repo,
  database: System.get_env("DATABASE_PATH") || Path.expand("../dukkadee_dev.db", __DIR__),
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# Endpoint configuration
config :dukkadee, DukkadeeWeb.Endpoint,
  http: [
    ip: {0, 0, 0, 0},
    port: String.to_integer(System.get_env("PORT") || "4003"),
    protocol_options: [idle_timeout: :infinity]
  ],
  server: true,
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base:
    System.get_env("SECRET_KEY_BASE") ||
      "8Pj9sBJaHg7JaTFxrqxX9DH+bN4dB/BxEV9mDyTTm4KQjwMwV+YT3dstdKFG3Y60",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]}
  ]

# Watch static and templates for browser reloading.
config :dukkadee, DukkadeeWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/dukkadee_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

# Enable dev routes for dashboard and mailbox
config :dukkadee, dev_routes: true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false
