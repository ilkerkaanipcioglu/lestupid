defmodule DukkadeeWeb.CustomerResetPasswordLive do
  use DukkadeeWeb, :live_view

  alias Dukkadee.Customers

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">Reset Password</.header>

      <.simple_form
        for={@form}
        id="reset_password_form"
        phx-submit="reset_password"
        phx-change="validate"
      >
        <.error :if={@form.errors != []}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.input field={@form[:email]} type="email" placeholder="Email" required />
        <:actions>
          <.button phx-disable-with="Sending..." class="w-full">
            Send password reset instructions
          </.button>
        </:actions>
      </.simple_form>

      <p class="text-center text-sm mt-4">
        <.link href={~p"/customers/log_in"}>Log in</.link>
        | <.link href={~p"/customers/register"}>Register</.link>
      </p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "customer"))}
  end

  def handle_event("reset_password", %{"customer" => %{"email" => email}}, socket) do
    if customer = Customers.get_customer_by_email(email) do
      Customers.deliver_customer_reset_password_instructions(
        customer,
        &url(~p"/customers/reset_password/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end
end
