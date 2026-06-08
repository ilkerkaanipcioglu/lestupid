# priv/repo/migrations/timestamp_create_users.exs
defmodule Dukkadee.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :password_hash, :string, null: false
      add :is_admin, :boolean, default: false

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end

# priv/repo/migrations/timestamp_create_stores.exs
defmodule Dukkadee.Repo.Migrations.CreateStores do
  use Ecto.Migration

  def change do
    create table(:stores) do
      add :name, :string, null: false
      add :slug, :string, null: false
      add :domain, :string
      add :description, :text
      add :logo_url, :string
      add :theme, :string, default: "default"
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:stores, [:slug])
    create unique_index(:stores, [:domain])
    create index(:stores, [:user_id])
  end
end

# priv/repo/migrations/timestamp_create_products.exs
defmodule Dukkadee.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string, null: false
      add :description, :text
      add :price, :decimal, precision: 10, scale: 2, null: false
      add :currency, :string, default: "USD"
      add :images, {:array, :string}, default: []
      add :requires_appointment, :boolean, default: false
      add :is_published, :boolean, default: true
      add :category, :string
      add :tags, {:array, :string}, default: []
      add :store_id, references(:stores, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:products, [:store_id])
    create index(:products, [:category])
  end
end

# priv/repo/migrations/timestamp_create_product_variants.exs
defmodule Dukkadee.Repo.Migrations.CreateProductVariants do
  use Ecto.Migration

  def change do
    create table(:product_variants) do
      add :name, :string, null: false
      add :sku, :string
      add :price, :decimal, precision: 10, scale: 2
      add :options, :map, default: %{}
      add :stock, :integer, default: 0
      add :product_id, references(:products, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:product_variants, [:product_id])
  end
end

# priv/repo/migrations/timestamp_create_appointments.exs
defmodule Dukkadee.Repo.Migrations.CreateAppointments do
  use Ecto.Migration

  def change do
    create table(:appointments) do
      add :start_time, :utc_datetime, null: false
      add :end_time, :utc_datetime, null: false
      add :customer_name, :string, null: false
      add :customer_email, :string, null: false
      add :customer_phone, :string
      add :status, :string, default: "scheduled"
      add :notes, :text
      add :product_id, references(:products, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:appointments, [:product_id])
    create index(:appointments, [:start_time])
  end
end

# priv/repo/migrations/timestamp_create_pages.exs
defmodule Dukkadee.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add :title, :string, null: false
      add :slug, :string, null: false
      add :content, :text
      add :is_published, :boolean, default: true
      add :store_id, references(:stores, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:pages, [:store_id])
    create unique_index(:pages, [:store_id, :slug])
  end
end
