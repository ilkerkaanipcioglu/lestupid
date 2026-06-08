defmodule DukkadeeWeb.StoreLive.HowItWorksLive do
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
     |> assign(:page_title, "How It Works | Inkless Is More")
     |> assign(:store, store)}
  end
  
  @impl true
  def render(assigns) do
    ~H"""
    <div class="how-it-works-page">
      <!-- Hero Section -->
      <div class="relative">
        <img src={~p"/images/stores/inklessismore/how_it_works_hero.jpg"} alt="How Tattoo Removal Works" class="w-full h-[300px] object-cover" />
        <div class="absolute inset-0 bg-black bg-opacity-50 flex items-center justify-center">
          <div class="text-center text-white px-4">
            <h1 class="text-4xl md:text-5xl font-bold mb-4">How Tattoo Removal Works</h1>
            <p class="text-xl md:text-2xl">Understanding the PicosureⓇ Laser Technology</p>
          </div>
        </div>
      </div>
      
      <!-- Process Section -->
      <div class="bg-white py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center mb-12">
            <h2 class="text-3xl font-extrabold text-gray-900 sm:text-4xl">
              The Tattoo Removal Process
            </h2>
            <p class="mt-4 text-lg text-gray-500 max-w-3xl mx-auto">
              Our advanced PicosureⓇ technology breaks down tattoo ink into tiny particles that your body can naturally eliminate.
            </p>
          </div>
          
          <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div class="bg-gray-50 p-6 rounded-lg shadow-md">
              <div class="flex items-center justify-center h-12 w-12 rounded-md bg-yellow-400 text-white mb-4">
                <span class="text-xl font-bold">1</span>
              </div>
              <h3 class="text-lg font-medium text-gray-900 mb-2">Consultation</h3>
              <p class="text-gray-600">
                We begin with a thorough assessment of your tattoo, discussing your removal goals, and creating a personalized treatment plan.
              </p>
            </div>
            
            <div class="bg-gray-50 p-6 rounded-lg shadow-md">
              <div class="flex items-center justify-center h-12 w-12 rounded-md bg-yellow-400 text-white mb-4">
                <span class="text-xl font-bold">2</span>
              </div>
              <h3 class="text-lg font-medium text-gray-900 mb-2">Treatment</h3>
              <p class="text-gray-600">
                During your session, our specialist will use the PicosureⓇ laser to target and break down the tattoo ink. Most sessions take 15-30 minutes.
              </p>
            </div>
            
            <div class="bg-gray-50 p-6 rounded-lg shadow-md">
              <div class="flex items-center justify-center h-12 w-12 rounded-md bg-yellow-400 text-white mb-4">
                <span class="text-xl font-bold">3</span>
              </div>
              <h3 class="text-lg font-medium text-gray-900 mb-2">Recovery</h3>
              <p class="text-gray-600">
                After treatment, we provide detailed aftercare instructions. Your body will naturally eliminate the ink particles over the next few weeks.
              </p>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Technology Section -->
      <div class="bg-gray-100 py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="lg:grid lg:grid-cols-2 lg:gap-8 items-center">
            <div>
              <h2 class="text-3xl font-extrabold text-gray-900 sm:text-4xl mb-4">
                PicosureⓇ Technology
              </h2>
              <p class="text-lg text-gray-600 mb-6">
                PicosureⓇ delivers ultra-short pulses of energy that shatter tattoo ink into tiny particles, which are then naturally eliminated by your body. This technology is more effective on stubborn inks and requires fewer treatments than traditional lasers.
              </p>
              <ul class="space-y-4">
                <li class="flex items-start">
                  <svg class="h-6 w-6 text-yellow-400 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                  </svg>
                  <span class="text-gray-600">Faster results with fewer treatments</span>
                </li>
                <li class="flex items-start">
                  <svg class="h-6 w-6 text-yellow-400 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                  </svg>
                  <span class="text-gray-600">Effective on difficult ink colors</span>
                </li>
                <li class="flex items-start">
                  <svg class="h-6 w-6 text-yellow-400 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                  </svg>
                  <span class="text-gray-600">Less discomfort and faster healing</span>
                </li>
                <li class="flex items-start">
                  <svg class="h-6 w-6 text-yellow-400 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                  </svg>
                  <span class="text-gray-600">Minimal risk of scarring</span>
                </li>
              </ul>
            </div>
            <div class="mt-10 lg:mt-0">
              <img src={~p"/images/stores/inklessismore/picosure_technology.jpg"} alt="PicosureⓇ Technology" class="rounded-lg shadow-lg" />
            </div>
          </div>
        </div>
      </div>
      
      <!-- FAQ Section -->
      <div class="bg-white py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center mb-8">
            <h2 class="text-3xl font-extrabold text-gray-900 sm:text-4xl">
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
                <h3 class="text-lg font-bold text-gray-900">Can all tattoos be completely removed?</h3>
                <p class="mt-2 text-gray-600">While our PicosureⓇ technology is highly effective, complete removal depends on various factors including ink type, colors, depth, and your skin type. During your consultation, we'll provide a realistic assessment of what you can expect.</p>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- CTA Section -->
      <div class="bg-yellow-400 py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center">
            <h2 class="text-3xl font-extrabold text-gray-900 sm:text-4xl mb-4">
              Ready to Start Your Tattoo Removal Journey?
            </h2>
            <p class="text-xl text-gray-800 mb-8">
              Book your consultation today and take the first step towards clear skin.
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
