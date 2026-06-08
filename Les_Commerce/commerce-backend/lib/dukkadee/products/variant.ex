defmodule Dukkadee.Products.Variant do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dukkadee.Products.Variant

  schema "product_variants" do
    field :name, :string
    field :sku, :string
    field :price, :decimal
    field :options, :map, default: %{}
    field :stock, :integer, default: 0
    
    belongs_to :product, Dukkadee.Products.Product
    
    timestamps()
  end

  def changeset(%Variant{} = variant, attrs) do
    variant
    |> cast(attrs, [:name, :sku, :price, :options, :stock, :product_id])
    |> validate_required([:name, :product_id])
    |> validate_number(:price, greater_than_or_equal_to: 0)
    |> validate_number(:stock, greater_than_or_equal_to: 0)
  end
end
