defmodule DukkadeeWeb.CustomerPortal.ProfileLive do
  use DukkadeeWeb, :live_view
  alias Dukkadee.Customers
  import DukkadeeWeb.CustomerPortalComponents

  @impl true
  def mount(_params, session, socket) do
    case session["customer_id"] do
      nil ->
        {:ok, 
          socket
          |> put_flash(:error, "You must be logged in to access the customer portal")
          |> redirect(to: Routes.customer_session_path(socket, :new))}
          
      customer_id ->
        customer = Customers.get_customer!(customer_id)
        changeset = Customers.change_customer_profile(customer)
        password_changeset = Customers.change_customer_password(customer)
        
        {:ok, 
         socket
         |> assign(:page_title, "My Profile")
         |> assign(:customer, customer)
         |> assign(:changeset, changeset)
         |> assign(:password_changeset, password_changeset)
         |> assign(:current_password, nil)}
    end
  end
  
  @impl true
  def handle_params(%{"action" => "edit"}, _uri, socket) do
    {:noreply, assign(socket, :page_title, "Edit Profile")}
  end
  
  @impl true
  def handle_params(%{"action" => "password"}, _uri, socket) do
    {:noreply, assign(socket, :page_title, "Change Password")}
  end
  
  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end
  
  @impl true
  def handle_event("save_profile", %{"customer" => params}, socket) do
    %{customer: customer} = socket.assigns
    
    case Customers.update_customer_profile(customer, params) do
      {:ok, updated_customer} ->
        {:noreply, 
         socket
         |> assign(:customer, updated_customer)
         |> assign(:changeset, Customers.change_customer_profile(updated_customer))
         |> put_flash(:info, "Profile updated successfully")
         |> push_navigate(to: Routes.profile_live_path(socket, :index))}
         
      {:error, changeset} ->
        {:noreply, 
         socket
         |> assign(:changeset, changeset)
         |> put_flash(:error, "Error updating profile")}
    end
  end
  
  @impl true
  def handle_event("save_password", %{"customer" => params}, socket) do
    %{customer: customer} = socket.assigns
    
    case Customers.update_customer_password(customer, params["current_password"], params) do
      {:ok, _customer} ->
        {:noreply,
         socket
         |> put_flash(:info, "Password updated successfully")
         |> push_navigate(to: Routes.profile_live_path(socket, :index))}
         
      {:error, changeset} ->
        {:noreply, 
         socket
         |> assign(:password_changeset, changeset)
         |> put_flash(:error, "Error updating password")}
    end
  end
  
  @impl true
  def render(assigns) do
    ~H"""
    <div class="customer-portal">
      <div class="container mx-auto px-4 py-8">
        <div class="flex flex-wrap">
          <!-- Sidebar -->
          <div class="w-full md:w-1/4 p-4">
            <div class="bg-white rounded-lg shadow p-6">
              <div class="text-center mb-6">
                <%= if @customer.profile_photo do %>
                  <img src={@customer.profile_photo} alt={@customer.first_name} class="mx-auto h-24 w-24 rounded-full object-cover">
                <% else %>
                  <div class="mx-auto h-24 w-24 rounded-full bg-gray-200 flex items-center justify-center">
                    <span class="text-2xl font-bold text-gray-500"><%= String.slice(@customer.first_name || "", 0, 1) %><%= String.slice(@customer.last_name || "", 0, 1) %></span>
                  </div>
                <% end %>
                <h2 class="mt-4 text-xl font-bold"><%= @customer.first_name %> <%= @customer.last_name %></h2>
              </div>
              
              <nav class="mt-8">
                <ul>
                  <li class="mb-2">
                    <a href={~p"/customer/dashboard"} class="block p-3 hover:bg-gray-100 rounded-md">
                      Dashboard
                    </a>
                  </li>
                  <li class="mb-2">
                    <a href={~p"/customer/appointments"} class="block p-3 hover:bg-gray-100 rounded-md">
                      My Appointments
                    </a>
                  </li>
                  <li class="mb-2">
                    <a href={~p"/customer/progress"} class="block p-3 hover:bg-gray-100 rounded-md">
                      Treatment Progress
                    </a>
                  </li>
                  <li class="mb-2">
                    <a href={~p"/customer/profile"} class="block p-3 hover:bg-gray-100 rounded-md">
                      Profile Settings
                    </a>
                  </li>
                  <li class="mt-8">
                    <form action={~p"/customers/log_out"} method="post">
                      <input type="hidden" name="_csrf_token" value={Phoenix.Controller.get_csrf_token()} />
                      <button type="submit" class="w-full text-left block p-3 text-red-600 hover:bg-red-50 rounded-md">
                        Sign Out
                      </button>
                    </form>
                  </li>
                </ul>
              </nav>
            </div>
          </div>

          <!-- Main Content -->
          <div class="w-full md:w-3/4 p-4">
            <div class="mb-6">
              <h1 class="text-3xl font-bold">Profile Settings</h1>
              <p class="text-gray-600 mt-2">Manage your account information and preferences</p>
            </div>

            <div class="bg-white rounded-lg shadow p-6">
              <.form :let={f} for={@changeset} phx-change="validate" phx-submit="save_profile" class="space-y-6">
                <.input field={f[:first_name]} type="text" label="First Name" />
                <.input field={f[:last_name]} type="text" label="Last Name" />
                <.input field={f[:email]} type="email" label="Email" />
                <.input field={f[:phone]} type="text" label="Phone" />
                <.input field={f[:profile_photo]} type="file" label="Profile Photo" />
                <.input field={f[:color_preferences]} type="select" options={@color_options} label="Color Preferences" />

                <div class="mt-6">
                  <.button class="px-4 py-2 bg-brand-yellow text-brand-dark-1 rounded-md hover:bg-amber-400">Save Changes</.button>
                </div>
              </.form>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
