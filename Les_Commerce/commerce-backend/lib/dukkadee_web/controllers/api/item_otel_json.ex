defmodule DukkadeeWeb.Api.ItemOtelJSON do
  alias Dukkadee.ItemOtel.Item
  alias Dukkadee.ItemOtel.CareLog
  alias Dukkadee.ItemOtel.Listing

  def index(%{items: items}) do
    %{data: for(item <- items, do: item_data(item))}
  end

  def show(%{item: item}) do
    %{data: item_data(item)}
  end

  def item_data(%Item{} = item) do
    # Schema.org JSON-LD metadata for AI Agent discovery
    json_ld = %{
      "@context" => "https://schema.org",
      "@type" => "Product",
      "name" => item.name,
      "category" => item.category,
      "status" => item.status,
      "storageLocation" => item.storage_location,
      "conditionRating" => item.condition_rating
    }

    %{
      id: item.id,
      owner_identity_id: item.owner_identity_id,
      name: item.name,
      category: item.category,
      status: item.status,
      storage_location: item.storage_location,
      condition_rating: item.condition_rating,
      images: item.images || [],
      care_logs: if(Ecto.assoc_loaded?(item.care_logs), do: for(log <- item.care_logs, do: care_log_data(log)), else: []),
      listing: if(Ecto.assoc_loaded?(item.listing) and item.listing, do: listing_data(item.listing), else: nil),
      schema_metadata: json_ld,
      inserted_at: item.inserted_at,
      updated_at: item.updated_at
    }
  end

  def care_log_data(%CareLog{} = log) do
    %{
      id: log.id,
      care_type: log.care_type,
      notes: log.notes,
      performed_at: log.performed_at,
      provider_id: log.provider_id,
      certificate_id: log.certificate_id,
      inserted_at: log.inserted_at
    }
  end

  def listing_data(%Listing{} = listing) do
    %{
      id: listing.id,
      listing_type: listing.listing_type,
      price_sale: listing.price_sale,
      price_rent_daily: listing.price_rent_daily,
      is_active: listing.is_active,
      inserted_at: listing.inserted_at
    }
  end
end
