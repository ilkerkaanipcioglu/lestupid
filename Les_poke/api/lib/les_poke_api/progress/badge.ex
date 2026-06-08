defmodule LesPokeApi.Progress.Badge do
  @derive Jason.Encoder
  defstruct [:id, :name, :description, :criteria]
end
