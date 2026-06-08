defmodule DukkadeeWeb.HomeLive.Index do
  use DukkadeeWeb, :live_view
  
  alias Dukkadee.Stores
  alias Dukkadee.Products

  @impl true
  def mount(_params, _session, socket) do
    stores = Stores.list_stores()
    featured_products = Products.list_featured_products(8)
    
    # Preload store data for each product
    featured_products = Enum.map(featured_products, fn product ->
      store = Stores.get_store!(product.store_id)
      Map.put(product, :store_name, store.name)
    end)
    
    {:ok, 
      socket
      |> assign(:page_title, "Welcome to Dukkadee")
      |> assign(:stores, stores)
      |> assign(:featured_products, featured_products)
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white">
      <!-- Hero Section -->
      <div class="relative isolate px-6 pt-14 lg:px-8">
        <div class="mx-auto max-w-2xl py-32 sm:py-48 lg:py-56">
          <div class="text-center">
            <h1 class="text-4xl font-bold tracking-tight text-gray-900 sm:text-6xl">
              Create your online store in just 1 minute
            </h1>
            <p class="mt-6 text-lg leading-8 text-gray-600">
              Dukkadee helps you launch your e-commerce business quickly. Import products from Instagram,
              customize your store, and start selling today.
            </p>
            <div class="mt-10 flex items-center justify-center gap-x-6">
              <a
                href="/open_new_store"
                class="rounded-md bg-indigo-600 px-3.5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
              >
                Create your store
              </a>
              <a href="/marketplace" class="text-sm font-semibold leading-6 text-gray-900">
                Browse marketplace <span aria-hidden="true">→</span>
              </a>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Featured Products Section -->
      <%= if length(@featured_products) > 0 do %>
        <div class="bg-white py-16">
          <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
            <div class="text-center">
              <h2 class="text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl">Featured Products</h2>
              <p class="mt-4 text-lg leading-8 text-gray-600">
                Explore our curated selection of products from across our marketplace
              </p>
            </div>
            
            <div class="mt-16 grid grid-cols-1 gap-y-10 gap-x-8 sm:grid-cols-2 lg:grid-cols-4">
              <%= for product <- @featured_products do %>
                <.link navigate={~p"/stores/#{product.store_id}/products/#{product.id}"} class="group">
                  <div class="aspect-w-1 aspect-h-1 w-full overflow-hidden rounded-lg bg-gray-200">
                    <%= if product.images && length(product.images) > 0 do %>
                      <img 
                        src={List.first(product.images)} 
                        alt={product.name} 
                        class="h-full w-full object-cover object-center group-hover:opacity-75"
                      />
                    <% else %>
                      <div class="h-64 w-full flex items-center justify-center bg-gray-100">
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
            
            <div class="text-center mt-12">
              <a 
                href="/marketplace" 
                class="inline-flex items-center rounded-md bg-white px-4 py-2 text-sm font-semibold text-indigo-600 shadow-sm ring-1 ring-inset ring-indigo-300 hover:bg-indigo-50"
              >
                View all products
                <svg class="ml-1 h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                  <path fill-rule="evenodd" d="M7.21 14.77a.75.75 0 01.02-1.06L11.168 10 7.23 6.29a.75.75 0 111.04-1.08l4.5 4.25a.75.75 0 010 1.08l-4.5 4.25a.75.75 0 01-1.06-.02z" clip-rule="evenodd" />
                </svg>
              </a>
            </div>
          </div>
        </div>
      <% end %>
      
      <!-- Available Stores Section -->
      <div class="bg-gray-50 py-16">
        <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <div class="text-center">
            <h2 class="text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl">Available Stores</h2>
            <p class="mt-4 text-lg leading-8 text-gray-600">
              Explore our diverse collection of stores offering unique products and services
            </p>
          </div>
          
          <div class="mt-16 grid grid-cols-1 gap-y-10 gap-x-8 sm:grid-cols-2 lg:grid-cols-3">
            <%= for store <- @stores do %>
              <div class="group relative overflow-hidden rounded-lg shadow-md transition transform hover:scale-105 hover:shadow-lg">
                <div class="h-64 w-full overflow-hidden bg-gray-200">
                  <%= if store.logo do %>
                    <img 
                      src={store.logo} 
                      alt={"#{store.name} logo"} 
                      class="h-full w-full object-cover object-center"
                    />
                  <% else %>
                    <div class="flex h-full items-center justify-center" style={"background-color: #{store.primary_color || "#fddb24"}"}>
                      <h3 class="text-2xl font-bold text-white"><%= store.name %></h3>
                    </div>
                  <% end %>
                </div>
                <div class="p-6 bg-white">
                  <h3 class="text-xl font-bold text-gray-900 mb-2"><%= store.name %></h3>
                  <p class="text-gray-600 line-clamp-2 mb-4"><%= store.description || "Explore this amazing store" %></p>
                  <div class="flex justify-between items-center">
                    <div class="flex space-x-2">
                      <div class="w-4 h-4 rounded-full" style={"background-color: #{store.primary_color || "#fddb24"}"}></div>
                      <div class="w-4 h-4 rounded-full" style={"background-color: #{store.secondary_color || "#b7acd4"}"}></div>
                      <div class="w-4 h-4 rounded-full" style={"background-color: #{store.accent_color || "#272727"}"}></div>
                    </div>
                    <a 
                      href={~p"/stores/#{store.slug}"} 
                      class="inline-flex items-center font-medium text-indigo-600 hover:text-indigo-900"
                    >
                      Visit Store
                      <svg class="ml-1 h-5 w-5" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                        <path fill-rule="evenodd" d="M7.21 14.77a.75.75 0 01.02-1.06L11.168 10 7.23 6.29a.75.75 0 111.04-1.08l4.5 4.25a.75.75 0 010 1.08l-4.5 4.25a.75.75 0 01-1.06-.02z" clip-rule="evenodd" />
                      </svg>
                    </a>
                  </div>
                </div>
              </div>
            <% end %>
          </div>
          
          <%= if @stores == [] do %>
            <div class="text-center mt-10 p-8 bg-white rounded-lg shadow">
              <p class="text-gray-600">No stores available yet. Be the first to create one!</p>
              <div class="mt-6">
                <a
                  href="/open_new_store"
                  class="rounded-md bg-indigo-600 px-3.5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
                >
                  Create your store
                </a>
              </div>
            </div>
          <% end %>
          
          <div class="text-center mt-12">
            <a 
              href="/stores" 
              class="inline-flex items-center rounded-md bg-white px-4 py-2 text-sm font-semibold text-indigo-600 shadow-sm ring-1 ring-inset ring-indigo-300 hover:bg-indigo-50"
            >
              View all stores
              <svg class="ml-1 h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M7.21 14.77a.75.75 0 01.02-1.06L11.168 10 7.23 6.29a.75.75 0 111.04-1.08l4.5 4.25a.75.75 0 010 1.08l-4.5 4.25a.75.75 0 01-1.06-.02z" clip-rule="evenodd" />
              </svg>
            </a>
          </div>
        </div>
      </div>
      
      <!-- Features Section -->
      <div class="bg-white py-16">
        <div class="mx-auto max-w-7xl px-6 lg:px-8">
          <div class="mx-auto max-w-2xl lg:text-center">
            <h2 class="text-base font-semibold leading-7 text-indigo-600">Sell Faster</h2>
            <p class="mt-2 text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl">
              Everything you need to run your online business
            </p>
            <p class="mt-6 text-lg leading-8 text-gray-600">
              Dukkadee provides all the tools you need to create, manage, and grow your online store
            </p>
          </div>
          <div class="mx-auto mt-16 max-w-2xl sm:mt-20 lg:mt-24 lg:max-w-4xl">
            <dl class="grid max-w-xl grid-cols-1 gap-x-8 gap-y-10 lg:max-w-none lg:grid-cols-2 lg:gap-y-16">
              <div class="relative pl-16">
                <dt class="text-base font-semibold leading-7 text-gray-900">
                  <div class="absolute left-0 top-0 flex h-10 w-10 items-center justify-center rounded-lg bg-indigo-600">
                    <svg class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M12 21a9.004 9.004 0 008.716-6.747M12 21a9.004 9.004 0 01-8.716-6.747M12 21c2.485 0 4.5-4.03 4.5-9S14.485 3 12 3m0 18c-2.485 0-4.5-4.03-4.5-9S9.515 3 12 3m0 0a8.997 8.997 0 017.843 4.582M12 3a8.997 8.997 0 00-7.843 4.582m15.686 0A11.953 11.953 0 0112 10.5c-2.998 0-5.74-1.1-7.843-2.918m15.686 0A8.959 8.959 0 0121 12c0 .778-.099 1.533-.284 2.253m0 0A17.919 17.919 0 0112 16.5c-3.162 0-6.133-.815-8.716-2.247m0 0A9.015 9.015 0 013 12c0-1.605.42-3.113 1.157-4.418" />
                    </svg>
                  </div>
                  Fast Store Setup
                </dt>
                <dd class="mt-2 text-base leading-7 text-gray-600">
                  Launch your online store in minutes with our simple setup process and customizable templates
                </dd>
              </div>
              <div class="relative pl-16">
                <dt class="text-base font-semibold leading-7 text-gray-900">
                  <div class="absolute left-0 top-0 flex h-10 w-10 items-center justify-center rounded-lg bg-indigo-600">
                    <svg class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 18.75a60.07 60.07 0 0115.797 2.101c.727.198 1.453-.342 1.453-1.096V18.75M3.75 4.5v.75A.75.75 0 013 6h-.75m0 0v-.375c0-.621.504-1.125 1.125-1.125H20.25M2.25 6v9m18-10.5v.75c0 .414.336.75.75.75h.75m-1.5-1.5h.375c.621 0 1.125.504 1.125 1.125v9.75c0 .621-.504 1.125-1.125 1.125h-.375m1.5-1.5H21a.75.75 0 00-.75.75v.75m0 0H3.75m0 0h-.375a1.125 1.125 0 01-1.125-1.125V15m1.5 1.5v-.75A.75.75 0 003 15h-.75M15 10.5a3 3 0 11-6 0 3 3 0 016 0zm3 0h.008v.008H18V10.5zm-12 0h.008v.008H6V10.5z" />
                    </svg>
                  </div>
                  Secure Payments
                </dt>
                <dd class="mt-2 text-base leading-7 text-gray-600">
                  Integrated payment solutions that work across multiple African countries and currencies
                </dd>
              </div>
              <div class="relative pl-16">
                <dt class="text-base font-semibold leading-7 text-gray-900">
                  <div class="absolute left-0 top-0 flex h-10 w-10 items-center justify-center rounded-lg bg-indigo-600">
                    <svg class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M9.594 3.94c.09-.542.56-.94 1.11-.94h2.593c.55 0 1.02.398 1.11.94l.213 1.281c.063.374.313.686.645.87.074.04.147.083.22.127.324.196.72.257 1.075.124l1.217-.456a1.125 1.125 0 011.37.49l1.296 2.247a1.125 1.125 0 01-.26 1.431l-1.003.827c-.293.24-.438.613-.431.992a6.759 6.759 0 010 .255c-.007.378.138.75.43.99l1.005.828c.424.35.534.954.26 1.43l-1.298 2.247a1.125 1.125 0 01-1.369.491l-1.217-.456c-.355-.133-.75-.072-1.076.124a6.57 6.57 0 01-.22.128c-.331.183-.581.495-.644.869l-.213 1.28c-.09.543-.56.941-1.11.941h-2.594c-.55 0-1.02-.398-1.11-.94l-.213-1.281c-.062-.374-.312-.686-.644-.87a6.52 6.52 0 01-.22-.127c-.325-.196-.72-.257-1.076-.124l-1.217.456a1.125 1.125 0 01-1.369-.49l-1.297-2.247a1.125 1.125 0 01.26-1.431l1.004-.827c.292-.24.437-.613.43-.992a6.932 6.932 0 010-.255c.007-.378-.138-.75-.43-.99l-1.004-.828a1.125 1.125 0 01-.26-1.43l1.297-2.247a1.125 1.125 0 011.37-.491l1.216.456c.356.133.751.072 1.076-.124.072-.044.146-.087.22-.128.332-.183.582-.495.644-.869l.214-1.281z" />
                      <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                    </svg>
                  </div>
                  Customizable Design
                </dt>
                <dd class="mt-2 text-base leading-7 text-gray-600">
                  Create a unique brand identity with our easy-to-use design tools and templates
                </dd>
              </div>
              <div class="relative pl-16">
                <dt class="text-base font-semibold leading-7 text-gray-900">
                  <div class="absolute left-0 top-0 flex h-10 w-10 items-center justify-center rounded-lg bg-indigo-600">
                    <svg class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M10.5 6a7.5 7.5 0 107.5 7.5h-7.5V6z" />
                      <path stroke-linecap="round" stroke-linejoin="round" d="M13.5 10.5H21A7.5 7.5 0 0013.5 3v7.5z" />
                    </svg>
                  </div>
                  Analytics & Insights
                </dt>
                <dd class="mt-2 text-base leading-7 text-gray-600">
                  Track your store's performance with detailed analytics and gain insights to grow your business
                </dd>
              </div>
            </dl>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
