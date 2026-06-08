defmodule Dukkadee.Repo.Migrations.InklessismoreMigration do
  use Ecto.Migration
  alias Dukkadee.Repo
  alias Dukkadee.Stores
  alias Dukkadee.Stores.Store
  alias Dukkadee.Products
  alias Dukkadee.Products.Product

  def up do
    # Create the store
    {:ok, store} = Stores.create_store(%{
      name: "Inkless Is More",
      slug: "inklessismore-ke",
      description: "Nairobi's Premier Laser Tattoo Removal Studio specializing in advanced PicosureⓇ technology for tattoo removal.",
      primary_color: "#000000",  # Based on their black theme
      secondary_color: "#FFFFFF", # White
      accent_color: "#FF6633",   # Orange accent
      logo_url: "/images/stores/inklessismore/logo.png",
      user_id: 1  # Using user_id instead of owner_id to match schema
    })

    IO.puts("Created store: #{store.name}")

    # Create the products
    create_single_session_product(store.id)
    create_small_tattoo_package(store.id)
    create_medium_tattoo_package(store.id)
    create_unlimited_package(store.id)

    IO.puts("Migration completed successfully")
  end

  def down do
    # Find the store
    case Repo.get_by(Store, slug: "inklessismore-ke") do
      nil -> 
        IO.puts("Store not found")
      
      store ->
        # Delete all products for the store
        store.id
        |> Products.list_store_products()
        |> Enum.each(fn product ->
          Products.delete_product(product)
        end)

        # Delete the store
        Stores.delete_store(store)
        IO.puts("Store and all associated products deleted")
    end
  end

  # Create product: Single Session
  defp create_single_session_product(store_id) do
    {:ok, product} = Products.create_product(%{
      name: "1 Single Laser Tattoo Removal Session",
      description: "A single session of laser tattoo removal using our advanced PicosureⓇ technology. Ideal for those who want to try the service before committing to a package.",
      price: Decimal.new("4500.00"),
      currency: "KES",
      images: [
        "/images/stores/inklessismore/1_session.jpg",
        "/images/stores/inklessismore/BeforeandAfter.jpg"
      ],
      requires_appointment: true,
      is_published: true,
      category: "Tattoo Removal",
      tags: ["single session", "tattoo removal", "laser", "picosure"],
      store_id: store_id
    })

    IO.puts("Created product: #{product.name}")
  end

  # Create product: Small Tattoo Package (3 Sessions)
  defp create_small_tattoo_package(store_id) do
    {:ok, product} = Products.create_product(%{
      name: "3 Laser Tattoo Removal Sessions (small size tattoo)",
      description: "Package of 3 laser tattoo removal sessions, ideal for small-sized tattoos. Save compared to buying individual sessions.",
      price: Decimal.new("10000.00"),
      currency: "KES",
      images: [
        "/images/stores/inklessismore/3sessions.jpg",
        "/images/stores/inklessismore/7eb822a5-2ae0-4739-9065-a5939d4759d9_08acd678-41c1-4aa7-9ccb-9475ea874dcc.jpg"
      ],
      requires_appointment: true,
      is_published: true,
      category: "Tattoo Removal",
      tags: ["package", "small tattoo", "tattoo removal", "laser", "picosure", "3 sessions"],
      store_id: store_id
    })

    IO.puts("Created product: #{product.name}")
  end

  # Create product: Medium Tattoo Package (5 Sessions)
  defp create_medium_tattoo_package(store_id) do
    {:ok, product} = Products.create_product(%{
      name: "5 Laser Tattoo Removal Sessions (medium size tattoo)",
      description: "Package of 5 laser tattoo removal sessions, recommended for medium-sized tattoos. Significant savings compared to individual sessions.",
      price: Decimal.new("15000.00"),
      currency: "KES",
      images: [
        "/images/stores/inklessismore/5sessions.jpg",
        "/images/stores/inklessismore/f2cecfc5-7fbb-4fe8-b36a-58b7ec4003cd.jpg"
      ],
      requires_appointment: true,
      is_published: true,
      category: "Tattoo Removal",
      tags: ["package", "medium tattoo", "tattoo removal", "laser", "picosure", "5 sessions"],
      store_id: store_id
    })

    IO.puts("Created product: #{product.name}")
  end

  # Create product: Unlimited Sessions Package
  defp create_unlimited_package(store_id) do
    {:ok, product} = Products.create_product(%{
      name: "Unlimited Laser Tattoo Removal Sessions Package For Complete Tattoo Removal",
      description: "Our most comprehensive package offering unlimited sessions until your tattoo is completely removed. Perfect for larger or stubborn tattoos that may require multiple treatments.",
      price: Decimal.new("25000.00"),
      currency: "KES",
      images: [
        "/images/stores/inklessismore/Unlimitedsessions.jpg",
        "/images/stores/inklessismore/acf8a6f8-1226-43d7-9a22-11d135947a6c.jpg"
      ],
      requires_appointment: true,
      is_published: true,
      category: "Tattoo Removal",
      tags: ["unlimited", "complete removal", "large tattoo", "tattoo removal", "laser", "picosure"],
      store_id: store_id
    })

    IO.puts("Created product: #{product.name}")
  end
end
