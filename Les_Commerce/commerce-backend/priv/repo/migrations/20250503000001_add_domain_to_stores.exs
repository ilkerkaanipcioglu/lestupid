defmodule Dukkadee.Repo.Migrations.AddDomainToStores do
  use Ecto.Migration

  def change do
    alter table(:stores) do
      add :domain, :string
    end
    
    create unique_index(:stores, [:domain])
  end
end
