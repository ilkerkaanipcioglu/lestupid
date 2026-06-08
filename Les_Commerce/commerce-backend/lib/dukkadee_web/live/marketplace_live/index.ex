defmodule DukkadeeWeb.MarketplaceLive.Index do
  use DukkadeeWeb, :live_view
  alias Dukkadee.Products
  alias Dukkadee.Stores

  @impl true
  def mount(params, _session, socket) do
    # Get categories for filters
    categories = Products.list_categories()
    
    socket = 
      socket
      |> assign(:page_title, "Marketplace")
      |> assign(:categories, categories)
      |> assign(:selected_category, params["category"])
      |> assign(:search_query, params["q"])
      |> fetch_products(params)
    
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    socket = 
      socket
      |> assign(:selected_category, params["category"])
      |> assign(:search_query, params["q"])
      |> fetch_products(params)
    
    {:noreply, socket}
  end

  defp fetch_products(socket, params) do
    products = 
      case {params["category"], params["q"]} do
        {nil, nil} -> 
          # No filters, get all products
          Products.list_marketplace_products()
        
        {category, nil} when not is_nil(category) -> 
          # Filter by category
          Products.list_products_by_category(category)
        
        {nil, query} when not is_nil(query) -> 
          # Filter by search query
          Products.search_products(query)
        
        {category, query} -> 
          # Filter by both category and search
          Products.search_products_by_category(query, category)
      end
    
    # Preload store data for each product to display store names
    products = Enum.map(products, fn product ->
      store = Stores.get_store!(product.store_id)
      Map.put(product, :store_name, store.name)
    end)
    
    assign(socket, :products, products)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
      <div class="flex justify-between items-center py-6">
        <h1 class="text-2xl font-bold text-gray-900">Global Marketplace</h1>
        <div>
          <form method="get" action={~p"/marketplace"} class="flex gap-2">
            <input 
              type="text" 
              name="q" 
              placeholder="Search products..." 
              value={@search_query}
              class="border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-indigo-500"
            />
            <button type="submit" class="bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-700">
              Search
            </button>
          </form>
        </div>
      </div>

      <div class="flex flex-col md:flex-row gap-6 mb-8">
        <div class="w-full md:w-64 flex-shrink-0">
          <div class="bg-white p-4 rounded-lg shadow">
            <h3 class="font-medium text-gray-900 mb-4">Categories</h3>
            <ul class="space-y-2">
              <li>
                <.link
                  navigate={~p"/marketplace"}
                  class={[
                    "block px-2 py-1 rounded hover:bg-gray-100",
                    is_nil(@selected_category) && "bg-gray-100 font-medium"
                  ]}
                >
                  All Products
                </.link>
              </li>
              <%= for category <- @categories do %>
                <li>
                  <.link
                    navigate={~p"/marketplace/categories/#{category}"}
                    class={[
                      "block px-2 py-1 rounded hover:bg-gray-100",
                      @selected_category == category && "bg-gray-100 font-medium"
                    ]}
                  >
                    <%= category %>
                  </.link>
                </li>
              <% end %>
            </ul>
          </div>
        </div>

        <div class="flex-1">
          <%= if Enum.empty?(@products) do %>
            <div class="bg-white p-8 rounded-lg shadow text-center">
              <h3 class="text-xl font-medium text-gray-900 mb-2">No products found</h3>
              <p class="text-gray-500">
                <%= if @search_query do %>
                  No products match your search query "<%= @search_query %>"
                <% else %>
                  There are no products in this category yet
                <% end %>
              </p>
            </div>
          <% else %>
            <div class="grid grid-cols-1 gap-y-10 gap-x-6 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
              <%= for product <- @products do %>
                <.link navigate={~p"/stores/#{product.store_id}/products/#{product.id}"} class="group">
                  <div class="aspect-w-1 aspect-h-1 w-full overflow-hidden rounded-lg bg-gray-200">
                    <%= if product.images && length(product.images) > 0 do %>
                      <img 
                        src={List.first(product.images)} 
                        alt={product.name} 
                        class="h-full w-full object-cover object-center group-hover:opacity-75"
                      />
                    <% else %>
                      <div class="h-full w-full flex items-center justify-center bg-gray-100">
                        <svg class="h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                        </svg>
                      </div>
                    <% end %>
                  </div>
                  <div class="mt-4">
                    <h3 class="text-sm font-medium text-gray-900"><%= product.name %></h3>
                    <p class="mt-1 text-sm text-gray-500"><%= product.store_name %></p>
                    <div class="mt-1 flex items-center justify-between">
                      <p class="text-sm font-medium text-gray-900">
                        <%= product.currency %> <%= Decimal.to_string(product.price) %>
                      </p>
                      <%= if product.requires_appointment do %>
                        <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-blue-100 text-blue-800">
                          Appointment
                        </span>
                      <% end %>
                    </div>
                  </div>
                </.link>
              <% end %>
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
