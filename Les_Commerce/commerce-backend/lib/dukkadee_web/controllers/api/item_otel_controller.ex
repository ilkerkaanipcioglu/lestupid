defmodule DukkadeeWeb.Api.ItemOtelController do
  use DukkadeeWeb, :controller

  alias Dukkadee.ItemOtel

  def index(conn, params) do
    owner_identity_id = params["owner_identity_id"] || "student-demo-001"
    items = ItemOtel.list_items(owner_identity_id)
    render(conn, :index, items: items)
  end

  def show(conn, %{"id" => id}) do
    item = ItemOtel.get_item(id)

    if item do
      render(conn, :show, item: item)
    else
      conn
      |> put_status(:not_found)
      |> put_view(DukkadeeWeb.ErrorJSON)
      |> render(:"404")
    end
  end

  def create(conn, %{"item" => item_params}) do
    case ItemOtel.create_item(item_params) do
      {:ok, item} ->
        conn
        |> put_status(:created)
        |> render(:show, item: item)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(DukkadeeWeb.ChangesetJSON)
        |> render(:error, changeset: changeset)
    end
  end

  def request_care(conn, %{"id" => id, "care_type" => care_type} = params) do
    notes = params["notes"]
    provider_id = params["provider_id"] || "Otel Bakım Merkezi"
    certificate_id = params["certificate_id"]

    care_params = %{
      "care_type" => care_type,
      "notes" => notes,
      "provider_id" => provider_id,
      "certificate_id" => certificate_id
    }

    case ItemOtel.add_care_log(id, care_params) do
      {:ok, {updated_item, _care_log}} ->
        conn
        |> put_status(:ok)
        |> render(:show, item: updated_item)

      {:error, _} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Failed to request care"})
    end
  end

  def list_item(conn, %{"id" => id, "listing_type" => listing_type} = params) do
    price_sale = params["price_sale"]
    price_rent_daily = params["price_rent_daily"]

    case ItemOtel.list_item(id, listing_type, price_sale, price_rent_daily) do
      {:ok, {updated_item, _listing}} ->
        conn
        |> put_status(:ok)
        |> render(:show, item: updated_item)

      {:error, _} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Failed to list item"})
    end
  end

  def unlist_item(conn, %{"id" => id}) do
    case ItemOtel.unlist_item(id) do
      {:ok, updated_item} ->
        conn
        |> put_status(:ok)
        |> render(:show, item: updated_item)

      {:error, _} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Failed to unlist item"})
    end
  end

  def recall_item(conn, %{"id" => id}) do
    case ItemOtel.recall_item(id) do
      {:ok, updated_item} ->
        conn
        |> put_status(:ok)
        |> render(:show, item: updated_item)

      {:error, _} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Failed to recall item"})
    end
  end
end
