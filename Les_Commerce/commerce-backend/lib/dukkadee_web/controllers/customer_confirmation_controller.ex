defmodule DukkadeeWeb.CustomerConfirmationController do
  use DukkadeeWeb, :controller

  alias Dukkadee.Customers

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"customer" => %{"email" => email}}) do
    if customer = Customers.get_customer_by_email(email) do
      Customers.deliver_customer_confirmation_instructions(
        customer,
        &url(~p"/customers/confirm/#{&1}")
      )
    end

    conn
    |> put_flash(
      :info,
      "If your email is in our system and it has not been confirmed yet, " <>
        "you will receive an email with instructions shortly."
    )
    |> redirect(to: ~p"/")
  end

  def edit(conn, %{"token" => token}) do
    render(conn, :edit, token: token)
  end

  # Do not log in the customer after confirmation to avoid a
  # leaked token giving the customer access to the account.
  def update(conn, %{"token" => token}) do
    case Customers.confirm_customer(token) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Customer confirmed successfully.")
        |> redirect(to: ~p"/customers/log_in")

      :error ->
        # If there is a current customer and the account was already confirmed,
        # then odds are that the confirmation link was already visited, either
        # by some automation or by the customer themselves, so we redirect without
        # a warning message.
        case conn.assigns do
          %{current_customer: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
            redirect(conn, to: ~p"/")

          %{} ->
            conn
            |> put_flash(:error, "Customer confirmation link is invalid or it has expired.")
            |> redirect(to: ~p"/")
        end
    end
  end
end
