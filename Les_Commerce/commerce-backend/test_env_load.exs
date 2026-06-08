# Simple script to test loading of environment variables
# Run with: mix run test_env_load.exs

# Load the modules
Code.require_file("lib/dukkadee/env.ex")

# Load environment variables
case Dukkadee.Env.load_env() do
  {:ok, message} ->
    IO.puts("#{message}")

  {:error, reason} ->
    IO.puts("Error: #{reason}")
end

# Test some environment variables
postgres_user = Dukkadee.Env.get("POSTGRES_USER")
postgres_password = Dukkadee.Env.get("POSTGRES_PASSWORD")
postgres_db = Dukkadee.Env.get("POSTGRES_DB")
port = Dukkadee.Env.get("PORT")

IO.puts("Environment variables loaded:")
IO.puts("POSTGRES_USER: #{postgres_user}")
IO.puts("POSTGRES_PASSWORD: #{String.slice(postgres_password, 0, 3)}*******")
IO.puts("POSTGRES_DB: #{postgres_db}")
IO.puts("PORT: #{port}")

# Test database connection using these values
IO.puts("\nAttempting to connect to database...")

db_config = [
  username: postgres_user,
  password: postgres_password,
  hostname: Dukkadee.Env.get("POSTGRES_HOST") || "localhost",
  database: postgres_db,
  adapter: Ecto.Adapters.Postgres
]

# Only print info for the connection test, not the actual connection
IO.puts("Using config:")
IO.puts("  Username: #{postgres_user}")
IO.puts("  Host: #{Dukkadee.Env.get("POSTGRES_HOST") || "localhost"}")
IO.puts("  Database: #{postgres_db}")
IO.puts("\nTo connect to the database, we would use:")
IO.puts("Ecto.Adapters.Postgres.Connection.connect(#{inspect(db_config)})")
IO.puts("\nThis is a simulation only. Actual connection would require the app to be running.")
