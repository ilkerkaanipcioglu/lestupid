defmodule Dukkadee.Repo.Migrations.UpdateAppointmentsTable do
  use Ecto.Migration

  def change do
    drop_if_exists index(:appointments, [:store_id])

    alter table(:appointments) do
      # Remove non-existent columns from schema
      remove :date
      remove :time
      remove :store_id
      remove :tattoo_description
      remove :tattoo_location

      # Add schema columns
      add :start_time, :utc_datetime
      add :end_time, :utc_datetime
      add :customer_name, :string
      add :customer_email, :string
      add :customer_phone, :string
      add :product_id, references(:products, on_delete: :delete_all)
      add :tattoo_age, :string
      add :tattoo_colors, {:array, :string}
    end

    create index(:appointments, [:product_id])
  end
end
