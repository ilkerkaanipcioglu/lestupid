defmodule Setup do
  def run do
    IO.puts("Setting up database...")

    # Start Ecto repos
    Dukkadee.Repo.start_link()

    # Create schema_migrations table if it doesn't exist
    Dukkadee.Repo.query!("""
    CREATE TABLE IF NOT EXISTS schema_migrations (
      version bigint PRIMARY KEY,
      inserted_at timestamp(0) NOT NULL DEFAULT now()
    )
    """)

    # Mark all migration files as completed
    migration_files =
      Path.wildcard("priv/repo/migrations/*.exs") ++
        Path.wildcard("priv/repo/store_migrations/*.exs")

    for file <- migration_files do
      version =
        file
        |> Path.basename()
        |> String.split("_")
        |> List.first()
        |> String.to_integer()

      IO.puts("Marking migration #{Path.basename(file)} (#{version}) as completed")

      # Check if migration already exists
      result =
        Dukkadee.Repo.query!(
          "SELECT 1 FROM schema_migrations WHERE version = $1",
          [version]
        )

      if result.num_rows == 0 do
        Dukkadee.Repo.query!(
          "INSERT INTO schema_migrations (version) VALUES ($1)",
          [version]
        )
      else
        IO.puts("  Migration already marked as completed")
      end
    end

    IO.puts("Database setup complete. You can now start the application.")
  end
end

Setup.run()
