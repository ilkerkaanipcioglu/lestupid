defmodule Dukkadee.Repo.Migrations.AddDiyTablesAndFields do
  use Ecto.Migration

  def change do
    # Add type to products (finished_good, material, service)
    alter table(:products) do
      add :type, :string, default: "finished_good", null: false
    end

    # Videos table (DIY tutorials)
    create table(:videos) do
      add :title, :string, null: false
      add :description, :text
      add :embed_url, :string, null: false
      add :store_id, references(:stores, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:videos, [:store_id])

    # Video products relationship (join table for materials and ready products used in a video)
    create table(:video_products, primary_key: false) do
      add :video_id, references(:videos, on_delete: :delete_all), null: false
      add :product_id, references(:products, on_delete: :delete_all), null: false
    end

    create index(:video_products, [:video_id])
    create index(:video_products, [:product_id])
    create unique_index(:video_products, [:video_id, :product_id])
  end
end
