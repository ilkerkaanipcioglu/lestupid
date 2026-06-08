defmodule DukkadeeWeb.CustomerPortal.NewAppointmentLive do
  use DukkadeeWeb, :live_view
  alias Dukkadee.Appointments
  alias Dukkadee.Customers
  alias Dukkadee.Products

  @impl true
  def mount(_params, session, socket) do
    case session["customer_id"] do
      nil ->
        {:ok,
          socket
          |> put_flash(:error, "You must be logged in to book an appointment")
          |> redirect(to: Routes.customer_session_path(socket, :new))}

      customer_id ->
        customer = Customers.get_customer!(customer_id)
        products = Products.list_products_for_appointments()

        {:ok,
         socket
         |> assign(:page_title, "Book Appointment")
         |> assign(:customer, customer)
         |> assign(:products, products)
         |> assign(:selected_product, nil)
         |> assign(:available_slots, [])
         |> assign(:form, to_form(%{}))}
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
              <h1 class="text-3xl font-bold">Book Appointment</h1>
              <p class="text-gray-600 mt-2">Schedule your next tattoo removal session</p>
            </div>

            <div class="bg-white rounded-lg shadow p-6">
              <.form :let={f} for={@form} phx-change="select_product" class="space-y-6">
                <div>
                  <.input field={f[:product_id]} type="select" 
                    options={Enum.map(@products, &{"#{&1.name} - KSh#{&1.price}", &1.id})}
                    label="Select Treatment Package" 
                    prompt="Select a treatment package" />
                </div>
              </.form>

              <%= if @selected_product do %>
                <div class="mt-8">
                  <h3 class="text-xl font-semibold mb-4">Available Time Slots</h3>
                  <%= if Enum.empty?(@available_slots) do %>
                    <p class="text-gray-600">No available slots found for this treatment.</p>
                  <% else %>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                      <%= for slot <- @available_slots do %>
                        <button class="bg-white border border-gray-200 rounded-lg p-4 hover:bg-gray-50 text-left">
                          <div class="font-medium">
                            <%= Calendar.strftime(slot.start_time, "%B %d, %Y") %>
                          </div>
                          <div class="text-sm text-gray-600">
                            <%= Calendar.strftime(slot.start_time, "%I:%M %p") %> - <%= Calendar.strftime(slot.end_time, "%I:%M %p") %>
                          </div>
                        </button>
                      <% end %>
                    </div>
                  <% end %>
                </div>
              <% end %>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("select_product", %{"form" => %{"product_id" => product_id}}, socket) do
    product = Products.get_product!(product_id)
    available_slots = Appointments.get_available_slots(product_id)

    {:noreply,
     socket
     |> assign(:selected_product, product)
     |> assign(:available_slots, available_slots)}
  end
end
