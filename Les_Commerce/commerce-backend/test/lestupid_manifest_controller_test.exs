defmodule DukkadeeWeb.LestupidManifestControllerTest do
  use ExUnit.Case, async: true

  import Plug.Test

  alias DukkadeeWeb.Router

  test "GET /api/health returns commerce health discovery payload" do
    conn = conn(:get, "/api/health") |> Router.call([])

    assert conn.status == 200

    assert %{
             "data" => %{
               "product_id" => "lescommerce-core",
               "status" => "ok",
               "discovery" => discovery
             }
           } = Jason.decode!(conn.resp_body)

    assert "/api/ecosystem/endpoints" in discovery
    assert "/.well-known/lestupid-app.json" in discovery
  end

  test "GET /api/ecosystem/endpoints returns grouped LesTupid commerce API dictionary" do
    conn = conn(:get, "/api/ecosystem/endpoints") |> Router.call([])

    assert conn.status == 200

    assert %{
             "data" => %{
               "product_id" => "lescommerce-core",
               "endpoint_groups" => %{
                 "catalog" => catalog,
                 "itemotel" => itemotel,
                 "booking" => booking
               }
             }
           } = Jason.decode!(conn.resp_body)

    assert Enum.any?(catalog, &(&1["id"] == "products_index"))
    assert Enum.any?(itemotel, &(&1["id"] == "itemotel_request_care"))
    assert Enum.any?(booking, &(&1["id"] == "appointments_create"))
  end

  test "GET /.well-known/lestupid-app.json returns LesTupid commerce manifest" do
    conn = conn(:get, "/.well-known/lestupid-app.json") |> Router.call([])

    assert conn.status == 200

    assert %{
             "schema_version" => "lestupid.app_manifest.v1",
             "product_id" => "lescommerce-core",
             "well_known" => well_known,
             "endpoints" => %{
               "health" => %{"url" => "http://www.example.com:80/api/health"},
               "ecosystem_endpoints" => %{"url" => "http://www.example.com:80/api/ecosystem/endpoints"},
               "lestupid_manifest" => %{"url" => "http://www.example.com:80/.well-known/lestupid-app.json"},
               "products" => %{"url" => "http://www.example.com:80/api/products"},
               "itemotel_items" => %{"url" => "http://www.example.com:80/api/itemotel/items"}
             }
           } = Jason.decode!(conn.resp_body)

    assert "/.well-known/lestupid-app.json" in well_known
    assert "/agent-manifest.json" in well_known
  end
end
