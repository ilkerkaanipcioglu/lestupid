defmodule LesPokeApi.CheckIns do
  @moduledoc """
  Deterministic check-in contract for the first Les Poke API slice.

  This module validates the shared privacy rules before publishing a standard
  LesTupid event envelope.
  """

  alias LesCore.Events, as: CoreEvents
  alias LesPokeApi.Contacts
  alias LesPokeApi.Events

  @allowed_privacy_levels ["public", "coarse_location", "private"]

  def create(params \\ %{}) do
    privacy_level = Map.get(params, "privacy_level", "coarse_location")

    with :ok <- validate_privacy_level(privacy_level),
         payload <- payload_for(privacy_level, params),
         {:ok, event} <-
           CoreEvents.record_check_in(%{
             "event_id" => Map.get(params, "event_id"),
             "identity_id" => Map.get(params, "identity_id", "demo-lestupid-identity"),
             "occurred_at" => Map.get(params, "occurred_at"),
             "source_app" => "les-poke",
             "privacy_level" => privacy_level,
             "payload" => payload
           }),
         {:ok, contacts_draft} <- contacts_draft(params, event) do
      :ok = Events.broadcast(event)

      {:ok,
       %{
         data: %{
           check_in: %{
             place_id: Map.get(params, "place_id"),
             city_id: Map.get(params, "city_id"),
             privacy_level: privacy_level,
             source: Map.get(params, "source", "manual")
           },
           event: event,
           contacts_draft: contacts_draft.data
         }
       }}
    end
  end

  defp payload_for("private", _params), do: %{}

  defp payload_for(_privacy_level, params) do
    %{}
    |> put_if_present("place_id", Map.get(params, "place_id"))
    |> put_if_present("city_id", Map.get(params, "city_id"))
    |> put_if_present("quest_id", Map.get(params, "quest_id"))
    |> put_if_present("source", Map.get(params, "source", "manual"))
  end

  defp validate_privacy_level(level) when level in @allowed_privacy_levels, do: :ok
  defp validate_privacy_level(level), do: {:error, {:unknown_privacy_level, level}}

  defp contacts_draft(params, event) do
    Contacts.draft_timeline_event(%{
      "identity_id" => Map.get(params, "identity_id", "demo-lestupid-identity"),
      "event_id" => event.event_id,
      "place_id" => Map.get(params, "place_id"),
      "place_name" => Map.get(params, "place_name"),
      "place_type" => place_type_for(params),
      "privacy_level" => event.privacy_level
    })
  end

  defp place_type_for(params) do
    Map.get(params, "place_type") || inferred_place_type(Map.get(params, "place_id"))
  end

  defp inferred_place_type(nil), do: "place"

  defp inferred_place_type(place_id) when is_binary(place_id) do
    cond do
      String.contains?(place_id, "library") -> "library"
      String.contains?(place_id, "clinic") -> "clinic"
      String.contains?(place_id, "campus") -> "campus"
      true -> "place"
    end
  end

  defp put_if_present(map, _key, nil), do: map
  defp put_if_present(map, key, value), do: Map.put(map, key, value)
end
