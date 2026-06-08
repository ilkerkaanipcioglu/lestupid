defmodule Dukkadee.ItemOtel do
  @moduledoc """
  The ItemOtel context.
  """

  import Ecto.Query, warn: false
  alias Dukkadee.Repo
  alias Dukkadee.ItemOtel.{Item, CareLog, Listing}

  @doc """
  Returns the list of items for a specific owner identity.
  Preloads care logs and listing.
  """
  def list_items(owner_identity_id) do
    Item
    |> where([i], i.owner_identity_id == ^owner_identity_id)
    |> preload([:care_logs, :listing])
    |> order_by([i], desc: i.inserted_at)
    |> Repo.all()
  end

  @doc """
  Gets a single item.
  """
  def get_item(id) do
    Item
    |> Repo.get(id)
    |> Repo.preload([:care_logs, :listing])
  end

  @doc """
  Gets a single item or raises an error.
  """
  def get_item!(id) do
    Item
    |> Repo.get!(id)
    |> Repo.preload([:care_logs, :listing])
  end

  @doc """
  Creates an item.
  """
  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, item} -> {:ok, Repo.preload(item, [:care_logs, :listing])}
      error -> error
    end
  end

  @doc """
  Updates an item.
  """
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, item} -> {:ok, Repo.preload(item, [:care_logs, :listing])}
      error -> error
    end
  end

  @doc """
  Deletes an item.
  """
  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  @doc """
  Adds a care log to an item and updates the item's status to "in_maintenance".
  """
  def add_care_log(item_id, attrs \\ %{}) do
    item = get_item!(item_id)
    performed_at = attrs["performed_at"] || NaiveDateTime.utc_now()
    care_log_attrs = Map.put(attrs, "item_id", item.id) |> Map.put("performed_at", performed_at)

    Repo.transaction(fn ->
      {:ok, care_log} =
        %CareLog{}
        |> CareLog.changeset(care_log_attrs)
        |> Repo.insert()

      {:ok, updated_item} =
        item
        |> Item.changeset(%{status: "in_maintenance"})
        |> Repo.update()

      {updated_item, care_log}
    end)
  end

  @doc """
  Lists an item for sale or rent. Creates a listing and updates item status.
  """
  def list_item(item_id, listing_type, price_sale, price_rent_daily) do
    item = get_item!(item_id)

    status =
      case listing_type do
        "sale" -> "listed_for_sale"
        "rent" -> "listed_for_rent"
        "both" -> "listed_for_sale" # map "both" to listed_for_sale or listed_for_rent, we will support both in status
      end

    Repo.transaction(fn ->
      # Remove any existing active listing first to avoid multiple active listings
      if item.listing do
        Repo.delete!(item.listing)
      end

      # Create new listing
      {:ok, listing} =
        %Listing{}
        |> Listing.changeset(%{
          item_id: item.id,
          listing_type: listing_type,
          price_sale: price_sale,
          price_rent_daily: price_rent_daily,
          is_active: true
        })
        |> Repo.insert()

      # Update item status
      {:ok, updated_item} =
        item
        |> Item.changeset(%{status: status})
        |> Repo.update()

      {updated_item, listing}
    end)
  end

  @doc """
  Unlists an item. Deactivates or deletes the listing and returns the item status to "in_storage".
  """
  def unlist_item(item_id) do
    item = get_item!(item_id)

    Repo.transaction(fn ->
      if item.listing do
        Repo.delete!(item.listing)
      end

      {:ok, updated_item} =
        item
        |> Item.changeset(%{status: "in_storage"})
        |> Repo.update()

      updated_item
    end)
  end

  @doc """
  Recalls an item back to its owner. Deactivates listing and sets status to "shipped_back".
  """
  def recall_item(item_id) do
    item = get_item!(item_id)

    Repo.transaction(fn ->
      if item.listing do
        Repo.delete!(item.listing)
      end

      {:ok, updated_item} =
        item
        |> Item.changeset(%{status: "shipped_back", storage_location: nil})
        |> Repo.update()

      updated_item
    end)
  end

  @doc """
  Helper for change changesets.
  """
  def change_item(%Item{} = item, attrs \\ %{}) do
    Item.changeset(item, attrs)
  end
end
