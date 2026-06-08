defmodule DukkadeeWeb.CustomerPortalComponents do
  use Phoenix.Component
  use Phoenix.VerifiedRoutes,
    endpoint: DukkadeeWeb.Endpoint,
    router: DukkadeeWeb.Router

  # Only import what we're actually using
  import Phoenix.Component
  
  # We're using Phoenix.VerifiedRoutes, so we don't need Router.Helpers
  # import DukkadeeWeb.Router.Helpers
  
  # Alias BrandColors if you're actually using it, otherwise remove
  # alias DukkadeeWeb.Components.BrandColors

  @doc """
  Returns the active class for the current page.
  """
  def active_class(current_page, page) when current_page == page do
    "bg-brand-yellow text-gray-900"
  end

  def active_class(_, _) do
    "text-gray-600 hover:bg-gray-100"
  end

  @doc """
  Renders a customer portal sidebar.
  """
  attr :current_page, :string, required: true
  attr :customer, :map, required: true
  
  def sidebar(assigns) do
    ~H"""
    <div class="bg-white rounded-lg shadow p-6 sidebar">
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
            <a href="/customer/dashboard" class={"block p-3 rounded-md #{active_class(@current_page, "dashboard")}"}>
              Dashboard
            </a>
          </li>
          <li class="mb-2">
            <a href="/customer/appointments" class={"block p-3 rounded-md #{active_class(@current_page, "appointments")}"}>
              My Appointments
            </a>
          </li>
          <li class="mb-2">
            <a href="/customer/progress" class={"block p-3 rounded-md #{active_class(@current_page, "progress")}"}>
              Treatment Progress
            </a>
          </li>
          <li class="mb-2">
            <a href="/customer/profile" class={"block p-3 rounded-md #{active_class(@current_page, "profile")}"}>
              Profile Settings
            </a>
          </li>
          <li class="mt-8">
            <form action="/customers/log_out" method="post">
              <input type="hidden" name="_csrf_token" value={Phoenix.Controller.get_csrf_token()} />
              <button type="submit" class="w-full text-left block p-3 text-red-600 hover:bg-red-50 rounded-md">
                Sign Out
              </button>
            </form>
          </li>
        </ul>
      </nav>
    </div>
    """
  end

  @doc """
  Renders a progress bar component used in the customer portal.
  """
  attr :percentage, :integer, required: true
  attr :label, :string, default: nil
  attr :color, :string, default: "brand-yellow"
  
  def progress_bar(assigns) do
    ~H"""
    <div class="w-full">
      <%= if @label do %>
        <div class="flex justify-between text-sm mb-2">
          <span><%= @label %></span>
          <span><%= @percentage %>%</span>
        </div>
      <% end %>
      <div class="w-full bg-gray-200 rounded-full h-2.5">
        <div class={"h-2.5 rounded-full bg-#{@color}"} style={"width: #{@percentage}%"}></div>
      </div>
    </div>
    """
  end

  @doc """
  Renders a card component for the customer portal.
  """
  attr :class, :string, default: ""
  slot :header
  slot :inner_block, required: true
  slot :footer
  
  def portal_card(assigns) do
    ~H"""
    <div class={"bg-white rounded-lg shadow overflow-hidden #{@class}"}>
      <%= if @header != [] do %>
        <div class="border-b px-6 py-4 bg-brand-yellow">
          <%= render_slot(@header) %>
        </div>
      <% end %>
      
      <div class="p-6">
        <%= render_slot(@inner_block) %>
      </div>
      
      <%= if @footer != [] do %>
        <div class="bg-gray-50 px-6 py-3 border-t">
          <%= render_slot(@footer) %>
        </div>
      <% end %>
    </div>
    """
  end
  
  @doc """
  Renders a colored header card component for treatment progress.
  """
  attr :title, :string, required: true
  attr :subtitle, :string, default: nil
  attr :badge_text, :string, default: nil
  
  def treatment_header(assigns) do
    ~H"""
    <div class="bg-gradient-to-r from-brand-yellow to-brand-light-purple px-6 py-4">
      <div class="flex justify-between items-center">
        <h2 class="text-xl font-bold text-brand-dark-1"><%= @title %></h2>
        <%= if @badge_text do %>
          <span class="px-3 py-1 bg-white bg-opacity-25 rounded-full text-brand-dark-1 text-sm">
            <%= @badge_text %>
          </span>
        <% end %>
      </div>
      <%= if @subtitle do %>
        <p class="text-brand-dark-2 mt-1"><%= @subtitle %></p>
      <% end %>
    </div>
    """
  end
  
  @doc """
  Renders a button styled with brand colors.
  """
  attr :type, :string, default: "button"
  attr :class, :string, default: ""
  attr :variant, :string, default: "primary"
  attr :rest, :global
  slot :inner_block, required: true
  
  def brand_button(assigns) do
    ~H"""
    <button
      type={@type}
      class={button_classes(@variant, @class)}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end
  
  # Private helper functions
  
  defp button_classes("primary", class) do
    "px-4 py-2 bg-brand-yellow text-brand-dark-1 rounded-md hover:bg-amber-400 transition-colors #{class}"
  end
  
  defp button_classes("secondary", class) do
    "px-4 py-2 bg-brand-light-purple text-white rounded-md hover:bg-purple-400 transition-colors #{class}"
  end
  
  defp button_classes("outline", class) do
    "px-4 py-2 border border-brand-yellow text-brand-dark-1 rounded-md hover:bg-brand-yellow hover:bg-opacity-10 transition-colors #{class}"
  end
  
  defp button_classes("text", class) do
    "px-4 py-2 text-brand-yellow hover:text-amber-400 transition-colors #{class}"
  end
  
  defp button_classes("danger", class) do
    "px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700 transition-colors #{class}"
  end
  
  defp button_classes(_, class) do
    "px-4 py-2 bg-gray-200 text-gray-700 rounded-md hover:bg-gray-300 transition-colors #{class}"
  end
end
