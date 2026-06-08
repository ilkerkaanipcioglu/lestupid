defmodule LesPokeApi.Progress.Completion do
  @derive Jason.Encoder
  defstruct [:id, :user_id, :quest_id, :completed_at]
end
