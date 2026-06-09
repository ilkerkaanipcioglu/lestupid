defmodule LesContactsTest do
  use ExUnit.Case, async: true

  alias LesContacts.{Ecosystem, Timeline}

  test "ecosystem metadata marks private draft defaults" do
    manifest = Ecosystem.manifest()

    assert manifest.product_id == "les-contacts"
    assert "standalone_app" in manifest.runtime_modes
    assert manifest.privacy_defaults.visibility == "private"
  end

  test "builds a private draft timeline event from a campus check-in" do
    assert {:ok, response} =
             Timeline.draft_from_check_in(%{
               "identity_id" => "id_123",
               "source_app" => "les-poke",
               "place_id" => "campus-library",
               "place_name" => "Campus Library",
               "place_type" => "library",
               "privacy_level" => "coarse_location"
             })

    assert response.data.identity_id == "id_123"
    assert response.data.draft_status == "private_draft"
    assert response.data.visibility == "private"
    assert response.data.context_space == "school"
    assert response.data.sensitivity == "standard"
    assert response.data.place.place_name == "Campus Library"
  end

  test "marks clinic or private check-ins as sensitive drafts" do
    assert {:ok, response} =
             Timeline.draft_from_check_in(%{
               "source_app" => "les-go",
               "place_id" => "clinic-desk",
               "place_name" => "Campus Clinic",
               "place_type" => "clinic",
               "privacy_level" => "private"
             })

    assert response.data.sensitivity == "sensitive"
    assert response.data.user_review_required == true
    assert response.data.cross_app_share_default == "blocked"
  end

  test "rejects unknown source apps" do
    assert {:error, {:unknown_source_app, "legacy-app"}} =
             Timeline.draft_from_check_in(%{"source_app" => "legacy-app"})
  end

  test "rejects invalid context spaces" do
    assert {:error, {:invalid_context_space, "public"}} =
             Timeline.draft_from_check_in(%{
               "source_app" => "les-poke",
               "context_space" => "public"
             })
  end
end
