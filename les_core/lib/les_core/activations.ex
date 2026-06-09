defmodule LesCore.Activations do
  @moduledoc """
  Deterministic identity, app activation and channel activation contract.
  """

  alias LesCore.ProductIds

  @default_identity_id "demo-lestupid-identity"

  def identity_status(params \\ %{}) do
    identity_id = identity_id(params)

    %{
      identity: %{
        id: identity_id,
        label: Map.get(params, "label", "Student identity"),
        status: Map.get(params, "status", "verified")
      },
      data: %{
        identity_id: identity_id,
        identity_status: "registered",
        rule: "register_once_activate_apps",
        sensitive_features_require_separate_consent: true
      }
    }
  end

  def list_activations(params \\ %{}) do
    identity_id = identity_id(params)

    %{
      data: default_app_activations(),
      meta: %{
        identity_id: identity_id,
        model: "one_lestupid_identity_many_app_activations",
        source_of_truth: "les-core"
      }
    }
  end

  def activate_app(product_id, params \\ %{}) do
    identity_id = identity_id(params)

    if ProductIds.canonical?(product_id) do
      {:ok,
       %{
         data: %{
           identity_id: identity_id,
           product_id: product_id,
           status: Map.get(params, "status", "activated"),
           activated_at: timestamp(params),
           permissions: Map.get(params, "permissions", []),
           consent_version: Map.get(params, "consent_version", "#{product_id}-consent-v1"),
           source_app: "les-core",
           user_controls: ["activate", "pause", "revoke", "export"]
         }
       }}
    else
      {:error, {:unknown_product_id, product_id}}
    end
  end

  def activate_channel(channel_id, params \\ %{}) do
    identity_id = identity_id(params)

    {:ok,
     %{
       data: %{
         identity_id: identity_id,
         channel_id: channel_id,
         status: Map.get(params, "status", "activated"),
         scope: Map.get(params, "scope", []),
         allowed_apps: Map.get(params, "allowed_apps", []),
         allowed_interactions: Map.get(params, "allowed_interactions", []),
         consent_version: Map.get(params, "consent_version", "#{channel_id}-channel-consent-v1"),
         privacy_level: Map.get(params, "privacy_level", "private"),
         activated_at: timestamp(params),
         source_app: "les-core"
       }
     }}
  end

  defp identity_id(params), do: Map.get(params, "identity_id") || @default_identity_id

  defp timestamp(params),
    do: Map.get(params, "occurred_at") || DateTime.utc_now() |> DateTime.truncate(:second)

  defp default_app_activations do
    [
      %{
        product_id: "les-go",
        status: "activated",
        permissions: ["place_checkin", "opportunity_preview"]
      },
      %{
        product_id: "les-poke",
        status: "activated",
        permissions: ["quest_profile", "city_selection"]
      },
      %{
        product_id: "les-wait",
        status: "activated",
        permissions: ["queue_profile", "service_notifications"]
      },
      %{product_id: "les-match", status: "available", permissions: ["match_preview"]},
      %{
        product_id: "les-ai",
        status: "activated",
        permissions: ["agent_tasks", "evidence_summary"]
      },
      %{
        product_id: "lescommerce-core",
        status: "activated",
        permissions: [
          "commerce_profile",
          "marketplace_listings",
          "book_marketplace_listings",
          "diy_creator_drops",
          "merchant_storefront"
        ]
      },
      %{
        product_id: "les-itemotel",
        status: "activated",
        permissions: ["storage_records", "maintenance_orders", "rental_offers", "resale_listings"]
      },
      %{
        product_id: "les-certification",
        status: "activated",
        permissions: ["trust_credential_preview", "selective_disclosure", "revocation_check"]
      },
      %{
        product_id: "les-travel",
        status: "activated",
        permissions: [
          "trip_intent",
          "visa_source_check",
          "stay_safety_preview",
          "travel_risk_briefing"
        ]
      },
      %{
        product_id: "les-harmonica",
        status: "available",
        permissions: ["safe_contact_preview", "trusted_proximity", "encrypted_contact_handoff"]
      },
      %{
        product_id: "les-affiliate",
        status: "available",
        permissions: ["card_drop_preview", "affiliate_reward_preview", "quest_deck_preview"]
      }
    ]
  end
end
