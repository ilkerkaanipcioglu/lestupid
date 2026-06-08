defmodule Dukkadee.Repo.Migrations.UpdateTestimonialsTable do
  use Ecto.Migration

  def change do
    alter table(:testimonials) do
      add :customer_image, :string
      add :service_type, :string
      add :is_approved, :boolean, default: false
      add :featured, :boolean, default: false
      add :customer_id, references(:customers, on_delete: :nilify_all)
      add :date, :date
    end
  end
end
