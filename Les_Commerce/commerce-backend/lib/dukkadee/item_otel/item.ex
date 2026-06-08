defmodule Dukkadee.ItemOtel.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :owner_identity_id, :string
    field :name, :string
    field :category, :string
    field :status, :string, default: "in_storage"
    field :storage_location, :string
    field :condition_rating, :integer
    field :images, {:array, :string}, default: []

    has_many :care_logs, Dukkadee.ItemOtel.CareLog
    has_one :listing, Dukkadee.ItemOtel.Listing

    timestamps()
  end

  def changeset(item, attrs) do
    item
    |> cast(attrs, [:owner_identity_id, :name, :category, :status, :storage_location, :condition_rating, :images])
    |> validate_required([:owner_identity_id, :name, :category, :status])
    |> validate_inclusion(:category, ["apparel", "sports", "automotive", "wedding", "other"])
    |> validate_inclusion(:status, ["in_storage", "in_maintenance", "listed_for_rent", "listed_for_sale", "shipped_back", "sold"])
  end
end
