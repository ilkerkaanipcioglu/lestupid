defmodule DukkadeeWeb.CustomerAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias Dukkadee.Customers
  alias DukkadeeWeb.Router.Helpers, as: Routes

  # Make the remember me cookie valid for 60 days.
  # If you want to do so, you have to also change the Phoenix.Token expiry.
  @max_age 60 * 60 * 24 * 60
  @remember_me_cookie "_dukkadee_web_customer_remember_me"
  @remember_me_options [sign: true, max_age: @max_age, same_site: "Lax"]

  def on_mount(:mount_current_customer, _params, session, socket) do
    {:cont, mount_current_customer(socket, session)}
  end

  def on_mount(:ensure_authenticated, _params, session, socket) do
    socket = mount_current_customer(socket, session)

    if socket.assigns.current_customer do
      {:cont, socket}
    else
      socket =
        socket
        |> Phoenix.LiveView.put_flash(:error, "You must log in to access this page.")
        |> Phoenix.LiveView.redirect(to: Routes.customer_login_path(socket, :new))

      {:halt, socket}
    end
  end

  def on_mount(:redirect_if_customer_authenticated, _params, session, socket) do
    socket = mount_current_customer(socket, session)

    if socket.assigns.current_customer do
      {:halt, Phoenix.LiveView.redirect(socket, to: signed_in_path(socket))}
    else
      {:cont, socket}
    end
  end

  defp mount_current_customer(socket, session) do
    Phoenix.Component.assign_new(socket, :current_customer, fn ->
      if customer_token = session["customer_token"] do
        Customers.get_customer_by_session_token(customer_token)
      end
    end)
  end

  def log_in_customer(conn, customer, params \\ %{}) do
    token = Customers.generate_customer_session_token(customer)
    customer_return_to = get_session(conn, :customer_return_to)

    conn
    |> renew_session()
    |> put_session(:customer_token, token)
    |> maybe_write_remember_me_cookie(token, params)
    |> redirect(to: customer_return_to || signed_in_path(conn))
  end

  defp maybe_write_remember_me_cookie(conn, token, %{"remember_me" => "true"}) do
    put_resp_cookie(conn, @remember_me_cookie, token, @remember_me_options)
  end

  defp maybe_write_remember_me_cookie(conn, _token, _params) do
    conn
  end

  # This function renews the session ID and erases the whole
  # session to avoid fixation attacks. If there is any data
  # in the session you may want to preserve after log in/log out,
  # you must explicitly fetch the session data before clearing
  # and then immediately set it after clearing.
  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  @doc """
  Logs the customer out.

  It clears all session data for safety. See renew_session.
  """
  def log_out_customer(conn) do
    customer_token = get_session(conn, :customer_token)
    customer_token && Customers.delete_session_token(customer_token)

    if live_socket_id = get_session(conn, :live_socket_id) do
      DukkadeeWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> renew_session()
    |> delete_resp_cookie(@remember_me_cookie)
    |> redirect(to: "/")
  end

  @doc """
  Authenticates the customer by looking into the session and remember me token.
  """
  def fetch_current_customer(conn, _opts) do
    {customer_token, conn} = ensure_customer_token(conn)
    customer = customer_token && Customers.get_customer_by_session_token(customer_token)
    assign(conn, :current_customer, customer)
  end

  defp ensure_customer_token(conn) do
    if customer_token = get_session(conn, :customer_token) do
      {customer_token, conn}
    else
      conn = fetch_cookies(conn, signed: [@remember_me_cookie])

      if customer_token = conn.cookies[@remember_me_cookie] do
        {customer_token, put_session(conn, :customer_token, customer_token)}
      else
        {nil, conn}
      end
    end
  end

  @doc """
  Used for routes that require the customer to not be authenticated.
  """
  def redirect_if_customer_is_authenticated(conn, _opts) do
    if conn.assigns[:current_customer] do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

  @doc """
  Used for routes that require the customer to be authenticated.
  """
  def require_authenticated_customer(conn, _opts) do
    if conn.assigns[:current_customer] do
      conn
    else
      conn
      |> put_flash(:error, "You must log in to access this page.")
      |> maybe_store_return_to()
      |> redirect(to: Routes.customer_login_path(conn, :new))
      |> halt()
    end
  end

  defp maybe_store_return_to(%{method: "GET"} = conn) do
    put_session(conn, :customer_return_to, current_path(conn))
  end

  defp maybe_store_return_to(conn), do: conn

  defp signed_in_path(conn_or_socket) do
    # Customize this to the path you want customers to go to after sign in
    # We're directing them to the customer portal
    case conn_or_socket do
      %Plug.Conn{} -> 
        Routes.dashboard_live_path(conn_or_socket, :index)
      socket -> 
        Routes.dashboard_live_path(socket, :index)
    end
  end
end
