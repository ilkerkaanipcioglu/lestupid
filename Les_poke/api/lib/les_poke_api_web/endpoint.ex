defmodule LesPokeApiWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :les_poke_api

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]
  plug Plug.Parsers, parsers: [:json], pass: ["*/*"], json_decoder: Phoenix.json_library()
  plug Plug.MethodOverride
  plug Plug.Head
  plug LesPokeApiWeb.Router
end
