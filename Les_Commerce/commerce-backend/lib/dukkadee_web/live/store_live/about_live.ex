defmodule DukkadeeWeb.StoreLive.AboutLive do
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
     |> assign(:page_title, "About Us | Inkless Is More")
     |> assign(:store, store)}
  end
  
  @impl true
  def render(assigns) do
    ~H"""
    <div class="about-page">
      <!-- Hero Section -->
      <div class="relative">
        <img src={~p"/images/stores/inklessismore/about_hero.jpg"} alt="About Inkless Is More" class="w-full h-[300px] object-cover" />
        <div class="absolute inset-0 bg-black bg-opacity-50 flex items-center justify-center">
          <div class="text-center text-white px-4">
            <h1 class="text-4xl md:text-5xl font-bold mb-4">About Us</h1>
            <p class="text-xl md:text-2xl">Nairobi's Premier Laser Tattoo Removal Studio</p>
          </div>
        </div>
      </div>
      
      <!-- Our Story Section -->
      <div class="bg-white py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="lg:grid lg:grid-cols-2 lg:gap-8 items-center">
            <div>
              <h2 class="text-3xl font-extrabold text-gray-900 sm:text-4xl mb-4">
                Our Story
              </h2>
              <p class="text-lg text-gray-600 mb-6">
                Inkless Is More was founded in 2023 with a simple mission: to provide safe, effective, and compassionate tattoo removal services to the people of Nairobi and beyond.
              </p>
              <p class="text-lg text-gray-600 mb-6">
                Our founder, Dr. Sarah Mwangi, recognized the growing need for professional tattoo removal services in Kenya. After years of specialized training in dermatology and laser treatments, she established Inkless Is More as the first dedicated tattoo removal studio in Nairobi.
              </p>
              <p class="text-lg text-gray-600">
                Today, we're proud to be at the forefront of tattoo removal technology in East Africa, offering state-of-the-art PicosureⓇ laser treatments in a comfortable, welcoming environment.
              </p>
            </div>
            <div class="mt-10 lg:mt-0">
              <img src={~p"/images/stores/inklessismore/our_story.jpg"} alt="Our Story" class="rounded-lg shadow-lg" />
            </div>
          </div>
        </div>
      </div>
      
      <!-- Our Mission -->
      <div class="bg-gray-100 py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center mb-12">
            <h2 class="text-3xl font-extrabold text-gray-900 sm:text-4xl">
              Our Mission
            </h2>
            <p class="mt-4 text-lg text-gray-500 max-w-3xl mx-auto">
              At Inkless Is More, we believe everyone deserves the chance to redefine their personal canvas. Our mission is to provide safe, effective tattoo removal services in a judgment-free environment, empowering our clients to embrace change and move forward with confidence.
            </p>
          </div>
          
          <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div class="bg-white p-6 rounded-lg shadow-md">
              <div class="flex items-center justify-center h-12 w-12 rounded-md bg-yellow-400 text-white mb-4">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                </svg>
              </div>
              <h3 class="text-lg font-medium text-gray-900 mb-2">Safety First</h3>
              <p class="text-gray-600">
                We prioritize your health and safety above all else, using only FDA-approved technology and maintaining the highest standards of cleanliness and sterilization.
              </p>
            </div>
            
            <div class="bg-white p-6 rounded-lg shadow-md">
              <div class="flex items-center justify-center h-12 w-12 rounded-md bg-yellow-400 text-white mb-4">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4" />
                </svg>
              </div>
              <h3 class="text-lg font-medium text-gray-900 mb-2">Cutting-Edge Technology</h3>
              <p class="text-gray-600">
                We invest in the most advanced laser technology available to ensure optimal results with minimal discomfort and recovery time.
              </p>
            </div>
            
            <div class="bg-white p-6 rounded-lg shadow-md">
              <div class="flex items-center justify-center h-12 w-12 rounded-md bg-yellow-400 text-white mb-4">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.828 14.828a4 4 0 01-5.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
              <h3 class="text-lg font-medium text-gray-900 mb-2">Compassionate Care</h3>
              <p class="text-gray-600">
                We understand that tattoo removal is a personal journey. Our team provides supportive, non-judgmental care throughout your treatment process.
              </p>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Our Team -->
      <div class="bg-white py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center mb-12">
            <h2 class="text-3xl font-extrabold text-gray-900 sm:text-4xl">
              Meet Our Team
            </h2>
            <p class="mt-4 text-lg text-gray-500 max-w-3xl mx-auto">
              Our team of certified professionals is dedicated to providing you with the highest quality care and results.
            </p>
          </div>
          
          <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div class="bg-gray-50 rounded-lg overflow-hidden shadow-lg">
              <img src={~p"/images/stores/inklessismore/team_member1.jpg"} alt="Dr. Sarah Mwangi" class="w-full h-64 object-cover" />
              <div class="p-6">
                <h3 class="text-xl font-bold text-gray-900 mb-1">Dr. Sarah Mwangi</h3>
                <p class="text-gray-600 text-sm mb-3">Founder & Lead Specialist</p>
                <p class="text-gray-600">
                  With over 10 years of experience in dermatology and laser treatments, Dr. Mwangi is a recognized expert in tattoo removal technology.
                </p>
              </div>
            </div>
            
            <div class="bg-gray-50 rounded-lg overflow-hidden shadow-lg">
              <img src={~p"/images/stores/inklessismore/team_member2.jpg"} alt="James Ochieng" class="w-full h-64 object-cover" />
              <div class="p-6">
                <h3 class="text-xl font-bold text-gray-900 mb-1">James Ochieng</h3>
                <p class="text-gray-600 text-sm mb-3">Laser Technician</p>
                <p class="text-gray-600">
                  James is a certified laser technician with specialized training in PicosureⓇ technology and a passion for helping clients achieve their skin goals.
                </p>
              </div>
            </div>
            
            <div class="bg-gray-50 rounded-lg overflow-hidden shadow-lg">
              <img src={~p"/images/stores/inklessismore/team_member3.jpg"} alt="Amina Wanjiku" class="w-full h-64 object-cover" />
              <div class="p-6">
                <h3 class="text-xl font-bold text-gray-900 mb-1">Amina Wanjiku</h3>
                <p class="text-gray-600 text-sm mb-3">Client Care Coordinator</p>
                <p class="text-gray-600">
                  Amina ensures every client receives personalized attention from consultation through their entire treatment journey.
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Our Facility -->
      <div class="bg-gray-100 py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center mb-12">
            <h2 class="text-3xl font-extrabold text-gray-900 sm:text-4xl">
              Our Facility
            </h2>
            <p class="mt-4 text-lg text-gray-500 max-w-3xl mx-auto">
              Located in the heart of Nairobi, our modern studio is designed with your comfort and privacy in mind.
            </p>
          </div>
          
          <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
            <img src={~p"/images/stores/inklessismore/facility1.jpg"} alt="Our Reception" class="rounded-lg shadow-lg h-64 w-full object-cover" />
            <img src={~p"/images/stores/inklessismore/facility2.jpg"} alt="Treatment Room" class="rounded-lg shadow-lg h-64 w-full object-cover" />
          </div>
          
          <div class="mt-8 text-center">
            <p class="text-lg text-gray-600">
              Our studio features state-of-the-art treatment rooms, comfortable waiting areas, and the latest in laser technology. We maintain the highest standards of cleanliness and sterilization to ensure your safety and comfort.
            </p>
          </div>
        </div>
      </div>
      
      <!-- Certifications -->
      <div class="bg-white py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center mb-12">
            <h2 class="text-3xl font-extrabold text-gray-900 sm:text-4xl">
              Our Certifications
            </h2>
            <p class="mt-4 text-lg text-gray-500 max-w-3xl mx-auto">
              We're proud to maintain the highest standards in the industry.
            </p>
          </div>
          
          <div class="grid grid-cols-2 md:grid-cols-4 gap-8 items-center justify-items-center">
            <img src={~p"/images/stores/inklessismore/cert1.png"} alt="Certification 1" class="h-24" />
            <img src={~p"/images/stores/inklessismore/cert2.png"} alt="Certification 2" class="h-24" />
            <img src={~p"/images/stores/inklessismore/cert3.png"} alt="Certification 3" class="h-24" />
            <img src={~p"/images/stores/inklessismore/cert4.png"} alt="Certification 4" class="h-24" />
          </div>
        </div>
      </div>
      
      <!-- CTA Section -->
      <div class="bg-yellow-400 py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center">
            <h2 class="text-3xl font-extrabold text-gray-900 sm:text-4xl mb-4">
              Ready to Start Your Journey?
            </h2>
            <p class="text-xl text-gray-800 mb-8">
              Schedule a consultation with our team today.
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
