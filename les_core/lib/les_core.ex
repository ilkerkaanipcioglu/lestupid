defmodule LesCore do
  @moduledoc """
  Lightweight LesTupid identity, activation and event contract.

  This package intentionally does not implement OAuth/OIDC, billing, push
  notifications or product business logic. It gives the ecosystem one small
  tested source for canonical ids, activation records and event envelopes.
  """

  alias LesCore.{Activations, Ecosystem, Events}

  defdelegate health(), to: Ecosystem
  defdelegate manifest(base_url \\ "http://127.0.0.1:4000"), to: Ecosystem

  defdelegate identity_status(params \\ %{}), to: Activations, as: :identity_status
  defdelegate list_activations(params \\ %{}), to: Activations
  defdelegate activate_app(product_id, params \\ %{}), to: Activations
  defdelegate activate_channel(channel_id, params \\ %{}), to: Activations

  defdelegate record_check_in(params \\ %{}), to: Events
  defdelegate record_opportunity_event(params \\ %{}), to: Events
end
