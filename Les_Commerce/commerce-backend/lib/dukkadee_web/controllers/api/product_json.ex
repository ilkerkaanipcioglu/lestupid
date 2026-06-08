defmodule DukkadeeWeb.Api.ProductJSON do
  alias Dukkadee.Products.Product
  alias Dukkadee.Products.Variant

  def index(%{products: products}) do
    %{data: for(product <- products, do: data(product))}
  end

  def show(%{product: product}) do
    %{data: data(product)}
  end

  def data(%Product{} = product) do
    # Generate schema.org JSON-LD for Agent-Friendly integration
    json_ld = %{
      "@context" => "https://schema.org",
      "@type" => if(product.type == "service", do: "GovernmentService", else: "Product"),
      "name" => product.name,
      "description" => product.description,
      "sku" => nil,
      "offers" => %{
        "@type" => "Offer",
        "price" => product.price,
        "priceCurrency" => product.currency || "USD",
        "availability" => "https://schema.org/InStock"
      }
    }

    %{
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      currency: product.currency,
      images: product.images,
      type: product.type,
      stock: nil,
      category: product.category,
      tags: product.tags,
      store_id: product.store_id,
      schema_metadata: json_ld, # AI Agents can read this structured metadata directly!
      variants: if(Ecto.assoc_loaded?(product.variants), do: for(v <- product.variants, do: variant_data(v)), else: [])
    }
  end

  defp variant_data(%Variant{} = variant) do
    %{
      id: variant.id,
      name: variant.name,
      price: variant.price,
      sku: variant.sku,
      stock: variant.stock
    }
  end
end
