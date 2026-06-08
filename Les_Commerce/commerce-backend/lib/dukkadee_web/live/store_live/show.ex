defmodule DukkadeeWeb.StoreLive.Show do
  use DukkadeeWeb, :live_view
  
  alias Dukkadee.Stores
  alias Dukkadee.Products
  
  @impl true
  def mount(%{"slug" => slug}, session, socket) do
    # Find store by slug
    store = Stores.get_store_by_slug!(slug)
    
    # Get featured products for the store
    featured_products = Products.list_featured_products_by_store(store.id, 4)
    
    # Get products by category
    products_by_category = get_products_by_category(store.id)
    
    {:ok, 
      socket
      |> assign(:page_title, store.name)
      |> assign(:store, store) 
      |> assign(:featured_products, featured_products)
      |> assign(:products_by_category, products_by_category)
      |> assign(:current_user_id, session["current_user_id"])
    }
  end
  
  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white">
      <!-- Store Header -->
      <div class="relative overflow-hidden bg-white">
        <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div class="relative z-10 py-8 bg-white sm:pb-16 md:pb-20 lg:w-full lg:max-w-2xl lg:pb-28 xl:pb-32">
            <div class="mt-10 sm:mt-12">
              <div class="flex items-center">
                <%= if @store.logo do %>
                  <img src={@store.logo} alt={@store.name} class="h-16 w-16 rounded-full object-cover mr-4" />
                <% else %>
                  <div class="h-16 w-16 rounded-full flex items-center justify-center mr-4" style={"background-color: #{@store.primary_color || "#fddb24"}"}>
                    <span class="text-white text-2xl font-bold"><%= String.first(@store.name) %></span>
                  </div>
                <% end %>
                <h1 class="text-4xl font-bold tracking-tight text-gray-900 sm:text-5xl md:text-6xl">
                  <%= @store.name %>
                </h1>
              </div>
              <p class="mt-3 text-base text-gray-500 sm:mt-5 sm:text-lg sm:max-w-xl sm:mx-auto md:mt-5 md:text-xl lg:mx-0">
                <%= @store.description %>
              </p>
              <div class="mt-5 sm:mt-8 sm:flex sm:justify-start lg:justify-start">
                <div class="rounded-md shadow">
                  <a href="#products" class="flex w-full items-center justify-center rounded-md border border-transparent bg-indigo-600 px-8 py-3 text-base font-medium text-white hover:bg-indigo-700 md:py-4 md:px-10 md:text-lg">
                    View Products
                  </a>
                </div>
                <%= if current_user_owns_store?(@socket, @store.id) do %>
                  <div class="mt-3 sm:mt-0 sm:ml-3">
                    <.link
                      navigate={~p"/stores/#{@store.id}/admin"}
                      class="flex w-full items-center justify-center rounded-md border border-transparent bg-indigo-100 px-8 py-3 text-base font-medium text-indigo-700 hover:bg-indigo-200 md:py-4 md:px-10 md:text-lg"
                    >
                      Manage Store
                    </.link>
                  </div>
                <% end %>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Featured Products -->
      <%= if length(@featured_products) > 0 do %>
        <div class="bg-white">
          <div class="mx-auto max-w-2xl px-4 py-16 sm:px-6 sm:py-24 lg:max-w-7xl lg:px-8">
            <h2 class="text-2xl font-bold tracking-tight text-gray-900">Featured Products</h2>
            <div class="mt-6 grid grid-cols-1 gap-x-6 gap-y-10 sm:grid-cols-2 lg:grid-cols-4 xl:gap-x-8">
              <%= for product <- @featured_products do %>
                <div class="group relative">
                  <div class="aspect-h-1 aspect-w-1 w-full overflow-hidden rounded-md bg-gray-200 lg:aspect-none group-hover:opacity-75 lg:h-80">
                    <%= if product.images && length(product.images) > 0 do %>
                      <img src={List.first(product.images)} alt={product.name} class="h-full w-full object-cover object-center lg:h-full lg:w-full" />
                    <% else %>
                      <div class="flex h-full items-center justify-center bg-gray-100">
                        <svg class="h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                        </svg>
                      </div>
                    <% end %>
                  </div>
                  <div class="mt-4 flex justify-between">
                    <div>
                      <h3 class="text-sm text-gray-700">
                        <.link navigate={~p"/stores/#{@store.id}/products/#{product.id}"}>
                          <span aria-hidden="true" class="absolute inset-0"></span>
                          <%= product.name %>
                        </.link>
                      </h3>
                      <%= if product.is_marketplace_listed do %>
                        <p class="mt-1 text-sm text-gray-500">
                          <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-blue-100 text-blue-800">
                            In Marketplace
                          </span>
                        </p>
                      <% end %>
                    </div>
                    <p class="text-sm font-medium text-gray-900"><%= product.price %></p>
                  </div>
                </div>
              <% end %>
            </div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
  
  # Helper to check if current user owns the store
  defp current_user_owns_store?(socket, store_id) do
    user_id = socket.assigns.current_user_id
    
    if is_nil(user_id) do
      false
    else
      case Stores.get_store_by_owner(store_id, user_id) do
        nil -> false
        _store -> true
      end
    end
  end
  
  # Helper to get products by category for the store
  defp get_products_by_category(store_id) do
    # Get all categories for the store
    categories = Products.list_categories_by_store(store_id)
    
    # For each category, get products
    Enum.map(categories, fn category ->
      products = Products.list_products_by_category(store_id, category)
      %{
        name: category,
        products: products
      }
    end)
  end
end 