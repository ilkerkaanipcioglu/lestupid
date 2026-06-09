defmodule LesPokeApiWeb.CheckInControllerTest do
  use ExUnit.Case, async: true
  import Plug.Test

  @opts LesPokeApiWeb.Router.init([])

  test "POST /api/check-ins returns a coarse_location event envelope by default" do
    conn =
      conn(:post, "/api/check-ins", %{
        "identity_id" => "user-1",
        "place_id" => "nairobi-city-market",
        "city_id" => "nairobi",
        "source" => "manual"
      })
      |> LesPokeApiWeb.Router.call(@opts)

    body = Jason.decode!(conn.resp_body)

    assert conn.status == 201
    assert body["data"]["check_in"]["privacy_level"] == "coarse_location"
    assert body["data"]["event"]["event_type"] == "place_checkin_recorded"
    assert body["data"]["event"]["source_app"] == "les-poke"
    assert body["data"]["event"]["payload"]["place_id"] == "nairobi-city-market"
    assert body["data"]["contacts_draft"]["draft_status"] == "private_draft"
    assert body["data"]["contacts_draft"]["visibility"] == "private"
  end

  test "POST /api/check-ins strips payload for private check-ins" do
    conn =
      conn(:post, "/api/check-ins", %{
        "identity_id" => "user-1",
        "place_id" => "nairobi-city-market",
        "city_id" => "nairobi",
        "privacy_level" => "private"
      })
      |> LesPokeApiWeb.Router.call(@opts)

    body = Jason.decode!(conn.resp_body)

    assert conn.status == 201
    assert body["data"]["event"]["privacy_level"] == "private"
    assert body["data"]["event"]["payload"] == %{}
    assert body["data"]["contacts_draft"]["sensitivity"] == "sensitive"
    assert body["data"]["contacts_draft"]["cross_app_share_default"] == "blocked"
  end

  test "POST /api/check-ins rejects unknown privacy level" do
    conn =
      conn(:post, "/api/check-ins", %{
        "identity_id" => "user-1",
        "place_id" => "nairobi-city-market",
        "privacy_level" => "precise_location"
      })
      |> LesPokeApiWeb.Router.call(@opts)

    body = Jason.decode!(conn.resp_body)

    assert conn.status == 422
    assert body["error"]["code"] == "unknown_privacy_level"
  end
end
