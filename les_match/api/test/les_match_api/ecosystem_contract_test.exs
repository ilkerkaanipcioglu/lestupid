defmodule LesMatchApi.EcosystemContractTest do
  use ExUnit.Case, async: true

  alias LesMatchApi.Ecosystem

  @product_id "les-match"

  test "ecosystem product id matches app manifest and certification registry" do
    manifest = read_json("../../../lestupid.app.json")
    registry = read_json("../../../../les_certification/certification-registry.json")
    registry_product = Enum.find(registry["products"], &(&1["id"] == @product_id))

    assert Ecosystem.product_id() == @product_id
    assert manifest["product_id"] == @product_id
    assert registry_product["manifest"] == "les_match/lestupid.app.json"
  end

  test "manifest contract includes required activation and portability fields" do
    manifest = Ecosystem.manifest("http://localhost:4002")

    assert manifest.product_id == @product_id
    assert "standalone_app" in manifest.runtime_modes
    assert manifest.identity_activation.activation_product_id == @product_id
    assert manifest.portability.standalone_ready == true
    assert Enum.any?(manifest.well_known, &String.ends_with?(&1, "/.well-known/lestupid-app.json"))
  end

  defp read_json(relative_path) do
    relative_path
    |> Path.expand(__DIR__)
    |> File.read!()
    |> Jason.decode!()
  end
end
