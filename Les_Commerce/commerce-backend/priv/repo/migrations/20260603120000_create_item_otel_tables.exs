defmodule Dukkadee.Repo.Migrations.CreateItemOtelTables do
  use Ecto.Migration

  def change do
    # items table
    create table(:items) do
      add :owner_identity_id, :string, null: false
      add :name, :string, null: false
      add :category, :string, null: false
      add :status, :string, null: false, default: "in_storage"
      add :storage_location, :string
      add :condition_rating, :integer
      add :images, {:array, :string}, default: []

      timestamps()
    end

    create index(:items, [:owner_identity_id])

    # item_care_logs table
    create table(:item_care_logs) do
      add :item_id, references(:items, on_delete: :delete_all), null: false
      add :care_type, :string, null: false
      add :notes, :text
      add :performed_at, :naive_datetime, null: false
      add :provider_id, :string
      add :certificate_id, :string

      timestamps()
    end

    create index(:item_care_logs, [:item_id])

    # item_listings table
    create table(:item_listings) do
      add :item_id, references(:items, on_delete: :delete_all), null: false
      add :listing_type, :string, null: false
      add :price_sale, :decimal, precision: 10, scale: 2
      add :price_rent_daily, :decimal, precision: 10, scale: 2
      add :is_active, :boolean, default: true, null: false

      timestamps()
    end

    create index(:item_listings, [:item_id])
  end
end
