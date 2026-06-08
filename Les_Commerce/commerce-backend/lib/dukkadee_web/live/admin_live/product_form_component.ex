defmodule DukkadeeWeb.AdminLive.ProductFormComponent do
  use DukkadeeWeb, :live_component

  alias Dukkadee.Products

  @impl true
  def update(%{product: product} = assigns, socket) do
    changeset = Products.change_product(product)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      socket.assigns.product
      |> Products.change_product(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.action, product_params)
  end

  defp save_product(socket, :edit, product_params) do
    # Get uploaded files
    uploaded_files =
      consume_uploaded_entries(socket, :product_images, fn %{path: path}, entry ->
        dest = Path.join(["priv", "static", "uploads", "#{entry.uuid}.#{ext(entry)}"])
        File.cp!(path, dest)
        "/uploads/#{entry.uuid}.#{ext(entry)}"
      end)
    
    # Add uploaded files to existing images
    current_images = socket.assigns.product.images || []
    product_params = Map.put(product_params, "images", current_images ++ uploaded_files)

    case Products.update_product(socket.assigns.product, product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_product(socket, :new, product_params) do
    # Get uploaded files
    uploaded_files =
      consume_uploaded_entries(socket, :product_images, fn %{path: path}, entry ->
        dest = Path.join(["priv", "static", "uploads", "#{entry.uuid}.#{ext(entry)}"])
        File.cp!(path, dest)
        "/uploads/#{entry.uuid}.#{ext(entry)}"
      end)
    
    # Add uploaded files to product params
    product_params = Map.put(product_params, "images", uploaded_files)
    
    # Add store_id to product params
    product_params = Map.put(product_params, "store_id", socket.assigns.store_id)

    case Products.create_product(product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp ext(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    ext
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form
        for={@changeset}
        id="product-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
        class="space-y-6"
      >
        <div class="space-y-4">
          <div>
            <.input field={@changeset[:name]} type="text" label="Name" required />
          </div>

          <div>
            <.input field={@changeset[:description]} type="textarea" label="Description" rows={4} />
          </div>

          <div>
            <.input field={@changeset[:price]} type="number" label="Price" step="0.01" required />
          </div>

          <div>
            <.input field={@changeset[:sku]} type="text" label="SKU" />
          </div>

          <div>
            <.input field={@changeset[:stock_quantity]} type="number" label="Stock Quantity" />
          </div>

          <div class="flex space-x-4">
            <div class="flex items-center">
              <.input 
                field={@changeset[:is_published]} 
                type="checkbox" 
                label="Published" 
                checked={@changeset.data.is_published} 
              />
            </div>
            
            <div class="flex items-center">
              <.input 
                field={@changeset[:is_featured]} 
                type="checkbox" 
                label="Featured" 
                checked={@changeset.data.is_featured}
              />
              <span class="ml-2 text-xs text-gray-500">
                Featured products will be displayed in the marketplace homepage and store homepage
              </span>
            </div>

            <div class="flex items-center">
              <.input 
                field={@changeset[:is_marketplace_listed]} 
                type="checkbox" 
                label="List in Marketplace" 
                checked={@changeset.data.is_marketplace_listed}
              />
              <span class="ml-2 text-xs text-gray-500">
                Make this product available in the global marketplace
              </span>
            </div>

            <div class="flex items-center">
              <.input 
                field={@changeset[:requires_appointment]} 
                type="checkbox" 
                label="Requires Appointment" 
                checked={@changeset.data.requires_appointment} 
              />
            </div>
          </div>

          <div class="mt-6">
            <label class="block text-sm font-medium text-gray-700 mb-2">
              Product Images
            </label>
            
            <div class="flex items-center justify-center w-full">
              <label class="flex flex-col w-full h-32 border-2 border-dashed border-gray-300 rounded-lg cursor-pointer hover:bg-gray-50">
                <div class="flex flex-col items-center justify-center pt-5 pb-6">
                  <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"></path>
                  </svg>
                  <p class="pt-1 text-sm text-gray-600">
                    <span class="font-semibold">Click to upload</span> or drag and drop
                  </p>
                  <p class="text-xs text-gray-500">
                    PNG, JPG, JPEG up to 10MB
                  </p>
                </div>
                <form phx-change="validate" phx-submit="save">
                  <%= live_file_input @uploads.product_images, class: "hidden" %>
                </form>
              </label>
            </div>
            
            <div class="mt-4">
              <%= for entry <- @uploads.product_images.entries do %>
                <div class="flex items-center space-x-2 mb-2">
                  <%= if entry.previewable? do %>
                    <div class="w-16 h-16 relative">
                      <%= live_img_preview entry, class: "w-16 h-16 object-cover rounded" %>
                      <div class="absolute inset-0 bg-black bg-opacity-50 flex items-center justify-center opacity-0 hover:opacity-100 transition-opacity duration-200">
                        <button phx-click="cancel-upload" phx-value-ref={entry.ref} class="text-white">
                          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                          </svg>
                        </button>
                      </div>
                    </div>
                  <% else %>
                    <div class="w-16 h-16 bg-gray-100 flex items-center justify-center rounded">
                      <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                      </svg>
                    </div>
                  <% end %>
                  
                  <div class="flex-1">
                    <div class="text-sm font-medium"><%= entry.client_name %></div>
                    <div class="text-xs text-gray-500"><%= entry.client_size |> format_bytes() %></div>
                    <div class="w-full h-2 bg-gray-200 rounded-full mt-1">
                      <div class="h-2 bg-indigo-600 rounded-full" style={"width: #{entry.progress}%"}></div>
                    </div>
                  </div>
                  
                  <button phx-click="cancel-upload" phx-value-ref={entry.ref} class="text-red-500 hover:text-red-700">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                  </button>
                </div>
              <% end %>
            </div>
            
            <%= for err <- upload_errors(@uploads.product_images) do %>
              <div class="text-red-500 text-sm mt-1">
                <%= error_to_string(err) %>
              </div>
            <% end %>
          </div>
          
          <%= if @product.images && length(@product.images) > 0 do %>
            <div class="mt-4">
              <h3 class="text-sm font-medium text-gray-700 mb-2">Current Images</h3>
              <div class="grid grid-cols-4 gap-4">
                <%= for {image, i} <- Enum.with_index(@product.images) do %>
                  <div class="relative">
                    <img src={image} alt="Product image" class="w-full h-24 object-cover rounded" />
                    <div class="absolute top-0 right-0 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center cursor-pointer">
                      <button phx-click="remove-image" phx-value-index={i} class="text-white">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                        </svg>
                      </button>
                    </div>
                  </div>
                <% end %>
              </div>
            </div>
          <% end %>
        </div>

        <div class="flex justify-end space-x-3">
          <.link
            navigate={@return_to}
            class="px-4 py-2 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50"
          >
            Cancel
          </.link>
          <.button type="submit" class="px-4 py-2 bg-indigo-600 border border-transparent rounded-md shadow-sm text-sm font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
            Save
          </.button>
        </div>
      </.form>
    </div>
    """
  end
  
  defp error_to_string(:too_large), do: "File is too large"
  defp error_to_string(:too_many_files), do: "Too many files"
  defp error_to_string(:not_accepted), do: "Unacceptable file type"
  
  defp format_bytes(bytes) do
    cond do
      bytes < 1_024 -> "#{bytes} B"
      bytes < 1_024_000 -> "#{Float.round(bytes / 1_024, 2)} KB"
      bytes < 1_024_000_000 -> "#{Float.round(bytes / 1_024_000, 2)} MB"
      true -> "#{Float.round(bytes / 1_024_000_000, 2)} GB"
    end
  end
end
