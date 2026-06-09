defmodule LesContacts.Timeline do
  @moduledoc """
  Private-draft timeline helpers for Les Contacts.

  This first slice accepts cross-app check-in context and turns it into a
  private draft event owned by Les Contacts. It does not expose public CRM
  state and it does not share sensitive drafts back out.
  """

  alias LesCore.ProductIds

  @allowed_sources ~w(les-go les-poke les-wait les-match les-travel les-care les-harmonica lescommerce-core les-itemotel)
  @context_spaces ~w(personal work family school social travel commerce)
  @sensitive_place_types ~w(clinic adult_venue)

  def draft_from_check_in(params \\ %{}) do
    source_app = Map.get(params, "source_app", "les-go")

    cond do
      not ProductIds.canonical?(source_app) ->
        {:error, {:unknown_source_app, source_app}}

      source_app not in @allowed_sources ->
        {:error, {:unsupported_source_app, source_app}}

      not valid_context_space?(Map.get(params, "context_space")) ->
        {:error, {:invalid_context_space, Map.get(params, "context_space")}}

      true ->
        {:ok, %{data: build_draft(params, source_app)}}
    end
  end

  defp build_draft(params, source_app) do
    place_type = Map.get(params, "place_type", "place")
    privacy_level = Map.get(params, "privacy_level", "coarse_location")
    context_space = Map.get(params, "context_space") || infer_context_space(place_type)
    sensitive? = privacy_level == "private" or place_type in @sensitive_place_types

    %{
      event_id: "draft_" <> Integer.to_string(System.unique_integer([:positive])),
      event_type: "place_visit",
      draft_status: "private_draft",
      visibility: "private",
      cross_app_share_default: "blocked",
      user_review_required: true,
      source_app: source_app,
      source_ref: Map.get(params, "source_ref"),
      identity_id: Map.get(params, "identity_id", "demo-lestupid-identity"),
      context_space: context_space,
      sensitivity: if(sensitive?, do: "sensitive", else: "standard"),
      tags: draft_tags(place_type, context_space),
      place: %{
        place_id: Map.get(params, "place_id"),
        place_name: Map.get(params, "place_name", "Unknown place"),
        place_type: place_type
      },
      note: Map.get(params, "note"),
      created_from: "check_in"
    }
  end

  defp draft_tags(place_type, context_space) do
    [context_space, place_type, "private_draft", "check_in"]
  end

  defp valid_context_space?(nil), do: true
  defp valid_context_space?(value), do: value in @context_spaces

  defp infer_context_space(place_type) do
    case place_type do
      type
      when type in ["campus", "library", "course_center", "high_school", "student_affairs"] ->
        "school"

      "workplace" ->
        "work"

      type when type in ["village", "beach"] ->
        "travel"

      "shop" ->
        "commerce"

      _ ->
        "personal"
    end
  end
end
