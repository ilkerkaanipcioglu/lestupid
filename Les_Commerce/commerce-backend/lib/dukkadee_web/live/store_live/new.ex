defmodule DukkadeeWeb.StoreLive.New do
  use DukkadeeWeb, :live_view

  alias Dukkadee.Accounts
  alias Dukkadee.Stores
  alias Dukkadee.Stores.Store

  @steps [:account, :store_details, :theme, :instagram, :confirmation]

  def mount(_params, session, socket) do
    socket =
      assign(socket,
        current_step: :account,
        steps: @steps,
        progress: 0,
        page_title: "Create Your Store in 1 Minute",
        current_user: session["current_user"],
        changeset: %{
          account: Accounts.change_user_registration(%Accounts.User{}),
          store: Stores.change_store(%Store{})
        },
        form_data: %{
          email: "",
          password: "",
          store_name: "",
          store_description: "",
          theme: "default",
          hosting: "dukkadee", # or "self_hosted"
          self_hosted_url: "",
          instagram_connected: false,
          instagram_username: "",
          instagram_products: []
        },
        form: to_form(%{"name" => "", "slug" => "", "description" => ""})
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-2xl mx-auto py-8">
      <.header>
        Create a New Store
        <:subtitle>Set up your online store with Dukkadee</:subtitle>
      </.header>

      <div class="mt-8">
        <.simple_form for={@form} as={:store} phx-submit="save">
          <.input field={@form[:name]} type="text" label="Store Name" required />
          <.input field={@form[:slug]} type="text" label="Store URL" required />
          <.input field={@form[:description]} type="textarea" label="Description" />
          
          <:actions>
            <.button phx-disable-with="Creating...">Create Store</.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def handle_event("save", %{"store" => _store_params}, socket) do
    # TODO: Implement store creation logic
    {:noreply, socket}
  end

  def handle_event("next_step", %{"account" => account_params}, %{assigns: %{current_step: :account}} = socket) do
    # Handle account creation or login
    form_data = Map.merge(socket.assigns.form_data, %{
      email: account_params["email"],
      password: account_params["password"]
    })

    socket =
      socket
      |> assign(current_step: :store_details)
      |> assign(progress: calculate_progress(:store_details))
      |> assign(form_data: form_data)

    {:noreply, socket}
  end

  def handle_event("next_step", %{"store" => store_params}, %{assigns: %{current_step: :store_details}} = socket) do
    # Handle store details
    form_data = Map.merge(socket.assigns.form_data, %{
      store_name: store_params["name"],
      store_description: store_params["description"],
      hosting: store_params["hosting"],
      self_hosted_url: store_params["self_hosted_url"]
    })

    socket =
      socket
      |> assign(current_step: :theme)
      |> assign(progress: calculate_progress(:theme))
      |> assign(form_data: form_data)

    {:noreply, socket}
  end

  def handle_event("next_step", %{"theme" => theme_params}, %{assigns: %{current_step: :theme}} = socket) do
    # Handle theme selection
    form_data = Map.merge(socket.assigns.form_data, %{
      theme: theme_params["selected_theme"]
    })

    socket =
      socket
      |> assign(current_step: :instagram)
      |> assign(progress: calculate_progress(:instagram))
      |> assign(form_data: form_data)

    {:noreply, socket}
  end

  def handle_event("next_step", %{"instagram" => instagram_params}, %{assigns: %{current_step: :instagram}} = socket) do
    # Handle Instagram integration
    form_data = Map.merge(socket.assigns.form_data, %{
      instagram_connected: instagram_params["connected"] == "true",
      instagram_username: instagram_params["username"]
    })

    # If connected, fetch products from Instagram
    form_data =
      if form_data.instagram_connected do
        Map.put(form_data, :instagram_products, fetch_instagram_products(form_data.instagram_username))
      else
        form_data
      end

    socket =
      socket
      |> assign(current_step: :confirmation)
      |> assign(progress: calculate_progress(:confirmation))
      |> assign(form_data: form_data)

    {:noreply, socket}
  end

  def handle_event("next_step", _params, %{assigns: %{current_step: :confirmation}} = socket) do
    # Create the user account (if new user)
    # Create the store
    # Import products from Instagram if connected
    # Redirect to new store admin panel
    
    with {:ok, user} <- create_or_get_user(socket),
         {:ok, store} <- create_store(socket, user) do
      
      if socket.assigns.form_data.instagram_connected do
        import_instagram_products(store, socket.assigns.form_data.instagram_products)
      end
      
      socket =
        socket
        |> put_flash(:info, "Your store has been created successfully!")
        |> redirect(to: ~p"/admin/stores/#{store.id}")
      
      {:noreply, socket}
    else
      {:error, step, changeset, _changes} ->
        socket =
          socket
          |> assign(current_step: step)
          |> assign(progress: calculate_progress(step))
          |> assign(changeset: Map.put(socket.assigns.changeset, step, changeset))
          |> put_flash(:error, "There was an error creating your store. Please check the form.")
        
        {:noreply, socket}
    end
  end

  def handle_event("prev_step", _params, socket) do
    current_index = Enum.find_index(@steps, &(&1 == socket.assigns.current_step))
    
    if current_index > 0 do
      prev_step = Enum.at(@steps, current_index - 1)
      
      socket =
        socket
        |> assign(current_step: prev_step)
        |> assign(progress: calculate_progress(prev_step))
      
      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  def handle_event("validate_account", %{"user" => user_params}, socket) do
    changeset =
      %Dukkadee.Accounts.User{}
      |> Dukkadee.Accounts.change_user_registration(user_params)
      |> Map.put(:action, :validate)

    socket =
      socket
      |> assign(changeset: Map.put(socket.assigns.changeset, :account, changeset))

    {:noreply, socket}
  end

  def handle_event("validate_store", %{"store" => store_params}, socket) do
    changeset =
      %Dukkadee.Stores.Store{}
      |> Dukkadee.Stores.change_store(store_params)
      |> Map.put(:action, :validate)

    socket =
      socket
      |> assign(changeset: Map.put(socket.assigns.changeset, :store, changeset))

    {:noreply, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  defp calculate_progress(current_step) do
    current_index = Enum.find_index(@steps, &(&1 == current_step))
    trunc(current_index / (length(@steps) - 1) * 100)
  end

  defp create_or_get_user(socket) do
    if socket.assigns.current_user do
      {:ok, socket.assigns.current_user}
    else
      user_params = %{
        email: socket.assigns.form_data.email,
        password: socket.assigns.form_data.password
      }

      Accounts.register_user(user_params)
    end
  end

  defp create_store(socket, user) do
    store_params = %{
      name: socket.assigns.form_data.store_name,
      description: socket.assigns.form_data.store_description,
      theme: socket.assigns.form_data.theme,
      user_id: user.id,
      self_hosted: socket.assigns.form_data.hosting == "self_hosted",
      self_hosted_url: socket.assigns.form_data.self_hosted_url
    }

    Stores.create_store(store_params)
  end

  defp fetch_instagram_products(_username) do
    # This would be replaced with actual Instagram API integration
    # For now, we'll return dummy data
    [
      %{
        image_url: "https://via.placeholder.com/300x300.png?text=Product+1",
        caption: "Beautiful product #fashion #style",
        suggested_name: "Fashion Item 1",
        suggested_price: 29.99
      },
      %{
        image_url: "https://via.placeholder.com/300x300.png?text=Product+2",
        caption: "Another great product #accessories",
        suggested_name: "Accessory 1",
        suggested_price: 19.99
      },
      %{
        image_url: "https://via.placeholder.com/300x300.png?text=Product+3",
        caption: "Must-have item #musthave #trendy",
        suggested_name: "Trendy Item 1",
        suggested_price: 39.99
      }
    ]
  end

  defp import_instagram_products(store, products) do
    # For each Instagram product, create a product in our database
    Enum.each(products, fn instagram_product ->
      product_params = %{
        name: instagram_product.suggested_name,
        description: instagram_product.caption,
        price: instagram_product.suggested_price,
        images: [instagram_product.image_url],
        store_id: store.id,
        is_published: true
      }

      Dukkadee.Products.create_product(product_params)
    end)
  end
end
