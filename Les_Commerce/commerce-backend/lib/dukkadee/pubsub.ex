defmodule Dukkadee.PubSub do
  @moduledoc """
  PubSub module for handling real-time updates across the application.
  
  This module provides helper functions to broadcast events to different channels
  and handle subscriptions for real-time features.
  """
  
  @doc """
  Broadcasts a new order event to relevant channels.
  
  ## Parameters
  
  - `order`: The order struct to broadcast
  - `store_id`: The ID of the store the order belongs to
  
  ## Examples
  
      Dukkadee.PubSub.broadcast_new_order(order, store_id)
  
  """
  def broadcast_new_order(order, store_id) do
    # Broadcast to admin dashboard
    Phoenix.PubSub.broadcast(Dukkadee.PubSub, "admin:dashboard", {:new_order, order})
    
    # Broadcast to store-specific channel
    Phoenix.PubSub.broadcast(Dukkadee.PubSub, "store:#{store_id}", {:new_order, order})
    
    # Broadcast to order-specific channel for real-time tracking
    Phoenix.PubSub.broadcast(Dukkadee.PubSub, "order:#{order.id}", {:order_updated, order})
  end
  
  @doc """
  Broadcasts a product update event to relevant channels.
  
  ## Parameters
  
  - `product`: The updated product struct
  - `store_id`: The ID of the store the product belongs to
  
  ## Examples
  
      Dukkadee.PubSub.broadcast_product_update(product, store_id)
  
  """
  def broadcast_product_update(product, store_id) do
    # Broadcast to store-specific channel
    Phoenix.PubSub.broadcast(Dukkadee.PubSub, "store:#{store_id}", {:product_updated, product})
    
    # Broadcast to product-specific channel
    Phoenix.PubSub.broadcast(Dukkadee.PubSub, "product:#{product.id}", {:product_updated, product})
    
    # Broadcast to marketplace channel if product is listed in marketplace
    if product.listed_in_marketplace do
      Phoenix.PubSub.broadcast(Dukkadee.PubSub, "marketplace", {:product_updated, product})
    end
  end
  
  @doc """
  Broadcasts an inventory update event to relevant channels.
  
  ## Parameters
  
  - `product_id`: The ID of the product
  - `store_id`: The ID of the store
  - `new_quantity`: The new inventory quantity
  
  ## Examples
  
      Dukkadee.PubSub.broadcast_inventory_update(product_id, store_id, 5)
  
  """
  def broadcast_inventory_update(product_id, store_id, new_quantity) do
    inventory_data = %{
      product_id: product_id,
      store_id: store_id,
      quantity: new_quantity,
      updated_at: DateTime.utc_now()
    }
    
    # Broadcast to store-specific channel
    Phoenix.PubSub.broadcast(Dukkadee.PubSub, "store:#{store_id}", {:inventory_updated, inventory_data})
    
    # Broadcast to product-specific channel
    Phoenix.PubSub.broadcast(Dukkadee.PubSub, "product:#{product_id}", {:inventory_updated, inventory_data})
    
    # Broadcast low stock alert if necessary
    if new_quantity <= 5 do
      Phoenix.PubSub.broadcast(Dukkadee.PubSub, "admin:dashboard", {:low_stock_alert, inventory_data})
    end
  end
  
  @doc """
  Broadcasts an appointment booking event to relevant channels.
  
  ## Parameters
  
  - `appointment`: The appointment struct
  - `store_id`: The ID of the store
  
  ## Examples
  
      Dukkadee.PubSub.broadcast_appointment_booking(appointment, store_id)
  
  """
  def broadcast_appointment_booking(appointment, store_id) do
    # Broadcast to store-specific channel
    Phoenix.PubSub.broadcast(Dukkadee.PubSub, "store:#{store_id}", {:appointment_booked, appointment})
    
    # Broadcast to user-specific channel
    Phoenix.PubSub.broadcast(Dukkadee.PubSub, "user:#{appointment.user_id}", {:appointment_booked, appointment})
    
    # Broadcast to admin dashboard
    Phoenix.PubSub.broadcast(Dukkadee.PubSub, "admin:dashboard", {:appointment_booked, appointment})
  end
  
  @doc """
  Broadcasts a user presence update to relevant channels.
  
  ## Parameters
  
  - `user_id`: The ID of the user
  - `store_id`: The ID of the store being viewed
  - `status`: The status of the user (e.g., "viewing", "cart", "checkout")
  
  ## Examples
  
      Dukkadee.PubSub.broadcast_user_presence(user_id, store_id, "viewing")
  
  """
  def broadcast_user_presence(user_id, store_id, status) do
    presence_data = %{
      user_id: user_id,
      store_id: store_id,
      status: status,
      timestamp: DateTime.utc_now()
    }
    
    # Broadcast to store-specific channel
    Phoenix.PubSub.broadcast(Dukkadee.PubSub, "store:#{store_id}:presence", {:user_presence, presence_data})
  end
end
