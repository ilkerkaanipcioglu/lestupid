defmodule LesPokeApi.Catalog.Place do
  @derive Jason.Encoder
  defstruct [:id, :city_id, :name, :summary, :location]
end
