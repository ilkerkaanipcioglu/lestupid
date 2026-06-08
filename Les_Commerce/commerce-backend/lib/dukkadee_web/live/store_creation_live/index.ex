defmodule DukkadeeWeb.StoreCreationLive.Index do
  use DukkadeeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      page_title: "Create Your Store",
      current_step: 1,
      form: %{
        store_name: "",
        store_url: "",
        description: "",
        theme: "modern",
        instagram_username: "",
        legacy_store_url: "",
        products_count: 0,
        pages_count: 0,
        forms_count: 0,
        brand_colors: []
      },
      url_available: nil,
      url_checking: false,
      themes: [
        %{id: "modern", name: "Modern", preview_url: "/images/theme-modern.jpg"},
        %{id: "minimal", name: "Minimal", preview_url: "/images/theme-minimal.jpg"},
        %{id: "bold", name: "Bold", preview_url: "/images/theme-bold.jpg"},
        %{id: "vintage", name: "Vintage", preview_url: "/images/theme-vintage.jpg"}
      ]
    )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-3xl">
      <div class="py-10">
        <h1 class="text-3xl font-bold text-center mb-6">Create Your Store in 1 Minute</h1>
        
        <div class="mb-10">
          <div class="flex justify-between w-full">
            <%= for step <- 1..3 do %>
              <div class="flex flex-col items-center">
                <div class={[
                  "w-10 h-10 rounded-full flex items-center justify-center text-white font-bold mb-2",
                  if(@current_step >= step, do: "bg-indigo-600", else: "bg-gray-300")
                ]}>
                  <%= step %>
                </div>
                <div class="text-sm text-gray-600">
                  <%= case step do
                    1 -> "Basic Info"
                    2 -> "Theme"
                    3 -> "Products"
                  end %>
                </div>
              </div>
              <%= if(step < 3) do %>
                <div class="flex-1 flex items-center">
                  <div class={[
                    "h-1 w-full",
                    if(@current_step > step, do: "bg-indigo-600", else: "bg-gray-200")
                  ]}></div>
                </div>
              <% end %>
            <% end %>
          </div>
        </div>
        
        <div class="bg-white p-6 rounded-lg shadow-md">
          <%= case @current_step do %>
            <% 1 -> %>
              <.form for={%{}} phx-submit="save_basic_info" phx-change="validate_form" class="space-y-6">
                <div>
                  <label class="block text-sm font-medium text-gray-700">Store Name</label>
                  <input 
                    type="text" 
                    name="store_name" 
                    value={@form.store_name}
                    required
                    class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
                  />
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700">Store URL</label>
                  <div class="mt-1 flex rounded-md shadow-sm">
                    <span class="inline-flex items-center px-3 rounded-l-md border border-r-0 border-gray-300 bg-gray-50 text-gray-500">
                      dukkadee.com/
                    </span>
                    <input
                      type="text"
                      name="store_url"
                      value={@form.store_url}
                      required
                      phx-debounce="300"
                      placeholder="yourstore"
                      class={[
                        "flex-1 min-w-0 block w-full px-3 py-2 rounded-none rounded-r-md border focus:outline-none",
                        if(@url_available == true, do: "border-green-500 focus:ring-green-500 focus:border-green-500", 
                          else: if(@url_available == false, do: "border-red-500 focus:ring-red-500 focus:border-red-500",
                            else: "border-gray-300 focus:ring-indigo-500 focus:border-indigo-500"))
                      ]}
                    />
                  </div>
                  <div class="mt-1">
                    <%= cond do %>
                      <% @url_checking -> %>
                        <p class="text-sm text-gray-500">Checking availability...</p>
                      <% @url_available == true -> %>
                        <p class="text-sm text-green-600">✓ This URL is available!</p>
                      <% @url_available == false -> %>
                        <p class="text-sm text-red-600">✗ This URL is already taken. Please try another.</p>
                      <% true -> %>
                        <p class="text-sm text-gray-500">Enter a URL for your store</p>
                    <% end %>
                  </div>
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700">Description</label>
                  <textarea
                    name="description"
                    rows="3"
                    class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
                  ><%= @form.description %></textarea>
                </div>
                
                <div class="flex justify-end">
                  <button type="submit" class="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                    Continue
                  </button>
                </div>
              </.form>
              
            <% 2 -> %>
              <div class="space-y-6">
                <h2 class="text-xl font-medium text-gray-900">Choose Your Store Theme</h2>
                
                <div class="grid grid-cols-2 gap-4">
                  <%= for theme <- @themes do %>
                    <div 
                      phx-click="select_theme"
                      phx-value-theme={theme.id}
                      class={[
                        "border-2 rounded-lg overflow-hidden cursor-pointer transition-all p-2",
                        if(@form.theme == theme.id, do: "border-indigo-600", else: "border-gray-200 hover:border-gray-300")
                      ]}
                    >
                      <div class="bg-gray-200 h-32 mb-2 rounded flex items-center justify-center">
                        <p class="text-gray-500 text-sm">[Theme Preview]</p>
                      </div>
                      <div class="text-center">
                        <p class="font-medium"><%= theme.name %></p>
                      </div>
                    </div>
                  <% end %>
                </div>
                
                <div class="flex justify-between">
                  <button 
                    phx-click="previous_step" 
                    class="inline-flex justify-center py-2 px-4 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                  >
                    Back
                  </button>
                  <button 
                    phx-click="next_step" 
                    class="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                  >
                    Continue
                  </button>
                </div>
              </div>
              
            <% 3 -> %>
              <div class="space-y-6">
                <h2 class="text-xl font-medium text-gray-900">Import Products</h2>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700">Import from Instagram</label>
                  <div class="mt-1 flex rounded-md shadow-sm">
                    <span class="inline-flex items-center px-3 rounded-l-md border border-r-0 border-gray-300 bg-gray-50 text-gray-500">
                      @
                    </span>
                    <input
                      type="text"
                      name="instagram_username"
                      value={@form.instagram_username}
                      placeholder="username"
                      class="flex-1 min-w-0 block w-full px-3 py-2 rounded-none rounded-r-md border border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
                    />
                    <button 
                      type="button" 
                      phx-click="import_instagram"
                      class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-r-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                    >
                      Import
                    </button>
                  </div>
                  <p class="mt-1 text-sm text-gray-500">Connect your Instagram account to import products</p>
                </div>
                
                <div class="mt-6">
                  <label class="block text-sm font-medium text-gray-700">Import from Legacy Store</label>
                  <div class="mt-1 flex rounded-md shadow-sm">
                    <span class="inline-flex items-center px-3 rounded-l-md border border-r-0 border-gray-300 bg-gray-50 text-gray-500">
                      URL
                    </span>
                    <input
                      type="text"
                      name="legacy_store_url"
                      value={@form.legacy_store_url}
                      placeholder="https://your-old-store.com"
                      class="flex-1 min-w-0 block w-full px-3 py-2 rounded-none rounded-r-md border border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
                    />
                    <button 
                      type="button" 
                      phx-click="import_legacy_store"
                      class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-r-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                    >
                      Import
                    </button>
                  </div>
                  <p class="mt-1 text-sm text-gray-500">We'll redesign your old store with your brand colors and modern design</p>
                  
                  <div class="mt-3 p-3 bg-blue-50 border border-blue-200 rounded-md">
                    <div class="flex">
                      <div class="flex-shrink-0">
                        <svg class="h-5 w-5 text-blue-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                          <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" />
                        </svg>
                      </div>
                      <div class="ml-3 flex-1 md:flex md:justify-between">
                        <p class="text-sm text-blue-700">
                          Enter your old store URL and we'll automatically import all your products, pages, and forms while giving them a fresh, modern design.
                        </p>
                      </div>
                    </div>
                  </div>
                </div>
                
                <div class="border border-gray-200 rounded-md p-4">
                  <%= if @form.products_count > 0 || @form.pages_count > 0 || @form.forms_count > 0 do %>
                    <h3 class="text-lg font-medium text-gray-900 mb-3">Import Summary</h3>
                    
                    <div class="grid grid-cols-3 gap-4 mb-4">
                      <div class="bg-white p-4 rounded-lg border border-gray-200 text-center">
                        <div class="text-2xl font-bold text-indigo-600"><%= @form.products_count %></div>
                        <div class="text-sm text-gray-500">Products</div>
                      </div>
                      
                      <div class="bg-white p-4 rounded-lg border border-gray-200 text-center">
                        <div class="text-2xl font-bold text-indigo-600"><%= @form.pages_count %></div>
                        <div class="text-sm text-gray-500">Pages</div>
                      </div>
                      
                      <div class="bg-white p-4 rounded-lg border border-gray-200 text-center">
                        <div class="text-2xl font-bold text-indigo-600"><%= @form.forms_count %></div>
                        <div class="text-sm text-gray-500">Forms</div>
                      </div>
                    </div>
                    
                    <%= if length(@form.brand_colors) > 0 do %>
                      <div class="mb-4">
                        <h4 class="text-sm font-medium text-gray-700 mb-2">Detected Brand Colors</h4>
                        <div class="flex space-x-2">
                          <%= for color <- @form.brand_colors do %>
                            <div class="w-8 h-8 rounded-full border border-gray-200" style={"background-color: #{color}"}></div>
                          <% end %>
                        </div>
                      </div>
                    <% end %>
                    
                    <div class="text-sm text-gray-500">
                      Your store has been redesigned with a modern look while preserving your brand identity.
                    </div>
                  <% else %>
                    <div class="text-center py-6">
                      <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                      </svg>
                      <h3 class="mt-2 text-sm font-medium text-gray-900">No imports yet</h3>
                      <p class="mt-1 text-sm text-gray-500">
                        Import your products from Instagram or your legacy store to get started.
                      </p>
                    </div>
                  <% end %>
                </div>
                
                <div class="flex justify-center">
                  <label 
                    for="file-upload" 
                    class="cursor-pointer inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                  >
                    <svg class="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
                      <path d="M5.5 13a3.5 3.5 0 01-.369-6.98 4 4 0 117.753-1.977A4.5 4.5 0 1113.5 13H11V9.413l1.293 1.293a1 1 0 001.414-1.414l-3-3a1 1 0 00-1.414 0l-3 3a1 1 0 001.414 1.414L9 9.414V13H5.5z" />
                      <path d="M9 13h2v5a1 1 0 11-2 0v-5z" />
                    </svg>
                    Upload Product Photos
                  </label>
                  <input id="file-upload" type="file" class="hidden" multiple />
                </div>
                
                <div class="flex justify-between">
                  <button 
                    phx-click="previous_step" 
                    class="inline-flex justify-center py-2 px-4 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                  >
                    Back
                  </button>
                  <button 
                    phx-click="create_store" 
                    class="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500"
                  >
                    Create My Store
                  </button>
                </div>
              </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("select_theme", %{"theme" => theme}, socket) do
    updated_form = Map.put(socket.assigns.form, :theme, theme)
    {:noreply, assign(socket, form: updated_form)}
  end

  @impl true
  def handle_event("save_basic_info", params, socket) do
    # Only proceed if URL is available
    if socket.assigns.url_available do
      updated_form = Map.merge(socket.assigns.form, %{
        store_name: params["store_name"],
        store_url: params["store_url"],
        description: params["description"]
      })
      
      {:noreply, socket 
        |> assign(form: updated_form) 
        |> assign(current_step: socket.assigns.current_step + 1)}
    else
      {:noreply, socket |> put_flash(:error, "Please choose an available store URL")}
    end
  end

  @impl true
  def handle_event("validate_form", %{"store_url" => url} = params, socket) do
    if url && String.length(url) > 0 do
      # Set checking state
      socket = assign(socket, url_checking: true)
      
      # Update form with current values
      updated_form = Map.merge(socket.assigns.form, %{
        store_name: params["store_name"] || socket.assigns.form.store_name,
        store_url: url,
        description: params["description"] || socket.assigns.form.description
      })
      
      # Check URL availability (simulated)
      # In a real app, this would check against the database
      Process.send_after(self(), {:check_url_availability, url}, 500)
      
      {:noreply, assign(socket, form: updated_form)}
    else
      {:noreply, socket |> assign(url_available: nil, url_checking: false)}
    end
  end

  @impl true
  def handle_event("next_step", _params, socket) do
    {:noreply, assign(socket, current_step: socket.assigns.current_step + 1)}
  end

  @impl true
  def handle_event("previous_step", _params, socket) do
    {:noreply, assign(socket, current_step: socket.assigns.current_step - 1)}
  end

  @impl true
  def handle_event("import_instagram", _params, socket) do
    # This would connect to Instagram API in a real implementation
    # For now, we just show a flash message
    socket = put_flash(socket, :info, "Instagram import would happen here in the actual implementation")
    {:noreply, socket}
  end

  @impl true
  def handle_event("import_legacy_store", _params, socket) do
    # This would normally initiate the import process
    # For now, we just show a flash message and update the UI
    
    # Get the legacy store URL from the form
    legacy_store_url = socket.assigns.form.legacy_store_url
    
    if legacy_store_url && legacy_store_url != "" do
      # In a real implementation, this would call the LegacyStoreImporter
      # and redirect to a progress page
      
      # For development, we'll just update the UI
      socket = 
        socket
        |> put_flash(:info, "Legacy store import initiated for: #{legacy_store_url}. We're extracting products, pages, and forms while applying your brand colors.")
        |> update(:form, fn form -> 
          # Update the form with some mock data that would normally come from the import
          Map.merge(form, %{
            name: "Imported Store",
            description: "This store was imported from #{legacy_store_url}",
            products_count: 10,
            pages_count: 5,
            forms_count: 2,
            brand_colors: ["#3B82F6", "#1E40AF", "#FFFFFF"]
          })
        end)
      
      {:noreply, socket}
    else
      socket = put_flash(socket, :error, "Please enter a valid store URL")
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("create_store", _params, socket) do
    # This would save the store to the database in a real implementation
    # For now, we just redirect to a success page
    {:noreply, 
      socket
      |> put_flash(:info, "Your store has been created successfully!")
      |> redirect(to: "/")}
  end

  @impl true
  def handle_info({:check_url_availability, url}, socket) do
    # Simulate URL availability check
    # In a real app, this would query the database
    available = !Enum.member?(["taken", "reserved", "admin", "store"], url)
    
    {:noreply, socket 
      |> assign(url_available: available) 
      |> assign(url_checking: false)}
  end
end
