defmodule DukkadeeWeb.Plugs.EnsureStoreOwner do
  @moduledoc """
  Plug to ensure the current user is the owner of the store they're trying to access.
  
  This plug should be used for all store admin routes.
  """
  import Plug.Conn
  import Phoenix.Controller

  alias DukkadeeWeb.Router.Helpers, as: Routes
  
  def init(opts), do: opts
  
  def call(conn, _opts) do
    # Extract store_id from params
    store_id = get_store_id(conn)
    
    # Get current user from session
    current_user_id = get_session(conn, :current_user_id)
    
    if is_nil(current_user_id) do
      # User is not logged in
      conn
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    else
      # Check if user owns this store
      case Dukkadee.Stores.get_store_by_owner(store_id, current_user_id) do
        nil ->
          # User is not the owner of this store
          conn
          |> put_flash(:error, "You don't have permission to manage this store")
          |> redirect(to: Routes.home_path(conn, :index))
          |> halt()
        _store ->
          # User is the owner, continue
          conn
      end
    end
  end
  
  # Helper to extract store_id from various path parameters
  defp get_store_id(conn) do
    conn.path_params["store_id"]
  end
end 