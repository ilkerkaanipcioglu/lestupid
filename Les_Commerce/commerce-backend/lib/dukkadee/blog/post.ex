defmodule Dukkadee.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dukkadee.Blog.Post

  schema "blog_posts" do
    field :title, :string
    field :slug, :string
    field :content, :string
    field :featured_image, :string
    field :excerpt, :string
    field :published, :boolean, default: false
    field :author, :string
    field :tags, {:array, :string}
    field :published_at, :utc_datetime
    
    belongs_to :store, Dukkadee.Stores.Store
    
    timestamps()
  end

  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:title, :content, :featured_image, :excerpt, :published, :author, :tags, :published_at, :store_id])
    |> validate_required([:title, :content, :store_id])
    |> maybe_generate_slug()
  end
  
  defp maybe_generate_slug(changeset) do
    case get_field(changeset, :slug) do
      nil ->
        title = get_field(changeset, :title)
        
        if title do
          slug = title
                 |> String.downcase()
                 |> String.replace(~r/[^a-z0-9\s-]/, "")
                 |> String.replace(~r/\s+/, "-")
                 |> String.replace(~r/-+/, "-")
                 |> String.trim("-")
          
          put_change(changeset, :slug, slug)
        else
          changeset
        end
        
      _ ->
        changeset
    end
  end
end
