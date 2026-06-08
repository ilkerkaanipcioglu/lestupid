defmodule DukkadeeWeb.CustomerPortal.DashboardLive do
  use DukkadeeWeb, :live_view
  
  alias Dukkadee.Customers
  alias Dukkadee.Progress
  alias Dukkadee.Appointments

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
        
        # Get customer's treatment progress
        progress_records = Progress.list_customer_progress(customer_id)
        
        # Get upcoming appointments
        upcoming_appointments = Appointments.list_customer_appointments(customer_id)
        
        {:ok, 
         socket
         |> assign(:page_title, "Dashboard")
         |> assign(:customer, customer)
         |> assign(:progress_records, progress_records)
         |> assign(:upcoming_appointments, upcoming_appointments)}
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
                    <span class="text-2xl font-bold text-gray-500"><%= String.slice(@customer.first_name, 0, 1) %><%= String.slice(@customer.last_name, 0, 1) %></span>
                  </div>
                <% end %>
                <h2 class="mt-4 text-xl font-bold"><%= @customer.first_name %> <%= @customer.last_name %></h2>
              </div>
              
              <nav class="mt-8">
                <ul>
                  <li class="mb-2">
                    <a href="#" class="block p-3 bg-blue-100 text-blue-800 rounded-md font-medium">
                      Dashboard
                    </a>
                  </li>
                  <li class="mb-2">
                    <a href="#" class="block p-3 hover:bg-gray-100 rounded-md">
                      My Appointments
                    </a>
                  </li>
                  <li class="mb-2">
                    <a href="#" class="block p-3 hover:bg-gray-100 rounded-md">
                      Treatment Progress
                    </a>
                  </li>
                  <li class="mb-2">
                    <a href="#" class="block p-3 hover:bg-gray-100 rounded-md">
                      Profile Settings
                    </a>
                  </li>
                  <li class="mt-8">
                    <a href="#" class="block p-3 text-red-600 hover:bg-red-50 rounded-md">
                      Sign Out
                    </a>
                  </li>
                </ul>
              </nav>
            </div>
          </div>
          
          <!-- Main Content -->
          <div class="w-full md:w-3/4 p-4">
            <h1 class="text-3xl font-bold mb-8">Welcome back, <%= @customer.first_name %>!</h1>
            
            <!-- Upcoming appointments section -->
            <div class="bg-white rounded-lg shadow mb-8">
              <div class="border-b px-6 py-4">
                <h2 class="text-xl font-semibold">Your Upcoming Appointments</h2>
              </div>
              <div class="p-6">
                <%= if Enum.empty?(@upcoming_appointments) do %>
                  <p class="text-gray-500">You don't have any upcoming appointments scheduled.</p>
                  <a href="#" class="mt-4 inline-block px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700">Book an Appointment</a>
                <% else %>
                  <div class="space-y-4">
                    <%= for appointment <- @upcoming_appointments do %>
                      <div class="flex items-center p-4 border rounded-lg">
                        <div class="flex-1">
                          <h3 class="font-semibold"><%= appointment.service_type %></h3>
                          <p class="text-sm text-gray-600"><%= Calendar.strftime(appointment.start_time, "%B %d, %Y at %I:%M %p") %></p>
                        </div>
                        <div>
                          <button class="px-3 py-1 text-sm border border-red-600 text-red-600 rounded hover:bg-red-50">Cancel</button>
                          <button class="px-3 py-1 text-sm border border-blue-600 text-blue-600 rounded hover:bg-blue-50 ml-2">Reschedule</button>
                        </div>
                      </div>
                    <% end %>
                  </div>
                <% end %>
              </div>
            </div>
            
            <!-- Treatment progress section -->
            <div class="bg-white rounded-lg shadow">
              <div class="border-b px-6 py-4">
                <h2 class="text-xl font-semibold">Your Treatment Progress</h2>
              </div>
              <div class="p-6">
                <%= if Enum.empty?(@progress_records) do %>
                  <p class="text-gray-500">You don't have any active treatments yet.</p>
                <% else %>
                  <div class="space-y-8">
                    <%= for progress <- @progress_records do %>
                      <div class="border rounded-lg p-6">
                        <div class="flex flex-wrap items-center justify-between mb-4">
                          <h3 class="text-lg font-semibold"><%= progress.treatment_area %> Tattoo Removal</h3>
                          <span class={[
                            "px-3 py-1 rounded-full text-sm",
                            progress.status == "active" && "bg-green-100 text-green-800",
                            progress.status != "active" && "bg-gray-100 text-gray-800"
                          ]}>
                            <%= String.capitalize(progress.status) %>
                          </span>
                        </div>
                        
                        <div class="mb-4">
                          <div class="flex justify-between text-sm text-gray-600 mb-1">
                            <span>Progress</span>
                            <span><%= progress.current_session %> of <%= progress.total_sessions %> sessions</span>
                          </div>
                          <div class="w-full bg-gray-200 rounded-full h-2.5">
                            <div class="bg-blue-600 h-2.5 rounded-full" style={"width: #{progress.current_session / progress.total_sessions * 100}%"}></div>
                          </div>
                        </div>
                        
                        <div class="flex flex-wrap -mx-2">
                          <div class="w-full md:w-1/2 px-2 mb-4 md:mb-0">
                            <div class="border rounded p-2">
                              <p class="text-xs text-gray-500 mb-1">Before Treatment</p>
                              <%= if progress.initial_photo do %>
                                <img src={progress.initial_photo} alt="Before treatment" class="w-full h-48 object-cover rounded">
                              <% else %>
                                <div class="w-full h-48 bg-gray-100 flex items-center justify-center rounded">
                                  <span class="text-gray-400">No image available</span>
                                </div>
                              <% end %>
                            </div>
                          </div>
                          <div class="w-full md:w-1/2 px-2">
                            <div class="border rounded p-2">
                              <p class="text-xs text-gray-500 mb-1">Current Progress</p>
                              <%= if progress.current_photo do %>
                                <img src={progress.current_photo} alt="Current progress" class="w-full h-48 object-cover rounded">
                              <% else %>
                                <div class="w-full h-48 bg-gray-100 flex items-center justify-center rounded">
                                  <span class="text-gray-400">No image available</span>
                                </div>
                              <% end %>
                            </div>
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
      </div>
    </div>
    """
  end
end
