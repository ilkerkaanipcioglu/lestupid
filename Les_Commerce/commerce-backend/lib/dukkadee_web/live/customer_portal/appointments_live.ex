defmodule DukkadeeWeb.CustomerPortal.AppointmentsLive do
  use DukkadeeWeb, :live_view
  alias Dukkadee.Appointments
  alias Dukkadee.Customers

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
        appointments = Appointments.list_customer_appointments(customer_id)

        {:ok,
         socket
         |> assign(:page_title, "My Appointments")
         |> assign(:customer, customer)
         |> assign(:appointments, appointments)}
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
                    <a href={~p"/customer/appointments"} class="block p-3 bg-brand-yellow text-brand-dark-1 rounded-md font-medium">
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
              <h1 class="text-3xl font-bold">My Appointments</h1>
              <p class="text-gray-600 mt-2">Manage your upcoming tattoo removal sessions</p>
            </div>

            <%= if Enum.empty?(@appointments) do %>
              <div class="bg-white rounded-lg shadow p-8 text-center">
                <div class="w-24 h-24 mx-auto bg-gray-100 rounded-full flex items-center justify-center">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                  </svg>
                </div>
                <h2 class="text-xl font-semibold mt-4">No Upcoming Appointments</h2>
                <p class="text-gray-600 mt-2 max-w-md mx-auto">
                  You don't have any upcoming appointments scheduled. Book your next session now.
                </p>
                <div class="mt-6">
                  <a href={~p"/customer/appointments/new"} class="px-4 py-2 bg-brand-yellow text-brand-dark-1 rounded-md hover:bg-amber-400">
                    Book Appointment
                  </a>
                </div>
              </div>
            <% else %>
              <div class="space-y-4">
                <%= for appointment <- @appointments do %>
                  <div class="bg-white rounded-lg shadow">
                    <div class="px-6 py-4">
                      <div class="flex flex-wrap items-center justify-between">
                        <h2 class="text-xl font-semibold"><%= appointment.service_type %></h2>
                        <span class="px-3 py-1 rounded-full text-sm bg-gray-100">
                          <%= Calendar.strftime(appointment.start_time, "%B %d, %Y") %>
                        </span>
                      </div>
                      <p class="text-gray-600 mt-2">
                        <%= Calendar.strftime(appointment.start_time, "%I:%M %p") %> - <%= Calendar.strftime(appointment.end_time, "%I:%M %p") %>
                      </p>
                    </div>
                    <div class="bg-gray-50 px-6 py-3 border-t flex justify-between items-center">
                      <div>
                        <button class="px-3 py-1 border border-red-600 text-red-600 rounded-md hover:bg-red-50">
                          Cancel
                        </button>
                        <button class="px-3 py-1 border border-brand-yellow text-brand-dark-1 rounded-md hover:bg-brand-yellow hover:bg-opacity-10 ml-2">
                          Reschedule
                        </button>
                      </div>
                      <div class="text-sm text-gray-600">
                        Status: <%= String.capitalize(appointment.status) %>
                      </div>
                    </div>
                  </div>
                <% end %>
              </div>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
