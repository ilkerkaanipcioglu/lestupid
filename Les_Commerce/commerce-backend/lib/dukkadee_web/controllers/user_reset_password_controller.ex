defmodule DukkadeeWeb.UserResetPasswordController do
  use DukkadeeWeb, :controller

  def new(conn, _params) do
    # For development, just render a simple page
    # In real implementation, would allow user to request password reset
    conn
    |> put_flash(:info, "If your email is in our system, you will receive reset instructions shortly.")
    |> redirect(to: ~p"/users/log_in")
  end
end
