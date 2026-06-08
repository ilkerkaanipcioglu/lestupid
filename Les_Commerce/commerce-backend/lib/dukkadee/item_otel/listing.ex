defmodule Dukkadee.ItemOtel.Listing do
  use Ecto.Schema
  import Ecto.Changeset

  schema "item_listings" do
    field :listing_type, :string
    field :price_sale, :decimal
    field :price_rent_daily, :decimal
    field :is_active, :boolean, default: true

    belongs_to :item, Dukkadee.ItemOtel.Item

    timestamps()
  end

  def changeset(listing, attrs) do
    listing
    |> cast(attrs, [:listing_type, :price_sale, :price_rent_daily, :is_active, :item_id])
    |> validate_required([:listing_type, :item_id])
    |> validate_inclusion(:listing_type, ["rent", "sale", "both"])
    |> validate_number(:price_sale, greater_than_or_equal_to: 0)
    |> validate_number(:price_rent_daily, greater_than_or_equal_to: 0)
  end
end
