defmodule DukkadeeWeb.StoreLive.FaqLive do
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
     |> assign(:page_title, "Questions & Answers | Inkless Is More")
     |> assign(:store, store)}
  end
  
  @impl true
  def render(assigns) do
    ~H"""
    <div class="faq-page">
      <!-- Hero Section -->
      <div class="relative">
        <img src={~p"/images/stores/inklessismore/faq_hero.jpg"} alt="Frequently Asked Questions" class="w-full h-[300px] object-cover" />
        <div class="absolute inset-0 bg-black bg-opacity-50 flex items-center justify-center">
          <div class="text-center text-white px-4">
            <h1 class="text-4xl md:text-5xl font-bold mb-4">Questions & Answers</h1>
            <p class="text-xl md:text-2xl">Everything You Need to Know About Tattoo Removal</p>
          </div>
        </div>
      </div>
      
      <!-- FAQ Categories -->
      <div class="bg-white py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center mb-12">
            <h2 class="text-3xl font-extrabold text-gray-900 sm:text-4xl">
              Frequently Asked Questions
            </h2>
            <p class="mt-4 text-lg text-gray-500 max-w-3xl mx-auto">
              Find answers to common questions about tattoo removal, our process, and what to expect.
            </p>
          </div>
          
          <!-- About the Process -->
          <div class="mb-12">
            <h3 class="text-2xl font-bold text-gray-900 mb-6 pb-2 border-b border-gray-200">About the Process</h3>
            
            <div class="space-y-6">
              <div class="bg-gray-50 p-6 rounded-lg">
                <h4 class="text-lg font-bold text-gray-900">How does laser tattoo removal work?</h4>
                <p class="mt-2 text-gray-600">
                  Our PicosureⓇ laser delivers ultra-short pulses of energy that shatter tattoo ink into tiny particles. 
                  These particles are then naturally eliminated by your body's immune system over time. The laser targets 
                  the ink particles without causing significant damage to the surrounding skin.
                </p>
              </div>
              
              <div class="bg-gray-50 p-6 rounded-lg">
                <h4 class="text-lg font-bold text-gray-900">How many sessions will I need?</h4>
                <p class="mt-2 text-gray-600">
                  The number of sessions varies depending on several factors including the size, colors, age of your tattoo, 
                  and your skin type. Most tattoos require 5-10 sessions for complete removal, with 6-8 weeks between sessions 
                  to allow your body to flush away the ink and for your skin to heal.
                </p>
              </div>
              
              <div class="bg-gray-50 p-6 rounded-lg">
                <h4 class="text-lg font-bold text-gray-900">How long does each session take?</h4>
                <p class="mt-2 text-gray-600">
                  Treatment sessions are relatively quick, typically lasting 15-30 minutes depending on the size of your tattoo. 
                  Your first appointment will be longer (about 45-60 minutes) as it includes a consultation to assess your tattoo 
                  and develop a treatment plan.
                </p>
              </div>
              
              <div class="bg-gray-50 p-6 rounded-lg">
                <h4 class="text-lg font-bold text-gray-900">Why choose PicosureⓇ over other laser technologies?</h4>
                <p class="mt-2 text-gray-600">
                  PicosureⓇ technology offers several advantages over traditional Q-switched lasers. It delivers energy in 
                  picoseconds (trillionths of a second) rather than nanoseconds, which is more effective at shattering ink 
                  particles. This results in fewer treatments, better clearance of difficult colors like blues and greens, 
                  and less discomfort and recovery time.
                </p>
              </div>
            </div>
          </div>
          
          <!-- Pain & Comfort -->
          <div class="mb-12">
            <h3 class="text-2xl font-bold text-gray-900 mb-6 pb-2 border-b border-gray-200">Pain & Comfort</h3>
            
            <div class="space-y-6">
              <div class="bg-gray-50 p-6 rounded-lg">
                <h4 class="text-lg font-bold text-gray-900">Is tattoo removal painful?</h4>
                <p class="mt-2 text-gray-600">
                  Most clients describe the sensation as similar to a rubber band snapping against the skin. The level of 
                  discomfort varies depending on the tattoo location and your personal pain tolerance. We use cooling 
                  techniques to minimize discomfort during the procedure.
                </p>
              </div>
              
              <div class="bg-gray-50 p-6 rounded-lg">
                <h4 class="text-lg font-bold text-gray-900">Do you use any form of anesthesia?</h4>
                <p class="mt-2 text-gray-600">
                  We use a combination of cooling techniques and, if needed, topical numbing cream to ensure your comfort 
                  during the procedure. For particularly sensitive areas or clients with low pain tolerance, we can apply 
                  a medical-grade numbing cream 30 minutes before your treatment.
                </p>
              </div>
              
              <div class="bg-gray-50 p-6 rounded-lg">
                <h4 class="text-lg font-bold text-gray-900">What does recovery feel like?</h4>
                <p class="mt-2 text-gray-600">
                  After treatment, the area may feel similar to a mild sunburn. Some redness, swelling, and occasionally 
                  blistering can occur, which is a normal part of the healing process. Most discomfort subsides within 
                  24-48 hours, and we provide detailed aftercare instructions to ensure proper healing.
                </p>
              </div>
            </div>
          </div>
          
          <!-- Results & Expectations -->
          <div class="mb-12">
            <h3 class="text-2xl font-bold text-gray-900 mb-6 pb-2 border-b border-gray-200">Results & Expectations</h3>
            
            <div class="space-y-6">
              <div class="bg-gray-50 p-6 rounded-lg">
                <h4 class="text-lg font-bold text-gray-900">Can all tattoos be completely removed?</h4>
                <p class="mt-2 text-gray-600">
                  While our PicosureⓇ technology is highly effective, complete removal depends on various factors including 
                  ink type, colors, depth, and your skin type. During your consultation, we'll provide a realistic assessment 
                  of what you can expect. Most tattoos can be significantly faded, if not completely removed.
                </p>
              </div>
              
              <div class="bg-gray-50 p-6 rounded-lg">
                <h4 class="text-lg font-bold text-gray-900">Which colors are hardest to remove?</h4>
                <p class="mt-2 text-gray-600">
                  Traditionally, blues, greens, and fluorescent inks have been the most challenging to remove. However, 
                  PicosureⓇ technology has significantly improved the ability to target these difficult colors. Black and 
                  red inks typically respond best to laser treatment.
                </p>
              </div>
              
              <div class="bg-gray-50 p-6 rounded-lg">
                <h4 class="text-lg font-bold text-gray-900">Will I have scarring after tattoo removal?</h4>
                <p class="mt-2 text-gray-600">
                  Our advanced laser technology minimizes the risk of scarring. However, if your tattoo already has scarring 
                  or if you have a history of keloid formation, there may be some texture changes. Following proper aftercare 
                  instructions is crucial to minimize any risk of scarring.
                </p>
              </div>
              
              <div class="bg-gray-50 p-6 rounded-lg">
                <h4 class="text-lg font-bold text-gray-900">How soon will I see results?</h4>
                <p class="mt-2 text-gray-600">
                  You may notice some fading immediately after your first treatment, but significant results typically become 
                  visible after 2-3 sessions. The body continues to flush away ink particles for several weeks after each 
                  treatment, so the full effect of each session develops over time.
                </p>
              </div>
            </div>
          </div>
          
          <!-- Aftercare & Recovery -->
          <div class="mb-12">
            <h3 class="text-2xl font-bold text-gray-900 mb-6 pb-2 border-b border-gray-200">Aftercare & Recovery</h3>
            
            <div class="space-y-6">
              <div class="bg-gray-50 p-6 rounded-lg">
                <h4 class="text-lg font-bold text-gray-900">What is the recovery process like?</h4>
                <p class="mt-2 text-gray-600">
                  After treatment, the area may be red and slightly swollen. You might experience blistering or scabbing, 
                  which is normal. We provide detailed aftercare instructions to ensure proper healing. Most people can 
                  return to normal activities immediately, though you should avoid sun exposure and strenuous exercise 
                  for a few days.
                </p>
              </div>
              
              <div class="bg-gray-50 p-6 rounded-lg">
                <h4 class="text-lg font-bold text-gray-900">How should I care for my skin between sessions?</h4>
                <p class="mt-2 text-gray-600">
                  Between sessions, it's important to keep the treated area clean and moisturized. Avoid sun exposure and 
                  use SPF 30+ when outdoors. Don't pick at scabs or blisters, as this can lead to scarring. Stay hydrated 
                  and maintain a healthy lifestyle to help your body process the ink particles more efficiently.
                </p>
              </div>
              
              <div class="bg-gray-50 p-6 rounded-lg">
                <h4 class="text-lg font-bold text-gray-900">Can I exercise after a treatment?</h4>
                <p class="mt-2 text-gray-600">
                  We recommend avoiding strenuous exercise for 24-48 hours after treatment to prevent excessive sweating 
                  and irritation to the treated area. Light activities like walking are fine. After the initial healing 
                  period, you can resume your normal exercise routine.
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Still Have Questions Section -->
      <div class="bg-yellow-400 py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center">
            <h2 class="text-3xl font-extrabold text-gray-900 sm:text-4xl mb-4">
              Still Have Questions?
            </h2>
            <p class="text-xl text-gray-800 mb-8">
              Contact us directly and our team will be happy to help.
            </p>
            <a href={~p"/stores/#{@store.slug}/contact"} class="inline-block bg-gray-900 text-white px-6 py-3 rounded-md font-medium text-lg hover:bg-gray-800 transition duration-300">
              Contact Us
            </a>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
