defmodule DukkadeeWeb.CustomerRegistrationLive do
  use DukkadeeWeb, :live_view

  alias Dukkadee.Customers
  alias Dukkadee.Customers.Customer

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Register for a customer account
        <:subtitle>
          Already registered?
          <.link navigate={~p"/customers/log_in"} class="font-semibold text-brand hover:underline">
            Sign in
          </.link>
          to your account now.
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="registration_form"
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/customers/log_in?_action=registered"}
        method="post"
      >
        <.error :if={@check_errors}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.input field={@form[:email]} type="email" label="Email" required />
        <.input field={@form[:password]} type="password" label="Password" required />
        <.input field={@form[:first_name]} type="text" label="First Name" required />
        <.input field={@form[:last_name]} type="text" label="Last Name" required />
        <.input field={@form[:phone]} type="tel" label="Phone" />

        <:actions>
          <.button phx-disable-with="Creating account..." class="w-full">Create an account</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Customers.change_customer_registration(%Customer{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"customer" => customer_params}, socket) do
    case Customers.register_customer(customer_params) do
      {:ok, customer} ->
        {:ok, _} =
          Customers.deliver_customer_confirmation_instructions(
            customer,
            &url(~p"/customers/confirm/#{&1}")
          )

        changeset = Customers.change_customer_registration(customer)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"customer" => customer_params}, socket) do
    changeset = Customers.change_customer_registration(%Customer{}, customer_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "customer")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
