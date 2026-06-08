defmodule DukkadeeWeb.StoreLive.ShowLive do
  use DukkadeeWeb, :live_view
  
  alias Dukkadee.Stores
  alias Dukkadee.Products
  alias Dukkadee.Testimonials
  alias DukkadeeWeb.Components.BrandColors
  
  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    case Stores.get_store_by_slug(slug) do
      nil ->
        {:ok, 
          socket
          |> put_flash(:error, "Store not found")
          |> redirect(to: ~p"/stores")
        }
      
      store ->
        featured_products = Products.list_featured_products_by_store(store.id, 4)
        store_categories = Products.list_categories_by_store(store.id)
        recent_testimonials = Testimonials.list_recent_testimonials_by_store(store.id, 3)
        
        {:ok, 
          socket
          |> assign(:page_title, store.name)
          |> assign(:store, store)
          |> assign(:featured_products, featured_products)
          |> assign(:store_categories, store_categories)
          |> assign(:testimonials, recent_testimonials)
          |> assign(:primary_color, store.primary_color || "#fddb24")
          |> assign(:secondary_color, store.secondary_color || "#b7acd4")
          |> assign(:accent_color, store.accent_color || "#272727")
          |> assign(:text_color, BrandColors.contrasting_text_color(store.primary_color || "#fddb24"))
        }
    end
  end
  
  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <!-- Hero section with store branding -->
      <div style={"background-color: #{@primary_color}; color: #{@text_color}"}>
        <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 py-12">
          <div class="flex justify-between items-center">
            <div class="max-w-2xl">
              <h1 class="text-4xl font-bold tracking-tight"><%= @store.name %></h1>
              <p class="mt-4 text-lg"><%= @store.description %></p>
              
              <div class="mt-6">
                <a 
                  href={~p"/stores/#{@store.slug}/shop"}
                  class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm"
                  style={"background-color: #{@accent_color}; color: #{BrandColors.contrasting_text_color(@accent_color)}"}
                >
                  Shop Now
                </a>
              </div>
            </div>
            
            <div>
              <%= if @store.logo do %>
                <img 
                  src={@store.logo} 
                  alt={"#{@store.name} logo"} 
                  class="w-48 h-48 object-contain rounded-lg shadow-md bg-white p-4"
                />
              <% else %>
                <div 
                  class="w-48 h-48 rounded-lg shadow-md flex items-center justify-center"
                  style={"background-color: #{@secondary_color}; color: #{BrandColors.contrasting_text_color(@secondary_color)}"}
                >
                  <h3 class="text-3xl font-bold"><%= @store.name |> String.slice(0, 2) |> String.upcase() %></h3>
                </div>
              <% end %>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Store navigation -->
      <div class="bg-white shadow-sm border-b">
        <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
          <nav class="flex space-x-8 py-4 overflow-x-auto">
            <a 
              href={~p"/stores/#{@store.slug}/shop"}
              class="text-gray-700 hover:text-gray-900 px-3 py-2 text-sm font-medium"
              style={"border-bottom: 2px solid #{@primary_color}"}
            >
              All Products
            </a>
            
            <%= for category <- @store_categories do %>
              <a 
                href={~p"/stores/#{@store.slug}/shop/category/#{category}"}
                class="text-gray-700 hover:text-gray-900 px-3 py-2 text-sm font-medium"
              >
                <%= category %>
              </a>
            <% end %>
            
            <a 
              href={~p"/stores/#{@store.slug}/about"}
              class="text-gray-700 hover:text-gray-900 px-3 py-2 text-sm font-medium"
            >
              About
            </a>
            
            <a 
              href={~p"/stores/#{@store.slug}/contact"}
              class="text-gray-700 hover:text-gray-900 px-3 py-2 text-sm font-medium"
            >
              Contact
            </a>
          </nav>
        </div>
      </div>
      
      <!-- Featured products section -->
      <div class="bg-white">
        <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 py-12">
          <h2 class="text-2xl font-bold text-gray-900 mb-8">Featured Products</h2>
          
          <%= if Enum.empty?(@featured_products) do %>
            <div class="text-center py-12 px-6 border rounded-lg">
              <p class="text-gray-500">This store doesn't have any featured products yet.</p>
            </div>
          <% else %>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
              <%= for product <- @featured_products do %>
                <div class="bg-white rounded-lg shadow overflow-hidden hover:shadow-md transition-shadow">
                  <div class="aspect-w-1 aspect-h-1 bg-gray-200 overflow-hidden">
                    <%= if Enum.at(product.images, 0) do %>
                      <img 
                        src={Enum.at(product.images, 0)} 
                        alt={product.name}
                        class="w-full h-full object-center object-cover"
                      />
                    <% else %>
                      <div class="w-full h-full flex items-center justify-center bg-gray-100">
                        <svg class="w-12 h-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                        </svg>
                      </div>
                    <% end %>
                  </div>
                  
                  <div class="p-4">
                    <h3 class="text-lg font-medium text-gray-900 truncate"><%= product.name %></h3>
                    <p class="mt-1 text-gray-500 text-sm line-clamp-2"><%= product.description %></p>
                    <div class="mt-3 flex justify-between items-center">
                      <p class="font-medium text-gray-900"><%= product.currency %> <%= product.price %></p>
                      <a 
                        href={~p"/stores/#{@store.slug}/products/#{product.id}"}
                        class="inline-flex items-center px-3 py-1 border border-transparent text-sm font-medium rounded-md"
                        style={"background-color: #{@primary_color}; color: #{@text_color}"}
                      >
                        View
                      </a>
                    </div>
                  </div>
                </div>
              <% end %>
            </div>
            
            <div class="mt-8 text-center">
              <a 
                href={~p"/stores/#{@store.slug}/shop"}
                class="inline-flex items-center px-4 py-2 text-sm font-medium"
                style={"color: #{@accent_color}"}
              >
                View all products
                <svg class="ml-2 w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                </svg>
              </a>
            </div>
          <% end %>
        </div>
      </div>
      
      <!-- Testimonials section -->
      <div style={"background-color: #{BrandColors.with_opacity(@secondary_color, 0.1)}; color: #{@accent_color}"}>
        <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 py-12">
          <h2 class="text-2xl font-bold text-gray-900 mb-8">What Our Customers Say</h2>
          
          <%= if Enum.empty?(@testimonials) do %>
            <div class="text-center py-12 px-6 bg-white rounded-lg shadow">
              <p class="text-gray-500">This store doesn't have any testimonials yet.</p>
            </div>
          <% else %>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
              <%= for testimonial <- @testimonials do %>
                <div class="bg-white rounded-lg shadow p-6">
                  <div class="flex items-center mb-4">
                    <%= for _ <- 1..testimonial.rating do %>
                      <svg class="w-5 h-5 text-yellow-500" fill="currentColor" viewBox="0 0 20 20">
                        <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                      </svg>
                    <% end %>
                    <%= for _ <- 1..(5 - testimonial.rating) do %>
                      <svg class="w-5 h-5 text-gray-300" fill="currentColor" viewBox="0 0 20 20">
                        <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                      </svg>
                    <% end %>
                  </div>
                  
                  <p class="text-gray-700 mb-3 italic">
                    "<%= testimonial.content %>"
                  </p>
                  
                  <p class="text-gray-500 text-sm">
                    - <%= testimonial.name %>, <%= testimonial.date |> Calendar.strftime("%b %d, %Y") %>
                  </p>
                </div>
              <% end %>
            </div>
            
            <div class="mt-8 text-center">
              <a 
                href={~p"/stores/#{@store.slug}/testimonials"}
                class="inline-flex items-center px-4 py-2 text-sm font-medium"
                style={"color: #{@accent_color}"}
              >
                Read more testimonials
                <svg class="ml-2 w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                </svg>
              </a>
            </div>
          <% end %>
        </div>
      </div>
      
      <!-- About section -->
      <div class="bg-white">
        <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 py-12">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-12">
            <div>
              <h2 class="text-2xl font-bold text-gray-900 mb-6">About <%= @store.name %></h2>
              <div class="prose max-w-none">
                <p><%= @store.description || "No description available." %></p>
              </div>
              
              <div class="mt-8">
                <a 
                  href={~p"/stores/#{@store.slug}/about"}
                  class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm"
                  style={"background-color: #{@primary_color}; color: #{@text_color}"}
                >
                  Learn more about us
                </a>
              </div>
            </div>
            
            <div>
              <h2 class="text-2xl font-bold text-gray-900 mb-6">Contact Information</h2>
              <div class="bg-gray-50 rounded-lg p-6">
                <div class="flex items-start mb-4">
                  <svg class="w-6 h-6 text-gray-400 mr-3 mt-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                  </svg>
                  <div>
                    <p class="font-medium text-gray-900">Phone</p>
                    <p class="text-gray-500">+254 (0) 722 123 456</p>
                  </div>
                </div>
                
                <div class="flex items-start mb-4">
                  <svg class="w-6 h-6 text-gray-400 mr-3 mt-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                  </svg>
                  <div>
                    <p class="font-medium text-gray-900">Email</p>
                    <p class="text-gray-500">contact@<%= @store.slug %>.com</p>
                  </div>
                </div>
                
                <div class="mt-6">
                  <a 
                    href={~p"/stores/#{@store.slug}/contact"}
                    class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm"
                    style={"background-color: #{@secondary_color}; color: #{BrandColors.contrasting_text_color(@secondary_color)}"}
                  >
                    Contact Us
                  </a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
