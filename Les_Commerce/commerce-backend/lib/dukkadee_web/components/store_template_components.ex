defmodule DukkadeeWeb.StoreTemplateComponents do
  use Phoenix.Component

  # Import CoreComponents for shared UI components
  import DukkadeeWeb.CoreComponents

  # Use VerifiedRoutes for route generation
  use Phoenix.VerifiedRoutes,
    endpoint: DukkadeeWeb.Endpoint,
    router: DukkadeeWeb.Router,
    statics: DukkadeeWeb.static_paths()

  def template_card(assigns) do
    ~H"""
    <div class="bg-white shadow rounded-lg p-6">
      <h3 class="text-lg font-semibold text-gray-900"><%= @template.name %></h3>
      <p class="mt-2 text-sm text-gray-600"><%= @template.description %></p>
      <div class="mt-4">
        <.button phx-click="select_template" phx-value-id={@template.id}>
          Select Template
        </.button>
      </div>
    </div>
    """
  end
end
