defmodule LesPokeApi.Contacts do
  @moduledoc """
  Adapter boundary from Les Poke check-ins into Les Contacts private drafts.

  This module creates a private draft timeline event without publishing private
  CRM details onto the shared event stream.
  """

  alias LesContacts.Timeline

  def draft_timeline_event(params \\ %{}) do
    Timeline.draft_from_check_in(%{
      "identity_id" => Map.get(params, "identity_id"),
      "source_app" => "les-poke",
      "source_ref" => Map.get(params, "event_id"),
      "place_id" => Map.get(params, "place_id"),
      "place_name" => Map.get(params, "place_name"),
      "place_type" => Map.get(params, "place_type"),
      "privacy_level" => Map.get(params, "privacy_level", "coarse_location")
    })
  end
end
