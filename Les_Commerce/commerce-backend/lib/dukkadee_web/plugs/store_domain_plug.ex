defmodule DukkadeeWeb.StoreDomainPlug do
  @moduledoc """
  A plug that handles custom domains for stores.
  
  This plug checks the host header and assigns the corresponding store
  to the connection if a matching domain is found.
  """
  
  import Plug.Conn
  alias Dukkadee.Stores

  def init(opts), do: opts

  def call(conn, _opts) do
    host = get_host(conn)
    
    case find_store_by_domain(host) do
      nil -> conn
      store ->
        conn
        |> assign(:current_store, store)
        |> assign(:custom_domain, true)
    end
  end
  
  defp get_host(conn) do
    conn
    |> get_req_header("host")
    |> List.first()
    |> String.split(":")
    |> List.first()
  end
  
  defp find_store_by_domain(host) do
    # Skip for localhost or dukkadee.com domains
    if String.contains?(host, "localhost") || String.contains?(host, "dukkadee.com") do
      nil
    else
      Stores.get_store_by_domain(host)
    end
  end
end
