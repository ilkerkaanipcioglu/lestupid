defmodule DukkadeeWeb.AppointmentLive.TattooRemovalFormComponent do
  use DukkadeeWeb, :live_component
  
  alias Dukkadee.Appointments
  alias Dukkadee.Appointments.Appointment
  
  @impl true
  def render(assigns) do
    ~H"""
    <div class="tattoo-removal-appointment-form">
      <h2 class="text-2xl font-bold mb-4">Book Your Tattoo Removal Session</h2>
      
      <.form for={@form} phx-submit="save" phx-target={@myself} class="space-y-4">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <.input field={@form[:customer_name]} type="text" label="Your Name" required />
          </div>
          <div>
            <.input field={@form[:customer_email]} type="email" label="Email Address" required />
          </div>
        </div>
        
        <div>
          <.input field={@form[:customer_phone]} type="tel" label="Phone Number" required />
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <.input field={@form[:date]} type="date" label="Preferred Date" required />
          </div>
          <div>
            <.input field={@form[:time]} type="time" label="Preferred Time" required />
          </div>
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Tattoo Details</label>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
            <div>
              <.input field={@form[:tattoo_size]} type="select" label="Approximate Size" options={tattoo_size_options()} required />
            </div>
            <div>
              <.input field={@form[:tattoo_age]} type="select" label="Tattoo Age" options={tattoo_age_options()} required />
            </div>
          </div>
          <div>
            <.input field={@form[:tattoo_colors]} type="select" label="Colors in Tattoo" options={tattoo_color_options()} multiple required />
            <p class="text-xs text-gray-500 mt-1">Hold Ctrl/Cmd to select multiple colors</p>
          </div>
        </div>
        
        <div>
          <.input field={@form[:notes]} type="textarea" label="Additional Notes" placeholder="Please share any other details about your tattoo or questions you have about the removal process" />
        </div>
        
        <div class="flex items-center mt-4">
          <input type="checkbox" id="consent" name="consent" class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded" required />
          <label for="consent" class="ml-2 block text-sm text-gray-900">
            I understand that multiple sessions are typically required for complete tattoo removal and results may vary.
          </label>
        </div>
        
        <div class="mt-6">
          <button type="submit" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">
            Book Appointment
          </button>
        </div>
      </.form>
      
      <div class="mt-8 text-sm text-gray-500">
        <h3 class="font-medium text-gray-700 mb-2">What to expect:</h3>
        <ul class="list-disc pl-5 space-y-1">
          <li>Sessions typically last 15-30 minutes depending on tattoo size</li>
          <li>We recommend 6-8 weeks between sessions for optimal results</li>
          <li>You'll receive confirmation of your appointment via email</li>
          <li>Please arrive 10 minutes before your scheduled time</li>
        </ul>
      </div>
    </div>
    """
  end
  
  @impl true
  def update(%{product: product} = assigns, socket) do
    changeset = Appointments.change_appointment(%Appointment{})
    
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, to_form(changeset))
     |> assign(:product, product)}
  end
  
  @impl true
  def handle_event("save", %{"appointment" => appointment_params}, socket) do
    # Convert date and time strings to DateTime
    appointment_params = process_datetime(appointment_params)
    
    # Add product_id to params
    appointment_params = Map.put(appointment_params, "product_id", socket.assigns.product.id)
    
    case Appointments.create_appointment(appointment_params) do
      {:ok, appointment} ->
        send(self(), {:appointment_created, appointment})
        
        {:noreply,
         socket
         |> put_flash(:info, "Appointment scheduled successfully!")
         |> push_navigate(to: ~p"/appointments/confirmation/#{appointment.id}")}
        
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end
  
  # Helper functions for form options
  defp tattoo_size_options do
    [
      {"Small (up to 2 inches)", "small"},
      {"Medium (2-5 inches)", "medium"},
      {"Large (5-8 inches)", "large"},
      {"Extra Large (8+ inches)", "extra_large"}
    ]
  end
  
  defp tattoo_age_options do
    [
      {"Less than 1 year", "less_than_1"},
      {"1-5 years", "1_to_5"},
      {"5-10 years", "5_to_10"},
      {"More than 10 years", "more_than_10"}
    ]
  end
  
  defp tattoo_color_options do
    [
      {"Black", "black"},
      {"Blue", "blue"},
      {"Red", "red"},
      {"Green", "green"},
      {"Yellow", "yellow"},
      {"Orange", "orange"},
      {"Purple", "purple"},
      {"White", "white"},
      {"Other", "other"}
    ]
  end
  
  # Process the date and time fields into start_time and end_time
  defp process_datetime(%{"date" => date, "time" => time} = params) do
    # Parse date and time
    [year, month, day] = String.split(date, "-") |> Enum.map(&String.to_integer/1)
    [hour, minute] = String.split(time, ":") |> Enum.map(&String.to_integer/1)
    
    # Create DateTime for start_time (in UTC)
    {:ok, naive_dt} = NaiveDateTime.new(year, month, day, hour, minute, 0)
    {:ok, start_time} = DateTime.from_naive(naive_dt, "Etc/UTC")
    
    # Set end_time to 30 minutes after start_time
    end_time = DateTime.add(start_time, 30 * 60, :second)
    
    # Remove date and time from params and add start_time and end_time
    params
    |> Map.drop(["date", "time"])
    |> Map.put("start_time", start_time)
    |> Map.put("end_time", end_time)
  end
  
  defp process_datetime(params), do: params
end
