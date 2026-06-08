defmodule LesMatchApiWeb.OpportunityControllerTest do
  use ExUnit.Case, async: true
  import Plug.Test

  @opts LesMatchApiWeb.Router.init([])

  test "POST /api/opportunities records a source app match opportunity" do
    conn =
      conn(:post, "/api/opportunities", %{
        "source_app" => "Les_poke",
        "source_event" => "check_in",
        "topic" => "lestupid_place_candidate",
        "channel_id" => "place"
      })
      |> LesMatchApiWeb.Router.call(@opts)

    body = Jason.decode!(conn.resp_body)

    assert conn.status == 201
    assert body["data"]["source_app"] == "Les_poke"
    assert body["data"]["source_event"] == "check_in"
    assert body["data"]["channel_id"] == "place"
    assert body["data"]["channel_activation_required"] == true
    assert body["data"]["requires_match_activation"] == true
    assert body["data"]["both_sides_matchmaking_required"] == true
  end
end
