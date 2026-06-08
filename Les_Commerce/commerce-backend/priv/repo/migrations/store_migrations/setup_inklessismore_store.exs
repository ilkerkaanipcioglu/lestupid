# Script to set up the Inkless Is More store
# Run with: mix run priv/repo/migrations/store_migrations/setup_inklessismore_store.exs

# First, run the migration to add tattoo fields to appointments
Code.eval_file("priv/repo/migrations/20230815000000_add_tattoo_fields_to_appointments.exs")
IO.puts("Added tattoo fields to appointments table")

# Copy assets from legacy site
Code.eval_file("priv/repo/migrations/store_migrations/copy_inklessismore_assets.exs")
IO.puts("Copied assets from legacy site")

# Create store and products
Code.eval_file("priv/repo/migrations/store_migrations/inklessismore_migration.exs")
IO.puts("Created Inkless Is More store and products")

IO.puts("\n=== Inkless Is More Store Setup Complete ===")
IO.puts("Store is now available at: /stores/inklessismore-ke")
IO.puts("Booking is available at: /stores/inklessismore-ke/book/:product_id")
