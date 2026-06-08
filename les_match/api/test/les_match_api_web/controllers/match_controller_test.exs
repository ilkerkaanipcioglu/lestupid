defmodule LesMatchApiWeb.MatchControllerTest do
  use ExUnit.Case, async: true
  import Plug.Test

  @opts LesMatchApiWeb.Router.init([])

  test "POST /api/matches/preview returns explainable candidates" do
    conn =
      conn(:post, "/api/matches/preview", %{"type" => "person_to_merchant"})
      |> LesMatchApiWeb.Router.call(@opts)

    body = Jason.decode!(conn.resp_body)

    assert conn.status == 200
    assert body["meta"]["opt_in_required"] == true
    assert length(body["data"]) >= 1
    candidate = Enum.find(body["data"], &(&1["id"] == "honest-local-offer"))

    assert candidate["type"] == "person_to_merchant"
    assert is_list(candidate["explanation"])
    assert candidate["safety"]["paid_placement_label_required"] == true
  end

  test "POST /api/matches/accept records an explicit match decision" do
    conn =
      conn(:post, "/api/matches/accept", %{"match_id" => "honest-local-offer"})
      |> LesMatchApiWeb.Router.call(@opts)

    body = Jason.decode!(conn.resp_body)

    assert conn.status == 200
    assert body["data"]["action"] == "accept"
    assert body["data"]["match_id"] == "honest-local-offer"
    assert body["data"]["status"] == "recorded"
  end

  test "POST /api/safety/report is accepted for human review" do
    conn =
      conn(:post, "/api/safety/report", %{"match_id" => "honest-local-offer"})
      |> LesMatchApiWeb.Router.call(@opts)

    body = Jason.decode!(conn.resp_body)

    assert conn.status == 202
    assert body["data"]["action"] == "report"
    assert body["data"]["human_review_required"] == true
  end
end
