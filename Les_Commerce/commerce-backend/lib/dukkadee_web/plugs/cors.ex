defmodule DukkadeeWeb.Plugs.CORS do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    conn =
      conn
      |> put_resp_header("access-control-allow-origin", "*")
      |> put_resp_header("access-control-allow-headers", "content-type, accept, authorization")
      |> put_resp_header("access-control-allow-methods", "GET, POST, OPTIONS, PUT, DELETE")

    if conn.method == "OPTIONS" do
      conn
      |> send_resp(200, "")
      |> halt()
    else
      conn
    end
  end
end
