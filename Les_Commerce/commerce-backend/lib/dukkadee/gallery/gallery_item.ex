defmodule Dukkadee.Gallery.GalleryItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "gallery_items" do
    field :title, :string
    field :description, :string
    field :before_image, :string
    field :after_image, :string
    field :category, :string
    field :tattoo_size, :string
    field :tattoo_colors, {:array, :string}
    field :sessions_required, :integer
    field :published, :boolean, default: false
    field :featured, :boolean, default: false
    
    belongs_to :store, Dukkadee.Stores.Store
    
    timestamps()
  end

  def changeset(gallery_item, attrs) do
    gallery_item
    |> cast(attrs, [:title, :description, :before_image, :after_image, :category, :tattoo_size, :tattoo_colors, :sessions_required, :published, :featured, :store_id])
    |> validate_required([:title, :before_image, :after_image, :store_id])
  end
end
