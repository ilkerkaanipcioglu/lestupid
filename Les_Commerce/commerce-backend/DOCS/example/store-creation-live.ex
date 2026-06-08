# lib/dukkadee_web/live/store_creation_live.ex
defmodule DukkadeeWeb.StoreCreationLive do
  use DukkadeeWeb, :live_view
  
  alias Dukkadee.Stores
  alias Dukkadee.Stores.Store
  
  @steps [:store_info, :select_template, :import_products]
  
  @impl true
  def mount(_params, session, socket) do
    current_user = session["current_user"]
    
    unless current_user do
      {:ok, 
        socket
        |> put_flash(:error, "You must be logged in to create a store")
        |> redirect(to: Routes.session_path(socket, :new))}
    else
      changeset = Stores.change_store(%Store{})
      
      {:ok, 
        socket
        |> assign(:current_user, current_user)
        |> assign(:changeset, changeset)
        |> assign(:step, :store_info)
        |> assign(:steps, @steps)
        |> assign(:step_index, 0)
        |> assign(:store_data, %{})
        |> assign(:selected_domain_type, "subdomain")
        |> assign(:available_templates, get_available_templates())}
    end
  end
  
  @impl true
  def handle_event("validate", %{"store" => store_params}, socket) do
    changeset =
      %Store{}
      |> Stores.change_store(store_params)
      |> Map.put(:action, :validate)
    
    {:noreply, assign(socket, :changeset, changeset)}
  end
  
  @impl true
  def handle_event("save_store_info", %{"store" => store_params}, socket) do
    store_data = Map.merge(socket.assigns.store_data, store_params)
    
    {:noreply, 
      socket
      |> assign(:store_data, store_data)
      |> assign(:step, :select_template)
      |> assign(:step_index, 1)}
  end
  
  @impl true
  def handle_event("select_template", %{"template" => template}, socket) do
    store_data = Map.put(socket.assigns.store_data, "theme", template)
    
    {:noreply, 
      socket
      |> assign(:store_data, store_data)
      |> assign(:step, :import_products)
      |> assign(:step_index, 2)}
  end
  
  @impl true
  def handle_event("select_domain_type", %{"domain_type" => domain_type}, socket) do
    {:noreply, assign(socket, :selected_domain_type, domain_type)}
  end
  
  @impl true
  def handle_event("back", _params, socket) do
    current_index = socket.assigns.step_index
    
    if current_index > 0 do
      previous_step = Enum.at(@steps, current_index - 1)
      
      {:noreply, 
        socket
        |> assign(:step, previous_step)
        |> assign(:step_index, current_index - 1)}
    else
      {:noreply, socket}
    end
  end
  
  @impl true
  def handle_event("create_store", params, socket) do
    user_id = socket.assigns.current_user.id
    
    store_params = Map.merge(socket.assigns.store_data, %{
      "user_id" => user_id,
      "imported_products" => Map.get(params, "imported_products", [])
    })
    
    case Stores.create_store(store_params) do
      {:ok, store} ->
        # If products were imported, create them here
        # This is simplified, in a real app you'd process imported products
        
        {:noreply,
          socket
          |> put_flash(:info, "Store created successfully!")
          |> redirect(to: Routes.store_path(socket, :show, store.slug))}
          
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, 
          socket
          |> assign(:changeset, changeset)
          |> put_flash(:error, "Error creating store")}
    end
  end
  
  defp get_available_templates do
    [
      %{id: "default", name: "Default", description: "A clean, modern store layout", image: "/images/templates/default.jpg"},
      %{id: "boutique", name: "Boutique", description: "Perfect for clothing and fashion", image: "/images/templates/boutique.jpg"},
      %{id: "tech", name: "Technology", description: "Great for gadgets and electronics", image: "/images/templates/tech.jpg"},
      %{id: "service", name: "Service Business", description: "For appointment-based businesses", image: "/images/templates/service.jpg"}
    ]
  end
end
