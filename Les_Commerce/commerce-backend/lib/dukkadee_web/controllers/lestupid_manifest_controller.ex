defmodule DukkadeeWeb.LestupidManifestController do
  use DukkadeeWeb, :controller

  @manifest_path Path.expand("../../../../lestupid.app.json", __DIR__)

  def show(conn, _params) do
    manifest =
      @manifest_path
      |> File.read!()
      |> Jason.decode!()
      |> inject_runtime_urls(base_url(conn))

    json(conn, manifest)
  end

  defp base_url(conn) do
    "#{Atom.to_string(conn.scheme)}://#{conn.host}:#{conn.port}"
  end

  defp inject_runtime_urls(manifest, base_url) do
    endpoints =
      manifest
      |> Map.get("endpoints", %{})
      |> Map.merge(%{
        "health" => %{"method" => "GET", "url" => "#{base_url}/api/health"},
        "ecosystem_endpoints" => %{
          "method" => "GET",
          "url" => "#{base_url}/api/ecosystem/endpoints"
        },
        "agent_manifest" => %{"method" => "GET", "url" => "#{base_url}/agent-manifest.json"},
        "lestupid_manifest" => %{
          "method" => "GET",
          "url" => "#{base_url}/.well-known/lestupid-app.json"
        },
        "products" => %{"method" => "GET", "url" => "#{base_url}/api/products"},
        "videos" => %{"method" => "GET", "url" => "#{base_url}/api/videos"},
        "appointments" => %{"method" => "POST", "url" => "#{base_url}/api/appointments"},
        "itemotel_items" => %{"method" => "GET", "url" => "#{base_url}/api/itemotel/items"}
      })

    manifest
    |> Map.put("endpoints", endpoints)
    |> Map.put("well_known", [
      "/agent-manifest.json",
      "/.well-known/ai-agent.json",
      "/.well-known/lestupid-app.json"
    ])
  end
end
