defmodule DukkadeeWeb.CustomerSessionController do
  use DukkadeeWeb, :controller

  alias DukkadeeWeb.CustomerAuth

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"customer" => customer_params}) do
    %{"email" => email, "password" => password} = customer_params

    if customer = Dukkadee.Customers.get_customer_by_email_and_password(email, password) do
      CustomerAuth.log_in_customer(conn, customer, customer_params)
    else
      conn
      |> put_flash(:error, "Invalid email or password")
      |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Signed out successfully.")
    |> CustomerAuth.log_out_customer()
  end
end
