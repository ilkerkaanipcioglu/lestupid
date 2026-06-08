defmodule DukkadeeWeb.CoreComponents do
  use Phoenix.Component

  alias Phoenix.LiveView.JS

  # Helper functions for input component - consolidated to use pattern matching properly
  defp get_field_name(%Phoenix.HTML.FormField{name: name}), do: name
  defp get_field_name({name, _}), do: name
  defp get_field_name(_), do: nil

  defp get_field_id(%Phoenix.HTML.FormField{id: id}), do: id
  defp get_field_id({name, _}), do: name
  defp get_field_id(_), do: nil

  defp get_field_value(%Phoenix.HTML.FormField{value: value}), do: value
  defp get_field_value({_, value}), do: value
  defp get_field_value(_), do: nil

  attr :field, :any,
    doc: "a form field struct retrieved from the form (e.g., @form[:email]) or a tuple of {field_name, value}"

  attr :type, :string,
    default: "text",
    doc: "the type of input"

  attr :label, :string,
    doc: "the label for the input"

  attr :required, :boolean, default: false
  attr :errors, :list, default: []
  attr :rows, :integer, default: nil
  attr :rest, :global, include: ~w(autocomplete disabled form max maxlength min minlength pattern placeholder readonly required step)

  def input(assigns) do
    field_name = get_field_name(assigns.field)
    field_id = get_field_id(assigns.field)
    field_value = get_field_value(assigns.field)
    
    assigns = assign(assigns, field_name: field_name, field_id: field_id, field_value: field_value)
    
    ~H"""
    <div phx-feedback-for={@field_name}>
      <label for={@field_id} class="block text-sm font-medium leading-6 text-gray-900">
        <%= @label %>
      </label>
      <div class="mt-2">
        <%= if @type == "textarea" do %>
          <textarea
            name={@field_name}
            id={@field_id}
            rows={@rows}
            class={[
              "block w-full rounded-lg border-gray-300 py-3 px-4 placeholder-gray-400 shadow-sm focus:border-zinc-400 focus:ring-zinc-400 sm:text-sm",
              "phx-no-feedback:border-zinc-300 phx-no-feedback:focus:border-zinc-400 phx-no-feedback:focus:ring-zinc-400",
              @errors != [] && "border-rose-400 focus:border-rose-400 focus:ring-rose-400"
            ]}
            {@rest}
          ><%= Phoenix.HTML.Form.normalize_value("textarea", @field_value) %></textarea>
        <% else %>
          <input
            type={@type}
            name={@field_name}
            id={@field_id}
            value={Phoenix.HTML.Form.normalize_value(@type, @field_value)}
            class={[
              "block w-full rounded-lg border-gray-300 py-3 px-4 placeholder-gray-400 shadow-sm focus:border-zinc-400 focus:ring-zinc-400 sm:text-sm",
              "phx-no-feedback:border-zinc-300 phx-no-feedback:focus:border-zinc-400 phx-no-feedback:focus:ring-zinc-400",
              @errors != [] && "border-rose-400 focus:border-rose-400 focus:ring-rose-400"
            ]}
            {@rest}
          />
        <% end %>
      </div>
      <div class="mt-2 flex gap-3 text-sm leading-6 text-rose-600">
        <.error :for={msg <- @errors}><%= msg %></.error>
      </div>
    </div>
    """
  end

  @doc """
  Renders an error message.
  """
  attr :message, :string, default: nil
  attr :kind, :atom, default: :error
  slot :inner_block

  def error(assigns) do
    ~H"""
    <p class="flex gap-3 text-sm leading-6 text-rose-600 phx-no-feedback:hidden">
      <.icon :if={@kind == :info} name="hero-information-circle-mini" class="mt-0.5 h-5 w-5 flex-none" />
      <.icon :if={@kind == :error} name="hero-exclamation-circle-mini" class="mt-0.5 h-5 w-5 flex-none" />
      <%= render_slot(@inner_block) || @message %>
    </p>
    """
  end

  @doc """
  Renders a header with title.
  """
  attr :class, :string, default: nil

  slot :inner_block, required: true
  slot :subtitle
  slot :actions

  def header(assigns) do
    ~H"""
    <header class={[@actions != [] && "flex items-center justify-between gap-6", @class]}>
      <div>
        <h1 class="text-lg font-semibold leading-8 text-zinc-800">
          <%= render_slot(@inner_block) %>
        </h1>
        <p :if={@subtitle != []} class="mt-2 text-sm leading-6 text-zinc-600">
          <%= render_slot(@subtitle) %>
        </p>
      </div>
      <div class="flex-none"><%= render_slot(@actions) %></div>
    </header>
    """
  end

  @doc """
  Renders a button.
  """
  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def button(assigns) do
    ~H"""
    <button
      type={@type}
      class={[
        "phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3",
        "text-sm font-semibold leading-6 text-white active:text-white/80",
        @class
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  @doc """
  Renders a simple form.
  """
  attr :for, :any, required: true, doc: "the datastructure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target multipart),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  slot :inner_block, required: true
  slot :actions, doc: "the slot for form actions, such as a submit button"

  def simple_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <div class="mt-10 space-y-8 bg-white">
        <%= render_slot(@inner_block, f) %>
        <div :for={action <- @actions} class="mt-2 flex items-center justify-between gap-6">
          <%= render_slot(action, f) %>
        </div>
      </div>
    </.form>
    """
  end

  @doc """
  Renders a back navigation link.
  """
  attr :navigate, :string, required: true
  attr :class, :string, default: nil

  slot :inner_block, required: true

  def back(assigns) do
    ~H"""
    <div class={[@class]}>
      <.link
        navigate={@navigate}
        class="text-sm font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
      >
        <.icon name="hero-arrow-left-solid" class="h-3 w-3" />
        <%= render_slot(@inner_block) %>
      </.link>
    </div>
    """
  end

  @doc """
  Renders an icon.
  """
  attr :name, :string, required: true
  attr :class, :string, default: nil

  def icon(%{name: "hero-exclamation-circle-mini"} = assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 20 20"
      fill="currentColor"
      class={[@class, "h-5 w-5"]}
    >
      <path
        fill-rule="evenodd"
        d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-8-5a.75.75 0 01.75.75v4.5a.75.75 0 01-1.5 0v-4.5A.75.75 0 0110 5zm0 10a1 1 0 100-2 1 1 0 000 2z"
        clip-rule="evenodd"
      />
    </svg>
    """
  end

  def icon(%{name: "hero-arrow-left-solid"} = assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      fill="currentColor"
      class={[@class, "h-6 w-6"]}
    >
      <path
        fill-rule="evenodd"
        d="M11.03 3.97a.75.75 0 010 1.06l-6.22 6.22H21a.75.75 0 010 1.5H4.81l6.22 6.22a.75.75 0 11-1.06 1.06l-7.5-7.5a.75.75 0 010-1.06l7.5-7.5a.75.75 0 011.06 0z"
        clip-rule="evenodd"
      />
    </svg>
    """
  end

  def icon(%{name: "hero-information-circle-mini"} = assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 20 20"
      fill="currentColor"
      class={[@class, "h-5 w-5"]}
    >
      <path
        fill-rule="evenodd"
        d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a.75.75 0 000 1.5h.253a.25.25 0 01.244.304l-.459 2.066A1.75 1.75 0 0010.747 15H11a.75.75 0 000-1.5h-.253a.25.25 0 01-.244-.304l.459-2.066A1.75 1.75 0 009.253 9H9z"
        clip-rule="evenodd"
      />
    </svg>
    """
  end

  def icon(%{name: "hero-x-mark-solid"} = assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 20 20"
      fill="currentColor"
      class={[@class, "h-5 w-5"]}
    >
      <path d="M6.28 5.22a.75.75 0 00-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 101.06 1.06L10 11.06l3.72 3.72a.75.75 0 101.06-1.06L11.06 10l3.72-3.72a.75.75 0 00-1.06-1.06L10 8.94 6.28 5.22z" />
    </svg>
    """
  end

  def icon(%{name: "hero-arrow-path"} = assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      fill="currentColor"
      class={[@class, "h-3 w-3"]}
    >
      <path
        fill-rule="evenodd"
        d="M4.755 10.059a7.5 7.5 0 0112.548-3.364l1.903 1.903h-3.183a.75.75 0 100 1.5h4.992a.75.75 0 00.75-.75V4.356a.75.75 0 00-1.5 0v3.18l-1.9-1.9A9 9 0 003.306 9.67a.75.75 0 101.45.388zm15.408 3.352a.75.75 0 00-.919.53 7.5 7.5 0 01-12.548 3.364l-1.902-1.903h3.183a.75.75 0 000-1.5H2.984a.75.75 0 00-.75.75v4.992a.75.75 0 001.5 0v-3.18l1.9 1.9a9 9 0 0015.059-4.035.75.75 0 00-.53-.918z"
        clip-rule="evenodd"
      />
    </svg>
    """
  end

  def icon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={[@class, "hero-" <> @name]} />
    """
  end

  @doc """
  Renders flash notices.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages to display"

  def flash_group(assigns) do
    ~H"""
    <div class="fixed top-2 right-2 w-80 z-50">
      <.flash kind={:info} title="Success!" flash={@flash} />
      <.flash kind={:error} title="Error!" flash={@flash} />
      <.flash
        id="client-error"
        kind={:error}
        title="We can't find the internet"
        phx-disconnected={show_flash(".phx-client-error #client-error")}
        phx-connected={hide_flash("#client-error")}
        hidden
      >
        Attempting to reconnect <.icon name="hero-arrow-path" class="ml-1 h-3 w-3 animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title="Something went wrong!"
        phx-disconnected={show_flash(".phx-server-error #server-error")}
        phx-connected={hide_flash("#server-error")}
        hidden
      >
        Hang in there while we get back on track <.icon name="hero-arrow-path" class="ml-1 h-3 w-3 animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Renders a single flash alert.
  """
  attr :flash, :map
  attr :id, :string, default: nil
  attr :kind, :atom, values: [:info, :error], doc: "used for styling and flash lookup"
  attr :title, :string, default: nil
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"

  slot :inner_block, doc: "the optional inner block that renders the flash message"

  def flash(assigns) do
    ~H"""
    <div
      :if={msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      role="alert"
      class={[
        "fixed hidden top-2 right-2 w-80 sm:w-96 z-50 rounded-lg p-3 ring-1",
        @kind == :info && "bg-emerald-50 text-emerald-800 ring-emerald-500 fill-cyan-900",
        @kind == :error && "bg-rose-50 text-rose-900 shadow-md ring-rose-500 fill-rose-900"
      ]}
      {@rest}
    >
      <p :if={@title} class="flex items-center gap-1.5 text-sm font-semibold leading-6">
        <.icon :if={@kind == :info} name="hero-information-circle-mini" class="h-4 w-4" />
        <.icon :if={@kind == :error} name="hero-exclamation-circle-mini" class="h-4 w-4" />
        <%= @title %>
      </p>
      <p class="mt-2 text-sm leading-5"><%= msg %></p>
      <button type="button" class="group absolute top-1 right-1 p-2" aria-label="Close">
        <.icon name="hero-x-mark-solid" class="h-5 w-5 opacity-40 group-hover:opacity-70" />
      </button>
    </div>
    """
  end

  @doc """
  Shows the flash group with the given JS command.
  """
  def show_flash(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      transition: {
        "transition-all transform ease-out duration-300",
        "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
        "opacity-100 translate-y-0 sm:scale-100"
      }
    )
  end

  @doc """
  Hides the flash group with the given JS command.
  """
  def hide_flash(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition: {
        "transition-all transform ease-in duration-200",
        "opacity-100 translate-y-0 sm:scale-100",
        "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
      }
    )
  end
end
