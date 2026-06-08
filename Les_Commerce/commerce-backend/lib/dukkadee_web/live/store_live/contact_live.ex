defmodule DukkadeeWeb.StoreLive.ContactLive do
  use DukkadeeWeb, :live_view

  alias Dukkadee.Stores

  @impl true
  def mount(_params, _session, socket) do
    store = case Stores.get_store_by_slug("inklessismore-ke") do
      nil -> 
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
     |> assign(:page_title, "Contact Us | Inkless Is More")
     |> assign(:store, store)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="contact-page">
      <!-- Hero Section -->
      <div class="relative">
        <img src={~p"/images/stores/inklessismore/contact_hero.jpg"} alt="Contact Inkless Is More" class="w-full h-[300px] object-cover" />
        <div class="absolute inset-0 bg-black bg-opacity-50 flex items-center justify-center">
          <div class="text-center text-white px-4">
            <h1 class="text-4xl md:text-5xl font-bold mb-4">Contact Us</h1>
            <p class="text-xl md:text-2xl">We're here to help with your tattoo removal journey</p>
          </div>
        </div>
      </div>

      <!-- Contact Form Section -->
      <div class="bg-white py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
            <!-- Contact Info -->
            <div>
              <h2 class="text-3xl font-bold text-gray-900 mb-6">Get in Touch</h2>
              <div class="space-y-4">
                <div class="flex items-start">
                  <div class="flex-shrink-0 mt-1">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-yellow-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                    </svg>
                  </div>
                  <div class="ml-3">
                    <h3 class="text-lg font-medium text-gray-900">Phone</h3>
                    <p class="text-gray-600">+254 712 345 678</p>
                  </div>
                </div>

                <div class="flex items-start">
                  <div class="flex-shrink-0 mt-1">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-yellow-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                    </svg>
                  </div>
                  <div class="ml-3">
                    <h3 class="text-lg font-medium text-gray-900">Email</h3>
                    <p class="text-gray-600">info@inklessismore.co.ke</p>
                  </div>
                </div>

                <div class="flex items-start">
                  <div class="flex-shrink-0 mt-1">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-yellow-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                    </svg>
                  </div>
                  <div class="ml-3">
                    <h3 class="text-lg font-medium text-gray-900">Location</h3>
                    <p class="text-gray-600">
                      Westlands Business Park<br/>
                      3rd Floor, Suite 12<br/>
                      Nairobi, Kenya
                    </p>
                  </div>
                </div>

                <div class="flex items-start">
                  <div class="flex-shrink-0 mt-1">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-yellow-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                  </div>
                  <div class="ml-3">
                    <h3 class="text-lg font-medium text-gray-900">Business Hours</h3>
                    <p class="text-gray-600">
                      Monday - Friday: 9am - 6pm<br/>
                      Saturday: 10am - 4pm<br/>
                      Sunday: Closed
                    </p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Contact Form -->
            <div>
              <h2 class="text-3xl font-bold text-gray-900 mb-6">Send Us a Message</h2>
              <form phx-submit="send-message" class="space-y-4">
                <div>
                  <label for="name" class="block text-sm font-medium text-gray-700">Your Name</label>
                  <input type="text" name="name" id="name" class="mt-1 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md" required />
                </div>
                <div>
                  <label for="email" class="block text-sm font-medium text-gray-700">Your Email</label>
                  <input type="email" name="email" id="email" class="mt-1 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md" required />
                </div>
                <div>
                  <label for="phone" class="block text-sm font-medium text-gray-700">Phone Number</label>
                  <input type="tel" name="phone" id="phone" class="mt-1 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md" />
                </div>
                <div>
                  <label for="subject" class="block text-sm font-medium text-gray-700">Subject</label>
                  <input type="text" name="subject" id="subject" class="mt-1 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md" required />
                </div>
                <div>
                  <label for="message" class="block text-sm font-medium text-gray-700">Message</label>
                  <textarea name="message" id="message" rows="4" class="mt-1 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md" required></textarea>
                </div>
                <div class="flex items-center">
                  <input id="privacy-policy" name="privacy-policy" type="checkbox" class="h-4 w-4 text-yellow-400 focus:ring-yellow-500 border-gray-300 rounded" required />
                  <label for="privacy-policy" class="ml-2 block text-sm text-gray-900">
                    I agree to the privacy policy
                  </label>
                </div>
                <div>
                  <button type="submit" class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-gray-900 hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-yellow-400">
                    Send Message
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>

      <!-- Map Section -->
      <div class="bg-gray-100 py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h2 class="text-3xl font-bold text-gray-900 mb-6 text-center">Find Us</h2>
          <div class="aspect-w-16 aspect-h-9 rounded-lg overflow-hidden shadow-lg">
            <!-- Placeholder for Google Map iframe -->
            <div class="bg-gray-300 w-full h-96 flex items-center justify-center">
              <p class="text-gray-600">Google Map will be embedded here</p>
            </div>
          </div>
        </div>
      </div>

      <!-- FAQ Section -->
      <div class="bg-white py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h2 class="text-3xl font-bold text-gray-900 mb-6 text-center">Frequently Asked Questions</h2>
          <div class="mt-8 space-y-6">
            <div class="border-b border-gray-200 pb-4">
              <h3 class="text-lg font-medium text-gray-900">How do I schedule a consultation?</h3>
              <p class="mt-2 text-gray-600">You can schedule a consultation by filling out the form above, calling our office during business hours, or sending us an email.</p>
            </div>
            <div class="border-b border-gray-200 pb-4">
              <h3 class="text-lg font-medium text-gray-900">Is a consultation required before treatment?</h3>
              <p class="mt-2 text-gray-600">Yes, a consultation is required before any treatment to assess your tattoo and determine the best removal plan for your specific needs.</p>
            </div>
            <div class="border-b border-gray-200 pb-4">
              <h3 class="text-lg font-medium text-gray-900">How long does it take to respond to inquiries?</h3>
              <p class="mt-2 text-gray-600">We aim to respond to all inquiries within 24 business hours.</p>
            </div>
          </div>
          <div class="mt-8 text-center">
            <a href={~p"/stores/#{@store.slug}/faq"} class="inline-flex items-center text-yellow-600 font-medium hover:text-yellow-700">
              View all FAQs
              <svg xmlns="http://www.w3.org/2000/svg" class="ml-1 h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M10.293 5.293a1 1 0 011.414 0l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414-1.414L12.586 11H5a1 1 0 110-2h7.586l-2.293-2.293a1 1 0 010-1.414z" clip-rule="evenodd" />
              </svg>
            </a>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("send-message", _params, socket) do
    # Here you would typically send an email or save the contact form data
    # For now, we'll just return a success message
    
    # You might add code here to:
    # 1. Validate the form data
    # 2. Send an email notification
    # 3. Save the message to the database
    # 4. Send a confirmation email to the customer
    
    {:noreply, socket 
    |> put_flash(:info, "Thank you for your message! We'll get back to you soon.")}
  end
end
