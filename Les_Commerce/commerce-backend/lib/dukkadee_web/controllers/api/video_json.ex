defmodule DukkadeeWeb.Api.VideoJSON do
  alias Dukkadee.Tutorials.Video
  alias DukkadeeWeb.Api.ProductJSON

  def index(%{videos: videos}) do
    %{data: for(video <- videos, do: data(video))}
  end

  def show(%{video: video}) do
    %{data: data(video)}
  end

  def data(%Video{} = video) do
    # Generate schema.org VideoObject JSON-LD linking the tutorial to products used
    products = if Ecto.assoc_loaded?(video.products), do: video.products, else: []
    
    json_ld = %{
      "@context" => "https://schema.org",
      "@type" => "VideoObject",
      "name" => video.title,
      "description" => video.description,
      "embedUrl" => video.embed_url,
      "uploadDate" => video.inserted_at,
      "about" => for(p <- products, do: %{
        "@type" => "Product",
        "name" => p.name,
        "price" => p.price,
        "priceCurrency" => p.currency || "USD"
      })
    }

    %{
      id: video.id,
      title: video.title,
      description: video.description,
      embed_url: video.embed_url,
      store_id: video.store_id,
      schema_metadata: json_ld, # Dynamic JSON-LD mapping
      products: for(p <- products, do: ProductJSON.data(p))
    }
  end
end
