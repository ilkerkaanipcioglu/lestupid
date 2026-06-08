defmodule DukkadeeWeb.UserLoginLive do
  use DukkadeeWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Sign in to your account
        <:subtitle>
          Don't have an account?
          <.link navigate={~p"/users/register"} class="text-indigo-600 font-semibold">
            Sign up
          </.link>
          for an account now.
        </:subtitle>
      </.header>

      <.simple_form for={%{}} as={:user} action={~p"/users/log_in"} phx-update="ignore">
        <.input field={{:email, ""}} label="Email" required type="email" />
        <.input field={{:password, ""}} label="Password" required type="password" />

        <:actions>
          <.input field={{:remember_me, "true"}} type="checkbox" label="Keep me logged in" />
          <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
            Forgot your password?
          </.link>
        </:actions>
        <:actions>
          <.button phx-disable-with="Signing in..." class="w-full">
            Sign in <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    {:ok, assign(socket, email: email, page_title: "Sign In")}
  end
end
