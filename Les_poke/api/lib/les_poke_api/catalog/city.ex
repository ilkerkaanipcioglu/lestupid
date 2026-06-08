defmodule LesPokeApi.Catalog.City do
  @derive Jason.Encoder
  defstruct [:id, :name, :country, :center]
end
