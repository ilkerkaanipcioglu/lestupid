defmodule LesMatchApiWeb.HealthControllerTest do
  use ExUnit.Case, async: true
  import Plug.Test

  @opts LesMatchApiWeb.Router.init([])

  test "GET /api/health returns ok" do
    conn =
      conn(:get, "/api/health")
      |> LesMatchApiWeb.Router.call(@opts)

    assert conn.status == 200
    body = Jason.decode!(conn.resp_body)

    assert body["status"] == "ok"
    assert body["ecosystem"] == "LesTupid"
    assert body["product_id"] == "les-match"
  end

  test "GET /agent-manifest.json returns LesTupid discovery metadata" do
    conn =
      conn(:get, "/agent-manifest.json")
      |> LesMatchApiWeb.Router.call(@opts)

    body = Jason.decode!(conn.resp_body)

    assert conn.status == 200
    assert body["schema_version"] == "lestupid.app_manifest.v1"
    assert body["product_id"] == "les-match"
    assert body["integrations"]["lescommerce"]["ready"] == true
    assert body["agent_capabilities"]["match_preview"] == true
  end
end
