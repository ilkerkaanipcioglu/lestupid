defmodule LesPokeApi.Events do
  @moduledoc """
  Published Les Poke event types and lightweight PubSub helpers.

  Les Poke owns place check-in and quest activity context, but shared event
  envelopes are delegated to `LesCore.Events`.
  """

  @published_event_types [
    "place_checkin_recorded",
    "quest_completed"
  ]

  def published_event_types, do: @published_event_types

  def broadcast(event) do
    Phoenix.PubSub.broadcast(LesPokeApi.PubSub, "lestupid.events", {:lestupid_event, event})
  end
end
