defmodule DukkadeeWeb.Presence do
  @moduledoc """
  Provides presence tracking for channels and LiveViews.
  
  This module uses Phoenix.Presence to track presence information
  for users in various parts of the application, such as:
  
  - Users viewing a store
  - Users viewing a product
  - Users in a shopping cart or checkout flow
  - Admin users active in the dashboard
  """
  
  use Phoenix.Presence,
    otp_app: :dukkadee,
    pubsub_server: Dukkadee.PubSub

  @doc """
  Tracks a user's presence in a store.
  
  ## Parameters
  
  - `store_id`: The ID of the store being viewed
  - `user_id`: The ID of the user viewing the store
  - `meta`: Additional metadata about the user's presence
  
  ## Examples
  
      DukkadeeWeb.Presence.track_store_presence(store_id, user_id, %{status: "browsing"})
  
  """
  def track_store_presence(store_id, user_id, meta \\ %{}) do
    default_meta = %{
      status: "browsing",
      page: "store",
      joined_at: DateTime.utc_now()
    }
    
    track(
      self(),
      "store:#{store_id}:presence",
      user_id,
      Map.merge(default_meta, meta)
    )
  end
  
  @doc """
  Tracks a user's presence on a product page.
  
  ## Parameters
  
  - `product_id`: The ID of the product being viewed
  - `user_id`: The ID of the user viewing the product
  - `meta`: Additional metadata about the user's presence
  
  ## Examples
  
      DukkadeeWeb.Presence.track_product_presence(product_id, user_id, %{referrer: "search"})
  
  """
  def track_product_presence(product_id, user_id, meta \\ %{}) do
    default_meta = %{
      status: "viewing",
      page: "product",
      joined_at: DateTime.utc_now()
    }
    
    track(
      self(),
      "product:#{product_id}:presence",
      user_id,
      Map.merge(default_meta, meta)
    )
  end
  
  @doc """
  Lists users present in a store.
  
  ## Parameters
  
  - `store_id`: The ID of the store
  
  ## Examples
  
      users = DukkadeeWeb.Presence.list_store_presence(store_id)
  
  """
  def list_store_presence(store_id) do
    list("store:#{store_id}:presence")
  end
  
  @doc """
  Lists users viewing a product.
  
  ## Parameters
  
  - `product_id`: The ID of the product
  
  ## Examples
  
      users = DukkadeeWeb.Presence.list_product_presence(product_id)
  
  """
  def list_product_presence(product_id) do
    list("product:#{product_id}:presence")
  end
  
  @doc """
  Gets the count of users present in a store.
  
  ## Parameters
  
  - `store_id`: The ID of the store
  
  ## Examples
  
      count = DukkadeeWeb.Presence.count_store_presence(store_id)
  
  """
  def count_store_presence(store_id) do
    list("store:#{store_id}:presence")
    |> map_size()
  end
  
  @doc """
  Gets the count of users viewing a product.
  
  ## Parameters
  
  - `product_id`: The ID of the product
  
  ## Examples
  
      count = DukkadeeWeb.Presence.count_product_presence(product_id)
  
  """
  def count_product_presence(product_id) do
    list("product:#{product_id}:presence")
    |> map_size()
  end
end
