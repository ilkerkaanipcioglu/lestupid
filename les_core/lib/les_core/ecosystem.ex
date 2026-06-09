defmodule LesCore.Ecosystem do
  @moduledoc """
  Product identity and discovery metadata for Les Core.
  """

  @product_id "les-core"
  @name "Les Core"
  @version "0.1.0"

  def product_id, do: @product_id
  def name, do: @name
  def version, do: @version

  def health do
    %{
      status: "ok",
      service: "les_core",
      product_id: @product_id,
      ecosystem: "LesTupid",
      version: @version,
      discovery: [
        "/api/health",
        "/api/identity/status",
        "/api/activations",
        "/.well-known/lestupid-app.json",
        "/agent-manifest.json"
      ]
    }
  end

  def manifest(base_url \\ "http://127.0.0.1:4000") do
    %{
      schema_version: "lestupid.app_manifest.v1",
      product_id: @product_id,
      name: @name,
      service: "les_core",
      version: @version,
      status: "internal_candidate",
      directory: "les_core",
      summary:
        "Lightweight identity, activation, channel and event-envelope contract for separable LesTupid apps.",
      ecosystem_roles: [
        "identity_contract",
        "app_activation_contract",
        "channel_activation_contract",
        "event_envelope_contract",
        "check_in_contract",
        "opportunity_event_contract"
      ],
      identity_activation: %{
        model: "shared_lestupid_identity",
        registration: "handled_by_lestupid_identity_layer",
        app_activation_required: false,
        activation_product_id: @product_id,
        activation_permissions: [
          "ecosystem_identity",
          "app_activation",
          "channel_activation",
          "check_in_event",
          "opportunity_event"
        ],
        user_controls: ["export"]
      },
      runtime_modes: [
        "standalone_app",
        "ecosystem_activated_app"
      ],
      portability: %{
        standalone_ready: true,
        ecosystem_activation_optional: true,
        extraction_difficulty: "low",
        data_owner: "ecosystem",
        required_adapters: [],
        optional_adapters: [
          "identity_adapter",
          "activation_adapter",
          "event_adapter"
        ],
        export_required: true,
        separation_rule:
          "Les Core coordinates identity, activation and event contracts; product business logic remains inside each app."
      },
      endpoints: %{
        health: %{method: "GET", url: "#{base_url}/api/health"},
        identity_status: %{method: "GET", url: "#{base_url}/api/identity/status"},
        activations: %{method: "GET", url: "#{base_url}/api/activations"},
        app_activation: %{method: "POST", url: "#{base_url}/api/activations/apps/:product_id"},
        channel_activation: %{
          method: "POST",
          url: "#{base_url}/api/activations/channels/:channel_id"
        },
        check_ins: %{method: "POST", url: "#{base_url}/api/check-ins"},
        opportunity_events: %{method: "POST", url: "#{base_url}/api/opportunity-events"}
      },
      well_known: [
        "/.well-known/lestupid-app.json",
        "/agent-manifest.json"
      ]
    }
  end
end
