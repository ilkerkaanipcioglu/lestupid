Code.require_file("lib/dukkadee/env.ex")
Dukkadee.Env.load_env()

# Configure the database
Application.put_env(:dukkadee, Dukkadee.Repo,
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "20911980",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  database: System.get_env("POSTGRES_DB") || "dukkadee_dev",
  stacktrace: true,
  pool_size: 10
)

# Start the Repo
{:ok, _} = Dukkadee.Repo.start_link()

IO.puts("Creating schema_migrations table...")

# Create the schema_migrations table directly
Dukkadee.Repo.query!("""
CREATE TABLE IF NOT EXISTS schema_migrations (
  version bigint PRIMARY KEY,
  inserted_at timestamp(0) NOT NULL DEFAULT now()
);
""")

# Insert a high version number to bypass all migrations
Dukkadee.Repo.query!("""
INSERT INTO schema_migrations (version)
VALUES (99999999999999)
ON CONFLICT (version) DO NOTHING;
""")

IO.puts("Schema migrations table created successfully.")
IO.puts("You can now start the Phoenix server with: mix phx.server")
