defmodule LesContacts.HTTP.Router do
  @moduledoc """
  Minimal HTTP read/preview surface for Les Contacts.
  """

  use Plug.Router

  alias LesContacts.Ecosystem
  alias LesContacts.Timeline

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  get "/api/health" do
    json(conn, 200, %{data: Ecosystem.health()})
  end

  post "/api/drafts/check-ins/preview" do
    params = body_params(conn)

    case Timeline.draft_from_check_in(params) do
      {:ok, response} ->
        json(conn, 200, response)

      {:error, {:unknown_source_app, source_app}} ->
        json(conn, 422, %{
          "error" => %{"code" => "unknown_source_app", "source_app" => source_app}
        })

      {:error, {:unsupported_source_app, source_app}} ->
        json(conn, 422, %{
          "error" => %{"code" => "unsupported_source_app", "source_app" => source_app}
        })

      {:error, {:invalid_context_space, context_space}} ->
        json(conn, 422, %{
          "error" => %{"code" => "invalid_context_space", "context_space" => context_space}
        })
    end
  end

  get "/.well-known/lestupid-app.json" do
    json(conn, 200, Ecosystem.manifest(base_url(conn)))
  end

  get "/agent-manifest.json" do
    json(conn, 200, Ecosystem.manifest(base_url(conn)))
  end

  match _ do
    json(conn, 404, %{"error" => %{"code" => "not_found"}})
  end

  defp json(conn, status, body) do
    body = Jason.encode!(body)

    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(status, body)
  end

  defp base_url(conn) do
    "#{Atom.to_string(conn.scheme)}://#{conn.host}:#{conn.port}"
  end

  defp body_params(%Plug.Conn{body_params: %Plug.Conn.Unfetched{}}), do: %{}
  defp body_params(%Plug.Conn{body_params: body_params}) when is_map(body_params), do: body_params
end
