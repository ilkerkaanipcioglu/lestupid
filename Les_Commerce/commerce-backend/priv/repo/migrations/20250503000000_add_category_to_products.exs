defmodule Dukkadee.Repo.Migrations.AddCategoryToProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :category, :string
      add :tags, {:array, :string}, default: []
      add :is_published, :boolean, default: true
      add :requires_appointment, :boolean, default: false
      add :currency, :string, default: "USD"
      add :images, {:array, :string}, default: []
      # Rename marketplace_listed to is_marketplace_listed for consistency
      remove :marketplace_listed
      add :is_marketplace_listed, :boolean, default: false
    end
  end
end
