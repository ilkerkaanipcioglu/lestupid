defmodule LesPokeApi.Repo.Migrations.CreateCityQuestFoundation do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS postgis"

    create table(:cities, primary_key: false) do
      add :id, :string, primary_key: true
      add :name, :string, null: false
      add :country, :string, null: false
      add :center, :geometry, null: false

      timestamps(type: :utc_datetime)
    end

    create table(:places, primary_key: false) do
      add :id, :string, primary_key: true
      add :city_id, references(:cities, type: :string, on_delete: :delete_all), null: false
      add :name, :string, null: false
      add :summary, :text
      add :location, :geometry, null: false

      timestamps(type: :utc_datetime)
    end

    create table(:quests, primary_key: false) do
      add :id, :string, primary_key: true
      add :city_id, references(:cities, type: :string, on_delete: :delete_all), null: false
      add :place_id, references(:places, type: :string, on_delete: :nilify_all)
      add :title, :string, null: false
      add :description, :text, null: false
      add :memory, :text
      add :type, :string, null: false
      add :points, :integer, null: false, default: 0
      add :location, :geometry, null: false

      timestamps(type: :utc_datetime)
    end

    create table(:badges, primary_key: false) do
      add :id, :string, primary_key: true
      add :name, :string, null: false
      add :description, :text
      add :criteria, :map, null: false, default: %{}

      timestamps(type: :utc_datetime)
    end

    create table(:completions) do
      add :user_id, :string, null: false
      add :quest_id, references(:quests, type: :string, on_delete: :delete_all), null: false
      add :completed_at, :utc_datetime, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:completions, [:user_id, :quest_id])
    create index(:places, [:city_id])
    create index(:quests, [:city_id])
  end

  def down do
    drop table(:completions)
    drop table(:badges)
    drop table(:quests)
    drop table(:places)
    drop table(:cities)
  end
end
