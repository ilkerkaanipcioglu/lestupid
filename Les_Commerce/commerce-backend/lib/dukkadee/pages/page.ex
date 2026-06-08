defmodule Dukkadee.Pages.Page do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dukkadee.Pages.Page

  schema "pages" do
    field :title, :string
    field :slug, :string
    field :content, :string
    field :is_published, :boolean, default: true
    
    belongs_to :store, Dukkadee.Stores.Store
    
    timestamps()
  end

  def changeset(%Page{} = page, attrs) do
    page
    |> cast(attrs, [:title, :slug, :content, :is_published, :store_id])
    |> validate_required([:title, :content, :store_id])
    |> generate_slug()
  end
  
  defp generate_slug(%Ecto.Changeset{valid?: true, changes: %{title: title}} = changeset) do
    if get_field(changeset, :slug) do
      changeset
    else
      slug = title 
        |> String.downcase() 
        |> String.replace(~r/[^a-z0-9\s]/, "") 
        |> String.replace(~r/\s+/, "-")
      
      put_change(changeset, :slug, slug)
    end
  end
  
  defp generate_slug(changeset), do: changeset
end
