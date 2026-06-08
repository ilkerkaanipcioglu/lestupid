defmodule DukkadeeWeb.StoreLive.TattooRemovalLive do
  use DukkadeeWeb, :live_view
  
  alias Dukkadee.Stores
  alias Dukkadee.Products
  
  @impl true
  def mount(_params, _session, socket) do
    # Try to get the store, or create a default one if it doesn't exist
    store = case Stores.get_store_by_slug("inklessismore-ke") do
      nil -> 
        # Return a default store structure when the actual store is not found
        %{
          id: 0,
          name: "Inkless Is More",
          slug: "inklessismore-ke",
          description: "Nairobi's Premier Laser Tattoo Removal Studio",
          primary_color: "#fddb24",
          secondary_color: "#b7acd4",
          accent_color: "#272727",
          logo: "/images/inklessismore-logo.png"
        }
      found_store -> found_store
    end
    
    # Get products or default to empty list if store doesn't exist
    products = if store.id == 0, do: [], else: Products.list_store_products(store.id)
    
    {:ok,
     socket
     |> assign(:page_title, "Inkless Is More - Nairobi's Premier Laser Tattoo Removal")
     |> assign(:store, store)
     |> assign(:products, products)
     |> assign(:selected_product, nil)
     |> assign(:show_booking_form, false)}
  end
  
  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end
  
  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:selected_product, nil)
    |> assign(:show_booking_form, false)
  end
  
  defp apply_action(socket, :book, %{"product_id" => product_id}) do
    product = Products.get_product!(product_id)
    
    socket
    |> assign(:selected_product, product)
    |> assign(:show_booking_form, true)
  end
  
  @impl true
  def handle_event("select_product", %{"product-id" => product_id}, socket) do
    {:noreply, push_patch(socket, to: ~p"/stores/inklessismore-ke/book/#{product_id}")}
  end
  
  @impl true
  def handle_event("close_booking_form", _, socket) do
    {:noreply, push_patch(socket, to: ~p"/stores/inklessismore-ke")}
  end
  
  @impl true
  def handle_info({:appointment_created, _appointment}, socket) do
    {:noreply, socket}
  end
  
  @impl true
  def render(assigns) do
    ~H"""
    <div class="tattoo-removal-page">
      <!-- Hero Section -->
      <div class="relative">
        <img src={~p"/images/stores/inklessismore/Inklessismore_Cover_Page.jpg"} alt="Tattoo Removal" class="w-full h-[400px] object-cover" />
        <div class="absolute inset-0 bg-black bg-opacity-50 flex items-center justify-center">
          <div class="text-center text-white px-4">
            <h1 class="text-4xl md:text-5xl font-bold mb-4">Inkless Is More</h1>
            <p class="text-xl md:text-2xl">Nairobi's Premier Laser Tattoo Removal Studio</p>
          </div>
        </div>
      </div>
      
      <!-- About Section -->
      <div class="bg-white py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center">
            <h2 class="text-3xl font-extrabold text-gray-900 sm:text-4xl">
              Advanced PicosureⓇ Technology
            </h2>
            <p class="mt-4 text-lg text-gray-500 max-w-3xl mx-auto">
              At our studio, we specialize in laser treatment for tattoo removal, using advanced PicosureⓇ technology 
              to ensure the best results for our clients. Our facility offers a comfortable and professional environment, 
              where our highly trained staff is dedicated to providing exceptional service.
            </p>
          </div>
          
          <!-- Before/After Gallery -->
          <div class="mt-12">
            <h3 class="text-2xl font-bold text-center mb-6">Before & After Results</h3>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div class="rounded-lg overflow-hidden shadow-lg">
                <img src={~p"/images/stores/inklessismore/BeforeandAfter.jpg"} alt="Before and After" class="w-full h-64 object-cover" />
              </div>
              <div class="rounded-lg overflow-hidden shadow-lg">
                <img src={~p"/images/stores/inklessismore/7eb822a5-2ae0-4739-9065-a5939d4759d9_08acd678-41c1-4aa7-9ccb-9475ea874dcc.jpg"} alt="Before and After" class="w-full h-64 object-cover" />
              </div>
              <div class="rounded-lg overflow-hidden shadow-lg">
                <img src={~p"/images/stores/inklessismore/f2cecfc5-7fbb-4fe8-b36a-58b7ec4003cd.jpg"} alt="Before and After" class="w-full h-64 object-cover" />
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Services Section -->
      <div class="bg-gray-100 py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center">
            <h2 class="text-3xl font-extrabold text-gray-900 sm:text-4xl mb-8">
              Our Tattoo Removal Services
            </h2>
          </div>
          
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <%= for product <- @products do %>
              <div class="bg-white rounded-lg shadow-lg overflow-hidden">
                <img src={List.first(product.images)} alt={product.name} class="w-full h-48 object-cover" />
                <div class="p-6">
                  <h3 class="text-lg font-bold text-gray-900 mb-2"><%= product.name %></h3>
                  <p class="text-gray-600 text-sm mb-4"><%= truncate_description(product.description, 100) %></p>
                  <div class="flex justify-between items-center">
                    <span class="text-xl font-bold text-gray-900"><%= format_price(product.price, product.currency) %></span>
                    <button 
                      phx-click="select_product"
                      phx-value-product-id={product.id}
                      class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded"
                    >
                      Book Now
                    </button>
                  </div>
                </div>
              </div>
            <% end %>
          </div>
        </div>
      </div>
      
      <!-- FAQ Section -->
      <div class="bg-white py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center">
            <h2 class="text-3xl font-extrabold text-gray-900 sm:text-4xl mb-8">
              Frequently Asked Questions
            </h2>
          </div>
          
          <div class="max-w-3xl mx-auto">
            <div class="space-y-6">
              <div class="bg-gray-50 p-6 rounded-lg">
                <h3 class="text-lg font-bold text-gray-900">How many sessions will I need?</h3>
                <p class="mt-2 text-gray-600">The number of sessions varies depending on the size, colors, and age of your tattoo. Most tattoos require 5-10 sessions for complete removal, with 6-8 weeks between sessions.</p>
              </div>
              
              <div class="bg-gray-50 p-6 rounded-lg">
                <h3 class="text-lg font-bold text-gray-900">Is tattoo removal painful?</h3>
                <p class="mt-2 text-gray-600">Most clients describe the sensation as similar to a rubber band snapping against the skin. We use cooling techniques to minimize discomfort during the procedure.</p>
              </div>
              
              <div class="bg-gray-50 p-6 rounded-lg">
                <h3 class="text-lg font-bold text-gray-900">What is the recovery process like?</h3>
                <p class="mt-2 text-gray-600">After treatment, the area may be red and slightly swollen. You might experience blistering or scabbing, which is normal. We provide detailed aftercare instructions to ensure proper healing.</p>
              </div>
              
              <div class="bg-gray-50 p-6 rounded-lg">
                <h3 class="text-lg font-bold text-gray-900">Why choose PicosureⓇ technology?</h3>
                <p class="mt-2 text-gray-600">PicosureⓇ delivers ultra-short pulses of energy that shatter tattoo ink into tiny particles, which are then naturally eliminated by your body. This technology is more effective on stubborn inks and requires fewer treatments than traditional lasers.</p>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Location Section -->
      <div class="bg-gray-100 py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center mb-8">
            <h2 class="text-3xl font-extrabold text-gray-900 sm:text-4xl">
              Visit Our Studio
            </h2>
            <p class="mt-4 text-lg text-gray-500">
              We're conveniently located in Nairobi. Schedule your consultation today.
            </p>
          </div>
          
          <div class="h-96 rounded-lg overflow-hidden shadow-lg">
            <iframe src="https://storage.googleapis.com/maps-solutions-qs2lt4g6jq/locator-plus/ot8w/locator-plus.html" width="100%" height="100%" style="border:0;" loading="lazy"></iframe>
          </div>
          
          <div class="mt-8 text-center">
            <div class="flex justify-center space-x-6">
              <a href="https://www.facebook.com/inklessismore" class="text-gray-400 hover:text-gray-500">
                <span class="sr-only">Facebook</span>
                <svg class="h-6 w-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                  <path fill-rule="evenodd" d="M22 12c0-5.523-4.477-10-10-10S2 6.477 2 12c0 4.991 3.657 9.128 8.438 9.878v-6.987h-2.54V12h2.54V9.797c0-2.506 1.492-3.89 3.777-3.89 1.094 0 2.238.195 2.238.195v2.46h-1.26c-1.243 0-1.63.771-1.63 1.562V12h2.773l-.443 2.89h-2.33v6.988C18.343 21.128 22 16.991 22 12z" clip-rule="evenodd" />
                </svg>
              </a>
              <a href="https://www.instagram.com/inklessismore_/" class="text-gray-400 hover:text-gray-500">
                <span class="sr-only">Instagram</span>
                <svg class="h-6 w-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                  <path fill-rule="evenodd" d="M12.315 2c2.43 0 2.784.013 3.808.06 1.064.049 1.791.218 2.427.465a4.902 4.902 0 011.772 1.153 4.902 4.902 0 011.153 1.772c.247.636.416 1.363.465 2.427.048 1.067.06 1.407.06 4.123v.08c0 2.643-.012 2.987-.06 4.043-.049 1.064-.218 1.791-.465 2.427a4.902 4.902 0 01-1.153 1.772 4.902 4.902 0 01-1.772 1.153c-.636.247-1.363.416-2.427.465-1.067.048-1.407.06-4.123.06h-.08c-2.643 0-2.987-.012-4.043-.06-1.064-.049-1.791-.218-2.427-.465a4.902 4.902 0 01-1.772-1.153 4.902 4.902 0 01-1.153-1.772c-.247-.636-.416-1.363-.465-2.427-.047-1.024-.06-1.379-.06-3.808v-.63c0-2.43.013-2.784.06-3.808.049-1.064.218-1.791.465-2.427a4.902 4.902 0 011.153-1.772A4.902 4.902 0 015.45 2.525c.636-.247 1.363-.416 2.427-.465C8.901 2.013 9.256 2 11.685 2h.63zm-.081 1.802h-.468c-2.456 0-2.784.011-3.807.058-.975.045-1.504.207-1.857.344-.467.182-.8.398-1.15.748-.35.35-.566.683-.748 1.15-.137.353-.3.882-.344 1.857-.047 1.023-.058 1.351-.058 3.807v.468c0 2.456.011 2.784.058 3.807.045.975.207 1.504.344 1.857.182.466.399.8.748 1.15.35.35.683.566 1.15.748.353.137.882.3 1.857.344 1.054.048 1.37.058 4.041.058h.08c2.597 0 2.917-.01 3.96-.058.976-.045 1.505-.207 1.858-.344.466-.182.8-.398 1.15-.748.35-.35.566-.683.748-1.15.137-.353.3-.882.344-1.857.048-1.055.058-1.37.058-4.041v-.08c0-2.597-.01-2.917-.058-3.96-.045-.976-.207-1.505-.344-1.858a3.097 3.097 0 00-.748-1.15 3.098 3.098 0 00-1.15-.748c-.353-.137-.882-.3-1.857-.344-1.023-.047-1.351-.058-3.807-.058zM12 6.865a5.135 5.135 0 110 10.27 5.135 5.135 0 010-10.27zm0 1.802a3.333 3.333 0 100 6.666 3.333 3.333 0 000-6.666zm5.338-3.205a1.2 1.2 0 110 2.4 1.2 1.2 0 010-2.4z" clip-rule="evenodd" />
                </svg>
              </a>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Booking Form Modal -->
      <%= if @show_booking_form and @selected_product do %>
        <div class="fixed inset-0 bg-gray-500 bg-opacity-75 flex items-center justify-center z-50">
          <div class="bg-white rounded-lg shadow-xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
            <div class="p-6">
              <div class="flex justify-between items-center mb-4">
                <h2 class="text-2xl font-bold">Book Your Appointment</h2>
                <button phx-click="close_booking_form" class="text-gray-500 hover:text-gray-700">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </button>
              </div>
              
              <div class="mb-6">
                <h3 class="font-bold text-lg"><%= @selected_product.name %></h3>
                <p class="text-gray-600"><%= @selected_product.description %></p>
                <p class="text-xl font-bold mt-2"><%= format_price(@selected_product.price, @selected_product.currency) %></p>
              </div>
              
              <.live_component
                module={DukkadeeWeb.AppointmentLive.TattooRemovalFormComponent}
                id="tattoo-removal-form"
                product={@selected_product}
              />
            </div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
  
  # Helper functions
  defp truncate_description(description, max_length) do
    if String.length(description) > max_length do
      String.slice(description, 0, max_length) <> "..."
    else
      description
    end
  end
  
  defp format_price(price, currency) do
    case currency do
      "KES" -> "KSh#{Decimal.to_string(price, :normal)}"
      "USD" -> "$#{Decimal.to_string(price, :normal)}"
      _ -> "#{Decimal.to_string(price, :normal)} #{currency}"
    end
  end
end
