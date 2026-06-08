defmodule Dukkadee.Repo.Migrations.CreateAllTables do
  use Ecto.Migration

  def change do
    # Users table
    create table(:users) do
      add(:email, :string, null: false)
      add(:password_hash, :string, null: false)
      add(:role, :string, default: "user")
      add(:is_admin, :boolean, default: false)
      add(:confirmed_at, :naive_datetime)

      timestamps()
    end

    create(unique_index(:users, [:email]))

    # Stores table
    create table(:stores) do
      add(:name, :string, null: false)
      add(:slug, :string, null: false)
      add(:description, :text)
      add(:logo, :string)
      add(:banner, :string)
      add(:primary_color, :string, default: "#fddb24")
      add(:secondary_color, :string, default: "#b7acd4")
      add(:accent_color, :string, default: "#272727")
      add(:user_id, references(:users, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(unique_index(:stores, [:slug]))
    create(index(:stores, [:user_id]))

    # Products table
    create table(:products) do
      add(:name, :string, null: false)
      add(:description, :text)
      add(:price, :decimal, precision: 10, scale: 2)
      add(:sku, :string)
      add(:stock, :integer, default: 0)
      add(:image, :string)
      add(:is_featured, :boolean, default: false)
      add(:marketplace_listed, :boolean, default: false)
      add(:store_id, references(:stores, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(index(:products, [:store_id]))
    create(unique_index(:products, [:sku, :store_id]))

    # Product variants table
    create table(:product_variants) do
      add(:name, :string, null: false)
      add(:price, :decimal, precision: 10, scale: 2)
      add(:sku, :string)
      add(:stock, :integer, default: 0)
      add(:product_id, references(:products, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(index(:product_variants, [:product_id]))

    # Customers table
    create table(:customers) do
      add(:email, :string, null: false)
      add(:password_hash, :string, null: false)
      add(:first_name, :string)
      add(:last_name, :string)
      add(:phone, :string)

      timestamps()
    end

    create(unique_index(:customers, [:email]))

    # Customer tokens table
    create table(:customer_tokens) do
      add(:token, :binary, null: false)
      add(:context, :string, null: false)
      add(:sent_to, :string)
      add(:customer_id, references(:customers, on_delete: :delete_all), null: false)

      timestamps(updated_at: false)
    end

    create(index(:customer_tokens, [:customer_id]))
    create(unique_index(:customer_tokens, [:context, :token]))

    # Appointments table
    create table(:appointments) do
      add(:date, :date, null: false)
      add(:time, :time, null: false)
      add(:status, :string, default: "pending")
      add(:notes, :text)
      add(:customer_id, references(:customers, on_delete: :nilify_all))
      add(:store_id, references(:stores, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(index(:appointments, [:customer_id]))
    create(index(:appointments, [:store_id]))

    # Add tattoo fields to appointments
    alter table(:appointments) do
      add(:tattoo_description, :text)
      add(:tattoo_size, :string)
      add(:tattoo_location, :string)
    end

    # Pages table
    create table(:pages) do
      add(:title, :string, null: false)
      add(:slug, :string, null: false)
      add(:content, :text)
      add(:store_id, references(:stores, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(index(:pages, [:store_id]))
    create(unique_index(:pages, [:slug, :store_id]))

    # Gallery items table
    create table(:gallery_items) do
      add(:title, :string)
      add(:description, :text)
      add(:image, :string, null: false)
      add(:order, :integer, default: 0)
      add(:store_id, references(:stores, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(index(:gallery_items, [:store_id]))

    # Testimonials table
    create table(:testimonials) do
      add(:name, :string, null: false)
      add(:content, :text, null: false)
      add(:rating, :integer)
      add(:store_id, references(:stores, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(index(:testimonials, [:store_id]))

    # Blog posts table
    create table(:blog_posts) do
      add(:title, :string, null: false)
      add(:slug, :string, null: false)
      add(:content, :text)
      add(:image, :string)
      add(:published, :boolean, default: false)
      add(:store_id, references(:stores, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(index(:blog_posts, [:store_id]))
    create(unique_index(:blog_posts, [:slug, :store_id]))

    # Staff profiles table
    create table(:staff_profiles) do
      add(:name, :string, null: false)
      add(:title, :string)
      add(:bio, :text)
      add(:image, :string)
      add(:order, :integer, default: 0)
      add(:store_id, references(:stores, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(index(:staff_profiles, [:store_id]))

    # Gift certificates table
    create table(:gift_certificates) do
      add(:code, :string, null: false)
      add(:amount, :decimal, precision: 10, scale: 2, null: false)
      add(:remaining_amount, :decimal, precision: 10, scale: 2)
      add(:expires_at, :utc_datetime)
      add(:redeemed_at, :utc_datetime)
      add(:customer_id, references(:customers, on_delete: :nilify_all))
      add(:store_id, references(:stores, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(index(:gift_certificates, [:customer_id]))
    create(index(:gift_certificates, [:store_id]))
    create(unique_index(:gift_certificates, [:code]))

    # Treatments table
    create table(:treatments) do
      add(:name, :string, null: false)
      add(:description, :text)
      add(:duration, :integer)
      add(:price, :decimal, precision: 10, scale: 2)
      add(:store_id, references(:stores, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(index(:treatments, [:store_id]))

    # Treatment sessions table
    create table(:treatment_sessions) do
      add(:date, :date, null: false)
      add(:notes, :text)
      add(:treatment_id, references(:treatments, on_delete: :delete_all), null: false)
      add(:customer_id, references(:customers, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(index(:treatment_sessions, [:treatment_id]))
    create(index(:treatment_sessions, [:customer_id]))

    # Treatment progress table
    create table(:treatment_progress) do
      add(:session_number, :integer, null: false)
      add(:date, :date, null: false)
      add(:notes, :text)
      add(:before_image, :string)
      add(:after_image, :string)
      add(:treatment_id, references(:treatments, on_delete: :delete_all), null: false)
      add(:customer_id, references(:customers, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(index(:treatment_progress, [:treatment_id]))
    create(index(:treatment_progress, [:customer_id]))

    # Import jobs table
    create table(:import_jobs) do
      add(:source, :string, null: false)
      add(:status, :string, default: "pending")
      add(:total_records, :integer, default: 0)
      add(:processed_records, :integer, default: 0)
      add(:store_id, references(:stores, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(index(:import_jobs, [:store_id]))

    # Import reports table
    create table(:import_reports) do
      add(:record_type, :string, null: false)
      add(:record_id, :string)
      add(:status, :string, default: "pending")
      add(:message, :text)
      add(:import_job_id, references(:import_jobs, on_delete: :delete_all), null: false)

      timestamps()
    end

    create(index(:import_reports, [:import_job_id]))
  end
end
