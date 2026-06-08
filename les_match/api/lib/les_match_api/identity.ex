defmodule LesMatchApi.Identity do
  @moduledoc """
  Shared LesTupid identity and app activation contract for Les Match.

  The first skeleton returns deterministic responses. A future identity service
  will own persistence and token verification.
  """

  @product_id "les-match"

  def status(params \\ %{}) do
    identity_id = identity_id(params)

    %{
      data: %{
        identity_id: identity_id,
        identity_status: "registered",
        app_activation: activation(identity_id, "available"),
        rule: "register_once_activate_apps"
      }
    }
  end

  def list_activations(params \\ %{}) do
    identity_id = identity_id(params)

    %{
      data: [
        activation(identity_id, "available")
      ],
      meta: %{
        identity_id: identity_id,
        model: "one_lestupid_identity_many_app_activations"
      }
    }
  end

  def activate(params \\ %{}) do
    identity_id = identity_id(params)

    %{
      data:
        activation(identity_id, "activated")
        |> Map.put(:activated_at, DateTime.utc_now() |> DateTime.truncate(:second))
    }
  end

  def update(product_id, params \\ %{}) do
    identity_id = identity_id(params)
    status = Map.get(params, "status", "paused")

    %{
      data:
        activation(identity_id, status)
        |> Map.put(:product_id, product_id)
    }
  end

  def revoke(product_id, params \\ %{}) do
    identity_id = identity_id(params)

    %{
      data:
        activation(identity_id, "revoked")
        |> Map.put(:product_id, product_id)
    }
  end

  defp activation(identity_id, status) do
    %{
      identity_id: identity_id,
      product_id: @product_id,
      status: status,
      permissions: [
        "match_profile",
        "match_preview",
        "match_decisions",
        "safety_reporting"
      ],
      consent_version: "les-match-consent-v1",
      source_app: @product_id,
      user_controls: ["activate", "pause", "revoke", "mute", "block", "report", "export"],
      sensitive_activation_note:
        "Matchmaking is never auto-enabled after ecosystem registration; the user must activate Les Match explicitly."
    }
  end

  defp identity_id(params) do
    Map.get(params, "identity_id") || "demo-lestupid-identity"
  end
end
