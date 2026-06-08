defmodule DukkadeeWeb.StoreLive.GalleryLive do
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

    gallery_images = [
      %{
        id: 1,
        title: "Before & After: Tribal Design",
        description: "Complete removal after 8 sessions",
        before_image: "/images/stores/inklessismore/gallery/before_after_1_before.jpg",
        after_image: "/images/stores/inklessismore/gallery/before_after_1_after.jpg",
        category: "before_after"
      },
      %{
        id: 2,
        title: "Before & After: Colorful Butterfly",
        description: "Complete removal after 10 sessions",
        before_image: "/images/stores/inklessismore/gallery/before_after_2_before.jpg",
        after_image: "/images/stores/inklessismore/gallery/before_after_2_after.jpg",
        category: "before_after"
      },
      %{
        id: 3,
        title: "Before & After: Text Removal",
        description: "Complete removal after 6 sessions",
        before_image: "/images/stores/inklessismore/gallery/before_after_3_before.jpg",
        after_image: "/images/stores/inklessismore/gallery/before_after_3_after.jpg",
        category: "before_after"
      },
      %{
        id: 4,
        title: "In Progress: Arm Sleeve",
        description: "After 4 of 12 planned sessions",
        before_image: "/images/stores/inklessismore/gallery/progress_1_before.jpg",
        after_image: "/images/stores/inklessismore/gallery/progress_1_after.jpg",
        category: "in_progress"
      },
      %{
        id: 5,
        title: "In Progress: Back Tattoo",
        description: "After 3 of 8 planned sessions",
        before_image: "/images/stores/inklessismore/gallery/progress_2_before.jpg",
        after_image: "/images/stores/inklessismore/gallery/progress_2_after.jpg",
        category: "in_progress"
      },
      %{
        id: 6,
        title: "Our Studio - Reception Area",
        description: "Modern, comfortable waiting area for our clients",
        image: "/images/stores/inklessismore/gallery/studio_1.jpg",
        category: "facility"
      },
      %{
        id: 7,
        title: "Our Studio - Treatment Room",
        description: "State-of-the-art equipment in a clean, calming environment",
        image: "/images/stores/inklessismore/gallery/studio_2.jpg",
        category: "facility"
      },
      %{
        id: 8,
        title: "Our Team at Work",
        description: "Our specialists performing a laser treatment session",
        image: "/images/stores/inklessismore/gallery/team_1.jpg",
        category: "team"
      }
    ]

    {:ok,
     socket
     |> assign(:page_title, "Gallery | Inkless Is More")
     |> assign(:store, store)
     |> assign(:gallery_images, gallery_images)
     |> assign(:filter, "all")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="gallery-page">
      <!-- Hero Section -->
      <div class="relative">
        <img src={~p"/images/stores/inklessismore/gallery_hero.jpg"} alt="Inkless Is More Gallery" class="w-full h-[300px] object-cover" />
        <div class="absolute inset-0 bg-black bg-opacity-50 flex items-center justify-center">
          <div class="text-center text-white px-4">
            <h1 class="text-4xl md:text-5xl font-bold mb-4">Gallery</h1>
            <p class="text-xl md:text-2xl">See the results of our professional tattoo removal services</p>
          </div>
        </div>
      </div>

      <!-- Gallery Filter -->
      <div class="bg-white py-8">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="sm:flex sm:items-center sm:justify-between">
            <h2 class="text-2xl font-bold text-gray-900">Browse Our Gallery</h2>
            <div class="mt-4 sm:mt-0">
              <div class="flex space-x-2">
                <button 
                  phx-click="filter-gallery" 
                  phx-value-filter="all" 
                  class={"px-4 py-2 text-sm font-medium rounded-md #{if @filter == "all", do: "bg-gray-900 text-white", else: "bg-gray-200 text-gray-800 hover:bg-gray-300"}"}>
                  All
                </button>
                <button 
                  phx-click="filter-gallery" 
                  phx-value-filter="before_after" 
                  class={"px-4 py-2 text-sm font-medium rounded-md #{if @filter == "before_after", do: "bg-gray-900 text-white", else: "bg-gray-200 text-gray-800 hover:bg-gray-300"}"}>
                  Before & After
                </button>
                <button 
                  phx-click="filter-gallery" 
                  phx-value-filter="in_progress" 
                  class={"px-4 py-2 text-sm font-medium rounded-md #{if @filter == "in_progress", do: "bg-gray-900 text-white", else: "bg-gray-200 text-gray-800 hover:bg-gray-300"}"}>
                  In Progress
                </button>
                <button 
                  phx-click="filter-gallery" 
                  phx-value-filter="facility" 
                  class={"px-4 py-2 text-sm font-medium rounded-md #{if @filter == "facility", do: "bg-gray-900 text-white", else: "bg-gray-200 text-gray-800 hover:bg-gray-300"}"}>
                  Our Facility
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Gallery Grid -->
      <div class="bg-white py-8 pb-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <%= for image <- filtered_images(@gallery_images, @filter) do %>
              <%= if image.category in ["before_after", "in_progress"] do %>
                <div class="bg-gray-50 rounded-lg overflow-hidden shadow-md hover:shadow-lg transition duration-300">
                  <div class="flex">
                    <div class="w-1/2 relative">
                      <img src={image.before_image} alt={"Before - #{image.title}"} class="w-full h-64 object-cover" />
                      <div class="absolute top-2 left-2 bg-gray-900 text-white text-xs px-2 py-1 rounded">Before</div>
                    </div>
                    <div class="w-1/2 relative">
                      <img src={image.after_image} alt={"After - #{image.title}"} class="w-full h-64 object-cover" />
                      <div class="absolute top-2 right-2 bg-yellow-400 text-gray-900 text-xs px-2 py-1 rounded">After</div>
                    </div>
                  </div>
                  <div class="p-4">
                    <h3 class="text-lg font-bold text-gray-900"><%= image.title %></h3>
                    <p class="text-gray-600 text-sm"><%= image.description %></p>
                  </div>
                </div>
              <% else %>
                <div class="bg-gray-50 rounded-lg overflow-hidden shadow-md hover:shadow-lg transition duration-300">
                  <img src={image.image} alt={image.title} class="w-full h-64 object-cover" />
                  <div class="p-4">
                    <h3 class="text-lg font-bold text-gray-900"><%= image.title %></h3>
                    <p class="text-gray-600 text-sm"><%= image.description %></p>
                  </div>
                </div>
              <% end %>
            <% end %>
          </div>
        </div>
      </div>

      <!-- CTA Section -->
      <div class="bg-yellow-400 py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center">
            <h2 class="text-3xl font-extrabold text-gray-900 sm:text-4xl mb-4">
              Ready to Start Your Transformation?
            </h2>
            <p class="text-xl text-gray-800 mb-8">
              Book a free consultation to discuss your tattoo removal options.
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

  @impl true
  def handle_event("filter-gallery", %{"filter" => filter}, socket) do
    {:noreply, assign(socket, filter: filter)}
  end

  # Helper function to filter gallery images
  defp filtered_images(images, "all"), do: images
  defp filtered_images(images, filter), do: Enum.filter(images, & &1.category == filter)
end
