defmodule LesContacts.Ecosystem do
  @moduledoc """
  Runtime identity metadata for the first Les Contacts MVP slice.
  """

  @product_id "les-contacts"
  @version "0.1.0"

  def product_id, do: @product_id

  def health do
    %{
      status: "ok",
      product_id: @product_id,
      service: "les_contacts",
      version: @version,
      scope: "private_draft_timeline_mvp"
    }
  end

  def manifest(base_url \\ "http://127.0.0.1:4004") do
    %{
      product_id: @product_id,
      version: @version,
      runtime_modes: ["standalone_app", "ecosystem_activated_app"],
      endpoints: %{
        health: %{method: "GET", url: "#{base_url}/api/health"},
        check_in_draft_preview: %{method: "POST", url: "#{base_url}/api/drafts/check-ins/preview"},
        manifest: %{method: "GET", url: "#{base_url}/.well-known/lestupid-app.json"}
      },
      privacy_defaults: %{
        visibility: "private",
        draft_status: "private_draft",
        cross_app_share_default: "blocked"
      }
    }
  end
end
