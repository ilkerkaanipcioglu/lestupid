alias Dukkadee.Repo
alias Dukkadee.Stores.Store
alias Dukkadee.Accounts.User

# Check if the store exists
store = Repo.get_by(Store, slug: "inklessismore-ke")
IO.puts("Store exists: #{store != nil}")

# If store doesn't exist, create it
if store == nil do
  # Get admin user
  admin = Repo.get_by(User, email: "admin@dukkadee.com")
  
  if admin == nil do
    IO.puts("Admin user doesn't exist, creating...")
    admin = Repo.insert!(%User{
      email: "admin@dukkadee.com",
      password_hash: "temporary_hash_for_development",
      is_admin: true
    })
  end
  
  IO.puts("Creating Inklessismore store...")
  store = Repo.insert!(%Store{
    name: "Inkless Is More",
    slug: "inklessismore-ke",
    description: "Nairobi's Premier Laser Tattoo Removal Studio",
    primary_color: "#fddb24",
    secondary_color: "#b7acd4",
    accent_color: "#272727",
    logo_url: "/images/inklessismore-logo.png",
    owner_id: admin.id
  })
  
  IO.puts("Store created successfully!")
end

# Display store details
if store != nil do
  IO.puts("Store details:")
  IO.puts("  Name: #{store.name}")
  IO.puts("  Slug: #{store.slug}")
  IO.puts("  Description: #{store.description}")
  IO.puts("  Primary Color: #{store.primary_color}")
  IO.puts("  Secondary Color: #{store.secondary_color}")
  IO.puts("  Accent Color: #{store.accent_color}")
end
