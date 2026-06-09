defmodule LesCoreTest do
  use ExUnit.Case, async: true

  alias LesCore.{Activations, Ecosystem, Events, ProductIds}

  test "product id list includes core and activated apps" do
    assert ProductIds.canonical?("les-core")
    assert ProductIds.canonical?("les-poke")
    refute ProductIds.canonical?("lestupid-waiting-app")
  end

  test "ecosystem manifest exposes core contract metadata" do
    manifest = Ecosystem.manifest("http://localhost:4000")

    assert manifest.product_id == "les-core"
    assert "standalone_app" in manifest.runtime_modes
    assert manifest.identity_activation.activation_product_id == "les-core"
    assert manifest.endpoints.check_ins.url == "http://localhost:4000/api/check-ins"
  end

  test "activates a canonical app product id" do
    assert {:ok, response} =
             Activations.activate_app("les-poke", %{
               "identity_id" => "id_123",
               "permissions" => ["location_for_quests"]
             })

    assert response.data.identity_id == "id_123"
    assert response.data.product_id == "les-poke"
    assert response.data.status == "activated"
    assert response.data.source_app == "les-core"
  end

  test "rejects non-canonical app product id" do
    assert {:error, {:unknown_product_id, "lestupid-waiting-app"}} =
             Activations.activate_app("lestupid-waiting-app", %{})
  end

  test "builds a standard public event envelope" do
    assert {:ok, event} =
             Events.build("place_checkin_recorded", %{
               "source_app" => "les-poke",
               "identity_id" => "id_123",
               "privacy_level" => "coarse_location",
               "payload" => %{"place_id" => "place_1"}
             })

    assert event.schema_version == "lestupid.event.v1"
    assert event.event_type == "place_checkin_recorded"
    assert event.source_app == "les-poke"
    assert event.identity_id == "id_123"
    assert event.payload == %{"place_id" => "place_1"}
  end

  test "rejects private payloads in shared events" do
    assert {:error, :private_payload_not_allowed_in_shared_event} =
             Events.build("place_checkin_recorded", %{
               "source_app" => "les-poke",
               "privacy_level" => "private",
               "payload" => %{"exact_location" => "do-not-share"}
             })
  end
end
