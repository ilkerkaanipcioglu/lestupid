defmodule Dukkadee.Stores.Store do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stores" do
    field :name, :string
    field :slug, :string
    field :description, :string
    field :primary_color, :string, default: "#fddb24"
    field :secondary_color, :string, default: "#b7acd4"
    field :accent_color, :string, default: "#272727"
    field :logo, :string
    field :banner, :string
    field :domain, :string
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(store, attrs) do
    store
    |> cast(attrs, [:name, :slug, :description, :primary_color, :secondary_color, :accent_color, :logo, :banner, :domain, :user_id])
    |> validate_required([:name, :slug, :user_id])
    |> validate_length(:name, min: 2, max: 100)
    |> validate_length(:slug, min: 2, max: 100)
    |> validate_format(:slug, ~r/^[a-z0-9\-]+$/, message: "must contain only lowercase letters, numbers, and hyphens")
    |> unique_constraint(:slug)
    |> unique_constraint(:domain)
  end
end
