defmodule DukkadeeWeb.CustomerPortal.ProgressTrackerLive do
  use DukkadeeWeb, :live_view
  
  alias Dukkadee.Customers
  alias Dukkadee.Treatments
  
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
        treatments = Treatments.list_customer_treatments(customer_id)
        
        {:ok, 
         socket
         |> assign(:page_title, "Treatment Progress")
         |> assign(:customer, customer)
         |> assign(:treatments, treatments)}
    end
  end
  
  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
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
                    <a href={Routes.dashboard_live_path(@socket, :index)} class="block p-3 hover:bg-gray-100 rounded-md">
                      Dashboard
                    </a>
                  </li>
                  <li class="mb-2">
                    <a href={Routes.appointments_live_path(@socket, :index)} class="block p-3 hover:bg-gray-100 rounded-md">
                      My Appointments
                    </a>
                  </li>
                  <li class="mb-2">
                    <a href={Routes.progress_tracker_live_path(@socket, :index)} class="block p-3 bg-blue-100 text-blue-800 rounded-md font-medium">
                      Treatment Progress
                    </a>
                  </li>
                  <li class="mb-2">
                    <a href={Routes.profile_live_path(@socket, :index)} class="block p-3 hover:bg-gray-100 rounded-md">
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
            <div class="mb-6">
              <h1 class="text-3xl font-bold">My Treatment Progress</h1>
              <p class="text-gray-600 mt-2">Track your tattoo removal journey with us.</p>
            </div>
            
            <!-- No treatments yet message -->
            <%= if Enum.empty?(@treatments) do %>
              <div class="bg-white rounded-lg shadow p-8 text-center">
                <div class="w-24 h-24 mx-auto bg-gray-100 rounded-full flex items-center justify-center">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                  </svg>
                </div>
                <h2 class="text-xl font-semibold mt-4">No Treatments Started Yet</h2>
                <p class="text-gray-600 mt-2 max-w-md mx-auto">
                  You haven't started any treatments with us yet. Once you book and complete your first appointment, your progress will appear here.
                </p>
                <div class="mt-6">
                  <a href="/book-appointment" class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700">
                    Book Your First Appointment
                  </a>
                </div>
              </div>
            <% else %>
              <!-- Treatment progress cards -->
              <div class="space-y-6">
                <%= for treatment <- @treatments do %>
                  <div class="bg-white rounded-lg shadow overflow-hidden">
                    <div class="bg-gradient-to-r from-blue-500 to-purple-600 px-6 py-4">
                      <div class="flex justify-between items-center">
                        <h2 class="text-xl font-bold text-white"><%= treatment.tattoo_name %></h2>
                        <span class="px-3 py-1 bg-white bg-opacity-25 rounded-full text-white text-sm">
                          <%= treatment.package_name %>
                        </span>
                      </div>
                      <p class="text-blue-100 mt-1">Started on <%= Calendar.strftime(treatment.started_at, "%B %d, %Y") %></p>
                    </div>
                    
                    <!-- Progress bar -->
                    <div class="px-6 py-4">
                      <div class="flex justify-between text-sm mb-2">
                        <span class="font-medium">Progress</span>
                        <span><%= treatment.completed_sessions %> of <%= treatment.total_sessions %> sessions completed</span>
                      </div>
                      
                      <div class="w-full bg-gray-200 rounded-full h-2.5">
                        <div class="bg-blue-600 h-2.5 rounded-full" style={"width: #{calculate_progress_percentage(treatment)}%"}></div>
                      </div>
                    </div>
                    
                    <!-- Sessions timeline -->
                    <div class="border-t px-6 py-4">
                      <h3 class="text-lg font-semibold mb-4">Treatment Timeline</h3>
                      <div class="relative">
                        <%= for {session, index} <- Enum.with_index(treatment.sessions) do %>
                          <div class="flex mb-6 last:mb-0">
                            <!-- Timeline line -->
                            <%= if index < Enum.count(treatment.sessions) - 1 do %>
                              <div class="absolute h-full w-0.5 bg-gray-200 left-2.5 top-0 z-0"></div>
                            <% end %>
                            
                            <!-- Status circle -->
                            <div class={"relative z-10 rounded-full h-5 w-5 flex-shrink-0 #{session_status_color(session)}"}>
                            </div>
                            
                            <!-- Session details -->
                            <div class="ml-4 flex-1">
                              <div class="flex flex-wrap justify-between">
                                <h4 class="text-base font-medium">Session <%= index + 1 %></h4>
                                <span class="text-sm text-gray-500">
                                  <%= if session.completed_at, do: Calendar.strftime(session.completed_at, "%B %d, %Y"), else: session_status_text(session) %>
                                </span>
                              </div>
                              
                              <%= if session.notes do %>
                                <p class="text-sm text-gray-600 mt-1"><%= session.notes %></p>
                              <% end %>
                              
                              <%= if session.before_photo && session.after_photo && session.completed_at do %>
                                <div class="mt-3 flex space-x-4">
                                  <div class="w-1/2">
                                    <p class="text-xs text-gray-500 mb-1">Before</p>
                                    <img src={session.before_photo} alt="Before treatment" class="w-full h-32 object-cover rounded-md">
                                  </div>
                                  <div class="w-1/2">
                                    <p class="text-xs text-gray-500 mb-1">After</p>
                                    <img src={session.after_photo} alt="After treatment" class="w-full h-32 object-cover rounded-md">
                                  </div>
                                </div>
                              <% end %>
                              
                              <%= if session.next_appointment && !session.completed_at do %>
                                <div class="mt-2 flex items-center">
                                  <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-gray-400 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                  </svg>
                                  <span class="text-sm">
                                    Next appointment: <%= Calendar.strftime(session.next_appointment, "%B %d, %Y at %I:%M %p") %>
                                  </span>
                                </div>
                              <% end %>
                            </div>
                          </div>
                        <% end %>
                      </div>
                    </div>
                    
                    <!-- Overall results -->
                    <%= if treatment.completed_sessions > 0 do %>
                      <div class="border-t px-6 py-4">
                        <h3 class="text-lg font-semibold mb-4">Overall Results</h3>
                        <div class="flex space-x-4">
                          <div class="w-1/2">
                            <p class="text-sm text-gray-500 mb-1">Before Treatment</p>
                            <img src={treatment.before_photo} alt="Before treatment started" class="w-full h-48 object-cover rounded-md">
                          </div>
                          <div class="w-1/2">
                            <p class="text-sm text-gray-500 mb-1">Current Progress</p>
                            <img src={treatment.current_photo} alt="Current progress" class="w-full h-48 object-cover rounded-md">
                          </div>
                        </div>
                      </div>
                    <% end %>
                    
                    <!-- Action buttons -->
                    <div class="bg-gray-50 px-6 py-3 flex justify-between">
                      <%= if treatment.next_appointment do %>
                        <div>
                          <span class="text-sm text-gray-500">Next appointment:</span>
                          <span class="ml-1 text-sm font-medium"><%= Calendar.strftime(treatment.next_appointment, "%B %d, %Y") %></span>
                        </div>
                        <a href={Routes.appointments_live_path(@socket, :edit, treatment.next_appointment_id)} class="text-blue-600 hover:text-blue-800 text-sm font-medium">
                          Reschedule
                        </a>
                      <% else %>
                        <span></span>
                        <a href={Routes.appointments_live_path(@socket, :new)} class="text-blue-600 hover:text-blue-800 text-sm font-medium">
                          Book Next Session
                        </a>
                      <% end %>
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
  
  # Helper functions
  defp calculate_progress_percentage(treatment) do
    percentage = (treatment.completed_sessions / treatment.total_sessions) * 100
    trunc(percentage)
  end
  
  defp session_status_color(session) do
    cond do
      session.completed_at -> "bg-green-500"
      session.next_appointment -> "bg-blue-500"
      true -> "bg-gray-300"
    end
  end
  
  defp session_status_text(session) do
    cond do
      session.completed_at -> "Completed"
      session.next_appointment -> "Scheduled"
      true -> "Not scheduled"
    end
  end
end
