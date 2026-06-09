defmodule LesContacts.HTTPTest do
  use ExUnit.Case, async: true
  import Plug.Conn
  import Plug.Test

  alias LesContacts.HTTP.Router

  test "GET /api/health returns contacts health payload" do
    conn = conn(:get, "/api/health") |> Router.call([])

    assert conn.status == 200

    assert %{"data" => %{"product_id" => "les-contacts", "status" => "ok"}} =
             Jason.decode!(conn.resp_body)
  end

  test "POST /api/drafts/check-ins/preview returns private draft preview" do
    conn =
      conn(:post, "/api/drafts/check-ins/preview", %{
        "identity_id" => "id_123",
        "source_app" => "les-poke",
        "place_id" => "campus-library",
        "place_name" => "Campus Library",
        "place_type" => "library",
        "privacy_level" => "coarse_location"
      })
      |> put_req_header("content-type", "application/json")
      |> Router.call([])

    assert conn.status == 200

    assert %{
             "data" => %{
               "draft_status" => "private_draft",
               "visibility" => "private",
               "context_space" => "school"
             }
           } = Jason.decode!(conn.resp_body)
  end

  test "POST /api/drafts/check-ins/preview rejects invalid context spaces" do
    conn =
      conn(:post, "/api/drafts/check-ins/preview", %{
        "source_app" => "les-poke",
        "context_space" => "public"
      })
      |> put_req_header("content-type", "application/json")
      |> Router.call([])

    assert conn.status == 422
    assert %{"error" => %{"code" => "invalid_context_space"}} = Jason.decode!(conn.resp_body)
  end

  test "GET /.well-known/lestupid-app.json returns manifest with preview endpoint" do
    conn = conn(:get, "/.well-known/lestupid-app.json") |> Router.call([])

    assert conn.status == 200

    assert %{
             "product_id" => "les-contacts",
             "endpoints" => %{
               "check_in_draft_preview" => %{
                 "url" => "http://www.example.com:80/api/drafts/check-ins/preview"
               }
             }
           } = Jason.decode!(conn.resp_body)
  end
end
