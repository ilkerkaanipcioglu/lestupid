defmodule LesPokeApiWeb.HealthControllerTest do
  use ExUnit.Case, async: true
  import Plug.Test

  @opts LesPokeApiWeb.Router.init([])

  test "GET /api/health returns ok" do
    conn =
      conn(:get, "/api/health")
      |> LesPokeApiWeb.Router.call(@opts)

    assert conn.status == 200
    body = Jason.decode!(conn.resp_body)

    assert body["status"] == "ok"
    assert body["ecosystem"] == "LesTupid"
    assert body["product_id"] == "les-poke"
  end

  test "GET /agent-manifest.json returns LesTupid discovery metadata" do
    conn =
      conn(:get, "/agent-manifest.json")
      |> LesPokeApiWeb.Router.call(@opts)

    body = Jason.decode!(conn.resp_body)

    assert conn.status == 200
    assert body["schema_version"] == "lestupid.app_manifest.v1"
    assert body["product_id"] == "les-poke"
    assert body["integrations"]["lescommerce"]["ready"] == true
  end
end
