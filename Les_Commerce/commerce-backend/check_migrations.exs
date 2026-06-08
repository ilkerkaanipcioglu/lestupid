# Run with: mix run check_migrations.exs

# Disable application start
System.put_env("ELIXIR_APP_MODE", "script")

alias Dukkadee.Repo

IO.puts("Checking schema_migrations table...")

case Repo.query("SELECT * FROM schema_migrations ORDER BY version", []) do
  {:ok, result} ->
    IO.puts("Found #{length(result.rows)} migrations")

    Enum.each(result.rows, fn [version, inserted_at] ->
      IO.puts("Version: #{version}, Inserted at: #{inserted_at}")
    end)

  {:error, error} ->
    IO.puts("Error querying schema_migrations: #{inspect(error)}")
end

# List migration files
migration_path = Path.join([File.cwd!(), "priv", "repo", "migrations"])
migration_files = File.ls!(migration_path)

IO.puts("\nMigration files in priv/repo/migrations:")

Enum.each(migration_files, fn file ->
  IO.puts("  #{file}")
end)
