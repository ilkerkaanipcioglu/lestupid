defmodule DukkadeeWeb.StoreLive.TreatmentCostLive do
  use DukkadeeWeb, :live_view
  
  alias Dukkadee.Stores
  
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
    
    {:ok,
     socket
     |> assign(:page_title, "Treatment Cost | Inkless Is More")
     |> assign(:store, store)}
  end
  
  @impl true
  def render(assigns) do
    ~H"""
    <div class="treatment-cost-page">
      <!-- Hero Section -->
      <div class="relative">
        <img src={~p"/images/stores/inklessismore/treatment_cost_hero.jpg"} alt="Treatment Cost" class="w-full h-[300px] object-cover" />
        <div class="absolute inset-0 bg-black bg-opacity-50 flex items-center justify-center">
          <div class="text-center text-white px-4">
            <h1 class="text-4xl md:text-5xl font-bold mb-4">Treatment Cost</h1>
            <p class="text-xl md:text-2xl">Transparent Pricing for Tattoo Removal</p>
          </div>
        </div>
      </div>
      
      <!-- Pricing Introduction -->
      <div class="bg-white py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center mb-12">
            <h2 class="text-3xl font-extrabold text-gray-900 sm:text-4xl">
              Our Pricing Structure
            </h2>
            <p class="mt-4 text-lg text-gray-500 max-w-3xl mx-auto">
              At Inkless Is More, we believe in transparent pricing. The cost of your tattoo removal depends on the size, colors, and complexity of your tattoo. We offer both per-session pricing and package deals for multiple sessions.
            </p>
          </div>
        </div>
      </div>
      
      <!-- Pricing Tables -->
      <div class="bg-gray-100 py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h3 class="text-2xl font-bold text-gray-900 mb-8 text-center">Tattoo Removal Pricing by Size</h3>
          
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <div class="bg-white rounded-lg shadow-lg overflow-hidden">
              <div class="bg-yellow-400 p-4">
                <h4 class="text-xl font-bold text-gray-900 text-center">Extra Small</h4>
                <p class="text-center text-gray-800">Up to 2 sq. inches</p>
              </div>
              <div class="p-6">
                <div class="text-center mb-4">
                  <span class="text-4xl font-bold text-gray-900">KSh 3,000</span>
                  <span class="text-gray-600">/session</span>
                </div>
                <ul class="space-y-2 mb-6">
                  <li class="flex items-center">
                    <svg class="h-5 w-5 text-yellow-400 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                    </svg>
                    <span class="text-gray-600">Small tattoos</span>
                  </li>
                  <li class="flex items-center">
                    <svg class="h-5 w-5 text-yellow-400 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                    </svg>
                    <span class="text-gray-600">Simple designs</span>
                  </li>
                  <li class="flex items-center">
                    <svg class="h-5 w-5 text-yellow-400 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                    </svg>
                    <span class="text-gray-600">15-minute sessions</span>
                  </li>
                </ul>
                <div class="text-center">
                  <a href={~p"/stores/#{@store.slug}/contact"} class="inline-block bg-yellow-400 text-gray-900 px-4 py-2 rounded-md font-medium hover:bg-yellow-500 transition duration-300">
                    Book Consultation
                  </a>
                </div>
              </div>
            </div>
            
            <div class="bg-white rounded-lg shadow-lg overflow-hidden">
              <div class="bg-yellow-400 p-4">
                <h4 class="text-xl font-bold text-gray-900 text-center">Small</h4>
                <p class="text-center text-gray-800">2-4 sq. inches</p>
              </div>
              <div class="p-6">
                <div class="text-center mb-4">
                  <span class="text-4xl font-bold text-gray-900">KSh 5,000</span>
                  <span class="text-gray-600">/session</span>
                </div>
                <ul class="space-y-2 mb-6">
                  <li class="flex items-center">
                    <svg class="h-5 w-5 text-yellow-400 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                    </svg>
                    <span class="text-gray-600">Medium-small tattoos</span>
                  </li>
                  <li class="flex items-center">
                    <svg class="h-5 w-5 text-yellow-400 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                    </svg>
                    <span class="text-gray-600">Moderate detail</span>
                  </li>
                  <li class="flex items-center">
                    <svg class="h-5 w-5 text-yellow-400 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                    </svg>
                    <span class="text-gray-600">20-minute sessions</span>
                  </li>
                </ul>
                <div class="text-center">
                  <a href={~p"/stores/#{@store.slug}/contact"} class="inline-block bg-yellow-400 text-gray-900 px-4 py-2 rounded-md font-medium hover:bg-yellow-500 transition duration-300">
                    Book Consultation
                  </a>
                </div>
              </div>
            </div>
            
            <div class="bg-white rounded-lg shadow-lg overflow-hidden">
              <div class="bg-yellow-400 p-4">
                <h4 class="text-xl font-bold text-gray-900 text-center">Medium</h4>
                <p class="text-center text-gray-800">4-6 sq. inches</p>
              </div>
              <div class="p-6">
                <div class="text-center mb-4">
                  <span class="text-4xl font-bold text-gray-900">KSh 8,000</span>
                  <span class="text-gray-600">/session</span>
                </div>
                <ul class="space-y-2 mb-6">
                  <li class="flex items-center">
                    <svg class="h-5 w-5 text-yellow-400 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                    </svg>
                    <span class="text-gray-600">Medium tattoos</span>
                  </li>
                  <li class="flex items-center">
                    <svg class="h-5 w-5 text-yellow-400 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                    </svg>
                    <span class="text-gray-600">Complex designs</span>
                  </li>
                  <li class="flex items-center">
                    <svg class="h-5 w-5 text-yellow-400 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                    </svg>
                    <span class="text-gray-600">30-minute sessions</span>
                  </li>
                </ul>
                <div class="text-center">
                  <a href={~p"/stores/#{@store.slug}/contact"} class="inline-block bg-yellow-400 text-gray-900 px-4 py-2 rounded-md font-medium hover:bg-yellow-500 transition duration-300">
                    Book Consultation
                  </a>
                </div>
              </div>
            </div>
            
            <div class="bg-white rounded-lg shadow-lg overflow-hidden">
              <div class="bg-yellow-400 p-4">
                <h4 class="text-xl font-bold text-gray-900 text-center">Large</h4>
                <p class="text-center text-gray-800">6+ sq. inches</p>
              </div>
              <div class="p-6">
                <div class="text-center mb-4">
                  <span class="text-4xl font-bold text-gray-900">KSh 12,000+</span>
                  <span class="text-gray-600">/session</span>
                </div>
                <ul class="space-y-2 mb-6">
                  <li class="flex items-center">
                    <svg class="h-5 w-5 text-yellow-400 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                    </svg>
                    <span class="text-gray-600">Large tattoos</span>
                  </li>
                  <li class="flex items-center">
                    <svg class="h-5 w-5 text-yellow-400 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                    </svg>
                    <span class="text-gray-600">Custom pricing</span>
                  </li>
                  <li class="flex items-center">
                    <svg class="h-5 w-5 text-yellow-400 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                    </svg>
                    <span class="text-gray-600">45+ minute sessions</span>
                  </li>
                </ul>
                <div class="text-center">
                  <a href={~p"/stores/#{@store.slug}/contact"} class="inline-block bg-yellow-400 text-gray-900 px-4 py-2 rounded-md font-medium hover:bg-yellow-500 transition duration-300">
                    Book Consultation
                  </a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Package Deals -->
      <div class="bg-white py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h3 class="text-2xl font-bold text-gray-900 mb-8 text-center">Package Deals</h3>
          
          <div class="bg-gray-50 rounded-lg shadow-lg p-8 mb-12">
            <div class="text-center mb-6">
              <h4 class="text-2xl font-bold text-gray-900">Save with Multi-Session Packages</h4>
              <p class="text-gray-600 mt-2">Commit to your tattoo removal journey and save with our package deals</p>
            </div>
            
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div class="bg-white p-6 rounded-lg shadow-md">
                <h5 class="text-xl font-bold text-gray-900 mb-2">3-Session Package</h5>
                <p class="text-gray-600 mb-4">Save 10% on the total cost when you purchase 3 sessions upfront.</p>
                <p class="text-lg font-semibold text-gray-900">10% Discount</p>
              </div>
              
              <div class="bg-white p-6 rounded-lg shadow-md">
                <h5 class="text-xl font-bold text-gray-900 mb-2">5-Session Package</h5>
                <p class="text-gray-600 mb-4">Save 15% on the total cost when you purchase 5 sessions upfront.</p>
                <p class="text-lg font-semibold text-gray-900">15% Discount</p>
              </div>
              
              <div class="bg-white p-6 rounded-lg shadow-md">
                <h5 class="text-xl font-bold text-gray-900 mb-2">8-Session Package</h5>
                <p class="text-gray-600 mb-4">Save 20% on the total cost when you purchase 8 sessions upfront.</p>
                <p class="text-lg font-semibold text-gray-900">20% Discount</p>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Additional Services -->
      <div class="bg-gray-100 py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h3 class="text-2xl font-bold text-gray-900 mb-8 text-center">Additional Services</h3>
          
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div class="bg-white p-6 rounded-lg shadow-md">
              <h4 class="text-xl font-bold text-gray-900 mb-2">Consultation</h4>
              <p class="text-gray-600 mb-2">Initial assessment and treatment plan development.</p>
              <p class="text-lg font-semibold text-gray-900">KSh 1,500</p>
              <p class="text-gray-600 text-sm">(Applied to your first treatment if you proceed)</p>
            </div>
            
            <div class="bg-white p-6 rounded-lg shadow-md">
              <h4 class="text-xl font-bold text-gray-900 mb-2">Aftercare Kit</h4>
              <p class="text-gray-600 mb-2">Includes healing ointment, bandages, and instructions.</p>
              <p class="text-lg font-semibold text-gray-900">KSh 2,000</p>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Payment Options -->
      <div class="bg-white py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center mb-8">
            <h3 class="text-2xl font-bold text-gray-900">Payment Options</h3>
            <p class="text-gray-600 mt-2">We offer flexible payment options to make your tattoo removal journey more accessible</p>
          </div>
          
          <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div class="bg-gray-50 p-6 rounded-lg shadow-md">
              <h4 class="text-xl font-bold text-gray-900 mb-2">Cash</h4>
              <p class="text-gray-600">Pay for each session individually or purchase a package deal upfront.</p>
            </div>
            
            <div class="bg-gray-50 p-6 rounded-lg shadow-md">
              <h4 class="text-xl font-bold text-gray-900 mb-2">Credit/Debit Cards</h4>
              <p class="text-gray-600">We accept all major credit and debit cards for your convenience.</p>
            </div>
            
            <div class="bg-gray-50 p-6 rounded-lg shadow-md">
              <h4 class="text-xl font-bold text-gray-900 mb-2">Mobile Money</h4>
              <p class="text-gray-600">Pay easily using M-Pesa and other mobile payment options.</p>
            </div>
          </div>
        </div>
      </div>
      
      <!-- CTA Section -->
      <div class="bg-yellow-400 py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center">
            <h2 class="text-3xl font-extrabold text-gray-900 sm:text-4xl mb-4">
              Ready to Get Started?
            </h2>
            <p class="text-xl text-gray-800 mb-8">
              Book your consultation today and receive a personalized quote for your tattoo removal.
            </p>
            <a href={~p"/stores/#{@store.slug}/contact"} class="inline-block bg-gray-900 text-white px-6 py-3 rounded-md font-medium text-lg hover:bg-gray-800 transition duration-300">
              Schedule Consultation
            </a>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
