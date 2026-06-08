defmodule DukkadeeWeb.StoreLive.DiscoveryLive do
  use DukkadeeWeb, :live_view
  alias Dukkadee.Stores
  alias DukkadeeWeb.Components.BrandColors

  @impl true
  def mount(_params, _session, socket) do
    featured_stores = Stores.list_featured_stores()
    
    {:ok, socket
      |> assign(:page_title, "Discover Stores")
      |> assign(:featured_stores, featured_stores)
      |> assign(:search_query, "")
      |> assign(:filter_criteria, %{})
      |> assign(:stores, [])
      |> assign(:page, 1)
      |> assign(:loading, false)
      |> assign(:total_pages, 1)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    page = String.to_integer(params["page"] || "1")
    search_query = params["search"] || ""
    
    socket = 
      socket
      |> assign(:search_query, search_query)
      |> assign(:page, page)
      
    socket =
      if search_query != "" do
        result = Stores.search_stores_paginated(search_query, page: page)
        
        socket
        |> assign(:stores, result.entries)
        |> assign(:total_pages, result.total_pages)
      else
        result = Stores.list_stores_paginated(page: page)
        
        socket
        |> assign(:stores, result.entries)
        |> assign(:total_pages, result.total_pages)
      end
      
    {:noreply, socket}
  end

  @impl true
  def handle_event("search", %{"search_query" => query}, socket) do
    socket = 
      socket
      |> assign(:search_query, query)
      |> assign(:loading, true)
    
    {:noreply, push_patch(socket, to: ~p"/stores/discover?search=#{query}&page=1")}
  end
  
  @impl true
  def handle_event("filter", %{"filter" => criteria}, socket) do
    filter_criteria = for {key, val} <- criteria, val != "", into: %{} do
      {String.to_atom(key), val}
    end
    
    filtered_stores = Stores.filter_stores(filter_criteria)
    
    {:noreply, 
      socket
      |> assign(:filter_criteria, filter_criteria)
      |> assign(:stores, filtered_stores)
      |> assign(:loading, false)
    }
  end
  
  @impl true
  def handle_event("load_more", _, socket) do
    next_page = socket.assigns.page + 1
    
    {:noreply, push_patch(socket, to: ~p"/stores/discover?search=#{socket.assigns.search_query}&page=#{next_page}")}
  end
  
  def store_card(assigns) do
    ~H"""
    <div class="store-card border rounded-lg shadow-md overflow-hidden transition-transform hover:scale-105"
      style={"box-shadow: 0 4px 6px #{rgba_with_opacity(assigns.store.primary_color, 0.2)};"}>
      <div class="h-40 overflow-hidden relative">
        <div class="store-banner w-full h-full bg-gray-100 flex items-center justify-center" 
          style={"background: linear-gradient(135deg, #{assigns.store.primary_color}, #{assigns.store.secondary_color});"}>
          <%= if assigns.store.logo do %>
            <img src={assigns.store.logo} alt={assigns.store.name} class="w-20 h-20 object-contain"/>
          <% else %>
            <div class="text-white text-2xl font-bold"><%= String.slice(assigns.store.name, 0, 1) %></div>
          <% end %>
        </div>
      </div>
      <div class="p-4">
        <h3 class="text-lg font-semibold mb-2" style={"color: #{assigns.store.accent_color};"}><%= assigns.store.name %></h3>
        <p class="text-sm text-gray-600 line-clamp-2 h-10 overflow-hidden">
          <%= assigns.store.description || "No description available" %>
        </p>
        <div class="mt-4 flex justify-between items-center">
          <.link 
            navigate={~p"/stores/#{assigns.store.slug}"} 
            class="px-4 py-2 rounded-md text-white text-sm font-medium transition-colors"
            style={"background-color: #{assigns.store.primary_color}; color: #{contrast_color(assigns.store.primary_color)};"}>
            Visit Store
          </.link>
          <span class="text-xs text-gray-500">
            <%= relative_time(assigns.store.inserted_at) %>
          </span>
        </div>
      </div>
    </div>
    """
  end
  
  defp contrast_color(hex_color) do
    case BrandColors.is_dark_color?(hex_color) do
      true -> "#ffffff"
      false -> "#272727"
    end
  end
  
  defp rgba_with_opacity(hex_color, opacity) do
    {r, g, b} = BrandColors.hex_to_rgb(hex_color)
    "rgba(#{r}, #{g}, #{b}, #{opacity})"
  end
  
  defp relative_time(datetime) do
    now = DateTime.utc_now()
    diff = DateTime.diff(now, datetime, :second)
    
    cond do
      diff < 60 -> "just now"
      diff < 3600 -> "#{div(diff, 60)} minutes ago"
      diff < 86400 -> "#{div(diff, 3600)} hours ago"
      diff < 2_592_000 -> "#{div(diff, 86400)} days ago"
      true -> "#{div(diff, 2_592_000)} months ago"
    end
  end
end
