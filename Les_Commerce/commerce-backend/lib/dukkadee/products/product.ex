defmodule Dukkadee.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dukkadee.Products.Product

  schema "products" do
    field :name, :string
    field :description, :string
    field :price, :decimal
    field :currency, :string, default: "USD"
    field :images, {:array, :string}, default: []
    field :requires_appointment, :boolean, default: false
    field :is_published, :boolean, default: true
    field :is_featured, :boolean, default: false
    field :is_marketplace_listed, :boolean, default: false
    field :category, :string
    field :tags, {:array, :string}, default: []
    field :type, :string, default: "finished_good"
    
    belongs_to :store, Dukkadee.Stores.Store
    has_many :variants, Dukkadee.Products.Variant
    has_many :appointments, Dukkadee.Appointments.Appointment
    many_to_many :videos, Dukkadee.Tutorials.Video, join_through: "video_products"
    
    timestamps()
  end

  def changeset(%Product{} = product, attrs) do
    product
    |> cast(attrs, [:name, :description, :price, :currency, :images, :requires_appointment, :is_published, :is_featured, :is_marketplace_listed, :category, :tags, :store_id, :type])
    |> validate_required([:name, :price, :store_id])
    |> validate_number(:price, greater_than_or_equal_to: 0)
    |> validate_inclusion(:type, ["finished_good", "material", "service"])
  end
end
