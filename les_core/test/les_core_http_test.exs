defmodule LesCore.HTTPTest do
  use ExUnit.Case, async: true
  import Plug.Conn
  import Plug.Test

  alias LesCore.HTTP.Router

  test "GET /api/health returns ecosystem health payload" do
    conn = conn(:get, "/api/health") |> Router.call([])

    assert conn.status == 200

    assert %{"data" => %{"product_id" => "les-core", "status" => "ok"}} =
             Jason.decode!(conn.resp_body)
  end

  test "GET /api/identity/status returns deterministic identity payload" do
    conn = conn(:get, "/api/identity/status?identity_id=id_123") |> Router.call([])

    assert conn.status == 200

    assert %{
             "identity" => %{
               "id" => "id_123",
               "label" => "Student identity",
               "status" => "verified"
             },
             "data" => %{
               "identity_id" => "id_123",
               "identity_status" => "registered"
             }
           } = Jason.decode!(conn.resp_body)
  end

  test "GET /api/activations returns app activations and channel list" do
    conn = conn(:get, "/api/activations?identity_id=id_123") |> Router.call([])

    assert conn.status == 200

    assert %{
             "data" => data,
             "meta" => %{
               "identity_id" => "id_123",
               "source_of_truth" => "les-core"
             },
             "app_activations" => app_activations,
             "channels" => channels
           } = Jason.decode!(conn.resp_body)

    assert length(data) >= 1
    assert Enum.any?(app_activations, &(&1["productId"] == "les-go"))
    assert Enum.any?(channels, &(&1["channelId"] == "place"))
  end

  test "POST /api/activations/apps/:product_id activates a known app" do
    conn =
      conn(:post, "/api/activations/apps/les-poke", Jason.encode!(%{"identity_id" => "id_123"}))
      |> put_req_header("content-type", "application/json")
      |> Router.call([])

    assert conn.status == 201

    assert %{
             "activation" => %{
               "productId" => "les-poke",
               "status" => "activated"
             }
           } = Jason.decode!(conn.resp_body)
  end

  test "POST /api/activations/apps/:product_id rejects an unknown app" do
    conn =
      conn(:post, "/api/activations/apps/lestupid-waiting-app", Jason.encode!(%{}))
      |> put_req_header("content-type", "application/json")
      |> Router.call([])

    assert conn.status == 422
    assert %{"error" => %{"code" => "unknown_product_id"}} = Jason.decode!(conn.resp_body)
  end

  test "POST /api/activations/channels/:channel_id activates a channel" do
    conn =
      conn(:post, "/api/activations/channels/place", Jason.encode!(%{"identity_id" => "id_123"}))
      |> put_req_header("content-type", "application/json")
      |> Router.call([])

    assert conn.status == 201

    assert %{
             "channel" => %{
               "channelId" => "place",
               "status" => "activated"
             }
           } = Jason.decode!(conn.resp_body)
  end

  test "POST /api/opportunity-events accepts a valid shared event envelope request" do
    conn =
      conn(
        :post,
        "/api/opportunity-events",
        Jason.encode!(%{
          "event_type" => "match_opportunity_created",
          "source_app" => "les-match",
          "identity_id" => "id_123",
          "privacy_level" => "coarse_location",
          "payload" => %{"match_id" => "match_42", "place_id" => "place_7"}
        })
      )
      |> put_req_header("content-type", "application/json")
      |> Router.call([])

    assert conn.status == 201

    assert %{
             "data" => %{
               "event_type" => "match_opportunity_created",
               "source_app" => "les-match",
               "identity_id" => "id_123",
               "payload" => %{"match_id" => "match_42", "place_id" => "place_7"}
             },
             "event" => %{
               "eventType" => "match_opportunity_created",
               "sourceApp" => "les-match",
               "identityId" => "id_123"
             }
           } = Jason.decode!(conn.resp_body)
  end

  test "POST /api/opportunity-events rejects unknown event types" do
    conn =
      conn(
        :post,
        "/api/opportunity-events",
        Jason.encode!(%{
          "event_type" => "mystery_event",
          "source_app" => "les-match",
          "payload" => %{}
        })
      )
      |> put_req_header("content-type", "application/json")
      |> Router.call([])

    assert conn.status == 422
    assert %{"error" => %{"code" => "unknown_event_type", "event_type" => "mystery_event"}} = Jason.decode!(conn.resp_body)
  end

  test "POST /api/opportunity-events rejects private payload sharing" do
    conn =
      conn(
        :post,
        "/api/opportunity-events",
        Jason.encode!(%{
          "event_type" => "match_opportunity_created",
          "source_app" => "les-match",
          "privacy_level" => "private",
          "payload" => %{"secret" => "do-not-share"}
        })
      )
      |> put_req_header("content-type", "application/json")
      |> Router.call([])

    assert conn.status == 422

    assert %{"error" => %{"code" => "private_payload_not_allowed_in_shared_event"}} =
             Jason.decode!(conn.resp_body)
  end

  test "POST /api/check-ins accepts a valid shared check-in envelope request" do
    conn =
      conn(
        :post,
        "/api/check-ins",
        Jason.encode!(%{
          "source_app" => "les-poke",
          "identity_id" => "id_123",
          "privacy_level" => "coarse_location",
          "payload" => %{"place_id" => "place_9", "mode" => "study"}
        })
      )
      |> put_req_header("content-type", "application/json")
      |> Router.call([])

    assert conn.status == 201

    assert %{
             "data" => %{
               "event_type" => "place_checkin_recorded",
               "source_app" => "les-poke",
               "identity_id" => "id_123",
               "payload" => %{"mode" => "study", "place_id" => "place_9"}
             },
             "event" => %{
               "eventType" => "place_checkin_recorded",
               "sourceApp" => "les-poke",
               "identityId" => "id_123"
             }
           } = Jason.decode!(conn.resp_body)
  end

  test "POST /api/check-ins rejects private payload sharing" do
    conn =
      conn(
        :post,
        "/api/check-ins",
        Jason.encode!(%{
          "source_app" => "les-poke",
          "privacy_level" => "private",
          "payload" => %{"exact_location" => "private-room"}
        })
      )
      |> put_req_header("content-type", "application/json")
      |> Router.call([])

    assert conn.status == 422

    assert %{"error" => %{"code" => "private_payload_not_allowed_in_shared_event"}} =
             Jason.decode!(conn.resp_body)
  end

  test "GET /.well-known/lestupid-app.json returns manifest" do
    conn = conn(:get, "/.well-known/lestupid-app.json") |> Router.call([])

    assert conn.status == 200

    assert %{
             "product_id" => "les-core",
             "runtime_modes" => runtime_modes,
             "endpoints" => %{
               "identity_status" => %{"url" => "http://www.example.com:80/api/identity/status"}
             }
           } = Jason.decode!(conn.resp_body)

    assert "standalone_app" in runtime_modes
  end
end
