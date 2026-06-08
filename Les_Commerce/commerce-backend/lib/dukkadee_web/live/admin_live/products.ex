defmodule DukkadeeWeb.AdminLive.Products do
  use DukkadeeWeb, :live_view

  alias Dukkadee.Products
  alias Dukkadee.Products.Product

  @impl true
  def mount(%{"store_id" => store_id}, _session, socket) do
    # Set up LiveView uploads for product images
    {:ok,
     socket
     |> assign(:store_id, store_id)
     |> assign(:products, list_products(store_id))
     |> assign(:page_title, "Manage Products")
     |> allow_upload(:product_images,
       accept: ~w(.jpg .jpeg .png),
       max_entries: 5,
       # 10MB
       max_file_size: 10_000_000,
       auto_upload: true,
       progress: &handle_progress/3
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Products")
    |> assign(:product, nil)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Products.get_product!(id))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Products.get_product!(id)
    {:ok, _} = Products.delete_product(product)

    {:noreply, assign(socket, :products, list_products(socket.assigns.store_id))}
  end

  @impl true
  def handle_event("toggle-marketplace", %{"id" => id}, socket) do
    product = Products.get_product!(id)
    {:ok, _product} = Products.toggle_marketplace_listing(product)

    {:noreply, assign(socket, :products, list_products(socket.assigns.store_id))}
  end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      %Product{}
      |> Product.change_product(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"product" => product_params}, socket) do
    # Get uploaded files
    uploaded_files =
      consume_uploaded_entries(socket, :product_images, fn %{path: path}, entry ->
        # In a real app, we would move the file to a permanent location
        # and store the path in the database
        dest = Path.join(["priv", "static", "uploads", "#{entry.uuid}.#{ext(entry)}"])
        File.cp!(path, dest)
        Routes.static_path(socket, "/uploads/#{entry.uuid}.#{ext(entry)}")
      end)

    # Add uploaded files to product params
    product_params = Map.put(product_params, "images", uploaded_files)

    # Save product
    case Products.create_product(Map.put(product_params, "store_id", socket.assigns.store_id)) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully")
         |> push_redirect(to: Routes.admin_products_path(socket, :index, socket.assigns.store_id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  @impl true
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :product_images, ref)}
  end

  # Handle progress updates for uploads
  defp handle_progress(:product_images, entry, socket) do
    if entry.done? do
      {:noreply, socket}
    else
      # Calculate progress percentage
      _progress = floor(entry.progress * 100)

      # You could broadcast this progress to other users if needed
      # For now, we just return the socket
      {:noreply, socket}
    end
  end

  defp list_products(store_id) do
    Products.list_products_by_store(store_id)
  end

  defp ext(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    ext
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container mx-auto px-4 py-8">
      <div class="flex justify-between items-center mb-6">
        <h1 class="text-2xl font-bold">Products</h1>
        <.link
          navigate={Routes.admin_products_path(@socket, :new, @store_id)}
          class="bg-indigo-600 hover:bg-indigo-700 text-white py-2 px-4 rounded"
        >
          Add Product
        </.link>
      </div>

      <div class="bg-white shadow-md rounded-lg overflow-hidden">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Image</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Name</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Price</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Marketplace</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <%= for product <- @products do %>
              <tr id={"product-#{product.id}"} class="hover:bg-gray-50">
                <td class="px-6 py-4 whitespace-nowrap">
                  <%= if product.images && Enum.at(product.images, 0) do %>
                    <img src={Enum.at(product.images, 0)} alt={product.name} class="h-10 w-10 rounded-full" />
                  <% else %>
                    <div class="h-10 w-10 rounded-full bg-gray-200 flex items-center justify-center">
                      <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                      </svg>
                    </div>
                  <% end %>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <div class="text-sm font-medium text-gray-900"><%= product.name %></div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <div class="text-sm text-gray-900">$<%= product.price %></div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <%= if product.is_published do %>
                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                      Active
                    </span>
                  <% else %>
                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-800">
                      Draft
                    </span>
                  <% end %>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <button
                    phx-click="toggle-marketplace"
                    phx-value-id={product.id}
                    class={[
                      "px-2 inline-flex text-xs leading-5 font-semibold rounded-full",
                      if(product.is_marketplace_listed, do: "bg-blue-100 text-blue-800", else: "bg-gray-100 text-gray-800")
                    ]}
                  >
                    <%= if product.is_marketplace_listed, do: "Listed", else: "Not Listed" %>
                  </button>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                  <.link
                    navigate={Routes.admin_products_path(@socket, :edit, @store_id, product)}
                    class="text-indigo-600 hover:text-indigo-900 mr-3"
                  >
                    Edit
                  </.link>
                  <a href="#" phx-click="delete" phx-value-id={product.id} data-confirm="Are you sure?" class="text-red-600 hover:text-red-900">
                    Delete
                  </a>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>
    </div>
    """
  end
end
