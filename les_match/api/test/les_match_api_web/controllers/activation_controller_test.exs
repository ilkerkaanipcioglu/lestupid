defmodule LesMatchApiWeb.ActivationControllerTest do
  use ExUnit.Case, async: true
  import Plug.Test

  @opts LesMatchApiWeb.Router.init([])

  test "GET /api/identity/status returns shared identity activation state" do
    conn =
      conn(:get, "/api/identity/status", %{"identity_id" => "user-1"})
      |> LesMatchApiWeb.Router.call(@opts)

    body = Jason.decode!(conn.resp_body)

    assert conn.status == 200
    assert body["data"]["identity_id"] == "user-1"
    assert body["data"]["rule"] == "register_once_activate_apps"
    assert body["data"]["app_activation"]["product_id"] == "les-match"
  end

  test "POST /api/activations activates Les Match for an existing identity" do
    conn =
      conn(:post, "/api/activations", %{"identity_id" => "user-1"})
      |> LesMatchApiWeb.Router.call(@opts)

    body = Jason.decode!(conn.resp_body)

    assert conn.status == 201
    assert body["data"]["identity_id"] == "user-1"
    assert body["data"]["product_id"] == "les-match"
    assert body["data"]["status"] == "activated"
    assert "revoke" in body["data"]["user_controls"]
  end

  test "DELETE /api/activations/:product_id revokes an app activation" do
    conn =
      conn(:delete, "/api/activations/les-match", %{"identity_id" => "user-1"})
      |> LesMatchApiWeb.Router.call(@opts)

    body = Jason.decode!(conn.resp_body)

    assert conn.status == 200
    assert body["data"]["product_id"] == "les-match"
    assert body["data"]["status"] == "revoked"
  end
end
