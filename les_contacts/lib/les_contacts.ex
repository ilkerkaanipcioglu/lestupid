defmodule LesContacts do
  @moduledoc """
  Lightweight runtime slice for Les Contacts private draft timeline events.
  """

  alias LesContacts.{Ecosystem, Timeline}

  defdelegate health(), to: Ecosystem
  defdelegate manifest(base_url \\ "http://127.0.0.1:4004"), to: Ecosystem

  defdelegate draft_from_check_in(params \\ %{}), to: Timeline
end
