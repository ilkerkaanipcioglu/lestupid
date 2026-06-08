# lib/dukkadee_web/live/store_creation_live.html.heex
<div class="max-w-4xl mx-auto px-4 py-8">
  <h1 class="text-3xl font-bold mb-8 text-center">Create Your Store in 1 Minute</h1>
  
  <!-- Step indicator -->
  <div class="mb-8 flex justify-center">
    <%= for {step, index} <- Enum.with_index(@steps) do %>
      <div class="flex items-center">
        <div class={
          "w-10 h-10 rounded-full flex items-center justify-center font-bold
          #{if index <= @step_index, do: "bg-blue-600 text-white", else: "bg-gray-200 text-gray-600"}"
        }>
          <%= index + 1 %>
        </div>
        <div class="text-sm mt-2 text-center w-24">
          <%= case step do
              :store_info -> "Store Info"
              :select_template -> "Template"
              :import_products -> "Import"
            end %>
        </div>
        <%= if index < length(@steps) - 1 do %>
          <div class={
            "h-1 w-16 mx-1
            #{if index < @step_index, do: "bg-blue-600", else: "bg-gray-200"}"
          }></div>
        <% end %>
      </div>
    <% end %>
  </div>
  
  <!-- Step content -->
  <div class="bg-white shadow-md rounded-lg p-6">
    <%= case @step do %>
      <% :store_info -> %>
        <%= render_store_info(assigns) %>
      <% :select_template -> %>
        <%= render_template_selection(assigns) %>
      <% :import_products -> %>
        <%= render_import_products(assigns) %>
    <% end %>
  </div>
</div>

<%= defp render_store_info(assigns) do %>
  <.form :let={f} for={@changeset} phx-change="validate" phx-submit="save_store_info">
    <div class="space-y-6">
      <div>
        <%= label f, :name, "Store Name", class: "block text-sm font-medium text-gray-700" %>
        <%= text_input f, :name, class: "mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500", placeholder: "My Awesome Store" %>
        <%= error_tag f, :name %>
      </div>
      
      <div>
        <%= label f, :description, "Store Description", class: "block text-sm font-medium text-gray-700" %>
        <%= textarea f, :description, class: "mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500", rows: 3, placeholder: "Describe your store in a few sentences..." %>
        <%= error_tag f, :description %>
      </div>
      
      <div>
        <h3 class="text-lg font-medium text-gray-700 mb-3">Store URL</h3>
        
        <div class="space-y-4">
          <div class="flex items-start">
            <div class="flex items-center h-5">
              <input id="subdomain" name="domain_type" type="radio" value="subdomain" checked={@selected_domain_type == "subdomain"} phx-click="select_domain_type" phx-value-domain_type="subdomain" class="focus:ring-blue-500 h-4 w-4 text-blue-600 border-gray-300" />
            </div>
            <div class="ml-3">
              <label for="subdomain" class="font-