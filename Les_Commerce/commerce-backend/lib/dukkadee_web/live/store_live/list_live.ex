defmodule DukkadeeWeb.StoreLive.ListLive do
  use DukkadeeWeb, :live_view
  
  alias Dukkadee.Stores
  
  @impl true
  def mount(_params, _session, socket) do
    stores = Stores.list_stores()
    
    {:ok, 
      socket
      |> assign(:page_title, "Available Stores")
      |> assign(:stores, stores)
    }
  end
  
  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white">
      <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 py-12">
        <div class="text-center mb-12">
          <h1 class="text-4xl font-bold tracking-tight text-gray-900">Our Stores</h1>
          <p class="mt-4 text-lg text-gray-600">Browse our collection of stores on Dukkadee platform</p>
        </div>
        
        <div class="grid grid-cols-1 gap-x-8 gap-y-10 sm:grid-cols-2 lg:grid-cols-3">
          <%= for store <- @stores do %>
            <div class="group relative overflow-hidden rounded-lg shadow-lg transition transform hover:-translate-y-1 hover:shadow-xl">
              <div class="h-64 w-full overflow-hidden bg-gray-200">
                <%= if store.logo do %>
                  <img 
                    src={store.logo} 
                    alt={"#{store.name} logo"} 
                    class="h-full w-full object-cover object-center"
                  />
                <% else %>
                  <div class="flex h-full items-center justify-center bg-gradient-to-r from-indigo-500 to-purple-600">
                    <h3 class="text-2xl font-bold text-white"><%= store.name %></h3>
                  </div>
                <% end %>
              </div>
              <div class="p-6 bg-white">
                <h3 class="text-xl font-bold text-gray-900 mb-2"><%= store.name %></h3>
                <p class="text-gray-600 line-clamp-2 mb-4"><%= store.description || "Explore this amazing store" %></p>
                
                <div class="flex justify-between items-center mt-4">
                  <%= if store.primary_color do %>
                    <div class="flex space-x-2">
                      <div class="w-6 h-6 rounded-full" style={"background-color: #{store.primary_color}"}></div>
                      <div class="w-6 h-6 rounded-full" style={"background-color: #{store.secondary_color || "#CCCCCC"}"}></div>
                      <div class="w-6 h-6 rounded-full" style={"background-color: #{store.accent_color || "#999999"}"}></div>
                    </div>
                  <% end %>
                  
                  <a 
                    href={~p"/stores/#{store.slug}"} 
                    class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                  >
                    Visit Store
                  </a>
                </div>
              </div>
            </div>
          <% end %>
        </div>
        
        <%= if @stores == [] do %>
          <div class="text-center mt-10 p-8 bg-white rounded-lg shadow">
            <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
            </svg>
            <p class="mt-2 text-lg font-medium text-gray-900">No stores available yet</p>
            <p class="mt-1 text-gray-500">Be the first to create a store on our platform.</p>
            <div class="mt-6">
              <a
                href="/open_new_store"
                class="inline-flex items-center px-4 py-2 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
              >
                Create your store
              </a>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
