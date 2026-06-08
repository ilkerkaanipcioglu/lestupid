defmodule LesPokeApi.Catalog.Quest do
  @derive Jason.Encoder
  defstruct [
    :id,
    :city_id,
    :title,
    :description,
    :memory,
    :type,
    :points,
    :source_app,
    :sponsor_label,
    :commerce_handoff,
    :safety_labels,
    :action_label,
    :location
  ]
end
