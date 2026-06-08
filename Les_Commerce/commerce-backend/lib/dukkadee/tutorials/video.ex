defmodule Dukkadee.Tutorials.Video do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dukkadee.Tutorials.Video

  schema "videos" do
    field :title, :string
    field :description, :string
    field :embed_url, :string

    belongs_to :store, Dukkadee.Stores.Store
    many_to_many :products, Dukkadee.Products.Product, join_through: "video_products", on_replace: :delete

    timestamps()
  end

  def changeset(%Video{} = video, attrs) do
    video
    |> cast(attrs, [:title, :description, :embed_url, :store_id])
    |> validate_required([:title, :embed_url, :store_id])
  end
end
