defmodule DukkadeeWeb.AppointmentLive.ConfirmationLive do
  use DukkadeeWeb, :live_view
  
  alias Dukkadee.Appointments
  
  @impl true
  def mount(%{"id" => id}, _session, socket) do
    appointment = Appointments.get_appointment(id)
    
    if appointment do
      {:ok,
       socket
       |> assign(:page_title, "Appointment Confirmation")
       |> assign(:appointment, appointment)}
    else
      {:ok,
       socket
       |> put_flash(:error, "Appointment not found")
       |> redirect(to: ~p"/")}
    end
  end
  
  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto px-4 py-8">
      <div class="bg-white shadow-lg rounded-lg overflow-hidden">
        <div class="bg-green-500 text-white p-6 text-center">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 mx-auto mb-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
          </svg>
          <h1 class="text-2xl font-bold">Appointment Confirmed!</h1>
          <p class="mt-2">Your tattoo removal session has been scheduled.</p>
        </div>
        
        <div class="p-6">
          <h2 class="text-xl font-semibold mb-4">Appointment Details</h2>
          
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <h3 class="text-sm font-medium text-gray-500">Service</h3>
              <p class="mt-1"><%= @appointment.product.name %></p>
            </div>
            
            <div>
              <h3 class="text-sm font-medium text-gray-500">Date & Time</h3>
              <p class="mt-1"><%= format_datetime(@appointment.start_time) %></p>
            </div>
            
            <div>
              <h3 class="text-sm font-medium text-gray-500">Name</h3>
              <p class="mt-1"><%= @appointment.customer_name %></p>
            </div>
            
            <div>
              <h3 class="text-sm font-medium text-gray-500">Email</h3>
              <p class="mt-1"><%= @appointment.customer_email %></p>
            </div>
            
            <div>
              <h3 class="text-sm font-medium text-gray-500">Phone</h3>
              <p class="mt-1"><%= @appointment.customer_phone %></p>
            </div>
            
            <div>
              <h3 class="text-sm font-medium text-gray-500">Status</h3>
              <p class="mt-1 capitalize"><%= @appointment.status %></p>
            </div>
          </div>
          
          <div class="mt-6">
            <h3 class="text-sm font-medium text-gray-500">Tattoo Details</h3>
            <div class="mt-2 grid grid-cols-1 md:grid-cols-3 gap-4">
              <div>
                <p class="text-xs text-gray-500">Size</p>
                <p class="mt-1"><%= format_tattoo_size(@appointment.tattoo_size) %></p>
              </div>
              <div>
                <p class="text-xs text-gray-500">Age</p>
                <p class="mt-1"><%= format_tattoo_age(@appointment.tattoo_age) %></p>
              </div>
              <div>
                <p class="text-xs text-gray-500">Colors</p>
                <p class="mt-1"><%= format_tattoo_colors(@appointment.tattoo_colors) %></p>
              </div>
            </div>
          </div>
          
          <%= if @appointment.notes do %>
            <div class="mt-6">
              <h3 class="text-sm font-medium text-gray-500">Additional Notes</h3>
              <p class="mt-1 text-gray-700"><%= @appointment.notes %></p>
            </div>
          <% end %>
          
          <div class="mt-8 bg-gray-50 p-4 rounded-md">
            <h3 class="font-medium text-gray-700">What to expect:</h3>
            <ul class="mt-2 space-y-1 text-sm text-gray-600">
              <li>• You will receive a confirmation email shortly.</li>
              <li>• Please arrive 10 minutes before your scheduled time.</li>
              <li>• Bring a form of ID for verification.</li>
              <li>• Wear comfortable clothing that allows easy access to the tattoo area.</li>
              <li>• If you need to reschedule, please contact us at least 24 hours in advance.</li>
            </ul>
          </div>
          
          <div class="mt-8 flex flex-col sm:flex-row justify-between items-center">
            <a href={~p"/stores/inklessismore-ke"} class="text-indigo-600 hover:text-indigo-800">
              ← Return to Inkless Is More
            </a>
            
            <button class="mt-4 sm:mt-0 bg-indigo-600 hover:bg-indigo-700 text-white py-2 px-4 rounded" onclick="window.print()">
              Print Confirmation
            </button>
          </div>
        </div>
      </div>
    </div>
    """
  end
  
  # Helper functions
  defp format_datetime(datetime) do
    # Format the datetime in a user-friendly way
    # Example: "Monday, August 15, 2023 at 2:30 PM"
    Calendar.strftime(datetime, "%A, %B %d, %Y at %I:%M %p")
  end
  
  defp format_tattoo_size(size) do
    case size do
      "small" -> "Small (up to 2 inches)"
      "medium" -> "Medium (2-5 inches)"
      "large" -> "Large (5-8 inches)"
      "extra_large" -> "Extra Large (8+ inches)"
      _ -> size
    end
  end
  
  defp format_tattoo_age(age) do
    case age do
      "less_than_1" -> "Less than 1 year"
      "1_to_5" -> "1-5 years"
      "5_to_10" -> "5-10 years"
      "more_than_10" -> "More than 10 years"
      _ -> age
    end
  end
  
  defp format_tattoo_colors(colors) when is_list(colors) do
    # Capitalize each color and join with commas
    colors
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(", ")
  end
  
  defp format_tattoo_colors(_), do: "Not specified"
end
