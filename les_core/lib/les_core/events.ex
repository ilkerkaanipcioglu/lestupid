defmodule LesCore.Events do
  @moduledoc """
  Standard event envelope builder and guard for LesTupid cross-app events.

  Private payloads are rejected for shared event envelopes. Apps should keep
  sensitive data in their own stores and publish only scoped references.
  """

  alias LesCore.ProductIds

  @schema_version "lestupid.event.v1"
  @privacy_levels ~w(public coarse_location private)

  @event_types ~w(
    user_registered
    app_activated
    channel_activated
    place_checkin_recorded
    match_opportunity_created
    match_decision_recorded
    purchase_completed
    itemotel_item_listed
    queue_ticket_created
    certification_signal_recorded
    travel_created
    agent_hired
  )

  def schema_version, do: @schema_version
  def event_types, do: @event_types
  def privacy_levels, do: @privacy_levels

  def record_check_in(params \\ %{}) do
    build("place_checkin_recorded", Map.put_new(params, "source_app", "les-poke"))
  end

  def record_opportunity_event(params \\ %{}) do
    build(Map.get(params, "event_type", "match_opportunity_created"), params)
  end

  def build(event_type, params \\ %{}) do
    source_app = Map.get(params, "source_app", "les-core")
    privacy_level = Map.get(params, "privacy_level", "coarse_location")
    payload = Map.get(params, "payload", %{})

    with :ok <- validate_event_type(event_type),
         :ok <- validate_source_app(source_app),
         :ok <- validate_privacy_level(privacy_level),
         :ok <- validate_payload(privacy_level, payload) do
      {:ok,
       %{
         schema_version: @schema_version,
         event_id: Map.get(params, "event_id", event_id()),
         event_type: event_type,
         source_app: source_app,
         identity_id: Map.get(params, "identity_id", "demo-lestupid-identity"),
         occurred_at:
           Map.get(params, "occurred_at", DateTime.utc_now() |> DateTime.truncate(:second)),
         privacy_level: privacy_level,
         payload: payload
       }}
    end
  end

  defp validate_event_type(event_type) when event_type in @event_types, do: :ok
  defp validate_event_type(event_type), do: {:error, {:unknown_event_type, event_type}}

  defp validate_source_app(source_app) do
    if ProductIds.canonical?(source_app),
      do: :ok,
      else: {:error, {:unknown_source_app, source_app}}
  end

  defp validate_privacy_level(level) when level in @privacy_levels, do: :ok
  defp validate_privacy_level(level), do: {:error, {:unknown_privacy_level, level}}

  defp validate_payload("private", payload) when payload == %{}, do: :ok

  defp validate_payload("private", _payload) do
    {:error, :private_payload_not_allowed_in_shared_event}
  end

  defp validate_payload(_level, payload) when is_map(payload), do: :ok
  defp validate_payload(_level, _payload), do: {:error, :payload_must_be_map}

  defp event_id do
    "evt_" <> (:crypto.strong_rand_bytes(8) |> Base.url_encode64(padding: false))
  end
end
